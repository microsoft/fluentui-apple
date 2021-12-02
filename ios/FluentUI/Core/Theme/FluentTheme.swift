//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
public class FluentTheme {
    /// Initializes and returns a new `FluentTheme`, with optional custom global and alias tokens.
    ///
    /// - Parameters globalTokens: An optional customized instance of `GlobalTokens`.
    /// - Parameters aliasTokens: An optional customized instance of `AliasTokens`.
    ///
    /// - Returns: An initialized `FluentTheme` instance that leverages the aforementioned global and alias token overrides.
    public init(globalTokens: GlobalTokens? = nil, aliasTokens: AliasTokens? = nil) {
        if let globalTokens = globalTokens {
            self.globalTokens = globalTokens
        }
        if let aliasTokens = aliasTokens {
            self.aliasTokens = aliasTokens
        }
    }

    /// Registers a custom set of `ControlTokens` for a given `TokenizedControl`.
    ///
    /// - Parameters:
    ///   - tokens: A custom set of tokens.
    ///   - control: The control to use custom tokens on.
    public func register<T: TokenizedControl>(tokens: T.TokenType, for control: T) {
        tokens.globalTokens = globalTokens
        tokens.aliasTokens = aliasTokens
        controlTokens["\(type(of: control))"] = tokens
    }

    /// Returns the appropriate `ControlTokens` instance that was provided a given `TokenizedControl`.
    ///
    /// Priority queue for token retrieval:
    /// 1. Instance-specific `overrideTokens`.
    /// 2. Theme-wide custom tokens set via `register(tokens:for:)`.
    /// 3. The control's own `defaultTokens`.
    ///
    /// - Parameter control: The control to fetch controls for.
    ///
    /// - Returns: The custom `ControlTokens` for the given control if one is registered, or `nil` if not.
    func tokens<T: TokenizedControlInternal>(for control: T) -> T.TokenType {
        if let tokens = control.state.overrideTokens {
            return tokens
        } else if let tokens = controlTokens["\(type(of: control))"] as? T.TokenType {
            return tokens
        } else {
            // Register the default tokens to make future lookups more efficient.
            let tokens = control.state.defaultTokens
            self.register(tokens: tokens, for: control)
            return tokens
        }
    }

    private var globalTokens: GlobalTokens = .shared
    private var aliasTokens: AliasTokens = .shared
    private var controlTokens: [String: ControlTokens] = [:]
}

// MARK: - FluentThemeable

/// Public protocol that, when implemented, allows any container to store and yield a `FluentTheme`.
public protocol FluentThemeable {
    var fluentTheme: FluentTheme? { get set }
}

extension UIWindow: FluentThemeable {
    private struct Keys {
        static var fluentTheme: String = "fluentTheme_key"
    }

    /// The custom `FluentTheme` to apply to this window.
    public var fluentTheme: FluentTheme? {
        get {
            return objc_getAssociatedObject(self, &Keys.fluentTheme) as? FluentTheme
        }
        set {
            objc_setAssociatedObject(self, &Keys.fluentTheme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

// MARK: - Environment

public extension View {
    /// Sets a custom theme for a specific SwiftUI View and its view hierarchy.
    /// - Parameter fluentTheme: Instance of the custom theme.
    /// - Returns: The view with its `fluentTheme` environment value overriden.
    func fluentTheme(_ fluentTheme: FluentTheme) -> some View {
        environment(\.fluentTheme, fluentTheme)
    }
}

extension EnvironmentValues {
    var fluentTheme: FluentTheme {
        get {
            self[FluentThemeKey.self]
        }
        set {
            self[FluentThemeKey.self] = newValue
        }
    }
}

struct FluentThemeKey: EnvironmentKey {
    static var defaultValue: FluentTheme {
        return FluentTheme()
    }
}
