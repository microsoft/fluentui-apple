//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension FluentTheme {
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

        // Brand colors - Brand stroke
        case brandStroke1
        case brandStroke1Pressed
        case brandStroke1Selected

        // Shared colors - Error & Status
        case dangerBackground1
        case dangerBackground2
        case dangerForeground1
        case dangerForeground2
        case successBackground1
        case successBackground2
        case successForeground1
        case successForeground2
        case warningBackground1
        case warningBackground2
        case warningForeground1
        case warningForeground2
        case severeBackground1
        case severeBackground2
        case severeForeground1
        case severeForeground2

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
        return UIColor(dynamicColor: aliasTokens.colors[AliasTokens.ColorsTokens(rawValue: token.rawValue)!])
    }

    /// Returns the shadow value for the given token.
    ///
    /// - Parameter token: The `ShadowTokens` value to be retrieved.
    /// - Returns: A `ShadowInfo` for the given token.
    @objc(shadowForToken:)
    func shadow(_ token: ShadowToken) -> ShadowInfo {
        return aliasTokens.shadow[AliasTokens.ShadowTokens(rawValue: token.rawValue)!]
    }

    /// Returns the font value for the given token.
    ///
    /// - Parameter token: The `TypographyTokens` value to be retrieved.
    /// - Parameter adjustsForContentSizeCategory: If true, the resulting font will change size according to Dynamic Type specifications.
    /// - Returns: A `FontInfo` for the given token.
    @objc(typographyForToken:adjustsForContentSizeCategory:)
    func typography(_ token: TypographyToken, adjustsForContentSizeCategory: Bool = true) -> UIFont {
        return UIFont.fluent(aliasTokens.typography[AliasTokens.TypographyTokens(rawValue: token.rawValue)!],
                             shouldScale: adjustsForContentSizeCategory)
    }
}
