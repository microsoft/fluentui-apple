//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

extension UIColor {

    /// Creates a dynamic color object that returns the appropriate color value based on the current
    /// rendering context.
    ///
    /// The decision order for choosing between the colors is based on the following questions, in order:
    /// - Is the current `userInterfaceStyle` `.dark` or `.light`?
    /// - Is the current `userInterfaceLevel` `.base` or `.elevated`?
    /// - Is the current `accessibilityContrast` `.normal` or `.high`?
    ///
    /// - Parameter light: The default color for a light context. Required.
    /// - Parameter lightHighContrast: The override color for a light, high contrast context. Optional.
    /// - Parameter lightElevated: The override color for a light, elevated context. Optional.
    /// - Parameter lightElevatedHighContrast: The override color for a light, elevated, high contrast context. Optional.
    /// - Parameter dark: The override color for a dark context. Optional.
    /// - Parameter darkHighContrast: The override color for a dark, high contrast context. Optional.
    /// - Parameter darkElevated: The override color for a dark, elevated context. Optional.
    /// - Parameter darkElevatedHighContrast: The override color for a dark, elevated, high contrast context. Optional.
    @objc public convenience init(light: UIColor,
                                  lightHighContrast: UIColor? = nil,
                                  lightElevated: UIColor? = nil,
                                  lightElevatedHighContrast: UIColor? = nil,
                                  dark: UIColor? = nil,
                                  darkHighContrast: UIColor? = nil,
                                  darkElevated: UIColor? = nil,
                                  darkElevatedHighContrast: UIColor? = nil) {
        self.init { traits -> UIColor in
            let getColorForContrast = { (_ default: UIColor?, highContrast: UIColor?) -> UIColor? in
                if traits.accessibilityContrast == .high, let color = highContrast {
                    return color
                }
                return `default`
            }

            let getColor = { (_ default: UIColor?, highContrast: UIColor?, elevated: UIColor?, elevatedHighContrast: UIColor?) -> UIColor? in
                if traits.userInterfaceLevel == .elevated,
                   let color = getColorForContrast(elevated, elevatedHighContrast) {
                    return color
                }
                return getColorForContrast(`default`, highContrast)
            }

            if traits.userInterfaceStyle == .dark,
               let color = getColor(dark, darkHighContrast, darkElevated, darkElevatedHighContrast) {
                return color
            } else if let color = getColor(light, lightHighContrast, lightElevated, lightElevatedHighContrast) {
                return color
            } else {
                preconditionFailure("Unable to choose color. Should not be reachable, as `light` color is non-optional.")
            }
        }
    }

    /// `DynamicColor` representation of the `UIColor` object.
    /// Requires the `UIColor` to be able to resolve its color values for at least the `.light` user interface style.
    public var dynamicColor: DynamicColor? {
        // Only the light color value is mandatory when making a DynamicColor.
        if let lightColorValue = resolvedColorValue(userInterfaceStyle: .light) {
            let colors = DynamicColor(
                light: lightColorValue,
                lightHighContrast: resolvedColorValue(userInterfaceStyle: .light,
                                                      accessibilityContrast: .high),
                lightElevated: resolvedColorValue(userInterfaceStyle: .light,
                                                  userInterfaceLevel: .elevated),
                lightElevatedHighContrast: resolvedColorValue(userInterfaceStyle: .light,
                                                              accessibilityContrast: .high,
                                                              userInterfaceLevel: .elevated),
                dark: resolvedColorValue(userInterfaceStyle: .dark),
                darkHighContrast: resolvedColorValue(userInterfaceStyle: .dark,
                                                     accessibilityContrast: .high),
                darkElevated: resolvedColorValue(userInterfaceStyle: .dark,
                                                 userInterfaceLevel: .elevated),
                darkElevatedHighContrast: resolvedColorValue(userInterfaceStyle: .dark,
                                                             accessibilityContrast: .high,
                                                             userInterfaceLevel: .elevated))
            return colors
        } else {
            return nil
        }
    }

