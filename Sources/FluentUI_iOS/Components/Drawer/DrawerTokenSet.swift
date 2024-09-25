//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum DrawerToken: Int, TokenSetKey {
    /// Corner radius for the popover style `Drawer` control.
    case cornerRadius

    /// Color used for the background of the content of the `Drawer` control.
    case drawerContentBackgroundColor

    /// Color used for the navigation bar of the `Drawer` control.
    case navigationBarBackgroundColor

    /// Color used for the background of the popover style `Drawer` control.
    case popoverContentBackgroundColor

    /// Color used for the background of the `ResizingHandleView` mark.
    case resizingHandleMarkColor

    /// Color used for the background of the `ResizingHandleView`.
    case resizingHandleBackgroundColor

    /// `ShadowInfo` for the shadow used in the `Drawer` control.
    case shadow
}

/// Design token set for the `Drawer` control
public class DrawerTokenSet: ControlTokenSet<DrawerToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .cornerRadius:
                return .float({
                    GlobalTokens.corner(.radius120)
                })

            case .drawerContentBackgroundColor:
                return .uiColor({
                    UIColor(light: theme.color(.background2).light,
                            dark: theme.color(.background2).dark)
                })

            case .navigationBarBackgroundColor:
                return .uiColor({
                    theme.color(.background3)
                })

            case .popoverContentBackgroundColor:
                return .uiColor({
                    UIColor(light: theme.color(.background4).light,
                            dark: theme.color(.background4).dark)
                })

            case .resizingHandleMarkColor:
                return .uiColor({
                    theme.color(.strokeAccessible)
                })

            case .resizingHandleBackgroundColor:
                return .uiColor({
                    .clear
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
