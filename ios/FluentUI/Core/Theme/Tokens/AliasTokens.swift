//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Alias Tokens represent a unified set of semantic values to be used by Fluent UI.
///
/// Values are derived from the Fluent UI design token system at https://github.com/microsoft/fluentui-design-tokens.
@objc(MSFAliasTokens)
public final class AliasTokens: NSObject {

    // MARK: - Typography

    @objc(MSFTypographyAliasTokens)
    public enum TypographyTokens: Int, TokenSetKey {
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

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `typography` property directly.")
    @objc(typographyForToken:)
    public func typography(_ token: TypographyTokens) -> FontInfo {
        return typography[token]
    }

    public let typography: TokenSet<TypographyTokens, FontInfo>

    // MARK: - Shadow

    @objc(MSFShadowAliasTokens)
    public enum ShadowTokens: Int, TokenSetKey {
        case clear
        case shadow02
        case shadow04
        case shadow08
        case shadow16
        case shadow28
        case shadow64
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `shadow` property directly.")
    @objc(shadowForToken:)
    public func shadow(_ token: ShadowTokens) -> ShadowInfo {
        return shadow[token]
    }

    public let shadow: TokenSet<ShadowTokens, ShadowInfo>

    // MARK: - Colors

    @objc(MSFColorAliasTokens)
    public enum ColorsTokens: Int, TokenSetKey {
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

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `colors` property directly.")
    @objc(aliasColorForToken:)
    public func color(_ token: ColorsTokens) -> DynamicColor {
        return colors[token]
    }
    public let colors: TokenSet<ColorsTokens, DynamicColor>

    // MARK: - Gradient Colors

    @objc(MSFGradientColorAliasTokens)
    public enum GradientTokens: Int, TokenSetKey {
        case flair
        case tint
    }

    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `gradientColors` property directly.")
    @objc(aliasGradientColorsForToken:)
    public func gradientColors(_ token: GradientTokens) -> [UIColor] {
        return gradients[token]
    }
    /// `GradientTokens` need to be lazily initialized in order to fetch the correct alias color tokens from the instance's `self.colors`.
    public lazy var gradients: TokenSet<GradientTokens, [UIColor]> = {
        return .init(self.defaultGradientColors(_:), gradientOverrides)
    }()

    private let gradientOverrides: [GradientTokens: [UIColor]]?

    // MARK: Initialization

    init(colorOverrides: [ColorsTokens: DynamicColor]? = nil,
         shadowOverrides: [ShadowTokens: ShadowInfo]? = nil,
         typographyOverrides: [TypographyTokens: FontInfo]? = nil,
         gradientOverrides: [GradientTokens: [UIColor]]? = nil) {

        self.colors = .init(AliasTokens.defaultColors(_:), colorOverrides)
        self.shadow = .init(AliasTokens.defaultShadows(_:), shadowOverrides)
        self.typography = .init(AliasTokens.defaultTypography(_:), typographyOverrides)
        self.gradientOverrides = gradientOverrides

        super.init()
    }
}

// MARK: - AliasTokens default values

extension AliasTokens {

