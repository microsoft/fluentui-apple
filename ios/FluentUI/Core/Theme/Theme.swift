//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// TODO: Documentation WIP
open class Theme: NSObject, ObservableObject {
    var tokenLookup: [TokenType: ControlTokens] = [:]

    public func set(tokens: ControlTokens, for control: Tokenizable) {
        let controlTokenType = type(of: control).requiredTokenType
        let tokenType = type(of: tokens).tokenType
        precondition(controlTokenType == tokenType, "Attempting to set wrong token type for control! TokenType: \(tokenType), ControlTokenType: \(controlTokenType)")
        tokenLookup[tokenType] = tokens
    }
}
