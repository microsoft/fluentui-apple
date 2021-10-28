//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Creates and manages `ControlTokens` for Fluent controls.
///
/// This class should be overridden by clients that want to provide custom control tokens on a larger scale.
open class ControlTokenFactory {
    public init() {}
    static let shared = ControlTokenFactory()

    /// Attempts to return a cached token set of type `T` if one exists. If not, this function will create
    /// and cache a new set of tokens using the supplied generator function.
    /// - Parameters:
    ///   - tokenGenerator: A closure that generates a set of `ControlTokens` of type `T`.
    /// - Returns:A set of `ControlTokens` of type `T`.
    func tokenCache<T: ControlTokens>(_ tokenGenerator: () -> T) -> T {
        if let tokens = currentCachedTokens as? T {
            return tokens
        }
        let tokens = tokenGenerator()
        currentCachedTokens = tokens
        return tokens
    }

    private var currentCachedTokens: ControlTokens?
}

// MARK: - UIWindow

protocol ControlTokenFactoryHosting {
    var tokenFactory: ControlTokenFactory? { get }
}

extension UIWindow: ControlTokenFactoryHosting {
    private struct Keys {
        static var tokenFactory: String = "tokenFactory_key"
    }

    public var tokenFactory: ControlTokenFactory? {
        get {
            return objc_getAssociatedObject(self, &Keys.tokenFactory) as? ControlTokenFactory
        }
        set {
            objc_setAssociatedObject(self, &Keys.tokenFactory, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: nil)
        }
    }
}

// MARK: - Environment

public extension View {
    /// Sets a custom token factory for a specific SwiftUI View and its view hierarchy.
    /// - Parameter tokenFactory: Instance of the custom overriding token factory.
    /// - Returns: The view with its theme environment value overriden.
    func tokenFactory(_ tokenFactory: ControlTokenFactory) -> some View {
        environment(\.tokenFactory, tokenFactory)
    }
}

extension EnvironmentValues {
    var tokenFactory: ControlTokenFactory {
        get {
            self[TokenFactoryKey.self]
        }
        set {
            self[TokenFactoryKey.self] = newValue
        }
    }
}

private struct TokenFactoryKey: EnvironmentKey {
    static var defaultValue: ControlTokenFactory {
        return ControlTokenFactory.shared
    }
}
