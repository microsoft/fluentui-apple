//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension FluentTheme {
    @objc(MSFGradientToken)
    enum GradientToken: Int, TokenSetKey {
        case flair
        case tint
    }

    @objc(MSFColorToken)
    enum ColorToken: Int, TokenSetKey {
        // Neutral colors - Background
        case background1
        case background1Pressed
        case background1Selected
        case background2
        case background2Pressed
        case background2Selected
        case background3
        case background3Pressed
        case background3Selected
        case background4
        case background4Pressed
        case background4Selected
        case background5
        case background5Pressed
        case background5Selected
        case background6
        case backgroundCanvas
        case backgroundDarkStatic
        case backgroundLightStatic
        case backgroundLightStaticDisabled
        case backgroundInverted
        case backgroundDisabled
        case stencil1
        case stencil2

        // Neutral colors - Foreground
        case foreground1
        case foreground2
        case foreground3
        case foregroundDisabled1
        case foregroundDisabled2
        case foregroundOnColor
        case foregroundDarkStatic
        case foregroundLightStatic

        // Neutral colors - Stroke
        case stroke1
        case stroke1Pressed
        case stroke2
        case strokeAccessible
        case strokeFocus1
        case strokeFocus2
        case strokeDisabled

        // Brand colors - Brand background
        case brandBackground1
        case brandBackground1Pressed
        case brandBackground1Selected
        case brandBackground2
        case brandBackground2Pressed
        case brandBackground2Selected
        case brandBackground3
        case brandBackgroundTint
        case brandBackgroundDisabled

        // Brand colors - Brand foreground
        case brandForeground1
        case brandForeground1Pressed
        case brandForeground1Selected
        case brandForegroundTint
        case brandForegroundDisabled1
        case brandForegroundDisabled2

        // Brand colors - Brand gradient
        case brandGradient1
        case brandGradient2
        case brandGradient3

        // Brand colors - Brand stroke
        case brandStroke1
        case brandStroke1Pressed
        case brandStroke1Selected

        // Shared colors - Error & Status
        case dangerBackground1
        case dangerBackground2
        case dangerForeground1
        case dangerForeground2
        case dangerStroke1
        case dangerStroke2
        case successBackground1
        case successBackground2
        case successForeground1
        case successForeground2
        case successStroke1
        case warningBackground1
        case warningBackground2
        case warningForeground1
        case warningForeground2
        case warningStroke1
        case severeBackground1
        case severeBackground2
        case severeForeground1
        case severeForeground2
        case severeStroke1

        // Shared colors - Presence
        case presenceAway
        case presenceDnd
        case presenceAvailable
        case presenceOof
    }

    @objc(MSFShadowToken)
    enum ShadowToken: Int, TokenSetKey {
        case clear
        case shadow02
        case shadow04
        case shadow08
        case shadow16
        case shadow28
        case shadow64
    }

    @objc(MSFTypographyToken)
    enum TypographyToken: Int, TokenSetKey {
        case display
        case largeTitle
        case title1
        case title2
        case title3
        case body1Strong
        case body1
        case body2Strong
        case body2
        case caption1Strong
        case caption1
        case caption2
    }

    /// Returns the color value for the given token.
    ///
    /// - Parameter token: The `ColorsTokens` value to be retrieved.
    /// - Returns: A `Color` for the given token.
    func swiftUIColor(_ token: ColorToken) -> Color {
        return Color(dynamicColor: colorTokenSet[token])
    }

    /// Returns the shadow value for the given token.
    ///
    /// - Parameter token: The `ShadowTokens` value to be retrieved.
    /// - Returns: A `ShadowInfo` for the given token.
    @objc(shadowForToken:)
    func shadow(_ token: ShadowToken) -> ShadowInfo {
        return shadowTokenSet[token]
    }

    /// Returns the font value for the given token.
    ///
    /// - Parameter token: The `TypographyTokens` value to be retrieved.
    /// - Parameter adjustsForContentSizeCategory: If true, the resulting font will change size according to Dynamic Type specifications.
    /// - Returns: A `UIFont` for the given token.
    @objc(typographyForToken:adjustsForContentSizeCategory:)
    func typography(_ token: TypographyToken, adjustsForContentSizeCategory: Bool = true) -> UIFont {
        return UIFont.fluent(typographyTokenSet[token],
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
        return UIFont.fluent(typographyTokenSet[token],
                             shouldScale: adjustsForContentSizeCategory,
                             contentSizeCategory: contentSizeCategory)
    }

    /// Returns an array of colors for the given token.
    ///
    /// - Parameter token: The `GradientTokens` value to be retrieved.
    /// - Returns: An array of `Color` values for the given token.
    func gradient(_ token: GradientToken) -> [Color] {
        return gradientTokenSet[token].map { Color(dynamicColor: $0) }
    }
}

