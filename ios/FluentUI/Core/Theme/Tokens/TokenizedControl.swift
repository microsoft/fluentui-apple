//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    associatedtype TokenType: ControlTokens

    /// The components of a unique key to use for token cacheing for a given `TokenizedControl`.
    ///
    /// In most cases, this will simply return `"type(of: self)"`. However, some controls may want to cache multiple token sets
    /// (e.g. one for each style for a control), and will thus add additional data to the array.
    var tokenKeyComponents: [AnyObject] { get }

    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these overridden tokens applied.
    func overrideTokens(_ tokens: TokenType) -> Self
}

/// Internal extension to `TokenizedControl` that adds information about `configuration`.
protocol TokenizedControlInternal: TokenizedControl {
    associatedtype ConfigurationType: ControlConfiguration where ConfigurationType.TokenType == TokenType

    /// Contains additional configuration information about the control.
    var state: ConfigurationType { get }

    /// Common token lookup method, which should contain a lookup via the current environment's `fluentTheme`.
    var tokens: TokenType { get }

    /// On-demand default token set.
    ///
    /// This property only be read the first time a unique set of `tokenKeyComponents` are found, so
    /// a computed property is a reasonable approach.
    var defaultTokens: TokenType { get }
}

/// Internal protocol for all controls' internal `configuration` objects.
protocol ControlConfiguration: NSObject, ObservableObject, Identifiable {
    associatedtype TokenType: ControlTokens

    /// Custom design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TokenType? { get set }
}
