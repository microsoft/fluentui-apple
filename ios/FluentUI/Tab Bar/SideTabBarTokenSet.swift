//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
public class SideTabBarTokenSet: ControlTokenSet<SideTabBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Optionally overrides the default background color of the  of the `TabBarItem` when selected.
        case tabBarItemSelectedColor

        /// Optionally overrides the default background color of the  of the `TabBarItem` when not selected.
        case tabBarItemUnselectedColor

        /// Optionally overrides the default font info for the title label of the `TabBarItem`when in portrait view.
        case tabBarItemTitleLabelFontPortrait

        /// Optionally overrides the default font info for the title label of the `TabBarItem`when in landscape view.
        case tabBarItemTitleLabelFontLandscape
    }

    init() {
        super.init { token, theme in
            switch token {
            case .tabBarItemSelectedColor:
                return .uiColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.color(.foreground1)
                }

            case .tabBarItemUnselectedColor:
                return .uiColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.color(.foreground1)
                }

            case .tabBarItemTitleLabelFontPortrait:
                return .uiFont {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.typography(.body1)
                }

            case .tabBarItemTitleLabelFontLandscape:
                return .uiFont {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.typography(.body1)
                }
            }
        }
    }
}

extension SideTabBarTokenSet {
    /// The safe spacing for the avatar.
    static let avatarViewSafeTopSpacing: CGFloat = 18.0

    /// The minimum spacing for the avatar.
    static let avatarViewMinTopSpacing: CGFloat = GlobalTokens.spacing(.size360)

    /// The spacing for the avatar StackView.
    static let avatarViewTopStackViewSpacing: CGFloat = GlobalTokens.spacing(.size360)

    /// The safe spacing for the bottom StackView.
    static let bottomStackViewSafeSpacing: CGFloat = 14.0

    /// The min spacing for the bottom StackView.
    static let bottomStackViewMinSpacing: CGFloat = GlobalTokens.spacing(.size240)

    /// The padding for the badges on the top set of TabBarItems.
    static let badgeTopSectionPadding: CGFloat = GlobalTokens.spacing(.size20)

    /// The padding for the badges on the bottom set of TabBarItems.
    static let badgeBottomSectionPadding: CGFloat = GlobalTokens.spacing(.size40)

    /// The width of the SideTabBar.
    static let sideTabBarWidth: CGFloat = 64.0

    /// The spacing between the  set of TabBarItems.
    static let tabBarItemSpacing: CGFloat = 42.0
}
