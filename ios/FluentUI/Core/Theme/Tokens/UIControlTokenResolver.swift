//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Internal extension to `TokenizedControl` that adds information about `configuration`.
protocol TokenizedUIControlInternal: TokenizedControl {
    associatedtype ConfigurationType: ControlConfiguration where ConfigurationType.TokenType == TokenType

    /// Contains additional configuration information about the control.
    var config: ConfigurationType { get }
}

/// A `ViewModifier` that will update the tokens on a given `TokenizedControlInternal` instance based on the current `FluentTheme` and `overrideTokens`.
struct UIControlTokenResolver<ControlType: TokenizedUIControlInternal>: ViewModifier {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    let control: ControlType

    /// Helper func to determine which tokens to use, and ensures they refer to the correct `FluentTheme` instance.
    static func tokens(for control: ControlType, fluentTheme: FluentTheme) -> ControlType.TokenType {
        let tokens = control.config.overrideTokens ?? fluentTheme.tokens(for: control) ?? ControlType.TokenType()
        tokens.fluentTheme = fluentTheme
        return tokens
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: fluentTheme) { newValue in
                control.config.tokens = Self.tokens(for: control, fluentTheme: newValue)
            }
            .onChange(of: control.config.overrideTokens) { _ in
                control.config.tokens = Self.tokens(for: control, fluentTheme: fluentTheme)
            }
    }
}
