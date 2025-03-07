//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI_common
import SwiftUI
import UIKit

public extension FluentTheme {

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
    ///   - gradientOverrides: A `Dictionary` of override values mapped to `GradientTokens`.
    ///
    /// - Returns: An initialized `FluentTheme` instance, with optional overrides.
    convenience init(colorOverrides: [ColorToken: UIColor]? = nil,
                     shadowOverrides: [ShadowToken: ShadowInfo]? = nil,
                     typographyOverrides: [TypographyToken: UIFont]? = nil,
                     gradientOverrides: [GradientToken: [UIColor]]? = nil) {

        let mappedColorOverrides = colorOverrides?.compactMapValues({ uiColor in
            return Color(uiColor)
        })

        let mappedTypographyOverrides = typographyOverrides?.compactMapValues({ uiFont in
            return FontInfo(name: uiFont.fontName, size: uiFont.pointSize)
        })

        let mappedGradientOverrides = gradientOverrides?.compactMapValues({ uiColors in
            return uiColors.compactMap { uiColor in
                Color(uiColor)
            }
        })

        self.init(colorOverrides: mappedColorOverrides,
                  shadowOverrides: shadowOverrides,
                  typographyOverrides: mappedTypographyOverrides,
                  gradientOverrides: mappedGradientOverrides)
    }

    /// Returns the color value for the given token.
    ///
    /// - Parameter token: The `ColorsTokens` value to be retrieved.
    /// - Returns: A `UIColor` for the given token.
    @objc(colorForToken:)
    func color(_ token: ColorToken) -> UIColor {
		return UIColor(swiftUIColor(token))
    }

    /// Returns the font value for the given token.
    ///
    /// - Parameter token: The `TypographyTokens` value to be retrieved.
    /// - Parameter adjustsForContentSizeCategory: If true, the resulting font will change size according to Dynamic Type specifications.
    /// - Returns: A `UIFont` for the given token.
    @objc(typographyForToken:adjustsForContentSizeCategory:)
    func typography(_ token: TypographyToken, adjustsForContentSizeCategory: Bool = true) -> UIFont {
        return UIFont.fluent(typographyInfo(token),
                             shouldScale: adjustsForContentSizeCategory)
    }

    /// Returns the font value for the given token.
    ///
    /// - Parameter token: The `TypographyTokens` value to be retrieved.
    /// - Parameter adjustsForContentSizeCategory: If true, the resulting font will change size according to Dynamic Type specifications.
    /// - Parameter contentSizeCategory: An overridden `UIContentSizeCategory` to conform to.
    /// - Returns: A `UIFont` for the given token.
    @objc(typographyForToken:adjustsForContentSizeCategory:contentSizeCategory:)
    func typography(_ token: TypographyToken,
                    adjustsForContentSizeCategory: Bool = true,
                    contentSizeCategory: UIContentSizeCategory) -> UIFont {
        return UIFont.fluent(typographyInfo(token),
                             shouldScale: adjustsForContentSizeCategory,
                             contentSizeCategory: contentSizeCategory)
    }

    /// Returns an array of colors for the given token.
    ///
    /// - Parameter token: The `GradientTokens` value to be retrieved.
    /// - Returns: An array of `UIColor` values for the given token.
    @objc(gradientColorsForToken:)
    func gradient(_ token: GradientToken) -> [UIColor] {
        let colors: [Color] = gradient(token)
        return colors.map { UIColor($0) }
    }
}

@objc extension UIView: FluentThemeable {
    private struct Keys {
        static var fluentTheme: UInt8 = 0
        static var cachedFluentTheme: UInt8 = 0
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

    /// Removes any associated `ColorProvider` from the given `UIView`.
    @objc(resetFluentTheme)
    public func resetFluentTheme() {
        objc_setAssociatedObject(self, &Keys.fluentTheme, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        NotificationCenter.default.post(name: .didChangeTheme, object: self)
    }

    @objc(isApplicableThemeChange:)
    public func isApplicableThemeChange(_ notification: Notification) -> Bool {
        // Do not update unless the notification's name is `.didChangeTheme`.
        guard notification.name == .didChangeTheme else {
            return false
        }

        // If there is no object, or it is not a UIView, we must assume that we need to update.
        guard let themeView = notification.object as? UIView else {
            return true
        }

        // If the object is a UIView, we only update if `view` is a descendant thereof.
        return self.isDescendant(of: themeView)
    }
}
