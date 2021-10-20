//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A type-safe representation of a unique identifier for a given control and its desired tokens.
public typealias TokenType = AnyHashable

/// Protocol that defines a control that can be tokenized.
public protocol Tokenizable {
    /// The required lookup value for this control's tokens.
    static var requiredTokenType: TokenType { get }
}
