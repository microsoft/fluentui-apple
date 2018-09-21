//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension CharacterSet {
    internal static var whitespaceNewlineAndZeroWidthSpace: CharacterSet {
        var whitespace = CharacterSet(charactersIn: "\u{200B}") // Zero-width space
        whitespace.formUnion(CharacterSet.whitespacesAndNewlines)
        return whitespace
    }
}
