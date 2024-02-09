//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum SideTabBarToken: Int, TokenSetKey {
    /// Optionally overrides the default background color of the `SideTabBar`.
    case backgroundColor

    /// Optionally overrides the default background color of the `TabBarItem` when selected.
    case tabBarItemSelectedColor

    /// Optionally overrides the default background color of the `TabBarItem` when not selected.
    case tabBarItemUnselectedColor

    /// Optionally overrides the default font info for the title label `TabBarItem`when in portrait view.
    case tabBarItemTitleLabelFontPortrait

    /// Optionally overrides the default font info for the title label `TabBarItem`when in landscape view.
    case tabBarItemTitleLabelFontLandscape

    /// Optionally overrides the default color of the separator.
    case separatorColor
}

/// Design token set for the `TabBar`.
public class SideTabBarTokenSet: ControlTokenSet<SideTabBarToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { .clear }

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

            case .separatorColor:
                return .uiColor { theme.color(.stroke2) }
            }
        }
    }
}

extension SideTabBarTokenSet {
    /// The safe spacing for the avatar.
    static let avatarViewSafeTopSpacing: CGFloat = 18.0

    /// The minimum spacing for the avatar.
    static let avatarViewMinTopSpacing: CGFloat = Compatibility.isDeviceIdiomVision() ? 34 : GlobalTokens.spacing(.size360)

    /// The spacing for the avatar StackView.
    static let avatarViewTopStackViewSpacing: CGFloat = GlobalTokens.spacing(.size360)

    /// The safe spacing for the bottom StackView.
    static let bottomStackViewSafeSpacing: CGFloat = 14.0

    /// The min spacing for the bottom StackView.
    static let bottomStackViewMinSpacing: CGFloat = Compatibility.isDeviceIdiomVision() ? GlobalTokens.spacing(.size360) : GlobalTokens.spacing(.size240)

    /// The padding for the badges on the top set of TabBarItems.
    static let badgeTopSectionPadding: CGFloat = GlobalTokens.spacing(.size20)

    /// The padding for the badges on the bottom set of TabBarItems.
    static let badgeBottomSectionPadding: CGFloat = GlobalTokens.spacing(.size40)

    /// The width of the SideTabBar.
    static let sideTabBarWidth: CGFloat = 64.0

    /// The spacing between the  set of TabBarItems.
    static let tabBarItemSpacing: CGFloat = 42.0
}
