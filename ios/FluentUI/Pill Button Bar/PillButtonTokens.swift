//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Represents the set of `DynamicColor` values for the various states of a `PillButton`
public struct PillButtonDynamicColors {
    public init (rest: DynamicColor,
                 selected: DynamicColor,
                 disabled: DynamicColor,
                 selectedDisabled: DynamicColor) {
        self.rest = rest
        self.selected = selected
        self.disabled = disabled
        self.selectedDisabled = selectedDisabled
    }

    public let rest: DynamicColor
    public let selected: DynamicColor
    public let disabled: DynamicColor
    public let selectedDisabled: DynamicColor
}

/// Design token set for the `PillButton` control.
open class PillButtonTokens: ControlTokens {
    /// Defines the style of the `PillButton`.
    public internal(set) var style: PillButtonStyle = .primary

    /// The background color of the `PillButton`.
    open var backgroundColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: aliasTokens.backgroundColors[.neutral4],
                         selected: aliasTokens.foregroundColors[.brandRest],
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey80], dark: globalTokens.neutralColors[.grey30]))
        case .onBrand:
            return .init(rest: DynamicColor(light: aliasTokens.backgroundColors[.brandHover].light, dark: aliasTokens.backgroundColors[.neutral3].dark),
                         selected: DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: globalTokens.neutralColors[.grey32]),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade20].light, dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey30]))
        }
    }

    /// The color of the title of the `PillButton`.
    open var titleColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: DynamicColor(light: aliasTokens.foregroundColors[.neutral2].light, dark: aliasTokens.foregroundColors[.neutral2].dark),
                         selected: DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.foregroundColors[.neutralInverted].dark),
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey44]))
        case .onBrand:
            return .init(rest: DynamicColor(light: aliasTokens.foregroundColors[.neutralInverted].light, dark: aliasTokens.foregroundColors[.neutral2].dark),
                         selected: DynamicColor(light: aliasTokens.foregroundColors[.brandRest].light, dark: aliasTokens.foregroundColors[.neutral1].dark),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey74], dark: globalTokens.neutralColors[.grey44]))
        }
    }

    /// The color of the unread dot when the `PillButton` is enabled.
    open var enabledUnreadDotColor: DynamicColor {
        switch style {
        case .primary:
            return aliasTokens.foregroundColors[.brandRest]
        case .onBrand:
            return DynamicColor(light: aliasTokens.foregroundColors[.neutralInverted].light, dark: aliasTokens.foregroundColors[.neutral2].dark)
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