extension FluentTheme {
    static func defaultColor(_ token: FluentTheme.ColorToken) -> DynamicColor {
        switch token {
        case .foreground1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey14),
                                dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .foreground2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey38),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey84))
        case .foreground3:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey50),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey68))
        case .foregroundDisabled1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey74),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey36))
        case .foregroundDisabled2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey18))
        case .foregroundOnColor:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .brandForegroundTint:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm60),
                                dark: GlobalTokens.brandSwiftUIColor(.comm130))
        case .brandForeground1:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm80),
                                dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandForeground1Pressed:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm50),
                                dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandForeground1Selected:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm60),
                                dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandForegroundDisabled1:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm90))
        case .brandForegroundDisabled2:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm140),
                                dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .brandGradient1:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.gradientPrimaryLight),
                                dark: GlobalTokens.brandSwiftUIColor(.gradientPrimaryDark))
        case .brandGradient2:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.gradientSecondaryLight),
                                dark: GlobalTokens.brandSwiftUIColor(.gradientSecondaryDark))
        case .brandGradient3:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.gradientTertiaryLight),
                                dark: GlobalTokens.brandSwiftUIColor(.gradientTertiaryDark))
        case .foregroundDarkStatic:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.black),
                                dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .foregroundLightStatic:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .background1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.black),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey4))
        case .background1Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey18),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey18))
        case .background1Selected:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey14),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey14))
        case .background2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey12),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey16))
        case .background2Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .background2Selected:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey26),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey26))
        case .background3:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey16),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey20))
        case .background3Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey34),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .background3Selected:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .background4:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey98),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey20),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey24))
        case .background4Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey86),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey38),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey38))
        case .background4Selected:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey90),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey34),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .background5:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey94),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey28))
        case .background5Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey42),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey42))
        case .background5Selected:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey86),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey38),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey38))
        case .background6:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey36),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey40))
        case .backgroundDisabled:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey32),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey32))
        case .brandBackgroundTint:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm150),
                                dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .brandBackground1:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm80),
                                dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandBackground1Pressed:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm50),
                                dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandBackground1Selected:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm60),
                                dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandBackground2:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm70))
        case .brandBackground2Pressed:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm40))
        case .brandBackground2Selected:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm80))
        case .brandBackground3:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm60),
                                dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandBackgroundDisabled:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm140),
                                dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .stencil1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey90),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .stencil2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey98),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey20))
        case .backgroundCanvas:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey96),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey8),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey14))
        case .backgroundDarkStatic:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey14),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .backgroundInverted:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey46),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey72),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey78))
        case .backgroundLightStatic:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.white),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.white))
        case .backgroundLightStaticDisabled:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey68),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey42))
        case .stroke1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey36))
        case .stroke1Pressed:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey70),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey48))
        case .stroke2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .strokeAccessible:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey38),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey62),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey68))
        case .strokeFocus1:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.white),
                                dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .strokeFocus2:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.black),
                                dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .strokeDisabled:
            return DynamicColor(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                                dark: GlobalTokens.neutralSwiftUIColor(.grey26),
                                darkElevated: GlobalTokens.neutralSwiftUIColor(.grey32))
        case .brandStroke1:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm80),
                                dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandStroke1Pressed:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm50),
                                dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandStroke1Selected:
            return DynamicColor(light: GlobalTokens.brandSwiftUIColor(.comm60),
                                dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .dangerBackground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .tint60),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .shade40))
        case .dangerBackground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .shade10))
        case .dangerForeground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .shade10),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .dangerForeground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .dangerStroke1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .tint20),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .tint20))
        case .dangerStroke2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .successBackground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.green, .tint60),
                                dark: GlobalTokens.sharedSwiftUIColor(.green, .shade40))
        case .successBackground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.green, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.green, .shade10))
        case .successForeground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
                                dark: GlobalTokens.sharedSwiftUIColor(.green, .tint30))
        case .successForeground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.green, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.green, .tint30))
        case .successStroke1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.green, .tint20),
                                dark: GlobalTokens.sharedSwiftUIColor(.green, .tint20))
        case .severeBackground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint60),
                                dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade40))
        case .severeBackground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade10))
        case .severeForeground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade10),
                                dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint30))
        case .severeForeground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade20),
                                dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint30))
        case .severeStroke1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint10),
                                dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint20))
        case .warningBackground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.yellow, .tint60),
                                dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade40))
        case .warningBackground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.yellow, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade10))
        case .warningForeground1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                                dark: GlobalTokens.sharedSwiftUIColor(.yellow, .tint30))
        case .warningForeground2:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                                dark: GlobalTokens.sharedSwiftUIColor(.yellow, .tint30))
        case .warningStroke1:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                                dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade20))
        case .presenceAway:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.marigold, .primary))
        case .presenceDnd:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.red, .tint10))
        case .presenceAvailable:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.lightGreen, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.lightGreen, .tint20))
        case .presenceOof:
            return DynamicColor(light: GlobalTokens.sharedSwiftUIColor(.berry, .primary),
                                dark: GlobalTokens.sharedSwiftUIColor(.berry, .tint20))
        }
    }

    static func defaultShadow(_ token: ShadowToken) -> ShadowInfo {
        switch token {
        case .clear:
            return ShadowInfo(keyColor: .clear,
                              keyBlur: 0.0,
                              xKey: 0.0,
                              yKey: 0.0,
                              ambientColor: .clear,
                              ambientBlur: 0.0,
                              xAmbient: 0.0,
                              yAmbient: 0.0)
        case .shadow02:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.14),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.28)),
                              keyBlur: 2,
                              xKey: 0,
                              yKey: 1,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow04:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.14),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.28)),
                              keyBlur: 4,
                              xKey: 0,
                              yKey: 2,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow08:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.14),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.28)),
                              keyBlur: 8,
                              xKey: 0,
                              yKey: 4,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow16:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.14),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.28)),
                              keyBlur: 16,
                              xKey: 0,
                              yKey: 8,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow28:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.24),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.48)),
                              keyBlur: 28,
                              xKey: 0,
                              yKey: 14,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.40)),
                              ambientBlur: 8,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow64:
            return ShadowInfo(keyColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.24),
                                                dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.48)),
                              keyBlur: 64,
                              xKey: 0,
                              yKey: 32,
                              ambientColor: UIColor(light: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.20),
                                                    dark: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.40)),
                              ambientBlur: 8,
                              xAmbient: 0,
                              yAmbient: 0)
        }
    }

    static func defaultTypography(_ token: TypographyToken) -> FontInfo {
        switch token {
        case .display:
            return .init(size: GlobalTokens.fontSize(.size900),
                         weight: GlobalTokens.fontWeight(.bold))
        case .largeTitle:
            return .init(size: GlobalTokens.fontSize(.size800),
                         weight: GlobalTokens.fontWeight(.bold))
        case .title1:
            return .init(size: GlobalTokens.fontSize(.size700),
                         weight: GlobalTokens.fontWeight(.bold))
        case .title2:
            return .init(size: GlobalTokens.fontSize(.size600),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .title3:
            return .init(size: GlobalTokens.fontSize(.size500),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body1Strong:
            return .init(size: GlobalTokens.fontSize(.size400),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body1:
            return .init(size: GlobalTokens.fontSize(.size400),
                         weight: GlobalTokens.fontWeight(.regular))
        case .body2Strong:
            return .init(size: GlobalTokens.fontSize(.size300),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .body2:
            return .init(size: GlobalTokens.fontSize(.size300),
                         weight: GlobalTokens.fontWeight(.regular))
        case .caption1Strong:
            return .init(size: GlobalTokens.fontSize(.size200),
                         weight: GlobalTokens.fontWeight(.semibold))
        case .caption1:
            return .init(size: GlobalTokens.fontSize(.size200),
                         weight: GlobalTokens.fontWeight(.regular))
        case .caption2:
            return .init(size: GlobalTokens.fontSize(.size100),
                         weight: GlobalTokens.fontWeight(.regular))
        }
    }

    /// Derives its default values from the theme's `colorTokenSet` values
    static func defaultGradientColor(_ token: GradientToken, colorTokenSet: TokenSet<ColorToken, DynamicColor>) -> [DynamicColor] {
        switch token {
        case .flair:
            return [colorTokenSet[.brandGradient1],
                    colorTokenSet[.brandGradient2],
                    colorTokenSet[.brandGradient3]]
        case .tint:
            return [colorTokenSet[.brandGradient2],
                    colorTokenSet[.brandGradient3]]
        }
    }

}
