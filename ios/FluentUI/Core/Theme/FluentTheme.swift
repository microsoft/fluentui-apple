//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
@objc public class FluentTheme: NSObject {
    /// Initializes and returns a new `FluentTheme`, with optional custom global and alias tokens.
    ///
    /// - Parameters globalTokens: An optional customized instance of `GlobalTokens`.
    /// - Parameters aliasTokens: An optional customized instance of `AliasTokens`.
    ///
    /// - Returns: An initialized `FluentTheme` instance that leverages the aforementioned global and alias token overrides.
    public init(globalTokens: GlobalTokens? = nil, aliasTokens: AliasTokens? = nil) {
        self.globalTokens = globalTokens ?? .init()
        self.aliasTokens = aliasTokens ?? .init()
        self.aliasTokens.globalTokens = self.globalTokens
    }

    /// Registers a custom set of `ControlTokens` for a given `TokenizedControl`.
    ///
    /// - Parameters:
    ///   - tokens: A custom set of tokens.
    ///   - control: The control to use custom tokens on.
    public func register<T: TokenizedControl>(tokens: T.TokenType, for control: T) {
        tokens.globalTokens = globalTokens
        tokens.aliasTokens = aliasTokens
        controlTokens[control.tokenKey] = tokens
    }

    /// Returns the appropriate `ControlTokens` instance that was provided a given `TokenizedControl`.
    ///
    /// This method returns the appropriate token based on a priority order. The first of these entries to be non-`nil` is returned:
    /// 1. Instance-specific `overrideTokens`.
    /// 2. Theme-wide custom tokens set via `register(tokens:for:)`.
    /// 3. The control's own `defaultTokens`.
    ///
    /// - Parameter control: The control to fetch tokens for.
    ///
    /// - Returns: The appropriate `ControlTokens` for the given control. See Discussion for more details.
    func tokens<T: TokenizedControlInternal>(for control: T) -> T.TokenType {
        if let tokens = control.state.overrideTokens {
            return tokens
        } else if let tokens = controlTokens[control.tokenKey] as? T.TokenType {
            return tokens
        } else {
            // Register the default tokens to make future lookups more efficient.
            let tokens = control.state.createDefaultTokens()
            self.register(tokens: tokens, for: control)
            return tokens
        }
    }

    static var shared: FluentTheme = .init()

    var globalTokens: GlobalTokens
    var aliasTokens: AliasTokens

    private var controlTokens: [String: ControlTokens] = [:]
}

// MARK: - FluentThemeable

/// Public protocol that, when implemented, allows any container to store and yield a `FluentTheme`.
public protocol FluentThemeable {
    var fluentTheme: FluentTheme { get set }
}

extension UIWindow: FluentThemeable {
    private struct Keys {
        static var fluentTheme: String = "fluentTheme_key"
    }

    /// The custom `FluentTheme` to apply to this window.
    public override var fluentTheme: FluentTheme {
        get {
            return objc_getAssociatedObject(self, &Keys.fluentTheme) as? FluentTheme ?? FluentThemeKey.defaultValue
        }
        set {
            objc_setAssociatedObject(self, &Keys.fluentTheme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

@objc extension UIView {
    /// Returns the current view's window's `FluentTheme`, or the default `FluentTheme` if no window yet exists.
    var fluentTheme: FluentTheme {
        return self.window?.fluentTheme ?? FluentThemeKey.defaultValue
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
        return FluentTheme.shared
    }
}
