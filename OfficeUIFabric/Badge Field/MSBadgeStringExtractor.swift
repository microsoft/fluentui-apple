//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

private struct BadgeStringData {
    let text: String
    let badgingString: String?

    init(text: String, badgingString: String?) {
        self.text = text
        self.badgingString = badgingString
    }

    init?(baseText: String, match: NSTextCheckingResult) {
        // Note about NSTextCheckingResult: the first range contains the full result, following ranges contain the captured groups
        guard match.numberOfRanges <= 3 else {
            assertionFailure("Invalid regex result: more than 2 groups")
            return nil
        }

        guard match.numberOfRanges >= 2 else {
            assertionFailure("Invalid regex result: missing text to badge")
            return nil
        }

        let text = (baseText as NSString).substring(with: match.range(at: 1))
        let badgingString: String? = {
            guard match.numberOfRanges == 3 else {
                return nil
            }
            let range = match.range(at: 2)
            guard range.location != NSNotFound else {
                return nil
            }
            return (baseText as NSString).substring(with: match.range(at: 2))
        }()

        self = BadgeStringData(text: text, badgingString: badgingString)
    }
}

func extractBadgeStrings(from text: String, badgingCharacters: String, hardBadgingCharacters: String, forceBadge: Bool, shouldBadge: (_ badgeString: String, _ softBadgingString: String) -> Bool) -> [String] {
    // Build array of possible badge data
    let possibleBadgeDatas = possibleBadgingStrings(badgingCharacters: badgingCharacters, text: text)

    // Build array of badge strings
    var badgeStrings = [String]()
    var currentString = ""

    possibleBadgeDatas.forEach { possibleBadgeData in
        currentString += possibleBadgeData.text
        // Last substring not followed by badging string, don't badge
        guard let badgingString = possibleBadgeData.badgingString else {
            if forceBadge {
                badgeStrings.append(currentString)
                currentString = ""
            }
            return
        }

        let hardBadgingCharactersSet = CharacterSet(charactersIn: hardBadgingCharacters)

        if badgingString.lowercased().rangeOfCharacter(from: hardBadgingCharactersSet) != nil {
            // String contains hard badging characters: force badging
            badgeStrings.append(currentString)
            currentString = ""
        } else {
            // String only contains soft badging characters: ask the delegate whether to badge
            if shouldBadge(currentString, badgingString) {
                badgeStrings.append(currentString)
                currentString = ""
            } else {
                currentString += badgingString
            }
        }
    }

    return badgeStrings.map({ $0.trimmed() }).compactMap({ $0.isEmpty ? nil : $0 })
}

private func possibleBadgingStrings(badgingCharacters: String, text: String) -> [BadgeStringData] {
    let regex: NSRegularExpression
    do {
        // Example: "A B, C;  D  ,E" -> [(A, " "), (B, ", "), (C, ";  "), (D, "   ,"), (E, nil)]
        regex = try NSRegularExpression(pattern: "([^\(badgingCharacters)]+)([\(badgingCharacters)]+)?", options: .caseInsensitive)
    } catch {
        return []
    }

    let textRange = NSRange(location: 0, length: (text as NSString).length)
    let matches = regex.matches(in: text, options: [], range: textRange)

    return matches.compactMap { BadgeStringData(baseText: text, match: $0) }
}
