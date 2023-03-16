//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    /// primary: the default style of PillButton; use this style in conjunction with a neutral or white background.
    case primary

    /// onBrand: use this style in conjunction with branded background where the background features
    /// a prominent brand color in light mode and a muted gray in dark mode.
    case onBrand
}

// MARK: PillButton colors

public extension PillButton {

    // MARK: normal state

    @objc(normalBackgroundColorForWindow:ForStyle:)
    static func normalBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.background5).light,
                                                      dark: fluentTheme.color(.background3).dark,
                                                      darkElevated: fluentTheme.color(.background5).darkElevated))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandBackground2).light,
                                                      dark: fluentTheme.color(.background3).dark,
                                                      darkElevated: fluentTheme.color(.background5).darkElevated))
        }
    }

    static func titleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foreground2))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.foregroundOnColor).light,
                                                      dark: fluentTheme.color(.foreground2).dark,
                                                      darkElevated: fluentTheme.color(.foreground2).darkElevated))
        }
    }

    static func titleFont(for fluentTheme: FluentTheme) -> FontInfo {
        return fluentTheme.typography(.body2)
    }

    // MARK: selected state

    static func selectedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.brandBackground1))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.background1).light,
                                                      dark: fluentTheme.color(.background3Selected).dark,
                                                      darkElevated: fluentTheme.color(.background5Selected).darkElevated))
        }
    }

    static func selectedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foregroundOnColor))

        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandForeground1).light,
                                                      dark: fluentTheme.color(.foreground1).dark,
                                                      darkElevated: fluentTheme.color(.foreground1).darkElevated))
        }
    }

    // MARK: disabled state

    static func disabledBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        return normalBackgroundColor(for: fluentTheme, for: style)
    }

    static func disabledTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foregroundDisabled1))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandForegroundDisabled1).light,
                                                      dark: fluentTheme.color(.foregroundDisabled1).dark,
                                                      darkElevated: fluentTheme.color(.foregroundDisabled1).darkElevated))
        }
    }

    // MARK: selected disabled state
    static func selectedDisabledBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.brandBackground1))

        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.background1).light,
                                                      dark: fluentTheme.color(.background3Selected).dark,
                                                      darkElevated: fluentTheme.color(.background5Selected).darkElevated))
        }
    }

    static func selectedDisabledTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.brandForegroundDisabled1))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandForegroundDisabled2).light,
                                                      dark: fluentTheme.color(.foregroundDisabled2).dark,
                                                      darkElevated: fluentTheme.color(.foregroundDisabled2).darkElevated))
        }
    }

    // MARK: highlighted state

    static func highlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.background5Pressed).light,
                                                      dark: fluentTheme.color(.background3Pressed).dark,
                                                      darkElevated: fluentTheme.color(.background5Pressed).darkElevated))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandBackground2Pressed).light,
                                                      dark: fluentTheme.color(.background3Pressed).dark,
                                                      darkElevated: fluentTheme.color(.background5Pressed).darkElevated))
        }
    }

    static func highlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foreground1))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.foregroundOnColor).light,
                                                      dark: fluentTheme.color(.foreground1).dark,
                                                      darkElevated: fluentTheme.color(.foreground1).darkElevated))
        }
    }

    // MARK: selected highlighted state

    static func selectedHighlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.brandBackground1Pressed))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.background1).light,
                                                      dark: fluentTheme.color(.background3Pressed).dark,
                                                      darkElevated: fluentTheme.color(.background3Pressed).darkElevated))
        }
    }

    static func selectedHighlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foregroundOnColor))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.color(.brandForeground1Pressed).light,
                                                      dark: fluentTheme.color(.foreground1).dark,
                                                      darkElevated: fluentTheme.color(.foreground1).darkElevated))
        }
    }

    // MARK: unread dot state

    static func enabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.color(.brandForeground1)),
                           dark: UIColor(dynamicColor: fluentTheme.color(.foreground2)))
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.color(.foregroundOnColor)),
                           dark: UIColor(dynamicColor: fluentTheme.color(.foreground1)))
        }
    }

    static func disabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.color(.foregroundDisabled1))
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.color(.brandForegroundDisabled1)),
                           dark: UIColor(dynamicColor: fluentTheme.color(.foregroundDisabled1)))
        }
    }
}
