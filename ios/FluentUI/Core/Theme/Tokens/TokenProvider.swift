//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
public class TokenProvider {
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
    /// If no token instance yet exists in this provider, this method will register and return the instance returned by `controlType.defaultTokens()`.
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
    var tokenProvider: TokenProvider? { get }
}

extension UIWindow: TokenProviding {
    private struct Keys {
        static var tokenProvider: String = "tokenProvider_key"
    }

    public var tokenProvider: TokenProvider? {
        get {
            return objc_getAssociatedObject(self, &Keys.tokenProvider) as? TokenProvider
        }
        set {
            objc_setAssociatedObject(self, &Keys.tokenProvider, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

// MARK: - Environment

public extension View {
    /// Sets a custom token provider for a specific SwiftUI View and its view hierarchy.
    /// - Parameter tokenProvider: Instance of the custom token provider.
    /// - Returns: The view with its `tokenProvider` environment value overriden.
    func tokenProvider(_ tokenProvider: TokenProvider) -> some View {
        environment(\.tokenProvider, tokenProvider)
    }
}

extension EnvironmentValues {
    var tokenProvider: TokenProvider {
        get {
            self[TokenProviderKey.self]
        }
        set {
            self[TokenProviderKey.self] = newValue
        }
    }
}

struct TokenProviderKey: EnvironmentKey {
    static var defaultValue: TokenProvider {
        return TokenProvider()
    }
}
