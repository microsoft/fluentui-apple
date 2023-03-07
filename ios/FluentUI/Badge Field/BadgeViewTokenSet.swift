//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `BadgeView` control.
public class BadgeViewTokenSet: ControlTokenSet<BadgeViewTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
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

        /// The border radius of the Badge.
        case borderRadius
    }

    init(style: @escaping () -> BadgeView.Style,
         sizeCategory: @escaping () -> BadgeView.SizeCategory) {
        self.style = style
        self.sizeCategory = sizeCategory
        super.init { [style] token, theme in
            switch token {
            case .backgroundTintColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.brandBackgroundTint]
                    case .danger:
                        return theme.aliasTokens.colors[.dangerBackground1]
                    case .severeWarning:
                        return theme.aliasTokens.colors[.severeBackground1]
                    case .warning:
                        return theme.aliasTokens.colors[.warningBackground1]
                    case .success:
                        return theme.aliasTokens.colors[.successBackground1]
                    case .neutral:
                        return theme.aliasTokens.colors[.background5]
                    }
                }
            case .backgroundFilledColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .danger:
                        return theme.aliasTokens.colors[.dangerBackground2]
                    case .severeWarning:
                        return theme.aliasTokens.colors[.severeBackground2]
                    case .warning:
                        return theme.aliasTokens.colors[.warningBackground2]
                    case .success:
                        return theme.aliasTokens.colors[.successBackground2]
                    case .neutral:
                        return theme.aliasTokens.colors[.background5Selected]
                    }
                }
            case .backgroundDisabledColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.brandBackground3]
                    case .danger, .severeWarning, .warning, .success, .neutral:
                        return theme.aliasTokens.colors[.background5]
                    }
                }
            case .foregroundTintColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.brandForegroundTint]
                    case .danger:
                        return theme.aliasTokens.colors[.dangerForeground1]
                    case .severeWarning:
                        return theme.aliasTokens.colors[.severeForeground1]
                    case .warning:
                        return theme.aliasTokens.colors[.warningForeground1]
                    case .success:
                        return theme.aliasTokens.colors[.successForeground1]
                    case .neutral:
                        return theme.aliasTokens.colors[.foreground2]
                    }
                }
            case .foregroundFilledColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .danger, .severeWarning, .success:
                        return theme.aliasTokens.colors[.foregroundLightStatic]
                    case .warning:
                        return theme.aliasTokens.colors[.foregroundDarkStatic]
                    case .neutral:
                        return theme.aliasTokens.colors[.foreground1]
                    }
                }
            case .foregroundDisabledColor:
                return .dynamicColor {
                    switch style() {
                    case .default:
                        return theme.aliasTokens.colors[.brandForegroundDisabled1]
                    case .danger, .severeWarning, .warning, .success, .neutral:
                        return theme.aliasTokens.colors[.foregroundDisabled1]
                    }
                }
            case .borderRadius:
                return .float({
                    switch sizeCategory() {
                    case .small:
                        return GlobalTokens.corner(.radius20)
                    case .medium:
                        return GlobalTokens.corner(.radius40)
                    }
                })
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
    enum Style: Int {
        case `default`
        case danger
        case severeWarning
        case warning
        case success
        case neutral
    }

    /// Pre-defined sizeCategories of the Badge.
    @objc(MSFBadgeViewSizeCategory)
    enum SizeCategory: Int, CaseIterable {
        case small
        case medium

        var labelTextStyle: AliasTokens.TypographyTokens {
            switch self {
            case .small:
                return .caption1
            case .medium:
                return .body2
            }
        }
    }
}
