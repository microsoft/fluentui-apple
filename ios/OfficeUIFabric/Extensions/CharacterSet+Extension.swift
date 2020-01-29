//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

public extension CharacterSet {
    internal static var whitespaceNewlineAndZeroWidthSpace: CharacterSet {
        var whitespace = CharacterSet(charactersIn: "\u{200B}") // Zero-width space
        whitespace.formUnion(CharacterSet.whitespacesAndNewlines)
        return whitespace
    }
}
