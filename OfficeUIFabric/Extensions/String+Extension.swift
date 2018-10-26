//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension String {
    var initials: String {
        var initials = ""

        // Use the leading character from the first two words in the user's name
        let nameComponents = self.components(separatedBy: " ")
        for nameComponent: String in nameComponents {
            let trimmedName = nameComponent.trimmed()
            if trimmedName.count < 1 {
                continue
            }
            let initial = trimmedName.index(trimmedName.startIndex, offsetBy: 0)
            let initialLetter = String(trimmedName[initial])
            let initialUnicodeScalars = initialLetter.unicodeScalars
            let initialUnicodeScalar = initialUnicodeScalars[initialUnicodeScalars.startIndex]
            // Discard name if first char is not a letter
            let isInitialLetter: Bool = initialLetter.count > 0 && CharacterSet.letters.contains(initialUnicodeScalar)
            if isInitialLetter && initials.count < 2 {
                initials = initials + initialLetter
            }
        }

        return initials
    }

    internal var localized: String {
        return NSLocalizedString(self, bundle: OfficeUIFabricFramework.bundle, comment: "")
    }

    func formatted(with args: CVarArg...) -> String {
        return String(format: self, locale: Locale.current, arguments: args)
    }

    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaceNewlineAndZeroWidthSpace)
    }
}
