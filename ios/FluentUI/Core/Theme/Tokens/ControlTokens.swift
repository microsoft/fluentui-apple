//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Template for all token sets, both global and alias. This ensures a unified return type for any given token set.
public protocol ControlTokens {
    /// The unique lookup value for this set of control tokens.
    static var tokenType: TokenType { get }
}
