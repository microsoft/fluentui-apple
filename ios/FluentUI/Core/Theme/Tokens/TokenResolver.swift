//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Contains all possible token overrides for a given control, and returns the appropriate token value for a given property.
public class TokenResolver<ControlType: TokenizedControl>: NSObject, ObservableObject {

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

    /// Prepares all three token sets by installing the current `FluentTheme` and then allowing the control to perform
    /// additional configuration (e.g. setting `style` or `size` properties) by invoking the `configuration` callback.
    func update() {
        [overrideTokens, themeTokens, defaultTokens].forEach { tokens in
            guard let tokens = tokens else {
                return
            }
            if let fluentTheme = fluentTheme {
                tokens.fluentTheme = fluentTheme
            }
            if let configuration = configuration {
                configuration(tokens)
            }
        }
    }

    /// Optional callback to configure a `ControlTokens` instance.
    var configuration: ((TokenType) -> Void)?

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
    func fluentTokens<ControlType: TokenizedControlInternal>(_ tokenResolver: TokenResolver<ControlType>,
                                                             _ fluentTheme: FluentTheme,
                                                             _ configuration: ((_ tokens: ControlType.TokenType) -> Void)? = nil) -> some View {
        if fluentTheme != tokenResolver.fluentTheme {
            tokenResolver.fluentTheme = fluentTheme
        }
        tokenResolver.configuration = configuration
        tokenResolver.update()
        return self
    }
}
