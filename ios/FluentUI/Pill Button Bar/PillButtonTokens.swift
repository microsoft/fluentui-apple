//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Represents the set of `DynamicColor` values for the various states of a `PillButton`
public struct PillButtonDynamicColors {
    let rest: DynamicColor
    let hover: DynamicColor
    let selected: DynamicColor
    let disabled: DynamicColor
    let selectedDisabled: DynamicColor
    let highlighted: DynamicColor
    let selectedHighlighted: DynamicColor
}

/// Design token set for the `PillButton` control.
public class PillButtonTokens: ControlTokens {
    /// Defines the style of the `PillButton`.
    public internal(set) var style: PillButtonStyle = .primary

    /// The background color of the `PillButton`.
    open var backgroundColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selected: globalTokens.brandColors[.primary],
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey80], dark: globalTokens.neutralColors[.grey30]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selectedHighlighted: globalTokens.brandColors[.primary])
        case .onBrand:
            return .init(rest: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         hover: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         selected: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey32]),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade20].light, dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey30]),
                         highlighted: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]))
        }
    }

    /// The color of the title of the `PillButton`.
    open var titleColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         selected: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.black]),
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey44]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.black]))
        case .onBrand:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         selected: DynamicColor(light: globalTokens.brandColors[.primary].light, dark: globalTokens.neutralColors[.white]),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey74], dark: globalTokens.neutralColors[.grey44]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]))
        }
    }

    /// The color of the unread dot when the `PillButton` is enabled.
    open var enabledUnreadDotColor: DynamicColor {
        switch style {
        case .primary:
            return globalTokens.brandColors[.primary]
        case .onBrand:
            return DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84])
        }
    }

    /// The color of the unread dot when the `PillButton` is disabled.
    open var disabledUnreadDotColor: DynamicColor {
        switch style {
        case .primary:
            return DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26])
        case .onBrand:
            return DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26])
        }
    }

    /// The distance of the content from the top of the `PillButton`.
    open var topInset: CGFloat { 6.0 }

    /// The distance of the content from the bottom of the `PillButton`.
    open var bottomInset: CGFloat { 6.0 }

    /// The distance of the content from the sides of the `PillButton`.
    open var horizontalInset: CGFloat { globalTokens.spacing[.medium] }

    /// The distance of the unread dot from the trailing edge of the content of the `PillButton`.
    open var unreadDotOffsetX: CGFloat { 6.0 }

    /// The distance of the unread dot from the bottom of the content of the `PillButton`.
    open var unreadDotOffsetY: CGFloat { 3.0 }

    /// The size of the unread dot of the `PillButton`
    open var unreadDotSize: CGFloat { 6.0 }

    /// The font used for the title of the `PillButton`.
    open var font: FontInfo { aliasTokens.typography[.body2] }
}
