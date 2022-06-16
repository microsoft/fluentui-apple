//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Contains all possible token overrides for a given control, and returns the appropriate token value for a given property.
class TokenResolver<ControlType: TokenizedControl>: NSObject, ObservableObject {

    /// Returns the appropriate token value for a given key path on this control's token set.
    ///
    /// This method looks for the first value that does not match the default value provided by `defaultTokens`.
    /// Priority order for tokens are `overrideTokens`, `themeTokens`, then finally `defaultTokens`.
    func value<ValueType: Equatable>(_ keyPath: KeyPath<TokenType, ValueType>) -> ValueType {
        let defaultValue = defaultTokens[keyPath: keyPath]
        if let overrideValue = overrideTokens?[keyPath: keyPath], overrideValue != defaultValue {
            return overrideValue
        } else if let themeValue = themeTokens?[keyPath: keyPath], themeValue != defaultValue {
            return themeValue
        } else {
            return defaultValue
        }
    }

    /// Prepares all three token sets by installing the current `FluentTheme` and then allowing the control
    /// to perform additional configuration (e.g. setting `style` or `size` properties) via this class's `tokenConfig` property.
    func configure(_ tokenConfig: ((_ tokens: TokenType) -> Void)? = nil) {
        [overrideTokens, themeTokens, defaultTokens].forEach { tokens in
            guard let tokens = tokens else {
                return
            }
            if let fluentTheme = fluentTheme {
                tokens.fluentTheme = fluentTheme
            }
            if let tokenConfig = tokenConfig {
                tokenConfig(tokens)
            }
        }
    }

    /// Optional callback to configure a `ControlTokens` instance.
    var tokenConfig: ((TokenType) -> Void)?

    typealias TokenType = ControlType.TokenType

    @Published var fluentTheme: FluentTheme?
    @Published var overrideTokens: TokenType?

    private var defaultTokens: TokenType = .init()
    private var themeTokens: TokenType? {
        return fluentTheme?.tokens(for: ControlType.self)
    }
}

// MARK: - Extensions

extension View {
    /// Used to configure a given `TokenResolver` instance with the current Fluent theme, as well as an optional token configuration callback.
    ///
    /// This view modifier should be attached to a tokenized SwiftUI view's main `body` to ensure that the `TokenResolver` is properly
    /// configured at render time.
    func designTokens<ControlType: TokenizedControlInternal>(_ tokenResolver: TokenResolver<ControlType>,
                                                             _ fluentTheme: FluentTheme,
                                                             _ tokenConfig: ((_ tokens: ControlType.TokenType) -> Void)? = nil) -> Self {
        if fluentTheme != tokenResolver.fluentTheme {
            tokenResolver.fluentTheme = fluentTheme
        }
        tokenResolver.configure(tokenConfig)
        return self
    }
}