    /// Creates a UIColor from a `ColorValue` instance.
    ///
    /// - Parameter colorValue: Color value to use to initialize this color.
    @objc public convenience init(colorValue: ColorValue) {
        self.init(
            red: colorValue.r,
            green: colorValue.g,
            blue: colorValue.b,
            alpha: colorValue.a)
    }

    /// Creates a `UIColor` instance with the specified three-channel, 8-bit-per-channel color value, usually in hex.
    ///
    /// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue. There is no way to specify an
    /// alpha channel via this initializer. For that, use `init(red:green:blue:alpha)` instead.
    ///
    /// - Parameter hexValue: The color value to store, in 24-bit (three-channel, 8-bit) RGB.
    ///
    /// - Returns: A color object that stores the provided color information.
    @objc public convenience init(hexValue: UInt32) {
        let red: CGFloat = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hexValue & 0x000000FF) / 255.0
        self.init(red: red,
                  green: green,
                  blue: blue,
                  alpha: 1.0)
    }

    /// Creates a dynamic color object that returns the appropriate color value based on the current
    /// rendering context.
    ///
    /// - Parameter dynamicColor: The set of color values that may be applied based on the current context.
    @objc public convenience init(dynamicColor: DynamicColor) {
        self.init { traits -> UIColor in
            let colorValue = dynamicColor.value(colorScheme: (traits.userInterfaceStyle == .dark ? .dark : .light),
                                            contrast: traits.accessibilityContrast == .high ? .increased : .standard,
                                            isElevated: traits.userInterfaceLevel == .elevated)
            return UIColor(colorValue: colorValue)
        }
    }

    @objc public var light: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .light) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var lightHighContrast: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .light,
                                             accessibilityContrast: .high) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var lightElevated: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .light,
                                             userInterfaceLevel: .elevated) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var lightElevatedHighContrast: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .light,
                                             accessibilityContrast: .high,
                                             userInterfaceLevel: .elevated) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var dark: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .dark) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var darkHighContrast: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .dark,
                                             accessibilityContrast: .high) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var darkElevated: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .dark,
                                             userInterfaceLevel: .elevated) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    @objc public var darkElevatedHighContrast: UIColor {
        guard let color = resolvedColorValue(userInterfaceStyle: .dark,
                                             accessibilityContrast: .high,
                                             userInterfaceLevel: .elevated) else {
            return self
        }
        return UIColor(colorValue: color)
    }

    private var colorValue: ColorValue? {
        var redValue: CGFloat = 1.0
        var greenValue: CGFloat = 1.0
        var blueValue: CGFloat = 1.0
        var alphaValue: CGFloat = 1.0
        if self.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue) {
            let colorValue = ColorValue(r: redValue, g: greenValue, b: blueValue, a: alphaValue)
            return colorValue
        } else {
            return nil
        }
    }

    /// Returns the version of the current color that results from the specified traits as a `ColorValue`.
    ///
    /// - Parameter userInterfaceStyle: The user interface style to use when resolving the color information.
    /// - Parameter accessibilityContrast: The accessibility contrast to use when resolving the color information.
    /// - Parameter userInterfaceLevel: The user interface level to use when resolving the color information.
    ///
    /// - Returns: The version of the color to display for the specified traits.
    private func resolvedColorValue(userInterfaceStyle: UIUserInterfaceStyle,
                                    accessibilityContrast: UIAccessibilityContrast = .unspecified,
                                    userInterfaceLevel: UIUserInterfaceLevel = .unspecified) -> ColorValue? {
        let traitCollectionStyle = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        let traitCollectionContrast = UITraitCollection(accessibilityContrast: accessibilityContrast)
        let traitCollectionLevel = UITraitCollection(userInterfaceLevel: userInterfaceLevel)
        let traitCollection = UITraitCollection(traitsFrom: [traitCollectionStyle, traitCollectionContrast, traitCollectionLevel])
        let resolvedColor = self.resolvedColor(with: traitCollection)
        return resolvedColor.colorValue
    }
}
