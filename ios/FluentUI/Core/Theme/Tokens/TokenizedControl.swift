//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl {
    associatedtype TokenType: ControlTokens

    /// The unique key to use for token cacheing for a given `TokenizedControl`.
    ///
    /// In most cases, this will simply return `"\(type(of: self)"`. However, some controls may want to cache multiple token sets
    /// (e.g. one for each style for a control), and will thus add additional data 
    var tokenKey: String { get }

    /// Modifier function that updates the design tokens for a given control.
    ///
    /// - Parameter tokens: The custom tokens to apply to this control.
    ///
    /// - Returns: A version of this control with these custom tokens applied.
    func customTokens(_ tokens: TokenType) -> Self
}

/// Internal extension to `TokenizedControl` that adds information about `configuration`.
protocol TokenizedControlInternal: TokenizedControl {
    associatedtype ConfigurationType: ControlConfiguration where ConfigurationType.TokenType == TokenType

    var state: ConfigurationType { get }
    var tokens: TokenType { get }
}

/// Internal protocol for all controls' internal `configuration` objects.
protocol ControlConfiguration: NSObject, ObservableObject, Identifiable {
    associatedtype TokenType: ControlTokens

    /// Custom design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TokenType? { get set }

    /// On-demand default token set.
    var defaultTokens: TokenType { get }
}
