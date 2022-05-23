//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `TabBar`.
open class TabBarTokens: ControlTokens {
    /// The height of the `TabBar` when in portrait view on a phone
    open var phonePortraitHeight: CGFloat { 48.0 }

    /// The height of the `TabBar` when in landscape view on a phone
    open var phoneLandscapeHeight: CGFloat { 40.0 }

    /// The height of the `TabBar` when on a non-phone device
    open var padHeight: CGFloat { 48.0 }

    /// Defines the background color of the  of the `TabBarItem` when selected.
    open var tabBarItemSelectedColor: DynamicColor? { nil }

    /// Defines the background color of the  of the `TabBarItem` when not selected.
    open var tabBarItemUnselectedColor: DynamicColor? { nil }

    /// Font info for the title label when in portrait view
    open var tabBarItemTitleLabelFontPortrait: FontInfo? { nil }

    /// Font info for the title label when in landscape view
    open var tabBarItemTitleLabelFontLandscape: FontInfo? { nil }
}
