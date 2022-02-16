//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Internal protocol for all controls' internal `configuration` objects.
protocol ControlConfiguration: NSObject, ObservableObject, Identifiable {
    associatedtype TokenType: ControlTokens

    /// Custom design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TokenType? { get set }

    /// Common token lookup method, which should contain a lookup via the current environment's `fluentTheme`.
    var tokens: TokenType { get set }
}

/// SwiftUI-specific extension to `TokenizedControl` that adds information about `configuration`.
protocol ConfigurableTokenizedControl: TokenizedControlInternal {
    associatedtype ConfigurationType: ControlConfiguration where ConfigurationType.TokenType == TokenType

    /// Contains additional configuration information about the control.
    var state: ConfigurationType { get }
}

// MARK: - Extensions

/// This set of extensions implements the `TokenizedControlInternal` APIs for SwiftUI components.
extension ConfigurableTokenizedControl {
    var overrideTokens: TokenType? { state.overrideTokens }

    func updateCurrentTokens(_ tokens: TokenType) {
        self.state.tokens = tokens
    }
}
