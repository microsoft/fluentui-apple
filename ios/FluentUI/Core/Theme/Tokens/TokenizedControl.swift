//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    associatedtype TokenType: ControlTokens

    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    func overrideTokens(_ tokens: TokenType?) -> Self
}

/// Internal extension to `TokenizedControl` that adds the ability to modify the active tokens.
protocol TokenizedControlInternal: TokenizedControl {
    /// Sets the current tokens to be used for drawing.
    func updateCurrentTokens(_ tokens: TokenType)

    /// Fetches the current token override.
    var overrideTokens: TokenType? { get }
}
