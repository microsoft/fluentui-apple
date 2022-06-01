//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
open class SideTabBarTokens: ControlTokens {
    /// The width of the SideTabBar
    open var sideTabBarWidth: CGFloat { 62.0 }

    /// The safe spacing for the avatar
    open var avatarViewSafeTopSpacing: CGFloat { 18.0 }

    /// The minimum spacing for the avatar
    open var avatarViewMinTopSpacing: CGFloat { 36.0 }

    /// The
    open var avatarViewTopStackViewSpacing: CGFloat { 34.0 }

    /// The safe spacing for the bottom StackView
    open var bottomStackViewSafeSpacing: CGFloat { 14.0 }

    /// The min spacing for the bottom StackView
    open var bottomStackViewMinSpacing: CGFloat { 24.0 }

    /// The spacing between the top set of TabBarItems
    open var topTabBarItemSpacing: CGFloat { 32.0 }

    /// The spacing between the bottom set of TabBarItems
    open var bottomTabBarItemSpacing: CGFloat { 24.0 }

    /// The size of the top set of TabBarItems
    open var topTabBarItemSize: CGFloat { 28.0 }

    /// The size of the bottom set of TabBarItems
    open var bottomTabBarItemSize: CGFloat { 24.0 }

    /// The padding for the badges on the top set of TabBarItems
    open var badgeTopSectionPadding: CGFloat { 2.0 }

    /// The padding for the badges on the bottom set of TabBarItems
    open var badgeBottomSectionPadding: CGFloat { 4.0 }

    /// Defines the background color of the  of the `TabBarItem` when selected.
    open var tabBarItemSelectedColor: DynamicColor? { nil }

    /// Defines the background color of the  of the `TabBarItem` when not selected.
    open var tabBarItemUnselectedColor: DynamicColor? { nil }

    /// Font info for the title label when in portrait view
    open var tabBarItemTitleLabelFontPortrait: FontInfo? { nil }

    /// Font info for the title label when in landscape view
    open var tabBarItemTitleLabelFontLandscape: FontInfo? { nil }
}
