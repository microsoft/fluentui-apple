//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines a control with customizable design tokens.
public protocol TokenizedControl: View {
    associatedtype TokenType: ControlTokens

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
}

/// Internal protocol for all controls' internal `configuration` objects.
protocol ControlConfiguration: NSObject, ObservableObject, Identifiable {
    associatedtype TokenType: ControlTokens
    var overrideTokens: TokenType? { get set }
    var defaultTokens: TokenType { get }
}
