//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - PillButtonStyle

@available(*, deprecated, renamed: "PillButtonStyle")
public typealias MSPillButtonStyle = PillButtonStyle

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
    static func normalBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        let defaultColor = UIColor(light: Colors.surfaceTertiary, dark: Colors.surfaceSecondary)
        switch style {
        case .primary:
            return defaultColor
        case .onBrand:
            return UIColor(light: Colors.primaryShade10(for: window), dark: defaultColor)
        }
    }

    static func titleColor(for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: Colors.textSecondary, dark: Colors.textPrimary)
        case .onBrand:
            return UIColor(light: Colors.textOnAccent, dark: Colors.textPrimary)
        }
    }

    static func hoverBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return Colors.surfaceQuaternary
        case .onBrand:
            return UIColor(light: Colors.primaryShade20(for: window), dark: Colors.surfaceQuaternary)
        }
    }

    // MARK: selected state

    static func selectedBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return Colors.primary(for: window)
        case .onBrand:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        }
    }

    static func selectedTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return Colors.textOnAccent
        case .onBrand:
            return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
        }
    }

    // MARK: disabled state

    static func disabledBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return normalBackgroundColor(for: window, for: style)
        case .onBrand:
            return UIColor(light: Colors.primaryShade10(for: window), dark: normalBackgroundColor(for: window, for: style))
        }
    }

    static func disabledTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return Colors.textDisabled
        case .onBrand:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDisabled)
        }
    }

    // MARK: selected disabled state

    static func selectedDisabledBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return Colors.surfaceQuaternary
        case .onBrand:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        }
    }

    static func selectedDisabledTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.gray500)
        case .onBrand:
            return UIColor(light: Colors.primaryTint20(for: window), dark: Colors.gray500)
        }
    }

    // MARK: highlighted state

    static func highlightedBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        return disabledBackgroundColor(for: window, for: style)
    }

    static func highlightedTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        return UIColor(light: disabledTitleColor(for: window, for: style), dark: Colors.textSecondary)
    }

    // MARK: selected highlighted state

    static func selectedHighlightedBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.primaryTint20(for: window))
        case .onBrand:
            return UIColor(light: Colors.surfaceSecondary, dark: Colors.gray700)
        }
    }

    static func selectedHighlightedTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .primary:
            return selectedTitleColor(for: window, for: style)
        case .onBrand:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDominant)
        }
    }
}
