//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A `ViewModifier` that will update the tokens on a given `TokenizedControlInternal` instance based on the current `FluentTheme` and `overrideTokens`.
struct TokenResolver<ControlType: TokenizedControlInternal>: ViewModifier {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    let control: ControlType

    /// Helper func to determine which tokens to use, and ensures they refer to the correct `FluentTheme` instance.
    static func tokens(for control: ControlType, fluentTheme: FluentTheme) -> ControlType.TokenType {
        let tokens = control.overrideTokens ?? fluentTheme.tokens(for: control) ?? ControlType.TokenType()
        tokens.fluentTheme = fluentTheme
        return tokens
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: fluentTheme) { newValue in
                control.updateCurrentTokens(Self.tokens(for: control, fluentTheme: newValue))
            }
            .onChange(of: control.overrideTokens) { _ in
                control.updateCurrentTokens(Self.tokens(for: control, fluentTheme: fluentTheme))
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
}
