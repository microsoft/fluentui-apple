//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Alias Tokens represent a unified set of semantic values to be used by Fluent UI.
///
/// Values are derived from the Fluent UI design token system at https://github.com/microsoft/fluentui-design-tokens.
@available(*, deprecated, message: "`AliasTokens` is now deprecated. Please fetch all token values from `FluentTheme` directly.")
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

    @available(*, deprecated, message: "`AliasTokens` is now deprecated. Please use `typography` on `FluentTheme`.")
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

    @available(*, deprecated, message: "`AliasTokens` is now deprecated. Please use `shadow` on `FluentTheme`.")
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

    @available(*, deprecated, message: "`AliasTokens` is now deprecated. Please use `color` on `FluentTheme`.")
    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `colors` property directly.")
    @objc(aliasColorForToken:)
    public func color(_ token: ColorsTokens) -> DynamicColor {
        return colors[token]
    }
    public private(set) var colors: TokenSet<ColorsTokens, DynamicColor>

    // MARK: - Gradient Colors

    @objc(MSFGradientColorAliasTokens)
    public enum GradientTokens: Int, TokenSetKey {
        case flair
        case tint
    }

    @available(*, deprecated, message: "`AliasTokens` is now deprecated. Please use `gradient` on `FluentTheme`.")
    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please use the `gradientColors` property directly.")
    @objc(aliasGradientColorsForToken:)
    public func gradientColors(_ token: GradientTokens) -> [UIColor] {
        return gradients[token]
    }
    public let gradients: TokenSet<GradientTokens, [UIColor]>

    // MARK: Initialization

    init(colorTokenSet: TokenSet<FluentTheme.ColorToken, UIColor>,
         shadowTokenSet: TokenSet<FluentTheme.ShadowToken, ShadowInfo>,
         typographyTokenSet: TokenSet<FluentTheme.TypographyToken, FontInfo>,
         gradientTokenSet: TokenSet<FluentTheme.GradientToken, [UIColor]>) {

        self.colors = .init { colorTokenSet[FluentTheme.ColorToken(rawValue: $0.rawValue)!].dynamicColor! }
        self.shadow = .init { shadowTokenSet[FluentTheme.ShadowToken(rawValue: $0.rawValue)!] }
        self.typography = .init { typographyTokenSet[FluentTheme.TypographyToken(rawValue: $0.rawValue)!] }
        self.gradients = .init { gradientTokenSet[FluentTheme.GradientToken(rawValue: $0.rawValue)!] }

        super.init()
    }
}
