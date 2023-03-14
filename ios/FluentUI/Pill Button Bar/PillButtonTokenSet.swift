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

        /// The background color of the `PillButton` when selected.
        case backgroundColorSelected

        /// The background color of the `PillButton` when disabled.
        case backgroundColorDisabled

        /// The background color of the `PillButton` when selected and disabled.
        case backgroundColorSelectedDisabled

        /// The color of the title of the `PillButton`.
        case titleColor

        /// The color of the title of the `PillButton` when selected.
        case titleColorSelected

        /// The color of the title of the `PillButton` when disabled.
        case titleColorDisabled

        /// The color of the title of the `PillButton` when selected and disabled.
        case titleColorSelectedDisabled

        /// The color of the unread dot when the `PillButton` is enabled.
        case enabledUnreadDotColor

        /// The color of the unread dot when the `PillButton` is disabled.
        case disabledUnreadDotColor

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
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return DynamicColor(light: theme.aliasTokens.colors[.background5].light,
                                            dark: theme.aliasTokens.colors[.background3].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5].darkElevated)
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandBackground2].light,
                                            dark: theme.aliasTokens.colors[.background3].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5].darkElevated)
                    }
                }

            case .backgroundColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.background1].light,
                                            dark: theme.aliasTokens.colors[.background3Selected].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5Selected].darkElevated)
                    }
                }

            case .backgroundColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return DynamicColor(light: theme.aliasTokens.colors[.background5].light,
                                            dark: theme.aliasTokens.colors[.background3].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5].darkElevated)
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandBackground2].light,
                                            dark: theme.aliasTokens.colors[.background3].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5].darkElevated)
                    }
                }

            case .backgroundColorSelectedDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.background1].light,
                                            dark: theme.aliasTokens.colors[.background3Selected].dark,
                                            darkElevated: theme.aliasTokens.colors[.background5Selected].darkElevated)
                    }
                }

            case .titleColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.foreground2]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.foregroundOnColor].light,
                                            dark: theme.aliasTokens.colors[.foreground2].dark,
                                            darkElevated: theme.aliasTokens.colors[.foreground2].darkElevated)
                    }
                }

            case .titleColorSelected:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandForeground1].light,
                                            dark: theme.aliasTokens.colors[.foreground1].dark,
                                            darkElevated: theme.aliasTokens.colors[.foreground1].darkElevated)
                    }
                }

            case .titleColorDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.foregroundDisabled1]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandForegroundDisabled1].light,
                                            dark: theme.aliasTokens.colors[.foregroundDisabled1].dark,
                                            darkElevated: theme.aliasTokens.colors[.foregroundDisabled1].darkElevated)
                    }
                }

            case .titleColorSelectedDisabled:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.brandForegroundDisabled1]
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandForegroundDisabled2].light,
                                            dark: theme.aliasTokens.colors[.foregroundDisabled2].dark,
                                            darkElevated: theme.aliasTokens.colors[.foregroundDisabled2].darkElevated)
                    }
                }

            case .enabledUnreadDotColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return DynamicColor(light: theme.aliasTokens.colors[.brandForeground1].light,
                                            dark: theme.aliasTokens.colors[.foreground1].dark)
                    case .onBrand:
                        return DynamicColor(light: theme.aliasTokens.colors[.foregroundOnColor].light,
                                            dark: theme.aliasTokens.colors[.foreground1].dark)
                    }
                }

            case .disabledUnreadDotColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.foregroundDisabled1]
                    case .onBrand:
                        return theme.aliasTokens.colors[.brandForegroundDisabled1]
                    }
                }

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

extension PillButtonTokenSet {
    /// The distance of the content from the top of the `PillButton`.
    static let topInset: CGFloat = 6.0

    /// The distance of the content from the bottom of the `PillButton`.
    static let bottomInset: CGFloat = 6.0

    /// The distance of the content from the sides of the `PillButton`.
    static let horizontalInset: CGFloat = GlobalTokens.spacing(.size160)

    /// The distance of the unread dot from the trailing edge of the content of the `PillButton`.
    static let unreadDotOffsetX: CGFloat = 6.0

    /// The distance of the unread dot from the top of the content of the `PillButton`.
    static let unreadDotOffsetY: CGFloat = 3.0
}
