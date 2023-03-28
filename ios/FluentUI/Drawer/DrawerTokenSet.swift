//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `Drawer` control
public class DrawerTokenSet: ControlTokenSet<DrawerTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Corner radius for the popover style `Drawer` control.
        case cornerRadius

        /// Color used for the background of the content of the `Drawer` control.
        case drawerContentBackground

        /// Color used for the navigation bar of the `Drawer` control.
        case navigationBarBackground

        /// Color used for the background of the popover style `Drawer` control.
        case popoverContentBackground

        /// `ShadowInfo` for the shadow used in the `Drawer` control.
        case shadow
    }

    init() {
        super.init { token, theme in
            switch token {
            case .cornerRadius:
                return .float({
                    GlobalTokens.corner(.radius120)
                })

            case .drawerContentBackground:
                return .uiColor({
                    UIColor(light: theme.color(.background2).light,
                            dark: theme.color(.background2).dark)
                })

            case .navigationBarBackground:
                return .uiColor({
                    theme.color(.background3)
                })

            case .popoverContentBackground:
                return .uiColor({
                    UIColor(light: theme.color(.background4).light,
                            dark: theme.color(.background4).dark)
                })

            case .shadow:
                return .shadowInfo({
                    theme.shadow(.shadow28)
                })
            }
        }
    }
}

extension DrawerTokenSet {
    /// Minimum horizontal margin for the `Drawer` control.
    static let minHorizontalMargin: CGFloat = GlobalTokens.spacing(.size480)

    /// Minimum vertical margin for the `Drawer` control.
    static let minVerticalMargin: CGFloat = GlobalTokens.spacing(.size200)

    /// Offset of the shadow for the `Drawer` control.
    static let shadowOffset: CGFloat = GlobalTokens.spacing(.size80)
}
