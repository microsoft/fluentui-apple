//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(UIKit)
import UIKit

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

    /// Creates a dynamic color object that returns the appropriate light or dark color value based on the current
    /// rendering context.
    ///
    /// Convenience wrapper for
    ///`init(light:lightHighContrast:lightElevated:lightElevatedHighContrast:dark:darkHighContrast:darkElevated:darkElevatedHighContrast:)`
    /// to simplify Objective-C consumption.
    ///
    /// - Parameter light: The default color for a light context. Required.
    /// - Parameter dark: The override color for a dark context. Required.
    @objc public convenience init(light: UIColor,
                                  dark: UIColor) {
        self.init(light: light,
                  lightHighContrast: nil,
                  lightElevated: nil,
                  lightElevatedHighContrast: nil,
                  dark: dark,
                  darkHighContrast: nil,
                  darkElevated: nil,
                  darkElevatedHighContrast: nil)
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

    @objc public var light: UIColor {
        return resolvedColorValue(userInterfaceStyle: .light)
    }

    @objc public var lightHighContrast: UIColor {
        return resolvedColorValue(userInterfaceStyle: .light,
                                  accessibilityContrast: .high)
    }

    @objc public var lightElevated: UIColor {
        return resolvedColorValue(userInterfaceStyle: .light,
                                  userInterfaceLevel: .elevated)
    }

    @objc public var lightElevatedHighContrast: UIColor {
        return resolvedColorValue(userInterfaceStyle: .light,
                                  accessibilityContrast: .high,
                                  userInterfaceLevel: .elevated)
    }

    @objc public var dark: UIColor {
        return resolvedColorValue(userInterfaceStyle: .dark)
    }

    @objc public var darkHighContrast: UIColor {
        return resolvedColorValue(userInterfaceStyle: .dark,
                                  accessibilityContrast: .high)
    }

    @objc public var darkElevated: UIColor {
        return resolvedColorValue(userInterfaceStyle: .dark,
                                  userInterfaceLevel: .elevated)
    }

    @objc public var darkElevatedHighContrast: UIColor {
        return resolvedColorValue(userInterfaceStyle: .dark,
                                  accessibilityContrast: .high,
                                  userInterfaceLevel: .elevated)
    }

    public convenience init(dynamicColor: DynamicColor) {
        self.init(light: UIColor(dynamicColor.light),
                  dark: dynamicColor.dark.map { UIColor($0) },
                  darkElevated: dynamicColor.darkElevated.map { UIColor($0) })
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
                                    userInterfaceLevel: UIUserInterfaceLevel = .unspecified) -> UIColor {
        let traitCollection: UITraitCollection
        if #available(iOS 17, *) {
            traitCollection = UITraitCollection { mutableTraits in
                mutableTraits.userInterfaceStyle = userInterfaceStyle
                mutableTraits.accessibilityContrast = accessibilityContrast
                mutableTraits.userInterfaceLevel = userInterfaceLevel
            }
        } else {
            let traitCollectionStyle = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
            let traitCollectionContrast = UITraitCollection(accessibilityContrast: accessibilityContrast)
            let traitCollectionLevel = UITraitCollection(userInterfaceLevel: userInterfaceLevel)
            traitCollection = UITraitCollection(traitsFrom: [traitCollectionStyle, traitCollectionContrast, traitCollectionLevel])
        }
        let resolvedColor = self.resolvedColor(with: traitCollection)
        return resolvedColor
    }
}
#endif // canImport(UIKit)
