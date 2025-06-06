//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
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
        return UIColor(dynamicColor: dynamicColor(token))
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
