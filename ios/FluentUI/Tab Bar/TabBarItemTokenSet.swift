//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Internal design token set for the `TabBarItem`.
class TabBarItemTokenSet: ControlTokenSet<TabBarItemTokenSet.Tokens> {
    enum Tokens: TokenSetKey {
        /// Defines the background color of the  of the `TabBarItem` when selected.
        case selectedColor

        /// Defines the background color of the  of the `TabBarItem` when not selected.
        case unselectedColor

        /// The vertical spacing of the `TabBarItem` within the TabBar
        case spacingVertical

        /// The horizontal spacing of the `TabBarItem` within the TabBar
        case spacingHorizontal

        /// The size of the image associated with the `TabBarItem` when the device is in portrait mode
        case portraitImageSize

        /// The size of the image associated with the `TabBarItem` when the device is in portrait mode and has a label
        case portraitImageWithLabelSize

        /// The size of the image associated with the `TabBarItem` when the device is in landscape mode
        case landscapeImageSize

        /// The vertical offset of the `Badge` associated with this `TabBarItem`
        case badgeVerticalOffset

        /// The vertical offset of the `BadgeLabel` associated with this `TabBarItem` when the device is in portrait mode
        case badgePortraitTitleVerticalOffset

        /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is a single digit
        case singleDigitBadgeHorizontalOffset

        /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is multiple digits
        case multiDigitBadgeHorizontalOffset

        /// The  height of the `BadgeLabel` associated with this `TabBarItem`
        case badgeHeight

        /// The minimum width of the `BadgeLabel` associated with this `TabBarItem`
        case badgeMinWidth

        /// The default maximum width of the `BadgeLabel` associated with this `TabBarItem`, if not otherwise overridden
        case defaultBadgeMaxWidth

        /// The width of the `BadgeLabel` border
        case badgeBorderWidth

        /// The horizontal padding for the `BadgeLabel`
        case badgeHorizontalPadding

        /// The radii of the four corners of the `BadgeLabel`
        case badgeCornerRadii

        /// Font info for the title label when in portrait view
        case titleLabelFontPortrait

        /// Font info for the title label when in landscape view
        case titleLabelFontLandscape
    }

    init() {
        super.init { token, theme in
            switch token {
            case .selectedColor:
                return .dynamicColor {
                    return theme.aliasTokens.foregroundColors[.brandRest]
                }

            case .unselectedColor:
                return .dynamicColor {
                    DynamicColor(light: ColorValue(0x6E6E6E) /* gray500 */,
                                 lightHighContrast: ColorValue(0x303030) /* gray700 */,
                                 dark: ColorValue(0x919191) /* gray400 */,
                                 darkHighContrast: ColorValue(0xC8C8C8) /* gray200 */)
                }

            case .spacingVertical:
                return .float { 3.0 }

            case .spacingHorizontal:
                return .float { theme.globalTokens.spacing[.xSmall] }

            case .portraitImageSize:
                return .float { theme.globalTokens.iconSize[.large] }

            case .portraitImageWithLabelSize:
                return .float { theme.globalTokens.iconSize[.medium] }

            case .landscapeImageSize:
                return .float { theme.globalTokens.iconSize[.medium] }

            case .badgeVerticalOffset:
                return .float { -theme.globalTokens.spacing[.xxSmall] }

            case .badgePortraitTitleVerticalOffset:
                return .float { -theme.globalTokens.spacing[.xxxSmall] }

            case .singleDigitBadgeHorizontalOffset:
                return .float { 14.0 }

            case .multiDigitBadgeHorizontalOffset:
                return .float { theme.globalTokens.spacing[.small] }

            case .badgeHeight:
                return .float { 16.0 }

            case .badgeMinWidth:
                return .float { 16.0 }

            case .defaultBadgeMaxWidth:
                return .float { 42.0 }

            case .badgeBorderWidth:
                return .float { theme.globalTokens.borderSize[.thick] }

            case .badgeHorizontalPadding:
                return .float { 10.0 }

            case .badgeCornerRadii:
                return .float { 10.0 }

            case .titleLabelFontPortrait:
                return .fontInfo { return .init(size: 10, weight: .medium) }

            case .titleLabelFontLandscape:
                return .fontInfo { return .init(size: 13, weight: .medium) }
            }
        }
    }
}
