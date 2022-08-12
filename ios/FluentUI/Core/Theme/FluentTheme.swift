//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
@objc public class FluentTheme: NSObject, ObservableObject {
    /// Initializes and returns a new `FluentTheme`.
    ///
    /// Once created, a `FluentTheme` can have its `AliasTokens` customized by setting custom values on the
    ///  `aliasTokens` property. Control tokens can be customized via `register(controlType:tokens:) `.
    ///  See the descriptions of those two for additional information.
    ///
    /// - Returns: An initialized `FluentTheme` instance.
    public override init() { }

    /// Registers a custom set of `ControlTokens` for a given `TokenizedControl`.
    ///
    /// - Parameters:
    ///   - controlType: The control type to use custom tokens on.
    ///   - tokens: A closure that returns a custom set of tokens.
    public func register<T: TokenizedControl>(controlType: T.Type, tokens: (() -> T.TokenType)?) {
        controlTokens[tokenKey(controlType)] = tokens
    }

    /// Returns the specified `ControlTokens` generator for a given `TokenizedControl`, if a lookup function has been registered.
    ///
    /// - Parameter controlType: The control type to fetch the token generator for.
    ///
    /// - Returns: A `ControlTokens` generator for the given control, or `nil` if no lookup function has been registered.
    public func tokenOverride<T: TokenizedControl>(for controlType: T.Type) -> (() -> T.TokenType)? {
        return controlTokens[tokenKey(controlType)] as? (() -> T.TokenType)
    }

    /// Returns a custom `ControlTokens` instance for a given `TokenizedControl`, if a lookup function has been registered.
    ///
    /// - Parameter controlType: The control type to fetch tokens for.
    ///
    /// - Returns: A `ControlTokens` instance for the given control, or `nil` if no lookup function has been registered.
    func tokens<T: TokenizedControl>(for controlType: T.Type) -> T.TokenType? {
        if let lookup = controlTokens[tokenKey(controlType)] as? (() -> T.TokenType) {
            return lookup()
        } else {
            return nil
        }
    }

    /// The associated `AliasTokens` for this theme.
    public let aliasTokens: AliasTokens = .init()

    static var shared: FluentTheme = .init()

    private func tokenKey<T: TokenizedControl>(_ controlType: T.Type) -> String {
        return "\(controlType)"
    }

    private var controlTokens: [String: Any] = [:]
}

// MARK: - FluentThemeable

/// Public protocol that, when implemented, allows any container to store and yield a `FluentTheme`.
public protocol FluentThemeable {
    var fluentTheme: FluentTheme { get set }
}

public extension Notification.Name {
    static let didChangeTheme = Notification.Name("FluentUI.stylesheet.theme")
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
            NotificationCenter.default.post(name: .didChangeTheme, object: self)
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
