//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum NavigationBarToken: Int, TokenSetKey {
    /// Describes the background color for the navigation bar.
    case backgroundColor

    /// Describes the color of the buttons at the top of the navigation bar.
    case buttonTintColor

    /// Describes the font used for a "large" title.
    case largeTitleFont

    /// Describes the color of the subtitle.
    case subtitleColor

    /// Describes the font used for the subtitle.
    case subtitleFont

    /// Describes the color of the title.
    case titleColor

    /// Describes the font used for a "small" title.
    case titleFont
}

/// Design token set for the `NavigationBar` control.
public class NavigationBarTokenSet: ControlTokenSet<NavigationBarToken> {
    init(style: @escaping () -> NavigationBar.Style) {
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .primary, .default, .custom:
                        return UIColor(light: theme.color(.brandBackground1).light,
                                       dark: theme.color(.background3).dark)
                    case .system:
                        return theme.color(.background3)
                    case .gradient:
                        return theme.color(.background1)
                    }
                }
            case .buttonTintColor, .subtitleColor: // By default, these return the same color
                return .uiColor {
                    switch style() {
                    case .primary, .default, .custom:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    case .system, .gradient:
                        return theme.color(.foreground2)
                    }
                }
            case .largeTitleFont:
                return .uiFont {
                    theme.typography(.title1)
                }
            case .subtitleFont:
                return .uiFont {
                    theme.typography(.caption1)
                }
            case .titleColor:
                return .uiColor {
                    switch style() {
                    case .primary, .default, .custom:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    case .system, .gradient:
                        return theme.color(.foreground1)
                    }
                }
            case .titleFont:
                return .uiFont {
                    theme.typography(.body1Strong)
                }
            }
        }
    }
}

public extension NavigationBar {
    static func backgroundColor(for style: Style, theme: FluentTheme?) -> UIColor {
        let tokenSet = TokenSetType { style }
        tokenSet.fluentTheme = theme ?? .shared
        return tokenSet[.backgroundColor].uiColor
    }
}

extension NavigationBarTokenSet {
    // These two constants are based on OS default values
    static let systemHeight: CGFloat = 44
    static let compactSystemHeight: CGFloat = 32

    static let normalContentHeight: CGFloat = 44
    static let expandedContentHeight: CGFloat = 48

    static let leftBarButtonItemHorizontalInset: CGFloat = GlobalTokens.spacing(.size80)
    static let rightBarButtonItemHorizontalInset: CGFloat = GlobalTokens.spacing(.size100)

    static let obscuringAnimationDuration: TimeInterval = 0.12
    static let revealingAnimationDuration: TimeInterval = 0.25
}
