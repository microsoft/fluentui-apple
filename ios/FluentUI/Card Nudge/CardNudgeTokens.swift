//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public class CardNudgeTokens: CardNudgeThemeable {
    public var accentColor: ColorSet {
        #if BRAND_COLORS
        return GlobalTokens.Colors.Brand.shade20.value
        #else
        return ColorSet(light: 0x005A9E,
                        dark: 0x3AA0F3)
        #endif
    }

    public var accentIconSize: Int {
        return GlobalTokens.Icon.Size.xxSmall.value
    }

    public var accentPadding: Int {
        return GlobalTokens.Spacing.xxSmall.value
    }

    public var backgroundColor: ColorSet {
        return AliasTokens.Colors.Background.neutral2.value
    }

    public var buttonBackgroundColor: ColorSet {
        #if BRAND_COLORS
        return GlobalTokens.Colors.Brand.tint30.value
        #else
        return ColorSet(light: 0xDEECF9,
                        dark: 0x002848)
        #endif
    }

    public var buttonInnerPaddingHorizontal: Int {
        return GlobalTokens.Spacing.small.value
    }

    public var circleSize: Int {
        return GlobalTokens.Icon.Size.xxLarge.value
    }

    public var cornerRadius: Int {
        return GlobalTokens.Border.Radius.xLarge.value
    }

    public var horizontalPadding: Int {
        return GlobalTokens.Spacing.medium.value
    }

    public var iconSize: Int {
        return GlobalTokens.Icon.Size.xSmall.value
    }

    public var interTextVerticalPadding: Int {
        return GlobalTokens.Spacing.xxxSmall.value
    }

    public var mainContentVerticalPadding: Int {
        return GlobalTokens.Spacing.small.value
    }

    public var minimumHeight: Int {
        return 56
    }

    public var outlineColor: ColorSet {
        return AliasTokens.Colors.Background.neutral2.value
    }

    public var outlineWidth: Int {
        return GlobalTokens.Border.Size.thin.value
    }

    public var subtitleTextColor: ColorSet {
        return AliasTokens.Colors.Foreground.neutral3.value
    }

    public var textColor: ColorSet {
        return AliasTokens.Colors.Foreground.neutral1.value
    }

    public var verticalPadding: Int {
        return GlobalTokens.Spacing.xSmall.value
    }
}

class BorderedCardNudgeTokens: CardNudgeTokens {
    override var backgroundColor: ColorSet {
        return AliasTokens.Colors.Background.neutral1.value
    }

    override var outlineColor: ColorSet {
        return AliasTokens.Colors.Stroke.neutral1.value
    }

    override var textColor: ColorSet {
        #if BRAND_COLORS
        return GlobalTokens.Colors.Brand.shade20.value
        #else
        return ColorSet(light: 0x005A9E,
                        dark: 0x3AA0F3)
        #endif
    }
}
