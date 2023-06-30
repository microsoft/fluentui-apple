//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Internal design token set for the `TabBarItem`.
class TabBarItemTokenSet: ControlTokenSet<TabBarItemTokenSet.Tokens> {
    enum Tokens: TokenSetKey {
        /// The width of the `BadgeLabel` border.
        case badgeBorderWidth

        /// The radii of the four corners of the `BadgeLabel`.
        case badgeCornerRadii

        /// Defines the foreground color of the `TabBarItem` when disabled.
        case disabledColor

        /// The size of the image associated with the `TabBarItem` when the device is in landscape mode.
        case landscapeImageSize

        /// The size of the image associated with the `TabBarItem` when the device is in portrait mode.
        case portraitImageSize

        /// The size of the image associated with the `TabBarItem` when the device is in portrait mode and has a label.
        case portraitImageWithLabelSize

        /// Defines the foreground color of the `TabBarItem` when selected.
        case selectedColor

        /// Font info for the title label when in portrait view.
        case titleLabelFontPortrait

        /// Font info for the title label when in landscape view.
        case titleLabelFontLandscape

        /// The size of the unread dot.
        case unreadDotSize

        /// Defines the image color of the `TabBarItem` when not selected.
        case unselectedImageColor

        /// Defines the text color of the `TabBarItem` when not selected.
        case unselectedTextColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .badgeBorderWidth:
                return .float { GlobalTokens.stroke(.width20) }

            case .badgeCornerRadii:
                return .float { 10.0 }

            case .disabledColor:
                return .uiColor { theme.color(.foregroundDisabled1) }

            case .landscapeImageSize:
                return .float { GlobalTokens.icon(.size240) }

            case .portraitImageSize:
                return .float { GlobalTokens.icon(.size280) }

            case .portraitImageWithLabelSize:
                return .float { GlobalTokens.icon(.size240) }

            case .selectedColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .titleLabelFontPortrait:
                return .uiFont { theme.typography(.caption2, adjustsForContentSizeCategory: false) }

            case .titleLabelFontLandscape:
                return .uiFont { theme.typography(.caption2, adjustsForContentSizeCategory: false) }

            case .unreadDotSize:
                return .float { 8.0 }

            case .unselectedImageColor:
                return .uiColor { return theme.color(.foreground3) }

            case .unselectedTextColor:
                return .uiColor { return theme.color(.foreground2) }
            }
        }
    }
}

extension TabBarItemTokenSet {
    /// The  height of the `BadgeLabel` associated with this `TabBarItem`.
    static let badgeHeight: CGFloat = GlobalTokens.spacing(.size160)

    /// The horizontal padding for the `BadgeLabel`.
    static let badgeHorizontalPadding: CGFloat = GlobalTokens.spacing(.size100)

    /// The minimum width of the `BadgeLabel` associated with this `TabBarItem`.
    static let badgeMinWidth: CGFloat = GlobalTokens.spacing(.size160)

    /// The vertical offset of the `BadgeLabel` associated with this `TabBarItem` when the device is in portrait mode.
    static let badgePortraitTitleVerticalOffset: CGFloat = -GlobalTokens.spacing(.size20)

    /// The vertical offset of the `Badge` associated with this `TabBarItem`.
    static let badgeVerticalOffset: CGFloat = -GlobalTokens.spacing(.size40)

    /// The default maximum width of the `BadgeLabel` associated with this `TabBarItem`, if not otherwise overridden.
    static let defaultBadgeMaxWidth: CGFloat = GlobalTokens.spacing(.size360)

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is multiple digits.
    static let multiDigitBadgeHorizontalOffset: CGFloat = GlobalTokens.spacing(.size120)

    /// The X offset of the unread dot.
    static let unreadDotOffsetX: CGFloat = GlobalTokens.spacing(.size40)

    /// The Y offset of the unread dot.
    static let unreadDotOffsetY: CGFloat = GlobalTokens.spacing(.size200)

    /// The X offset of the unread dot in portrait mode.
    static let unreadDotPortraitOffsetX: CGFloat = GlobalTokens.spacing(.size60)

    /// The horizontal offset of the `BadgeLabel` associated with this `TabBarItem` when the bade value is a single digit.
    static let singleDigitBadgeHorizontalOffset: CGFloat = 14.0

    /// The horizontal spacing of the `TabBarItem` within the TabBar.
    static let spacingHorizontal: CGFloat = GlobalTokens.spacing(.size80)

    /// The vertical spacing of the `TabBarItem` within the TabBar.
    static let spacingVertical: CGFloat = 3.0
}
