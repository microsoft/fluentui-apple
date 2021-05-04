//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Defintes the interface for a object that is in the view hierarchy and provides its associated UIWindow
/// that can be used by the tokens class to retrieve a theme override for that UIWindow if it exists.
protocol FluentUIWindowProvider {
    var window: UIWindow? { get }
}

/// Base class for all Tokens class. It provides the logic of computing the correct theme to be used by a given control.
class MSFTokensBase {
    var windowProvider: FluentUIWindowProvider?

    /// Used to retrieve the correct theme instance based on the following order of precedence:
    /// - The overriden theme on the control the owns the Tokens class.
    /// - The theme set for the window returned by the windowProvider instance.
    /// - The default theme
    /// Setting this property explicitly means overriding the theme for the control that owns this MSFTokensBase instance.
    var theme: FluentUIStyle {
        get {
            var theme = ThemeKey.defaultValue

            // Uses the window theme if available unless there is a theme explicitly overriden
            // through the View's environment value for the hierarchy that it is contained in.
            if let overridenTheme = _theme {
                theme = overridenTheme
            } else if  let window = windowProvider?.window,
                    let windowTheme = FluentUIThemeManager.stylesheet(for: window) {
                theme = windowTheme
            }

            return theme
        }

        set {
            _theme = newValue
            updateForCurrentTheme()
        }
    }

    /// Override this method to apply the respective appearence proxy values to the tokens.
    /// The appearance proxy should be retrieved from the theme property.
    func updateForCurrentTheme() {
    }

    private var _theme: FluentUIStyle?
}

// MARK: SwiftUI Environment Values

struct ThemeKey: EnvironmentKey {
    static var defaultValue: FluentUIStyle {
        return FluentUIThemeManager.S
    }
}

struct WindowProviderKey: EnvironmentKey {
    static var defaultValue: FluentUIWindowProvider? {
        return nil
    }
}

extension EnvironmentValues {
    var theme: FluentUIStyle {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }

    var windowProvider: FluentUIWindowProvider? {
        get { self[WindowProviderKey.self] }
        set { self[WindowProviderKey.self] = newValue }
    }
}

extension View {

    /// Overrides a theme for a specific SwiftUI View and its view hierarchy.
    /// - Parameter theme: Instance of the custom overriding theme.
    /// - Returns: The view with its theme environment value overriden.
    func customTheme(_ theme: FluentUIStyle) -> some View {
        environment(\.theme, theme)
    }

    /// Sets the window provider used to compute the theme associated with the SwiftUI View
    /// based on the window that it belongs to.
    /// - Parameter windowProvider: An instance of an class that implements the FluentUIWindowProvider protocol.
    /// - Returns: The view with the window provider set for itself and its view hierarchy.
    func windowProvider(_ windowProvider: FluentUIWindowProvider?) -> some View {
        environment(\.windowProvider, windowProvider)
    }

    /// SwiftUI Views using this modifier need to define the following environment values:
    ///  - @Environment(\.theme) var theme: FluentUIStyle
    ///  - @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    ///
    /// The instances of these environment value properties will be passed to the SwiftUI view's subviews in its hierarchy.
    ///
    /// The logic behind the order or precedence to retrieve the correct theme to be used is:
    ///  1. If the SwiftUI View gets a non-default theme instance through the environment value property,
    ///    it will be used to override the theme for this View and all the sub Views in its hierarchy.
    ///
    ///  2. If the theme property retrieve is the default theme instance, the windowProvider will be used to
    ///  retrieve the theme associated with the window that this View belongs to.
    ///
    ///  3. If the windowProvider is nil the default theme property will be used.
    ///
    /// - Parameters:
    ///   - tokens: An instance of a subclass of MSFTokensBase that defines the design tokens used in that particular SwiftUI View.
    ///   - theme: theme property (environment value) of the SwiftUI View.
    ///   - windowProvider: windowProvider property  (environment value) of the SwiftUI View that will potentially retrieve the theme to be applied.
    /// - Returns: The resulting View either with the computed theme applied to its design tokens.
    func designTokens(_ tokens: MSFTokensBase,
                      from theme: FluentUIStyle,
                      with windowProvider: FluentUIWindowProvider?) -> some View {
        self.onAppear {
            tokens.windowProvider = windowProvider

            if theme == ThemeKey.defaultValue {
                tokens.updateForCurrentTheme()
            } else {
                tokens.theme = theme
            }
        }
    }
}
