//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Represents the set of `DynamicColor` values for the various states of a `PillButton`
public struct PillButtonDynamicColors: Equatable {
    public init(rest: DynamicColor,
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
public class PillButtonTokenSet: ControlTokenSet<PillButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the `PillButton`.
        case backgroundColor

        /// The color of the title of the `PillButton`.
        case titleColor

        /// The color of the unread dot when the `PillButton` is enabled.
        case enabledUnreadDotColor

        /// The color of the unread dot when the `PillButton` is disabled.
        case disabledUnreadDotColor

        /// The distance of the content from the top of the `PillButton`.
        case topInset

        /// The distance of the content from the bottom of the `PillButton`.
        case bottomInset

        /// The distance of the content from the sides of the `PillButton`.
        case horizontalInset

        /// The distance of the unread dot from the trailing edge of the content of the `PillButton`.
        case unreadDotOffsetX

        /// The distance of the unread dot from the top of the content of the `PillButton`.
        case unreadDotOffsetY

        /// The size of the unread dot of the `PillButton`
        case unreadDotSize

        /// The font used for the title of the `PillButton`.
        case font
    }

    init(style: @escaping () -> PillButtonStyle) {
        self.style = style
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .backgroundColor:
            return .pillButtonDynamicColors {
                switch self.style() {
                case .primary:
                    return .init(rest: DynamicColor(light: self.aliasTokens.backgroundColors[.neutral4].light,
                                                    dark: self.aliasTokens.backgroundColors[.neutral3].dark),
                                 selected: self.aliasTokens.foregroundColors[.brandRest],
                                 disabled: DynamicColor(light: self.globalTokens.neutralColors[.grey94],
                                                        dark: self.globalTokens.neutralColors[.grey8]),
                                 selectedDisabled: DynamicColor(light: self.globalTokens.neutralColors[.grey80],
                                                                dark: self.globalTokens.neutralColors[.grey30]))
                case .onBrand:
                    return .init(rest: DynamicColor(light: self.aliasTokens.backgroundColors[.brandHover].light,
                                                    dark: self.aliasTokens.backgroundColors[.neutral3].dark),
                                 selected: DynamicColor(light: self.aliasTokens.backgroundColors[.neutral1].light,
                                                        dark: self.globalTokens.neutralColors[.grey32]),
                                 disabled: DynamicColor(light: self.globalTokens.brandColors[.shade20].light,
                                                        dark: self.globalTokens.neutralColors[.grey8]),
                                 selectedDisabled: DynamicColor(light: self.globalTokens.neutralColors[.white],
                                                                dark: self.globalTokens.neutralColors[.grey30]))
                }
            }

        case .titleColor:
            return .pillButtonDynamicColors {
                switch self.style() {
                case .primary:
                    return .init(rest: DynamicColor(light: self.aliasTokens.foregroundColors[.neutral3].light,
                                                    dark: self.aliasTokens.foregroundColors[.neutral2].dark),
                                 selected: DynamicColor(light: self.aliasTokens.backgroundColors[.neutral1].light,
                                                        dark: self.aliasTokens.foregroundColors[.neutralInverted].dark),
                                 disabled: DynamicColor(light: self.globalTokens.neutralColors[.grey70],
                                                        dark: self.globalTokens.neutralColors[.grey26]),
                                 selectedDisabled: DynamicColor(light: self.globalTokens.neutralColors[.grey94],
                                                                dark: self.globalTokens.neutralColors[.grey44]))
                case .onBrand:
                    return .init(rest: DynamicColor(light: self.aliasTokens.foregroundColors[.neutralInverted].light,
                                                    dark: self.aliasTokens.foregroundColors[.neutral2].dark),
                                 selected: DynamicColor(light: self.aliasTokens.foregroundColors[.brandRest].light,
                                                        dark: self.aliasTokens.foregroundColors[.neutral1].dark),
                                 disabled: DynamicColor(light: self.globalTokens.brandColors[.shade10].light,
                                                        dark: self.globalTokens.neutralColors[.grey26]),
                                 selectedDisabled: DynamicColor(light: self.globalTokens.neutralColors[.grey74],
                                                                dark: self.globalTokens.neutralColors[.grey44]))
                }
            }

        case .enabledUnreadDotColor:
            return .dynamicColor {
                switch self.style() {
                case .primary:
                    return self.aliasTokens.foregroundColors[.brandRest]
                case .onBrand:
                    return DynamicColor(light: self.aliasTokens.foregroundColors[.neutralInverted].light, dark: self.aliasTokens.foregroundColors[.neutral2].dark)
                }
            }

        case .disabledUnreadDotColor:
            return .dynamicColor {
                switch self.style() {
                case .primary:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey70], dark: self.globalTokens.neutralColors[.grey26])
                case .onBrand:
                    return DynamicColor(light: self.globalTokens.brandColors[.shade10].light, dark: self.globalTokens.neutralColors[.grey26])
                }
            }

        case .topInset:
            return .float { 6.0 }

        case .bottomInset:
            return .float { 6.0 }

        case .horizontalInset:
            return .float { self.globalTokens.spacing[.medium] }

        case .unreadDotOffsetX:
            return .float { 6.0 }

        case .unreadDotOffsetY:
            return .float { 3.0 }

        case .unreadDotSize:
            return .float { 6.0 }

        case .font:
            return .fontInfo { self.aliasTokens.typography[.body2] }
        }
    }

    /// Defines the style of the `PillButton`.
    var style: () -> PillButtonStyle
}
