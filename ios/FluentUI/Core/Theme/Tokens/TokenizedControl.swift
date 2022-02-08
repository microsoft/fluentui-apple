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

/// Internal extension to `TokenizedControl` that adds information about `configuration`.
protocol TokenizedControlInternal: TokenizedControl {
    associatedtype ConfigurationType: ControlConfiguration where ConfigurationType.TokenType == TokenType

    /// Contains additional configuration information about the control.
    var state: ConfigurationType { get }
}

/// Internal protocol for all controls' internal `configuration` objects.
protocol ControlConfiguration: NSObject, ObservableObject, Identifiable {
    associatedtype TokenType: ControlTokens

    /// Custom design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TokenType? { get set }

    /// Common token lookup method, which should contain a lookup via the current environment's `fluentTheme`.
    var tokens: TokenType { get set }
}
