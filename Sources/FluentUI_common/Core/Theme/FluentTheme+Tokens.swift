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

        // Neutral colors - Glass Foreground
        case glassForeground1
        case glassForegroundDisabled1

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
    /// - Returns: A `UIFont` for the given token.
    @objc(typographyForToken:)
    func typographyInfo(_ token: TypographyToken) -> FontInfo {
        return typographyTokenSet[token]
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
    static func defaultShadow(_ token: ShadowToken) -> ShadowInfo {
        switch token {
        case .clear:
            return ShadowInfo(keyColor: Color.clear,
                              keyBlur: 0.0,
                              xKey: 0.0,
                              yKey: 0.0,
                              ambientColor: Color.clear,
                              ambientBlur: 0.0,
                              xAmbient: 0.0,
                              yAmbient: 0.0)
        case .shadow02:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.14),
                                              dark: .black.opacity(0.28)),
                              keyBlur: 2,
                              xKey: 0,
                              yKey: 1,
                              ambientColor: .init(light: .black.opacity(0.12),
                                                  dark: .black.opacity(0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow04:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.14),
                                              dark: .black.opacity(0.28)),
                              keyBlur: 4,
                              xKey: 0,
                              yKey: 2,
                              ambientColor: .init(light: .black.opacity(0.12),
                                                  dark: .black.opacity(0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow08:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.14),
                                              dark: .black.opacity(0.28)),
                              keyBlur: 8,
                              xKey: 0,
                              yKey: 4,
                              ambientColor: .init(light: .black.opacity(0.12),
                                                  dark: .black.opacity(0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow16:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.14),
                                              dark: .black.opacity(0.28)),
                              keyBlur: 16,
                              xKey: 0,
                              yKey: 8,
                              ambientColor: .init(light: .black.opacity(0.12),
                                                  dark: .black.opacity(0.20)),
                              ambientBlur: 2,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow28:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.24),
                                              dark: .black.opacity(0.48)),
                              keyBlur: 28,
                              xKey: 0,
                              yKey: 14,
                              ambientColor: .init(light: .black.opacity(0.20),
                                                  dark: .black.opacity(0.40)),
                              ambientBlur: 8,
                              xAmbient: 0,
                              yAmbient: 0)
        case .shadow64:
            return ShadowInfo(keyColor: .init(light: .black.opacity(0.24),
                                              dark: .black.opacity(0.48)),
                              keyBlur: 64,
                              xKey: 0,
                              yKey: 32,
                              ambientColor: .init(light: .black.opacity(0.20),
                                                  dark: .black.opacity(0.40)),
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
