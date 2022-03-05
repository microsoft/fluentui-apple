//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `SegmentedControl`.
open class SegmentedControlTokens: ControlTokens {
    /// Defines the style of the `SegmentedControl`.
    public internal(set) var style: SegmentedControl.Style = .primaryPill

    /// Defines the background color of the unselected segments of the `SegmentedControl`.
    open var restTabColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: aliasTokens.backgroundColors[.neutral4].light, dark: aliasTokens.backgroundColors[.neutral3].dark)
        case .onBrandPill:
            return DynamicColor(light: aliasTokens.backgroundColors[.brandHover].light, dark: aliasTokens.backgroundColors[.neutral3].dark)
        }
    }

    /// Defines the background color of the selected segments of the `SegmentedControl`.
    open var selectedTabColor: DynamicColor {
        switch style {
        case .primaryPill:
            return aliasTokens.foregroundColors[.brandRest]
        case .onBrandPill:
            return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: globalTokens.neutralColors[.grey32])
        }
    }

    /// Defines the background color of the unselected segments of the `SegmentedControl` when disabled.
    open var disabledTabColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8])
        case .onBrandPill:
            return DynamicColor(light: globalTokens.brandColors[.shade20].light, dark: globalTokens.neutralColors[.grey8])
        }
    }

    /// Defines the background color of the selected segments of the `SegmentedControl` when disabled.
    open var disabledSelectedTabColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: globalTokens.neutralColors[.grey80], dark: globalTokens.neutralColors[.grey30])
        case .onBrandPill:
            return DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey30])
        }
    }

    /// Defines the label color of the unselected segments of the `SegmentedControl`.
    open var restLabelColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: aliasTokens.foregroundColors[.neutral3].light, dark: aliasTokens.foregroundColors[.neutral2].dark)
        case .onBrandPill:
            return DynamicColor(light: aliasTokens.foregroundColors[.neutralInverted].light, dark: aliasTokens.foregroundColors[.neutral2].dark)
        }
    }

    /// Defines the label color of the selected segments of the `SegmentedControl`.
    open var selectedLabelColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.foregroundColors[.neutralInverted].dark)
        case .onBrandPill:
            return DynamicColor(light: aliasTokens.foregroundColors[.brandRest].light, dark: aliasTokens.foregroundColors[.neutral1].dark)
        }
    }

    /// Defines the label color of the unselected segments of the `SegmentedControl` when disabled.
    open var disabledLabelColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26])
        case .onBrandPill:
            return DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26])
        }
    }

    /// Defines the label color of the selected segments of the `SegmentedControl` when disabled.
    open var disabledSelectedLabelColor: DynamicColor {
        switch style {
        case .primaryPill:
            return DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey44])
        case .onBrandPill:
            return DynamicColor(light: globalTokens.neutralColors[.grey74], dark: globalTokens.neutralColors[.grey44])
        }
    }

    /// The color of the unread dot when the `SegmentedControl` is enabled.
    open var enabledUnreadDotColor: DynamicColor {
        switch style {
        case .primaryPill:
            return aliasTokens.foregroundColors[.brandRest]
        case .onBrandPill:
            return DynamicColor(light: aliasTokens.foregroundColors[.neutralInverted].light, dark: aliasTokens.foregroundColors[.neutral2].dark)
        }
    }

    /// The distance of the content from the top and bottom of the `SegmentedControl`.
    open var verticalInset: CGFloat { 6.0 }

    /// The distance of the content from the leading and trailing edges of the `SegmentedControl`.
    open var horizontalInset: CGFloat { 16.0 }

    /// The distance of the unread dot from the trailing edge of the content of the `SegmentedControl`.
    open var unreadDotOffsetX: CGFloat { 6.0 }

    /// The distance of the unread dot from the top of the content of the `SegmentedControl`.
    open var unreadDotOffsetY: CGFloat { 3.0 }

    /// The size of the unread dot of the `SegmentedControl`
    open var unreadDotSize: CGFloat { 6.0 }

    /// The font used for the label of the `SegmentedControl`.
    open var font: FontInfo { aliasTokens.typography[.body2] }
}
