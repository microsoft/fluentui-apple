//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `Drawer` control
public class DrawerTokenSet: ControlTokenSet<DrawerTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// `ShadowInfo` for the shadow used in the `Drawer` control.
        case shadow

        /// Color used when dimming the background while showing the `Drawer` control.
        case backgroundDimmedColor

        /// Color used for the background of the content of the `Drawer` control.
        case drawerContentBackground

        /// Color used for the background of the popover style `Drawer` control.
        case popoverContentBackground

        /// Color used for the navigation bar of the `Drawer` control.
        case navigationBarBackground

        /// Corner radius for the popover style `Drawer` control.
        case cornerRadius

        /// Minimum horizontal margin for the `Drawer` control.
        case minHorizontalMargin

        /// Minimum vertical margin for the `Drawer` control.
        case minVerticalMargin

        /// Offset of the shadow for the `Drawer` control.
        case shadowOffset
    }

    init() {
        super.init { token, theme in
            switch token {
            case .shadow:
                return .shadowInfo({
                    ShadowInfo(colorOne: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.03),
                                                      dark: ColorValue(r: 0, g: 0, b: 0, a: 0.07)),
                               blurOne: 14,
                               xOne: 0,
                               yOne: 14,
                               colorTwo: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.33),
                                                      dark: ColorValue(r: 0, g: 0, b: 0, a: 0.66)),
                               blurTwo: 4,
                               xTwo: 0,
                               yTwo: 0)
                })

            case .backgroundDimmedColor:
                return .dynamicColor({
                    DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.66),
                                 dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.99))
                })

            case .drawerContentBackground:
                return .dynamicColor({
                    DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                                 dark: theme.aliasTokens.backgroundColors[.neutral3].dark)
                })

            case .popoverContentBackground:
                return .dynamicColor({
                    DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                                 dark: theme.aliasTokens.backgroundColors[.surfaceQuaternary].dark)
                })

            case .navigationBarBackground:
                return .dynamicColor({
                    DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                                 dark: theme.globalTokens.neutralColors[.grey14])
                })

            case .cornerRadius:
                return .float({ 14 })

            case .minHorizontalMargin:
                return .float({ theme.globalTokens.spacing[.xxxLarge] })

            case .minVerticalMargin:
                return .float({ theme.globalTokens.spacing[.large] })

            case .shadowOffset:
                return .float({ theme.globalTokens.spacing[.xSmall] })
            }
        }
    }
}

public class PopupMenuTokenSet: DrawerTokenSet {}
