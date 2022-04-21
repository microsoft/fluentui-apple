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
    open var selectedColor: DynamicColor {
        return self.aliasTokens.foregroundColors[.brandRest]
    }

    /// Defines the background color of the  of the `TabBarItem` when not selected.
    open var unselectedColor: DynamicColor {
        return DynamicColor(light: ColorValue(0x6E6E6E) /* gray500 */,
                            lightHighContrast: ColorValue(0x303030) /* gray700 */,
                            dark: ColorValue(0x919191) /* gray400 */,
                            darkHighContrast: ColorValue(0xC8C8C8) /* gray200 */)
    }

    /// The vertical spacing of the `TabBarItem` within the TabBar
    open var spacingVertical: CGFloat { globalTokens.spacing[.xSmall] }

    /// The horizontal spacing of the `TabBarItem` within the TabBar
    open var spacingHorizontal: CGFloat { 8.0 }

    /// The size of the image associated with the `TabBarItem` when the device is in portrait mode
    open var portraitImageSize: CGFloat { globalTokens.iconSize[.large] }

    /// The size of the image associated with the `TabBarItem` when the device is in portrait mode and has a label
    open var portraitImageWithLabelSize: CGFloat { globalTokens.iconSize[.medium] }

    /// The size of the image associated with the `TabBarItem` when the device is in landscape mode
    open var landscapeImageSize: CGFloat { 24.0 }

    /// The vertical offset of the `Badge` associated with this `TabBarItem`
    open var badgeVerticalOffset: CGFloat { -globalTokens.spacing[.xxxSmall] }

    /// The vertical offset of the `BadgeLabel` associated with this `TabBarItem` when the device is in portrait mode
    open var badgePortraitTitleVerticalOffset: CGFloat { -2.0 }

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is a single digit
    open var singleDigitBadgeHorizontalOffset: CGFloat { 14.0 }

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is multiple digits
    open var multiDigitBadgeHorizontalOffset: CGFloat { 12.0 }

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
}