    private static func defaultColors(_ token: ColorsTokens) -> DynamicColor {
        switch token {
        case .foreground1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                dark: GlobalTokens.neutralColors(.white))
        case .foreground2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey84))
        case .foreground3:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey50),
                                dark: GlobalTokens.neutralColors(.grey68))
        case .foregroundDisabled1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey74),
                                dark: GlobalTokens.neutralColors(.grey36))
        case .foregroundDisabled2:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey18))
        case .foregroundOnColor:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black))
        case .brandForegroundTint:
            return DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                dark: GlobalTokens.brandColors(.comm130))
        case .brandForeground1:
            return DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                dark: GlobalTokens.brandColors(.comm100))
        case .brandForeground1Pressed:
            return DynamicColor(light: GlobalTokens.brandColors(.comm50),
                                dark: GlobalTokens.brandColors(.comm140))
        case .brandForeground1Selected:
            return DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                dark: GlobalTokens.brandColors(.comm120))
        case .brandForegroundDisabled1:
            return DynamicColor(light: GlobalTokens.brandColors(.comm90))
        case .brandForegroundDisabled2:
            return DynamicColor(light: GlobalTokens.brandColors(.comm140),
                                dark: GlobalTokens.brandColors(.comm40))
        case .brandGradient1:
            return DynamicColor(light: GlobalTokens.brandColors(.gradientPrimaryLight),
                                dark: GlobalTokens.brandColors(.gradientPrimaryDark))
        case .brandGradient2:
            return DynamicColor(light: GlobalTokens.brandColors(.gradientSecondaryLight),
                                dark: GlobalTokens.brandColors(.gradientSecondaryDark))
        case .brandGradient3:
            return DynamicColor(light: GlobalTokens.brandColors(.gradientTertiaryLight),
                                dark: GlobalTokens.brandColors(.gradientTertiaryDark))
        case .foregroundDarkStatic:
            return DynamicColor(light: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.black))
        case .foregroundLightStatic:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.white))
        case .background1:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black),
                                darkElevated: GlobalTokens.neutralColors(.grey4))
        case .background1Pressed:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey18),
                                darkElevated: GlobalTokens.neutralColors(.grey18))
        case .background1Selected:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                                dark: GlobalTokens.neutralColors(.grey14),
                                darkElevated: GlobalTokens.neutralColors(.grey14))
        case .background2:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey12),
                                darkElevated: GlobalTokens.neutralColors(.grey16))
        case .background2Pressed:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey30),
                                darkElevated: GlobalTokens.neutralColors(.grey30))
        case .background2Selected:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                                dark: GlobalTokens.neutralColors(.grey26),
                                darkElevated: GlobalTokens.neutralColors(.grey26))
        case .background3:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey16),
                                darkElevated: GlobalTokens.neutralColors(.grey20))
        case .background3Pressed:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey34),
                                darkElevated: GlobalTokens.neutralColors(.grey34))
        case .background3Selected:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey92),
                                dark: GlobalTokens.neutralColors(.grey30),
                                darkElevated: GlobalTokens.neutralColors(.grey30))
        case .background4:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey98),
                                dark: GlobalTokens.neutralColors(.grey20),
                                darkElevated: GlobalTokens.neutralColors(.grey24))
        case .background4Pressed:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey86),
                                dark: GlobalTokens.neutralColors(.grey38),
                                darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background4Selected:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey90),
                                dark: GlobalTokens.neutralColors(.grey34),
                                darkElevated: GlobalTokens.neutralColors(.grey34))
        case .background5:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey94),
                                dark: GlobalTokens.neutralColors(.grey24),
                                darkElevated: GlobalTokens.neutralColors(.grey28))
        case .background5Pressed:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                dark: GlobalTokens.neutralColors(.grey42),
                                darkElevated: GlobalTokens.neutralColors(.grey42))
        case .background5Selected:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey86),
                                dark: GlobalTokens.neutralColors(.grey38),
                                darkElevated: GlobalTokens.neutralColors(.grey38))
        case .background6:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                dark: GlobalTokens.neutralColors(.grey36),
                                darkElevated: GlobalTokens.neutralColors(.grey40))
        case .backgroundDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey32),
                                darkElevated: GlobalTokens.neutralColors(.grey32))
        case .brandBackgroundTint:
            return DynamicColor(light: GlobalTokens.brandColors(.comm150),
                                dark: GlobalTokens.brandColors(.comm40))
        case .brandBackground1:
            return DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                dark: GlobalTokens.brandColors(.comm100))
        case .brandBackground1Pressed:
            return DynamicColor(light: GlobalTokens.brandColors(.comm50),
                                dark: GlobalTokens.brandColors(.comm140))
        case .brandBackground1Selected:
            return DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                dark: GlobalTokens.brandColors(.comm120))
        case .brandBackground2:
            return DynamicColor(light: GlobalTokens.brandColors(.comm70))
        case .brandBackground2Pressed:
            return DynamicColor(light: GlobalTokens.brandColors(.comm40))
        case .brandBackground2Selected:
            return DynamicColor(light: GlobalTokens.brandColors(.comm80))
        case .brandBackground3:
            return DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                dark: GlobalTokens.brandColors(.comm120))
        case .brandBackgroundDisabled:
            return DynamicColor(light: GlobalTokens.brandColors(.comm140),
                                dark: GlobalTokens.brandColors(.comm40))
        case .stencil1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey90),
                                dark: GlobalTokens.neutralColors(.grey34))
        case .stencil2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey98),
                                dark: GlobalTokens.neutralColors(.grey20))
        case .backgroundCanvas:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey96),
                                dark: GlobalTokens.neutralColors(.grey8),
                                darkElevated: GlobalTokens.neutralColors(.grey14))
        case .backgroundDarkStatic:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                dark: GlobalTokens.neutralColors(.grey24),
                                darkElevated: GlobalTokens.neutralColors(.grey30))
        case .backgroundInverted:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey46),
                                dark: GlobalTokens.neutralColors(.grey72),
                                darkElevated: GlobalTokens.neutralColors(.grey78))
        case .backgroundLightStatic:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.white),
                                darkElevated: GlobalTokens.neutralColors(.white))
        case .backgroundLightStaticDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.grey68),
                                darkElevated: GlobalTokens.neutralColors(.grey42))
        case .stroke1:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                dark: GlobalTokens.neutralColors(.grey30),
                                darkElevated: GlobalTokens.neutralColors(.grey36))
        case .stroke2:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey24))
        case .strokeDisabled:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey88),
                                dark: GlobalTokens.neutralColors(.grey26))
        case .strokeAccessible:
            return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                dark: GlobalTokens.neutralColors(.grey62))
        case .strokeFocus1:
            return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                dark: GlobalTokens.neutralColors(.black))
        case .strokeFocus2:
            return DynamicColor(light: GlobalTokens.neutralColors(.black),
                                dark: GlobalTokens.neutralColors(.white))
        case .brandStroke1:
            return DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                dark: GlobalTokens.brandColors(.comm100))
        case .brandStroke1Pressed:
            return DynamicColor(light: GlobalTokens.brandColors(.comm50),
                                dark: GlobalTokens.brandColors(.comm140))
        case .brandStroke1Selected:
            return DynamicColor(light: GlobalTokens.brandColors(.comm60),
                                dark: GlobalTokens.brandColors(.comm120))
        case .dangerBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .tint60),
                                dark: GlobalTokens.sharedColors(.red, .shade40))
        case .dangerBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .primary),
                                dark: GlobalTokens.sharedColors(.red, .shade10))
        case .dangerForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                dark: GlobalTokens.sharedColors(.red, .tint30))
        case .dangerForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .primary),
                                dark: GlobalTokens.sharedColors(.red, .tint30))
        case .dangerStroke1:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .tint20),
                                dark: GlobalTokens.sharedColors(.red, .tint20))
        case .successBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .tint60),
                                dark: GlobalTokens.sharedColors(.green, .shade40))
        case .successBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .primary),
                                dark: GlobalTokens.sharedColors(.green, .shade10))
        case .successForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .shade10),
                                dark: GlobalTokens.sharedColors(.green, .tint30))
        case .successForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .primary),
                                dark: GlobalTokens.sharedColors(.green, .tint30))
        case .successStroke1:
            return DynamicColor(light: GlobalTokens.sharedColors(.green, .tint20),
                                dark: GlobalTokens.sharedColors(.green, .tint20))
        case .severeBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .tint60),
                                dark: GlobalTokens.sharedColors(.darkOrange, .shade40))
        case .severeBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .primary),
                                dark: GlobalTokens.sharedColors(.darkOrange, .shade10))
        case .severeForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .shade10),
                                dark: GlobalTokens.sharedColors(.darkOrange, .tint30))
        case .severeForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .shade20),
                                dark: GlobalTokens.sharedColors(.darkOrange, .tint30))
        case .severeStroke1:
            return DynamicColor(light: GlobalTokens.sharedColors(.darkOrange, .tint10),
                                dark: GlobalTokens.sharedColors(.darkOrange, .tint20))
        case .warningBackground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .tint60),
                                dark: GlobalTokens.sharedColors(.yellow, .shade40))
        case .warningBackground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .primary),
                                dark: GlobalTokens.sharedColors(.yellow, .shade10))
        case .warningForeground1:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .shade30),
                                dark: GlobalTokens.sharedColors(.yellow, .tint30))
        case .warningForeground2:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .shade30),
                                dark: GlobalTokens.sharedColors(.yellow, .tint30))
        case .warningStroke1:
            return DynamicColor(light: GlobalTokens.sharedColors(.yellow, .shade30),
                                dark: GlobalTokens.sharedColors(.yellow, .shade20))
        case .presenceAway:
            return DynamicColor(light: GlobalTokens.sharedColors(.marigold, .primary))
        case .presenceDnd:
            return DynamicColor(light: GlobalTokens.sharedColors(.red, .primary),
                                dark: GlobalTokens.sharedColors(.red, .tint10))
        case .presenceAvailable:
            return DynamicColor(light: GlobalTokens.sharedColors(.lightGreen, .primary),
                                dark: GlobalTokens.sharedColors(.lightGreen, .tint20))
        case .presenceOof:
            return DynamicColor(light: GlobalTokens.sharedColors(.berry, .primary),
                                dark: GlobalTokens.sharedColors(.berry, .tint20))
        }
    }

    private func defaultGradientColors(_ token: GradientTokens) -> [UIColor] {
        switch token {
        case .flair:
            return [UIColor(dynamicColor: colors[.brandGradient1]),
                    UIColor(dynamicColor: colors[.brandGradient2]),
                    UIColor(dynamicColor: colors[.brandGradient3])]
        case .tint:
            return [UIColor(dynamicColor: colors[.brandGradient2]),
                    UIColor(dynamicColor: colors[.brandGradient3])]
        }
    }

    private static func defaultShadows(_ token: ShadowTokens) -> ShadowInfo {
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

    private static func defaultTypography(_ token: TypographyTokens) -> FontInfo {
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
}
