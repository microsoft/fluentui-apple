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
    case onBrand
    case primary
}

// MARK: PillButton colors

public extension PillButton {

    // MARK: normal state

    @objc(normalBackgroundColorForWindow:ForStyle:)
    static func normalBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        let defaultColor = UIColor(light: Colors.surfaceTertiary, dark: Colors.surfaceSecondary)
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryShade10(for: window), dark: defaultColor)
        case .primary:
            return defaultColor
        }
    }

    static func titleColor(for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.textOnAccent, dark: Colors.textPrimary)
        case .primary:
            return UIColor(light: Colors.textSecondary, dark: Colors.textPrimary)

        }
    }

    static func hoverBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryShade20(for: window), dark: Colors.surfaceQuaternary)
        case .primary:
            return Colors.surfaceQuaternary
        }
    }
 
    // MARK: selected state

    static func selectedBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        case .primary:
            return Colors.primary(for: window)
        }
    }

    static func selectedTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
        case .primary:
            return Colors.textOnAccent
        }
    }

    // MARK: disabled state

    static func disabledBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryShade10(for: window), dark: normalBackgroundColor(for: window, for: style))
        case .primary:
            return normalBackgroundColor(for: window, for: style)
        }
    }
    
    static func disabledTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDisabled)
        case .primary:
            return Colors.textDisabled
        }
    }

    // MARK: selected disabled state

    static func selectedDisabledBackgroundColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.surfaceQuaternary)
        case .primary:
            return Colors.surfaceQuaternary
        }
    }

    static func selectedDisabledTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryTint20(for: window), dark: Colors.gray500)
        case .primary:
            return UIColor(light: Colors.surfacePrimary, dark: Colors.gray500)
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
        case .onBrand:
            return UIColor(light: Colors.surfaceSecondary, dark: Colors.gray700)
        case .primary:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.primaryTint20(for: window))
        }
    }

    static func selectedHighlightedTitleColor(for window: UIWindow, for style: PillButtonStyle) -> UIColor {
        switch style {
        case .onBrand:
            return UIColor(light: Colors.primaryTint10(for: window), dark: Colors.textDominant)
        case .primary:
            return selectedTitleColor(for: window, for: style)
        }
    }
}
