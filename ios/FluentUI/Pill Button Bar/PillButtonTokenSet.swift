//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum PillButtonToken: Int, TokenSetKey {
    /// The background color of the `PillButton`.
    case backgroundColor

    /// The background color of the `PillButton` when disabled.
    case backgroundColorDisabled

    /// The background color of the `PillButton` when selected.
    case backgroundColorSelected

    /// The background color of the `PillButton` when selected and disabled.
    case backgroundColorSelectedDisabled

    /// The color of the unread dot when the `PillButton` is disabled.
    case disabledUnreadDotColor

    /// The color of the unread dot when the `PillButton` is enabled.
    case enabledUnreadDotColor

    /// The font used for the title of the `PillButton`.
    case font

    /// The color of the title of the `PillButton`.
    case titleColor

    /// The color of the title of the `PillButton` when disabled.
    case titleColorDisabled

    /// The color of the title of the `PillButton` when selected.
    case titleColorSelected

    /// The color of the title of the `PillButton` when selected and disabled.
    case titleColorSelectedDisabled
}

/// Design token set for the `PillButton` control.
public class PillButtonTokenSet: ControlTokenSet<PillButtonToken> {
    init(style: @escaping () -> PillButtonStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.background5).light,
                                       dark: theme.color(.background3).dark,
                                       darkElevated: theme.color(.background5).darkElevated)
                    case .onBrand:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background3).dark,
                                       darkElevated: theme.color(.background5).darkElevated)
                    }
                }

            case .backgroundColorDisabled:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.background5).light,
                                       dark: theme.color(.background3).dark,
                                       darkElevated: theme.color(.background5).darkElevated)
                    case .onBrand:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background3).dark,
                                       darkElevated: theme.color(.background5).darkElevated)
                    }
                }

            case .backgroundColorSelected:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.brandBackground1)
                    case .onBrand:
                        return UIColor(light: theme.color(.background1).light,
                                       dark: theme.color(.background3Selected).dark,
                                       darkElevated: theme.color(.background5Selected).darkElevated)
                    }
                }

            case .backgroundColorSelectedDisabled:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.brandBackground1)
                    case .onBrand:
                        return UIColor(light: theme.color(.background1).light,
                                       dark: theme.color(.background3Selected).dark,
                                       darkElevated: theme.color(.background5Selected).darkElevated)
                    }
                }

            case .disabledUnreadDotColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.foregroundDisabled1)
                    case .onBrand:
                        return theme.color(.brandForegroundDisabled1)
                    }
                }

            case .enabledUnreadDotColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: theme.color(.foreground1).dark)
                    case .onBrand:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                }

            case .font:
                return .uiFont { theme.typography(.body2) }

            case .titleColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.foreground2)
                    case .onBrand:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark,
                                       darkElevated: theme.color(.foreground2).darkElevated)
                    }
                }

            case .titleColorDisabled:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.foregroundDisabled1)
                    case .onBrand:
                        return UIColor(light: theme.color(.brandForegroundDisabled1).light,
                                       dark: theme.color(.foregroundDisabled1).dark,
                                       darkElevated: theme.color(.foregroundDisabled1).darkElevated)
                    }
                }

            case .titleColorSelected:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.foregroundOnColor)
                    case .onBrand:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: theme.color(.foreground1).dark,
                                       darkElevated: theme.color(.foreground1).darkElevated)
                    }
                }

            case .titleColorSelectedDisabled:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.brandForegroundDisabled1)
                    case .onBrand:
                        return UIColor(light: theme.color(.brandForegroundDisabled2).light,
                                       dark: theme.color(.foregroundDisabled2).dark,
                                       darkElevated: theme.color(.foregroundDisabled2).darkElevated)
                    }
                }
            }
        }
    }

    /// Defines the style of the `PillButton`.
    var style: () -> PillButtonStyle
}

extension PillButtonTokenSet {
    /// The distance of the content from the bottom of the `PillButton`.
    static let bottomInset: CGFloat = GlobalTokens.spacing(.size60)

    /// The distance of the content from the sides of the `PillButton`.
    static let horizontalInset: CGFloat = GlobalTokens.spacing(.size160)

    /// The distance of the unread dot from the trailing edge of the content of the `PillButton`.
    static let unreadDotOffsetX: CGFloat = GlobalTokens.spacing(.size60)

    /// The distance of the unread dot from the top of the content of the `PillButton`.
    static let unreadDotOffsetY: CGFloat = 3.0

    /// The size of the unread dot of the `PillButton`.
    static let unreadDotSize: CGFloat = GlobalTokens.spacing(.size60)

    /// The distance of the content from the top of the `PillButton`.
    static let topInset: CGFloat = GlobalTokens.spacing(.size60)
}

// MARK: - PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    /// primary: the default style of PillButton; use this style in conjunction with a neutral or white background.
    case primary

    /// onBrand: use this style in conjunction with branded background where the background features
    /// a prominent brand color in light mode and a muted gray in dark mode.
    case onBrand
}
