//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Determines which tokens to use, and ensures they refer to the correct `FluentTheme` instance.
func resolvedTokens<T: TokenizedControlInternal>(for control: T, fluentTheme: FluentTheme) -> T.TokenType {
    let tokens = control.state.overrideTokens ?? fluentTheme.tokens(for: control) ?? control.state.defaultTokens
    tokens.fluentTheme = fluentTheme
    return tokens
}

struct TokenResolver<T: TokenizedControlInternal>: ViewModifier {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    let control: T

    func body(content: Content) -> some View {
        content
            .onChange(of: fluentTheme) { newValue in
                control.state.tokens = resolvedTokens(for: control, fluentTheme: newValue)
            }
            .onChange(of: control.state.overrideTokens) { _ in
                control.state.tokens = resolvedTokens(for: control, fluentTheme: fluentTheme)
            }
    }
}

struct TokenModifierResolver<ControlType: TokenizedControlInternal, Value: Equatable>: ViewModifier {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    let control: ControlType
    var value: Value

    func body(content: Content) -> some View {
        content
            .onChange(of: value) { _ in
                control.state.tokens = resolvedTokens(for: control, fluentTheme: fluentTheme)
            }
    }
}

extension View {
    /// Used to recalculate tokens whenever the current `FluentTheme` or `overrideTokens` change.
    ///
    /// - Parameter control: The `TokenizedControlInternal` instance to update.
    func resolveTokens<ControlType: TokenizedControlInternal>(_ control: ControlType) -> some View {
        modifier(TokenResolver(control: control))
    }

    /// Used to recalculate tokens whenever a specific value is changed.
    ///
    /// - Parameter control: The `TokenizedControlInternal` instance to update.
    /// - Parameter value: The value whose change will trigger a token recalculation.
    func resolveTokenModifier<ControlType: TokenizedControlInternal, Value: Equatable>(_ control: ControlType, value: Value) -> some View {
        modifier(TokenModifierResolver(control: control, value: value))
    }
}
