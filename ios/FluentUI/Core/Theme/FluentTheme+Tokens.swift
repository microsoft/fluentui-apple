//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
    /// - Returns: A `UIColor` for the given token.
    @objc(colorForToken:)
    func color(_ token: ColorToken) -> UIColor {
        return colorTokenSet[token]
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
    /// - Returns: An array of `UIColor` values for the given token.
    @objc(gradientColorsForToken:)
    func gradient(_ token: GradientToken) -> [UIColor] {
        return gradientTokenSet[token]
    }
}

extension FluentTheme {
    static func defaultColor(_ token: FluentTheme.ColorToken) -> UIColor {
        switch token {
        case .foreground1:
            return UIColor(light: GlobalTokens.neutralColor(.grey14),
                           dark: GlobalTokens.neutralColor(.white))
        case .foreground2:
            return UIColor(light: GlobalTokens.neutralColor(.grey38),
                           dark: GlobalTokens.neutralColor(.grey84))
        case .foreground3:
            return UIColor(light: GlobalTokens.neutralColor(.grey50),
                           dark: GlobalTokens.neutralColor(.grey68))
        case .foregroundDisabled1:
            return UIColor(light: GlobalTokens.neutralColor(.grey74),
                           dark: GlobalTokens.neutralColor(.grey36))
        case .foregroundDisabled2:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.grey18))
        case .foregroundOnColor:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.black))
        case .brandForegroundTint:
            return UIColor(light: GlobalTokens.brandColor(.comm60),
                           dark: GlobalTokens.brandColor(.comm130))
        case .brandForeground1:
            return UIColor(light: GlobalTokens.brandColor(.comm80),
                           dark: GlobalTokens.brandColor(.comm100))
        case .brandForeground1Pressed:
            return UIColor(light: GlobalTokens.brandColor(.comm50),
                           dark: GlobalTokens.brandColor(.comm140))
        case .brandForeground1Selected:
            return UIColor(light: GlobalTokens.brandColor(.comm60),
                           dark: GlobalTokens.brandColor(.comm120))
        case .brandForegroundDisabled1:
            return UIColor(light: GlobalTokens.brandColor(.comm90))
        case .brandForegroundDisabled2:
            return UIColor(light: GlobalTokens.brandColor(.comm140),
                           dark: GlobalTokens.brandColor(.comm40))
        case .brandGradient1:
            return UIColor(light: GlobalTokens.brandColor(.gradientPrimaryLight),
                           dark: GlobalTokens.brandColor(.gradientPrimaryDark))
        case .brandGradient2:
            return UIColor(light: GlobalTokens.brandColor(.gradientSecondaryLight),
                           dark: GlobalTokens.brandColor(.gradientSecondaryDark))
        case .brandGradient3:
            return UIColor(light: GlobalTokens.brandColor(.gradientTertiaryLight),
                           dark: GlobalTokens.brandColor(.gradientTertiaryDark))
        case .foregroundDarkStatic:
            return UIColor(light: GlobalTokens.neutralColor(.black),
                           dark: GlobalTokens.neutralColor(.black))
        case .foregroundLightStatic:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.white))
        case .background1:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.black),
                           darkElevated: GlobalTokens.neutralColor(.grey4))
        case .background1Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey18),
                           darkElevated: GlobalTokens.neutralColor(.grey18))
        case .background1Selected:
            return UIColor(light: GlobalTokens.neutralColor(.grey92),
                           dark: GlobalTokens.neutralColor(.grey14),
                           darkElevated: GlobalTokens.neutralColor(.grey14))
        case .background2:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.grey12),
                           darkElevated: GlobalTokens.neutralColor(.grey16))
        case .background2Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey30),
                           darkElevated: GlobalTokens.neutralColor(.grey30))
        case .background2Selected:
            return UIColor(light: GlobalTokens.neutralColor(.grey92),
                           dark: GlobalTokens.neutralColor(.grey26),
                           darkElevated: GlobalTokens.neutralColor(.grey26))
        case .background3:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.grey16),
                           darkElevated: GlobalTokens.neutralColor(.grey20))
        case .background3Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey34),
                           darkElevated: GlobalTokens.neutralColor(.grey34))
        case .background3Selected:
            return UIColor(light: GlobalTokens.neutralColor(.grey92),
                           dark: GlobalTokens.neutralColor(.grey30),
                           darkElevated: GlobalTokens.neutralColor(.grey30))
        case .background4:
            return UIColor(light: GlobalTokens.neutralColor(.grey98),
                           dark: GlobalTokens.neutralColor(.grey20),
                           darkElevated: GlobalTokens.neutralColor(.grey24))
        case .background4Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey86),
                           dark: GlobalTokens.neutralColor(.grey38),
                           darkElevated: GlobalTokens.neutralColor(.grey38))
        case .background4Selected:
            return UIColor(light: GlobalTokens.neutralColor(.grey90),
                           dark: GlobalTokens.neutralColor(.grey34),
                           darkElevated: GlobalTokens.neutralColor(.grey34))
        case .background5:
            return UIColor(light: GlobalTokens.neutralColor(.grey94),
                           dark: GlobalTokens.neutralColor(.grey24),
                           darkElevated: GlobalTokens.neutralColor(.grey28))
        case .background5Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey82),
                           dark: GlobalTokens.neutralColor(.grey42),
                           darkElevated: GlobalTokens.neutralColor(.grey42))
        case .background5Selected:
            return UIColor(light: GlobalTokens.neutralColor(.grey86),
                           dark: GlobalTokens.neutralColor(.grey38),
                           darkElevated: GlobalTokens.neutralColor(.grey38))
        case .background6:
            return UIColor(light: GlobalTokens.neutralColor(.grey82),
                           dark: GlobalTokens.neutralColor(.grey36),
                           darkElevated: GlobalTokens.neutralColor(.grey40))
        case .backgroundDisabled:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey32),
                           darkElevated: GlobalTokens.neutralColor(.grey32))
        case .brandBackgroundTint:
            return UIColor(light: GlobalTokens.brandColor(.comm150),
                           dark: GlobalTokens.brandColor(.comm40))
        case .brandBackground1:
            return UIColor(light: GlobalTokens.brandColor(.comm80),
                           dark: GlobalTokens.brandColor(.comm100))
        case .brandBackground1Pressed:
            return UIColor(light: GlobalTokens.brandColor(.comm50),
                           dark: GlobalTokens.brandColor(.comm140))
        case .brandBackground1Selected:
            return UIColor(light: GlobalTokens.brandColor(.comm60),
                           dark: GlobalTokens.brandColor(.comm120))
        case .brandBackground2:
            return UIColor(light: GlobalTokens.brandColor(.comm70))
        case .brandBackground2Pressed:
            return UIColor(light: GlobalTokens.brandColor(.comm40))
        case .brandBackground2Selected:
            return UIColor(light: GlobalTokens.brandColor(.comm80))
        case .brandBackground3:
            return UIColor(light: GlobalTokens.brandColor(.comm60),
                           dark: GlobalTokens.brandColor(.comm120))
        case .brandBackgroundDisabled:
            return UIColor(light: GlobalTokens.brandColor(.comm140),
                           dark: GlobalTokens.brandColor(.comm40))
        case .stencil1:
            return UIColor(light: GlobalTokens.neutralColor(.grey90),
                           dark: GlobalTokens.neutralColor(.grey34))
        case .stencil2:
            return UIColor(light: GlobalTokens.neutralColor(.grey98),
                           dark: GlobalTokens.neutralColor(.grey20))
        case .backgroundCanvas:
            return UIColor(light: GlobalTokens.neutralColor(.grey96),
                           dark: GlobalTokens.neutralColor(.grey8),
                           darkElevated: GlobalTokens.neutralColor(.grey14))
        case .backgroundDarkStatic:
            return UIColor(light: GlobalTokens.neutralColor(.grey14),
                           dark: GlobalTokens.neutralColor(.grey24),
                           darkElevated: GlobalTokens.neutralColor(.grey30))
        case .backgroundInverted:
            return UIColor(light: GlobalTokens.neutralColor(.grey46),
                           dark: GlobalTokens.neutralColor(.grey72),
                           darkElevated: GlobalTokens.neutralColor(.grey78))
        case .backgroundLightStatic:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.white),
                           darkElevated: GlobalTokens.neutralColor(.white))
        case .backgroundLightStaticDisabled:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.grey68),
                           darkElevated: GlobalTokens.neutralColor(.grey42))
        case .stroke1:
            return UIColor(light: GlobalTokens.neutralColor(.grey82),
                           dark: GlobalTokens.neutralColor(.grey30),
                           darkElevated: GlobalTokens.neutralColor(.grey36))
        case .stroke1Pressed:
            return UIColor(light: GlobalTokens.neutralColor(.grey70),
                           dark: GlobalTokens.neutralColor(.grey48))
        case .stroke2:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey24),
                           darkElevated: GlobalTokens.neutralColor(.grey30))
        case .strokeAccessible:
            return UIColor(light: GlobalTokens.neutralColor(.grey38),
                           dark: GlobalTokens.neutralColor(.grey62),
                           darkElevated: GlobalTokens.neutralColor(.grey68))
        case .strokeFocus1:
            return UIColor(light: GlobalTokens.neutralColor(.white),
                           dark: GlobalTokens.neutralColor(.black))
        case .strokeFocus2:
            return UIColor(light: GlobalTokens.neutralColor(.black),
                           dark: GlobalTokens.neutralColor(.white))
        case .strokeDisabled:
            return UIColor(light: GlobalTokens.neutralColor(.grey88),
                           dark: GlobalTokens.neutralColor(.grey26),
                           darkElevated: GlobalTokens.neutralColor(.grey32))
        case .brandStroke1:
            return UIColor(light: GlobalTokens.brandColor(.comm80),
                           dark: GlobalTokens.brandColor(.comm100))
        case .brandStroke1Pressed:
            return UIColor(light: GlobalTokens.brandColor(.comm50),
                           dark: GlobalTokens.brandColor(.comm140))
        case .brandStroke1Selected:
            return UIColor(light: GlobalTokens.brandColor(.comm60),
                           dark: GlobalTokens.brandColor(.comm120))
        case .dangerBackground1:
            return UIColor(light: GlobalTokens.sharedColor(.red, .tint60),
                           dark: GlobalTokens.sharedColor(.red, .shade40))
        case .dangerBackground2:
            return UIColor(light: GlobalTokens.sharedColor(.red, .primary),
                           dark: GlobalTokens.sharedColor(.red, .shade10))
        case .dangerForeground1:
            return UIColor(light: GlobalTokens.sharedColor(.red, .shade10),
                           dark: GlobalTokens.sharedColor(.red, .tint30))
        case .dangerForeground2:
            return UIColor(light: GlobalTokens.sharedColor(.red, .primary),
                           dark: GlobalTokens.sharedColor(.red, .tint30))
        case .dangerStroke1:
            return UIColor(light: GlobalTokens.sharedColor(.red, .tint20),
                           dark: GlobalTokens.sharedColor(.red, .tint20))
        case .dangerStroke2:
            return UIColor(light: GlobalTokens.sharedColor(.red, .primary),
                           dark: GlobalTokens.sharedColor(.red, .tint30))
        case .successBackground1:
            return UIColor(light: GlobalTokens.sharedColor(.green, .tint60),
                           dark: GlobalTokens.sharedColor(.green, .shade40))
        case .successBackground2:
            return UIColor(light: GlobalTokens.sharedColor(.green, .primary),
                           dark: GlobalTokens.sharedColor(.green, .shade10))
        case .successForeground1:
            return UIColor(light: GlobalTokens.sharedColor(.green, .shade10),
                           dark: GlobalTokens.sharedColor(.green, .tint30))
        case .successForeground2:
            return UIColor(light: GlobalTokens.sharedColor(.green, .primary),
                           dark: GlobalTokens.sharedColor(.green, .tint30))
        case .successStroke1:
            return UIColor(light: GlobalTokens.sharedColor(.green, .tint20),
                           dark: GlobalTokens.sharedColor(.green, .tint20))
        case .severeBackground1:
            return UIColor(light: GlobalTokens.sharedColor(.darkOrange, .tint60),
                           dark: GlobalTokens.sharedColor(.darkOrange, .shade40))
        case .severeBackground2:
            return UIColor(light: GlobalTokens.sharedColor(.darkOrange, .primary),
                           dark: GlobalTokens.sharedColor(.darkOrange, .shade10))
        case .severeForeground1:
            return UIColor(light: GlobalTokens.sharedColor(.darkOrange, .shade10),
                           dark: GlobalTokens.sharedColor(.darkOrange, .tint30))
        case .severeForeground2:
            return UIColor(light: GlobalTokens.sharedColor(.darkOrange, .shade20),
                           dark: GlobalTokens.sharedColor(.darkOrange, .tint30))
        case .severeStroke1:
            return UIColor(light: GlobalTokens.sharedColor(.darkOrange, .tint10),
                           dark: GlobalTokens.sharedColor(.darkOrange, .tint20))
        case .warningBackground1:
            return UIColor(light: GlobalTokens.sharedColor(.yellow, .tint60),
                           dark: GlobalTokens.sharedColor(.yellow, .shade40))
        case .warningBackground2:
            return UIColor(light: GlobalTokens.sharedColor(.yellow, .primary),
                           dark: GlobalTokens.sharedColor(.yellow, .shade10))
        case .warningForeground1:
            return UIColor(light: GlobalTokens.sharedColor(.yellow, .shade30),
                           dark: GlobalTokens.sharedColor(.yellow, .tint30))
        case .warningForeground2:
            return UIColor(light: GlobalTokens.sharedColor(.yellow, .shade30),
                           dark: GlobalTokens.sharedColor(.yellow, .tint30))
        case .warningStroke1:
            return UIColor(light: GlobalTokens.sharedColor(.yellow, .shade30),
                           dark: GlobalTokens.sharedColor(.yellow, .shade20))
        case .presenceAway:
            return UIColor(light: GlobalTokens.sharedColor(.marigold, .primary))
        case .presenceDnd:
            return UIColor(light: GlobalTokens.sharedColor(.red, .primary),
                           dark: GlobalTokens.sharedColor(.red, .tint10))
        case .presenceAvailable:
            return UIColor(light: GlobalTokens.sharedColor(.lightGreen, .primary),
                           dark: GlobalTokens.sharedColor(.lightGreen, .tint20))
        case .presenceOof:
            return UIColor(light: GlobalTokens.sharedColor(.berry, .primary),
                           dark: GlobalTokens.sharedColor(.berry, .tint20))
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
    static func defaultGradientColor(_ token: GradientToken, colorTokenSet: TokenSet<ColorToken, UIColor>) -> [UIColor] {
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
