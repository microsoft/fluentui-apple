//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

/// Extending `FluentTheme` to implement this protocol allows for platform-specific implementation of token values.
extension FluentTheme: PlatformThemeProviding {

    /// Returns the platform-appropriate value for a given `ColorToken`.
    /// - Parameters:
    ///   - token: The `ColorToken` whose color should be provided.
    /// - Returns: The color value for this token. If the token is not supported on the platform, a fallback value will be returned.
    public static func platformColorValue(_ token: FluentTheme.ColorToken) -> DynamicColor {
        var color: DynamicColor
        switch token {
        case .foreground1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey14),
                          dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .foreground2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey38),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey84))
        case .foreground3:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey50),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey68))
        case .foregroundDisabled1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey74),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey36))
        case .foregroundDisabled2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey18))
        case .foregroundOnColor:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .brandForegroundTint:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm60),
                          dark: GlobalTokens.brandSwiftUIColor(.comm130))
        case .brandForeground1:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm80),
                          dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandForeground1Pressed:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm50),
                          dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandForeground1Selected:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm60),
                          dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandForegroundDisabled1:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm90))
        case .brandForegroundDisabled2:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm140),
                          dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .glassForeground1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey30),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey92))
        case .glassForegroundDisabled1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey60),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey50))
        case .brandGradient1:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.gradientPrimaryLight),
                          dark: GlobalTokens.brandSwiftUIColor(.gradientPrimaryDark))
        case .brandGradient2:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.gradientSecondaryLight),
                          dark: GlobalTokens.brandSwiftUIColor(.gradientSecondaryDark))
        case .brandGradient3:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.gradientTertiaryLight),
                          dark: GlobalTokens.brandSwiftUIColor(.gradientTertiaryDark))
        case .foregroundDarkStatic:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.black),
                          dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .foregroundLightStatic:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .background1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.black),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey4))
        case .background1Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey18),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey18))
        case .background1Selected:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey14),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey14))
        case .background2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey12),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey16))
        case .background2Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .background2Selected:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey26),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey26))
        case .background3:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey16),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey20))
        case .background3Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey34),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .background3Selected:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey92),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .background4:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey98),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey20),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey24))
        case .background4Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey86),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey38),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey38))
        case .background4Selected:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey90),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey34),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .background5:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey94),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey28))
        case .background5Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey42),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey42))
        case .background5Selected:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey86),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey38),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey38))
        case .background6:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey36),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey40))
        case .backgroundDisabled:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey32),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey32))
        case .brandBackgroundTint:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm150),
                          dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .brandBackground1:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm80),
                          dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandBackground1Pressed:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm50),
                          dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandBackground1Selected:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm60),
                          dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandBackground2:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm70))
        case .brandBackground2Pressed:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm40))
        case .brandBackground2Selected:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm80))
        case .brandBackground3:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm60),
                          dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .brandBackgroundDisabled:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm140),
                          dark: GlobalTokens.brandSwiftUIColor(.comm40))
        case .stencil1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey90),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey34))
        case .stencil2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey98),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey20))
        case .backgroundCanvas:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey96),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey8),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey14))
        case .backgroundDarkStatic:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey14),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .backgroundInverted:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey46),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey72),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey78))
        case .backgroundLightStatic:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.white),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.white))
        case .backgroundLightStaticDisabled:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey68),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey42))
        case .stroke1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey82),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey30),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey36))
        case .stroke1Pressed:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey70),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey48))
        case .stroke2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey24),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey30))
        case .strokeAccessible:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey38),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey62),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey68))
        case .strokeFocus1:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.white),
                          dark: GlobalTokens.neutralSwiftUIColor(.black))
        case .strokeFocus2:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.black),
                          dark: GlobalTokens.neutralSwiftUIColor(.white))
        case .strokeDisabled:
            color = .init(light: GlobalTokens.neutralSwiftUIColor(.grey88),
                          dark: GlobalTokens.neutralSwiftUIColor(.grey26),
                          darkElevated: GlobalTokens.neutralSwiftUIColor(.grey32))
        case .brandStroke1:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm80),
                          dark: GlobalTokens.brandSwiftUIColor(.comm100))
        case .brandStroke1Pressed:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm50),
                          dark: GlobalTokens.brandSwiftUIColor(.comm140))
        case .brandStroke1Selected:
            color = .init(light: GlobalTokens.brandSwiftUIColor(.comm60),
                          dark: GlobalTokens.brandSwiftUIColor(.comm120))
        case .dangerBackground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .tint60),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .shade40))
        case .dangerBackground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .shade10))
        case .dangerForeground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .shade10),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .dangerForeground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .dangerStroke1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .tint20),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .tint20))
        case .dangerStroke2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .tint30))
        case .successBackground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.green, .tint60),
                          dark: GlobalTokens.sharedSwiftUIColor(.green, .shade40))
        case .successBackground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.green, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.green, .shade10))
        case .successForeground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
                          dark: GlobalTokens.sharedSwiftUIColor(.green, .tint30))
        case .successForeground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.green, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.green, .tint30))
        case .successStroke1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.green, .tint20),
                          dark: GlobalTokens.sharedSwiftUIColor(.green, .tint20))
        case .severeBackground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint60),
                          dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade40))
        case .severeBackground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade10))
        case .severeForeground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade10),
                          dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint30))
        case .severeForeground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .shade20),
                          dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint30))
        case .severeStroke1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint10),
                          dark: GlobalTokens.sharedSwiftUIColor(.darkOrange, .tint20))
        case .warningBackground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.yellow, .tint60),
                          dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade40))
        case .warningBackground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.yellow, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade10))
        case .warningForeground1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                          dark: GlobalTokens.sharedSwiftUIColor(.yellow, .tint30))
        case .warningForeground2:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                          dark: GlobalTokens.sharedSwiftUIColor(.yellow, .tint30))
        case .warningStroke1:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.yellow, .shade30),
                          dark: GlobalTokens.sharedSwiftUIColor(.yellow, .shade20))
        case .presenceAway:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.marigold, .primary))
        case .presenceDnd:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.red, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.red, .tint10))
        case .presenceAvailable:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.lightGreen, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.lightGreen, .tint20))
        case .presenceOof:
            color = .init(light: GlobalTokens.sharedSwiftUIColor(.berry, .primary),
                          dark: GlobalTokens.sharedSwiftUIColor(.berry, .tint20))
        }

#if os(visionOS)
        // visionOS has special overrides above and beyond what iOS does
        if let visionColor = visionColorOverride(token, defaultColor: color) {
            color = visionColor
        }
#endif
        return color
    }
}
