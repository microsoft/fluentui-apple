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
                    ShadowInfo(keyColor: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.03),
                                                      dark: ColorValue(r: 0, g: 0, b: 0, a: 0.07)),
                               keyBlur: 14,
                               xKey: 0,
                               yKey: 14,
                               ambientColor: DynamicColor(light: ColorValue(r: 0, g: 0, b: 0, a: 0.33),
                                                          dark: ColorValue(r: 0, g: 0, b: 0, a: 0.66)),
                               ambientBlur: 4,
                               xAmbient: 0,
                               yAmbient: 0)
                })

            case .drawerContentBackground:
                return .dynamicColor({
                    DynamicColor(light: theme.aliasTokens.colors[.background2].light,
                                 dark: theme.aliasTokens.colors[.background2].dark)
                })

            case .popoverContentBackground:
                return .dynamicColor({
                    DynamicColor(light: theme.aliasTokens.colors[.background4].light,
                                 dark: theme.aliasTokens.colors[.background4].dark)
                })

            case .navigationBarBackground:
                return .dynamicColor({
                    theme.aliasTokens.colors[.background3]
                })

            case .cornerRadius:
                return .float({ 14 })

            case .minHorizontalMargin:
                return .float({ GlobalTokens.spacing(.size480) })

            case .minVerticalMargin:
                return .float({ GlobalTokens.spacing(.size200) })

            case .shadowOffset:
                return .float({ GlobalTokens.spacing(.size80) })
            }
        }
    }
}
