//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    /// The type of tokens associated with this `TokenizedControl`.
    associatedtype TokenType: ControlTokens

    /// Custom tokens to provide styling for this `TokenizedControl`.
    var overrideTokens: TokenType? { get set }
}

/// Internal extension to `TokenizedControl` that adds the ability to modify the active tokens.
protocol TokenizedControlInternal: TokenizedControl {
    /// The current `FluentTheme` applied to this control. Usually acquired via the environment.
    var fluentTheme: FluentTheme { get }

    associatedtype ControlType: TokenizedControlInternal where ControlType.TokenType == TokenType
    var tokenResolver: TokenResolver<ControlType> { get }
}

// MARK: - Extensions

extension TokenizedControlInternal {
    /// Per-control override tokens.
    public var overrideTokens: TokenType? {
        get { tokenResolver.overrideTokens }
        set { tokenResolver.overrideTokens = newValue }
    }

    /// Theme-provided class-wide override tokens.
    var themeTokens: TokenType? { fluentTheme.tokens(for: type(of: self)) }
}
