//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `Drawer` control
open class DrawerTokens: ControlTokens {
    /// `ShadowInfo` for the shadow used in the `Drawer` control.
    open var shadow: ShadowInfo { return .init(colorOne: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.03),
                                                                      dark: ColorValue(r: 0, g: 0, b: 0, a: 0.07)),
                                               blurOne: 14,
                                               xOne: 0,
                                               yOne: 14,
                                               colorTwo: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.33),
                                                                      dark: ColorValue(r: 0, g: 0, b: 0, a: 0.66)),
                                               blurTwo: 4,
                                               xTwo: 0,
                                               yTwo: 0) }

    /// Color used when dimming the background while showing the `Drawer` control.
    open var backgroundDimmedColor: DynamicColor {
        return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.66),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.99))
    }

    /// Color used for the background of the content of the `Drawer` control.
    open var drawerContentBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.backgroundColors[.neutral3].dark)
    }

    /// Color used for the background of the popover style `Drawer` control.
    open var popoverContentBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.backgroundColors[.surfaceQuaternary].dark)
    }

    /// Color used for the navigation bar of the `Drawer` control.
    open var navigationBarBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: globalTokens.neutralColors[.grey14])
    }

    /// Corner radius for the popover style `Drawer` control.
    open var cornerRadius: CGFloat { return 14 }

    /// Minimum horizontal margin for the `Drawer` control.
    open var minHorizontalMargin: CGFloat { return globalTokens.spacing[.xxxLarge] }

    /// Minimum vertical margin for the `Drawer` control.
    open var minVerticalMargin: CGFloat { return globalTokens.spacing[.large] }

    /// Offset of the shadow for the `Drawer` control.
    open var shadowOffset: CGFloat { return globalTokens.spacing[.xSmall] }
}
