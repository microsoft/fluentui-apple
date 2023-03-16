//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import SwiftUI

/// Base class that allows for customization of global, alias, and control tokens.
@objc(MSFFluentTheme)
public class FluentTheme: NSObject, ObservableObject {
    /// Initializes and returns a new `FluentTheme`.
    ///
    /// A `FluentTheme` receives any custom alias tokens on initialization via arguments here.
    /// Control tokens can be customized via `register(controlType:tokens:) `;
    /// see that method's description for additional information.
    ///
    /// - Parameters:
    ///   - colorOverrides: A `Dictionary` of override values mapped to `ColorTokens`.
    ///   - shadowOverrides: A `Dictionary` of override values mapped to `ShadowTokens`.
    ///   - typographyOverrides: A `Dictionary` of override values mapped to `TypographyTokens`.
    ///
    /// - Returns: An initialized `FluentTheme` instance, with optional overrides.
    public init(colorOverrides: [AliasTokens.ColorsTokens: DynamicColor]? = nil,
                shadowOverrides: [AliasTokens.ShadowTokens: ShadowInfo]? = nil,
                typographyOverrides: [AliasTokens.TypographyTokens: FontInfo]? = nil) {
        // Pass overrides to AliasTokens
        aliasTokens = .init(colorOverrides: colorOverrides,
                            shadowOverrides: shadowOverrides,
                            typographyOverrides: typographyOverrides)
    }

    /// Registers a custom set of `ControlTokenValue` instances for a given `ControlTokenSet`.
    ///
    /// - Parameters:
    ///   - tokenSetType: The token set type to register custom tokens for.
    ///   - tokens: A custom set of tokens to register.
    public func register<T: TokenSetKey>(tokenSetType: ControlTokenSet<T>.Type, tokenSet: [T: ControlTokenValue]?) {
        controlTokenSets[tokenKey(tokenSetType)] = tokenSet
    }

    /// Returns the `ControlTokenValue` array for a given `TokenizedControl`, if any overrides have been registered.
    ///
    /// - Parameter tokenSetType: The token set type to fetch the token overrides for.
    ///
    /// - Returns: An array of `ControlTokenValue` instances for the given control, or `nil` if no custom tokens have been registered.
    public func tokens<T: TokenSetKey>(for tokenSetType: ControlTokenSet<T>.Type) -> [T: ControlTokenValue]? {
        return controlTokenSets[tokenKey(tokenSetType)] as? [T: ControlTokenValue]
    }

    /// The associated `AliasTokens` for this theme.
    @objc public let aliasTokens: AliasTokens

    /// A shared, immutable, default `FluentTheme` instance.
    ///
    /// This instance of `FluentTheme` is not customizable, and will not return any overridden values that may be
    /// applied to other instances of `FluentTheme`. For example, any branding colors applied via an instantiation of
    /// the `ColorProviding` protocol will not be reflected here. As such, this should only be used in cases where the
    /// caller is certain that they are looking for the _default_ token values associated with Fluent.
    @objc(sharedTheme)
    public static let shared: FluentTheme = .init()

    private func tokenKey<T: TokenSetKey>(_ tokenSetType: ControlTokenSet<T>.Type) -> String {
        return "\(tokenSetType)"
    }

    private var controlTokenSets: [String: Any] = [:]
}

// MARK: - FluentThemeable

/// Public protocol that, when implemented, allows any container to store and yield a `FluentTheme`.
@objc public protocol FluentThemeable {
    var fluentTheme: FluentTheme { get set }
}

public extension Notification.Name {
    /// The notification that will fire when a new `FluentTheme` is set on a view.
    ///
    /// The `object` for the fired `Notification` will be the `UIView` whose `fluentTheme` has changed.
    /// Listeners will likely only want to redraw if they are a descendent of this view.
    static let didChangeTheme = Notification.Name("FluentUI.stylesheet.theme")
}

@objc extension UIView: FluentThemeable {
    private struct Keys {
        static var fluentTheme: String = "fluentTheme_key"
        static var cachedFluentTheme: String = "cachedFluentTheme_key"
    }

    /// The custom `FluentTheme` to apply to this view.
    @objc public var fluentTheme: FluentTheme {
        get {
            var optionalView: UIView? = self
            while let view = optionalView {
                // If we successfully find a theme, return it.
                if let theme = objc_getAssociatedObject(view, &Keys.fluentTheme) as? FluentTheme {
                    return theme
                } else {
                    optionalView = view.superview
                }
            }

            // No custom themes anywhere, so return the default theme
            return FluentTheme.shared
        }
        set {
            objc_setAssociatedObject(self, &Keys.fluentTheme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: self)
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
        return FluentTheme.shared
    }
}
