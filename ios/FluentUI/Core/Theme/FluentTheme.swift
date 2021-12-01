//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
public class FluentTheme {
    public init(globalTokens: GlobalTokens? = nil, aliasTokens: AliasTokens? = nil) {
        if let globalTokens = globalTokens {
            self.globalTokens = globalTokens
        }
        if let aliasTokens = aliasTokens {
            self.aliasTokens = aliasTokens
        }
    }

    /// Registers a custom set of `ControlTokens` for a given `TokenizedControl`.
    /// - Parameters:
    ///   - tokens: A custom set of tokens.
    ///   - control: The control to use custom tokens on.
    public func register<T: TokenizedControl>(tokens: T.TokenType, for control: T) {
        tokens.globalTokens = globalTokens
        tokens.aliasTokens = aliasTokens
        controlTokens["\(type(of: control))"] = tokens
    }

    /// Returns the `ControlTokens` instance for a given `TokenizedControl`.
    ///
    /// If no token instance yet exists in this theme, this method will register and return the instance returned by `controlType.defaultTokens()`.
    /// - Parameters:
    ///   - control: The control to fetch controls for.
    func tokens<T: TokenizedControl>(for control: T) -> T.TokenType {
        let controlType = type(of: control)
        if let tokens = controlTokens["\(type(of: control))"] as? T.TokenType {
            return tokens
        }
        let tokens = controlType.defaultTokens()
        self.register(tokens: tokens, for: control)
        return tokens
    }

    private var globalTokens: GlobalTokens = .shared
    private var aliasTokens: AliasTokens = .shared
    private var controlTokens: [String: ControlTokens] = [:]
}

// MARK: - UIWindow

protocol TokenProviding {
    var fluentTheme: FluentTheme? { get }
}

extension UIWindow: TokenProviding {
    private struct Keys {
        static var fluentTheme: String = "fluentTheme_key"
    }

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
