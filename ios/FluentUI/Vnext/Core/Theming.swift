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

// MARK: Theme SwiftUI Environment Value

struct ThemeKey: EnvironmentKey {
    static var defaultValue: FluentUIStyle {
        return FluentUIThemeManager.S
    }
}

extension EnvironmentValues {
    var theme: FluentUIStyle {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

extension View {
    func usingTheme(_ theme: FluentUIStyle) -> some View {
        environment(\.theme, theme)
    }
}
