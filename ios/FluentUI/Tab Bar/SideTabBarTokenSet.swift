//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
public class SideTabBarTokenSet: ControlTokenSet<SideTabBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The width of the SideTabBar
        case sideTabBarWidth

        /// The safe spacing for the avatar
        case avatarViewSafeTopSpacing

        /// The minimum spacing for the avatar
        case avatarViewMinTopSpacing

        /// The spacing for the avatar StackView
        case avatarViewTopStackViewSpacing

        /// The safe spacing for the bottom StackView
        case bottomStackViewSafeSpacing

        /// The min spacing for the bottom StackView
        case bottomStackViewMinSpacing

        /// The spacing between the top set of TabBarItems
        case topTabBarItemSpacing

        /// The spacing between the bottom set of TabBarItems
        case bottomTabBarItemSpacing

        /// The padding for the badges on the top set of TabBarItems
        case badgeTopSectionPadding

        /// The padding for the badges on the bottom set of TabBarItems
        case badgeBottomSectionPadding

        /// Optionally overrides the default background color of the  of the `TabBarItem` when selected.
        case tabBarItemSelectedColor

        /// Optionally overrides the default background color of the  of the `TabBarItem` when not selected.
        case tabBarItemUnselectedColor

        /// Optionally overrides the default font info for the title label of the `TabBarItem`when in portrait view
        case tabBarItemTitleLabelFontPortrait

        /// Optionally overrides the default font info for the title label of the `TabBarItem`when in landscape view
        case tabBarItemTitleLabelFontLandscape
    }

    init() {
        super.init { token, theme in
            switch token {
            case .sideTabBarWidth:
                return .float { 62.0 }

            case .avatarViewSafeTopSpacing:
                return .float { 18.0 }

            case .avatarViewMinTopSpacing:
                return .float { theme.globalTokens.spacing[.xxLarge] }

            case .avatarViewTopStackViewSpacing:
                return .float { 34.0 }

            case .bottomStackViewSafeSpacing:
                return .float { 14.0 }

            case .bottomStackViewMinSpacing:
                return .float { theme.globalTokens.spacing[.xLarge] }

            case .topTabBarItemSpacing:
                return .float { 32.0 }

            case .bottomTabBarItemSpacing:
                return .float { theme.globalTokens.spacing[.xLarge] }

            case .badgeTopSectionPadding:
                return .float { 2.0 }

            case .badgeBottomSectionPadding:
                return .float { 4.0 }

            case .tabBarItemSelectedColor:
                return .dynamicColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.foregroundColors[.neutral1]
                }

            case .tabBarItemUnselectedColor:
                return .dynamicColor {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.foregroundColors[.neutral1]
                }

            case .tabBarItemTitleLabelFontPortrait:
                return .fontInfo {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.typography[.body1]
                }

            case .tabBarItemTitleLabelFontLandscape:
                return .fontInfo {
                    assertionFailure("TabBarItem tokens are placeholders and should not be read.")
                    return theme.aliasTokens.typography[.body1]
                }
            }
        }
    }
}
