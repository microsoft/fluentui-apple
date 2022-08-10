//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .pillButtonDynamicColors {
                    switch style() {
                    case .primary:
                        return .init(rest: DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral4].light,
                                                        dark: theme.aliasTokens.backgroundColors[.neutral3].dark),
                                     selected: theme.aliasTokens.foregroundColors[.brandRest],
                                     disabled: DynamicColor(light: theme.globalTokens.neutralColors[.grey94],
                                                            dark: theme.globalTokens.neutralColors[.grey8]),
                                     selectedDisabled: DynamicColor(light: theme.globalTokens.neutralColors[.grey80],
                                                                    dark: theme.globalTokens.neutralColors[.grey30]))
                    case .onBrand:
                        return .init(rest: DynamicColor(light: theme.aliasTokens.backgroundColors[.brandHover].light,
                                                        dark: theme.aliasTokens.backgroundColors[.neutral3].dark),
                                     selected: DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                                                            dark: theme.globalTokens.neutralColors[.grey32]),
                                     disabled: DynamicColor(light: theme.globalTokens.brandColors[.shade20].light,
                                                            dark: theme.globalTokens.neutralColors[.grey8]),
                                     selectedDisabled: DynamicColor(light: theme.globalTokens.neutralColors[.white],
                                                                    dark: theme.globalTokens.neutralColors[.grey30]))
                    }
                }

            case .titleColor:
                return .pillButtonDynamicColors {
                    switch style() {
                    case .primary:
                        return .init(rest: DynamicColor(light: theme.aliasTokens.foregroundColors[.neutral3].light,
                                                        dark: theme.aliasTokens.foregroundColors[.neutral2].dark),
                                     selected: DynamicColor(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                                                            dark: theme.aliasTokens.foregroundColors[.neutralInverted].dark),
                                     disabled: DynamicColor(light: theme.globalTokens.neutralColors[.grey70],
                                                            dark: theme.globalTokens.neutralColors[.grey26]),
                                     selectedDisabled: DynamicColor(light: theme.globalTokens.neutralColors[.grey94],
                                                                    dark: theme.globalTokens.neutralColors[.grey44]))
                    case .onBrand:
                        return .init(rest: DynamicColor(light: theme.aliasTokens.foregroundColors[.neutralInverted].light,
                                                        dark: theme.aliasTokens.foregroundColors[.neutral2].dark),
                                     selected: DynamicColor(light: theme.aliasTokens.foregroundColors[.brandRest].light,
                                                            dark: theme.aliasTokens.foregroundColors[.neutral1].dark),
                                     disabled: DynamicColor(light: theme.globalTokens.brandColors[.shade10].light,
                                                            dark: theme.globalTokens.neutralColors[.grey26]),
                                     selectedDisabled: DynamicColor(light: theme.globalTokens.neutralColors[.grey74],
                                                                    dark: theme.globalTokens.neutralColors[.grey44]))
                    }
                }

            case .enabledUnreadDotColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.foregroundColors[.neutralInverted].light, dark: theme.aliasTokens.foregroundColors[.neutral2].dark)
                    }
                }

            case .disabledUnreadDotColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return DynamicColor(light: theme.globalTokens.neutralColors[.grey70], dark: theme.globalTokens.neutralColors[.grey26])
                    case .onBrand:
                        return DynamicColor(light: theme.globalTokens.brandColors[.shade10].light, dark: theme.globalTokens.neutralColors[.grey26])
                    }
                }

            case .topInset:
                return .float { 6.0 }

            case .bottomInset:
                return .float { 6.0 }

            case .horizontalInset:
                return .float { theme.globalTokens.spacing[.medium] }

            case .unreadDotOffsetX:
                return .float { 6.0 }

            case .unreadDotOffsetY:
                return .float { 3.0 }

            case .unreadDotSize:
                return .float { 6.0 }

            case .font:
                return .fontInfo { theme.aliasTokens.typography[.body2] }
            }
        }
    }

    /// Defines the style of the `PillButton`.
    var style: () -> PillButtonStyle
}
