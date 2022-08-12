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

    // TODO: is there a dark on brand? Should it just be hard coded in dark mode to match light mode? Do light and dark match correctly?
}

// MARK: PillButton colors

public extension PillButton {

    // MARK: normal state

    @objc(normalBackgroundColorForWindow:ForStyle:)
    static func normalBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        let defaultColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5])
        switch style {
        case .primary:
            return defaultColor
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground2]), dark: defaultColor)
        }
    }

    static func titleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1]))
        }
    }

    // TODO: remove hover state? Crazy colors for now so I can test it
    static func hoverBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.red][.primary])
        case .onBrand:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.darkGreen][.primary])
        }
    }

    // MARK: selected state

    static func selectedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1])
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackgroundInverted]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1]))
        }
    }

    static func selectedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundInverted1]))
        case .onBrand:
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForeground1]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundInverted1]))
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
            return UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForegroundDisabled]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundDisabled1]))
        }
    }

    // MARK: selected disabled state
    // TODO: what even is this state? Should I color these weirdly too?
    static func selectedDisabledBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.cyan][.primary])
        case .onBrand:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.burgundy][.primary])
        }
    }

    static func selectedDisabledTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.cyan][.shade10])
        case .onBrand:
            return UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.burgundy][.tint40])
        }
    }

    // MARK: highlighted state

    static func highlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        return disabledBackgroundColor(for: fluentTheme, for: style)
    }

    // TODO: what is highlighted?
    static func highlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        return UIColor(light: disabledTitleColor(for: fluentTheme, for: style), dark: UIColor(colorValue: fluentTheme.globalTokens.sharedColors[.lime][.primary]))
    }

    // MARK: selected highlighted state

    static func selectedHighlightedBackgroundColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5])
        case .onBrand:
            return UIColor(light: UIColor(colorValue: fluentTheme.globalTokens.neutralColors[.white]), dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1]))
        }
    }

    static func selectedHighlightedTitleColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return selectedTitleColor(for: fluentTheme, for: style)
        case .onBrand:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5])
        }
    }

    // MARK: unread dot state

    static func enabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForegroundInverted])
        case .onBrand:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor])
        }
    }

    static func disabledUnreadDotColor(for fluentTheme: FluentTheme, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundDisabled1])
        case .onBrand:
            return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForegroundDisabled])
        }
    }
}
