//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `PillButtonBar` control
public class PillButtonBarTokenSet: ControlTokenSet<PillButtonBarTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the `PillButton`.
        case pillButtonBackgroundColor

        /// The background color of the `PillButton` when selected.
        case pillButtonBackgroundColorSelected

        /// The background color of the `PillButton` when disabled.
        case pillButtonBackgroundColorDisabled

        /// The background color of the `PillButton` when selected and disabled.
        case pillButtonBackgroundColorSelectedDisabled

        /// The color of the title of the `PillButton`.
        case pillButtonTitleColor

        /// The color of the title of the `PillButton` when selected.
        case pillButtonTitleColorSelected

        /// The color of the title of the `PillButton` when disabled.
        case pillButtonTitleColorDisabled

        /// The color of the title of the `PillButton` when selected and disabled.
        case pillButtonTitleColorSelectedDisabled

        /// The color of the unread dot when the `PillButton` is enabled.
        case pillButtonEnabledUnreadDotColor

        /// The color of the unread dot when the `PillButton` is disabled.
        case pillButtonDisabledUnreadDotColor

        /// The size of the unread dot of the `PillButton`
        case pillButtonUnreadDotSize

        /// The font used for the title of the `PillButton`.
        case pillButtonFont
    }

    init(style: @escaping () -> PillButtonStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .pillButtonBackgroundColor:
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

            case .pillButtonBackgroundColorSelected:
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

            case .pillButtonBackgroundColorDisabled:
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

            case .pillButtonBackgroundColorSelectedDisabled:
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

            case .pillButtonTitleColor:
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

            case .pillButtonTitleColorSelected:
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

            case .pillButtonTitleColorDisabled:
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

            case .pillButtonTitleColorSelectedDisabled:
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

            case .pillButtonEnabledUnreadDotColor:
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

            case .pillButtonDisabledUnreadDotColor:
                return .dynamicColor {
                    switch style() {
                    case .primary:
                        return theme.aliasTokens.colors[.foregroundDisabled1]
                    case .onBrand:
                        return theme.aliasTokens.colors[.brandForegroundDisabled1]
                    }
                }

            case .pillButtonUnreadDotSize:
                return .float { 6.0 }

            case .pillButtonFont:
                return .fontInfo { theme.aliasTokens.typography[.body2] }
            }
        }
    }

    /// Defines the style of the `PillButton`.
    var style: () -> PillButtonStyle
}

extension PillButtonBarTokenSet {
    /// Maximum spacing between `PillButton` controls
    static let maxButtonsSpacing: CGFloat = 10.0

    /// Minimum spacing between `PillButton` controls
    static let minButtonsSpacing: CGFloat = GlobalTokens.spacing(.size80)

    /// Minimum width of the last button that must be showing on screen when the `PillButtonBar` loads or redraws
    static let minButtonVisibleWidth: CGFloat = GlobalTokens.spacing(.size200)

    /// Minimum width of a `PillButton`
    static let minButtonWidth: CGFloat = 56.0

    /// Minimum height of the `PillButtonBar`
    static let minHeight: CGFloat = 28.0

    /// Offset from the leading edge when the `PillButtonBar` loads or redraws
    static let sideInset: CGFloat = GlobalTokens.spacing(.size160)
}
