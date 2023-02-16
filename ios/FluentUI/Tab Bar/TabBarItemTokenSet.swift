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

        /// The X offset of the unread dot in portrait mode
        case unreadDotPortraitOffsetX

        /// The X offset of the unread dot
        case unreadDotOffsetX

        /// The Y offset of the unread dot
        case unreadDotOffsetY

        /// The size of the unread dot
        case unreadDotSize

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
                    return theme.aliasTokens.colors[.brandForeground1]
                }

            case .unselectedColor:
                return .dynamicColor {
                    return theme.aliasTokens.colors[.foreground3]
                }

            case .spacingVertical:
                return .float { 3.0 }

            case .spacingHorizontal:
                return .float { GlobalTokens.spacing(.size80) }

            case .portraitImageSize:
                return .float { GlobalTokens.icon(.size280) }

            case .portraitImageWithLabelSize:
                return .float { GlobalTokens.icon(.size240) }

            case .landscapeImageSize:
                return .float { GlobalTokens.icon(.size240) }

            case .badgeVerticalOffset:
                return .float { -GlobalTokens.spacing(.size40) }

            case .badgePortraitTitleVerticalOffset:
                return .float { -GlobalTokens.spacing(.size20) }

            case .singleDigitBadgeHorizontalOffset:
                return .float { 14.0 }

            case .multiDigitBadgeHorizontalOffset:
                return .float { GlobalTokens.spacing(.size120) }

            case .badgeHeight:
                return .float { 16.0 }

            case .badgeMinWidth:
                return .float { 16.0 }

            case .defaultBadgeMaxWidth:
                return .float { 42.0 }

            case .badgeBorderWidth:
                return .float { GlobalTokens.stroke(.width20) }

            case .badgeHorizontalPadding:
                return .float { 10.0 }

            case .badgeCornerRadii:
                return .float { 10.0 }

            case .unreadDotPortraitOffsetX:
                return .float { 6.0 }

            case .unreadDotOffsetX:
                return .float { 4.0 }

            case .unreadDotOffsetY:
                return .float { 20.0 }

            case .unreadDotSize:
                return .float { 8.0 }

            case .titleLabelFontPortrait:
                return .fontInfo { return .init(size: 10, weight: .medium) }

            case .titleLabelFontLandscape:
                return .fontInfo { return .init(size: 13, weight: .medium) }
            }
        }
    }
}
