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
    public convenience init(light: UIColor,
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

    /// Creates a UIColor from a single 32-bit integer value.
    ///
    /// - Parameter hexValue: Integer value, generally represented as hexadecimal (e.g. `0x0086F0`), to use to initialize this color.
    ///     Must be formatted as ARGB. Note: we will not utilize the alpha channel.
    convenience init(colorValue: ColorValue) {
        self.init(
            red: CGFloat((colorValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((colorValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((colorValue & 0x0000FF) >> 0) / 255.0,
            alpha: 1.0)
    }

    /// Creates a dynamic color object that returns the appropriate color value based on the current
    /// rendering context.
    ///
    /// - Parameter colorSet: The set of color values that may be applied based on the current context.
    convenience init(colorSet: ColorSet) {
        self.init { traits -> UIColor in
            let colorValue = colorSet.value(colorScheme: (traits.userInterfaceStyle == .dark ? .dark : .light),
                                            contrast: traits.accessibilityContrast == .high ? .increased : .standard,
                                            isElevated: traits.userInterfaceLevel == .elevated ? true : false)
            return UIColor(colorValue: colorValue)
        }
    }

    var colorSet: ColorSet? {
        // Only the light color value is mandatory when making a ColorSet.
        if let lightColorValue = resolvedColorValue(userInterfaceStyle: .light) {
            let colors = ColorSet(
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

    private var colorValue: ColorValue? {
        var redValue: CGFloat = 0.0
        var greenValue: CGFloat = 0.0
        var blueValue: CGFloat = 0.0
        if self.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: nil) {
            // Ensure that all channels fall within 0x0 and 0xFF
            let red = min(UInt32(redValue * 255.0), 0xFF)
            let green = min(UInt32(greenValue * 255.0), 0xFF)
            let blue = min(UInt32(blueValue * 255.0), 0xFF)
            let colorValue: ColorValue = (red << 16) + (green << 8) + blue
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
