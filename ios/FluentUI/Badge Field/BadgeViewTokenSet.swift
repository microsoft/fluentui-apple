//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum BadgeViewToken: Int, TokenSetKey {
    /// The background tint color of the Badge.
    case backgroundTintColor

    /// The background filled color of the Badge.
    case backgroundFilledColor

    /// The background color of the Badge when disabled.
    case backgroundDisabledColor

    /// The foreground tint color of the Badge.
    case foregroundTintColor

    /// The foreground filled color of the Badge.
    case foregroundFilledColor

    /// The foreground color of the Badge when disabled.
    case foregroundDisabledColor

    /// The stroke tint color of the Badge.
    case strokeTintColor

    /// The stroke width of the Badge.
    case strokeWidth

    /// The border radius of the Badge.
    case borderRadius

    /// The font of the Badge label.
    case labelFont
}

/// Design token set for the `BadgeView` control.
public class BadgeViewTokenSet: ControlTokenSet<BadgeViewToken> {
    init(style: @escaping () -> BadgeView.Style,
         sizeCategory: @escaping () -> BadgeView.SizeCategory) {
        self.style = style
        self.sizeCategory = sizeCategory
        super.init { [style] token, theme in
            switch token {
            case .backgroundTintColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandBackgroundTint)
                    case .danger:
                        return theme.color(.dangerBackground1)
                    case .severe:
                        return theme.color(.severeBackground1)
                    case .warning:
                        return theme.color(.warningBackground1)
                    case .success:
                        return theme.color(.successBackground1)
                    case .neutral:
                        return theme.color(.background5)
                    }
                }
            case .backgroundFilledColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandBackground1)
                    case .danger:
                        return theme.color(.dangerBackground2)
                    case .severe:
                        return theme.color(.severeBackground2)
                    case .warning:
                        return theme.color(.warningBackground2)
                    case .success:
                        return theme.color(.successBackground2)
                    case .neutral:
                        return theme.color(.background5Selected)
                    }
                }
            case .backgroundDisabledColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandBackground3)
                    case .danger, .severe, .warning, .success, .neutral:
                        return theme.color(.background5)
                    }
                }
            case .foregroundTintColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandForegroundTint)
                    case .danger:
                        return theme.color(.dangerForeground1)
                    case .severe:
                        return theme.color(.severeForeground1)
                    case .warning:
                        return theme.color(.warningForeground1)
                    case .success:
                        return theme.color(.successForeground1)
                    case .neutral:
                        return theme.color(.foreground2)
                    }
                }
            case .foregroundFilledColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.foregroundOnColor)
                    case .danger, .severe, .success:
                        return theme.color(.foregroundLightStatic)
                    case .warning:
                        return theme.color(.foregroundDarkStatic)
                    case .neutral:
                        return theme.color(.foreground1)
                    }
                }
            case .foregroundDisabledColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandForegroundDisabled1)
                    case .danger, .severe, .warning, .success, .neutral:
                        return theme.color(.foregroundDisabled1)
                    }
                }
            case .strokeTintColor:
                return .uiColor {
                    switch style() {
                    case .default:
                        return theme.color(.brandForegroundTint)
                    case .danger:
                        return theme.color(.dangerStroke1)
                    case .severe:
                        return theme.color(.severeStroke1)
                    case .warning:
                        return theme.color(.warningStroke1)
                    case .success:
                        return theme.color(.successStroke1)
                    case .neutral:
                        return theme.color(.strokeAccessible)
                    }
                }
            case .strokeWidth:
                return .float { GlobalTokens.stroke(.width10) }
            case .borderRadius:
                return .float {
                    switch sizeCategory() {
                    case .small:
                        return GlobalTokens.corner(.radius20)
                    case .medium:
                        return GlobalTokens.corner(.radius40)
                    }
                }
            case .labelFont:
                return .uiFont {
                    switch sizeCategory() {
                    case .small:
                        return theme.typography(.caption1)
                    case .medium:
                        return theme.typography(.body2)
                    }
                }
            }
        }
    }

    /// Defines the style of the Badge.
    var style: () -> BadgeView.Style

    /// Defines the sizeCategory of the Badge.
    var sizeCategory: () -> BadgeView.SizeCategory
}

// MARK: Constants
extension BadgeViewTokenSet {
    static func horizontalPadding(_ sizeCategory: BadgeView.SizeCategory) -> CGFloat {
        switch sizeCategory {
        case .small:
            return GlobalTokens.spacing(.size40)
        case .medium:
            return GlobalTokens.spacing(.size80)
        }
    }

    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size20)

    static let defaultMinWidth: CGFloat = 25
}

public extension BadgeView {
    /// Pre-defined styles of the Badge.
    @objc(MSFBadgeViewStyle)
    enum Style: Int, CaseIterable {
        case `default`
        case danger
        case severe
        case warning
        case success
        case neutral
    }

    /// Pre-defined sizeCategories of the Badge.
    @objc(MSFBadgeViewSizeCategory)
    enum SizeCategory: Int, CaseIterable {
        case small
        case medium

        var labelTextStyle: FluentTheme.TypographyToken {
            switch self {
            case .small:
                return .caption1
            case .medium:
                return .body2
            }
        }
    }
}
