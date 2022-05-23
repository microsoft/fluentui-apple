//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Internal design token set for the `TabBarItem`.
class TabBarItemTokens: ControlTokens {
    /// Defines the background color of the  of the `TabBarItem` when selected.
    open var selectedColor: DynamicColor {
        return aliasTokens.foregroundColors[.brandRest]
    }

    /// Defines the background color of the  of the `TabBarItem` when not selected.
    open var unselectedColor: DynamicColor {
        DynamicColor(light: ColorValue(0x6E6E6E) /* gray500 */,
                     lightHighContrast: ColorValue(0x303030) /* gray700 */,
                     dark: ColorValue(0x919191) /* gray400 */,
                     darkHighContrast: ColorValue(0xC8C8C8) /* gray200 */)
    }

    /// The vertical spacing of the `TabBarItem` within the TabBar
    open var spacingVertical: CGFloat { 3.0 }

    /// The horizontal spacing of the `TabBarItem` within the TabBar
    open var spacingHorizontal: CGFloat { globalTokens.spacing[.xSmall] }

    /// The size of the image associated with the `TabBarItem` when the device is in portrait mode
    open var portraitImageSize: CGFloat { globalTokens.iconSize[.large] }

    /// The size of the image associated with the `TabBarItem` when the device is in portrait mode and has a label
    open var portraitImageWithLabelSize: CGFloat { globalTokens.iconSize[.medium] }

    /// The size of the image associated with the `TabBarItem` when the device is in landscape mode
    open var landscapeImageSize: CGFloat { globalTokens.iconSize[.medium] }

    /// The vertical offset of the `Badge` associated with this `TabBarItem`
    open var badgeVerticalOffset: CGFloat { -globalTokens.spacing[.xxSmall] }

    /// The vertical offset of the `BadgeLabel` associated with this `TabBarItem` when the device is in portrait mode
    open var badgePortraitTitleVerticalOffset: CGFloat { -globalTokens.spacing[.xxxSmall] }

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is a single digit
    open var singleDigitBadgeHorizontalOffset: CGFloat { 14.0 }

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is multiple digits
    open var multiDigitBadgeHorizontalOffset: CGFloat { globalTokens.spacing[.small] }

    /// The  height of the `BadgeLabel` associated with this `TabBarItem`
    open var badgeHeight: CGFloat { 16.0 }

    /// The minimum width of the `BadgeLabel` associated with this `TabBarItem`
    open var badgeMinWidth: CGFloat { 16.0 }

    /// The default maximum width of the `BadgeLabel` associated with this `TabBarItem`, if not otherwise overridden
    open var defaultBadgeMaxWidth: CGFloat { 42.0 }

    /// The width of the `BadgeLabel` border
    open var badgeBorderWidth: CGFloat { globalTokens.borderSize[.thick] }

    /// The horizontal padding for the `BadgeLabel`
    open var badgeHorizontalPadding: CGFloat { 10.0 }

    /// The radii of the four corners of the `BadgeLabel`
    open var badgeCornerRadii: CGFloat { 10.0 }

    /// Font info for the title label when in portrait view
    open var titleLabelFontPortrait: FontInfo { return .init(size: 10, weight: .medium) }

    /// Font info for the title label when in landscape view
    open var titleLabelFontLandscape: FontInfo { return .init(size: 13, weight: .medium) }
}
