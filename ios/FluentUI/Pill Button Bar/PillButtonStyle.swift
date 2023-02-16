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
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background5].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5].darkElevated))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandBackground2].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5].darkElevated))
        }
    }

    static func titleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foreground2].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foreground2].darkElevated))
        }
    }

    static func titleFont(for fluentTheme: FluentTheme) -> FontInfo {
        return fluentTheme.aliasTokens.typography[.body2]
    }

    // MARK: selected state

    static func selectedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background1].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3Selected].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5Selected].darkElevated))
        }
    }

    static func selectedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor])

        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForeground1].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foreground1].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foreground1].darkElevated))
        }
    }

    // MARK: disabled state

    static func disabledBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        return normalBackgroundColor(for: fluentTheme, for: style)
    }

    static func disabledTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundDisabled1])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForegroundDisabled1].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foregroundDisabled1].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foregroundDisabled1].darkElevated))
        }
    }

    // MARK: selected disabled state
    static func selectedDisabledBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1])

        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background1].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3Selected].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5Selected].darkElevated))
        }
    }

    static func selectedDisabledTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForegroundDisabled1])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForegroundDisabled2].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foregroundDisabled2].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foregroundDisabled2].darkElevated))
        }
    }

    // MARK: highlighted state

    static func highlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background5Pressed].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3Pressed].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5Pressed].darkElevated))
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandBackground2Pressed].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3Pressed].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background5Pressed].darkElevated))
        }
    }

    static func highlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foreground1].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foreground1].darkElevated))
        }
    }

    // MARK: selected highlighted state

    static func selectedHighlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1Pressed])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background1].light,
                                                      dark: fluentTheme.aliasTokens.colors[.background3Pressed].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.background3Pressed].darkElevated))
        }
    }

    static func selectedHighlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor])
        case .onBrand:
            return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForeground1Pressed].light,
                                                      dark: fluentTheme.aliasTokens.colors[.foreground1].dark,
                                                      darkElevated: fluentTheme.aliasTokens.colors[.foreground1].darkElevated))
        }
    }

    // MARK: unread dot state

    static func enabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForeground1]),
                           dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2]))
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor]),
                           dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1]))
        }
    }

    static func disabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundDisabled1])
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForegroundDisabled1]),
                           dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundDisabled1]))
        }
    }
}
