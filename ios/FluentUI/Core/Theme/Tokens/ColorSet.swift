//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A platform-agnostic representation of a 32-bit RGBA color value.
public struct ColorValue {
    var r: CGFloat { CGFloat((hexValue & 0xFF000000) >> 24) / 255.0 }
    var g: CGFloat { CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0 }
    var b: CGFloat { CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0 }
    var a: CGFloat { CGFloat(hexValue & 0x000000FF) / 255.0 }

    /// Creates a color value instance with the specified three-channel, 8-bit-per-channel color value, usually in hex.
    ///
    /// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue.
    /// There is no way to specify an alpha channel via this initializer. For that, use `init(r:g:b:a)` instead.
    ///
    /// - Parameter hexValue: The color value to store, in 24-bit (three-channel, 8-bit) RGB.
    ///
    /// - Returns: A color object that stores the provided color information.
    public init(_ hexValue: UInt32) {
        self.hexValue = hexValue << 8 | 0xFF
    }

    /// Creates a color value instance with the specified channel values.
    ///
    /// Parameters work just like `UIColor`, `NSColor`, or `SwiftUI.Color`, and should all be in the range of `0.0 ≤ value ≤ 1.0`.
    /// Any channel that is above 1.0 will be clipped down to 1.0; results are undefined for negative inputs.
    ///
    /// - Parameter r: The red channel.
    /// - Parameter g: The green channel.
    /// - Parameter b: The blue channel.
    /// - Parameter a: The alpha channel.
    ///
    /// - Returns: A color object that stores the provided color information.
    public init(r: CGFloat,
                g: CGFloat,
                b: CGFloat,
                a: CGFloat) {
        hexValue = (min(UInt32(r * 255.0), 0xFF) << 24) |
                   (min(UInt32(g * 255.0), 0xFF) << 16) |
                   (min(UInt32(b * 255.0), 0xFF) << 8) |
                   (min(UInt32(a * 255.0), 0xFF))
    }

    // Value is stored in RGBA format.
    private let hexValue: UInt32
}

/// Represents a set of color values to be used in different contexts.
public struct ColorSet {
    /// Creates a dynamic color object that wraps a set of color values for various rendering contexts.
    ///
    /// - Parameter light: The default color for a light context. Required.
    /// - Parameter lightHighContrast: The override color for a light, high contrast context. Optional.
    /// - Parameter lightElevated: The override color for a light, elevated context. Optional.
    /// - Parameter lightElevatedHighContrast: The override color for a light, elevated, high contrast context. Optional.
    /// - Parameter dark: The override color for a dark context. Optional.
    /// - Parameter darkHighContrast: The override color for a dark, high contrast context. Optional.
    /// - Parameter darkElevated: The override color for a dark, elevated context. Optional.
    /// - Parameter darkElevatedHighContrast: The override color for a dark, elevated, high contrast context. Optional.
    public init(light: ColorValue,
                lightHighContrast: ColorValue? = nil,
                lightElevated: ColorValue? = nil,
                lightElevatedHighContrast: ColorValue? = nil,
                dark: ColorValue? = nil,
                darkHighContrast: ColorValue? = nil,
                darkElevated: ColorValue? = nil,
                darkElevatedHighContrast: ColorValue? = nil) {
        self.light = light
        self.lightHighContrast = lightHighContrast
        self.lightElevated = lightElevated
        self.lightElevatedHighContrast = lightElevatedHighContrast
        self.dark = dark
        self.darkHighContrast = darkHighContrast
        self.darkElevated = darkElevated
        self.darkElevatedHighContrast = darkElevatedHighContrast
    }

    /// The default color for a light context. Required.
    var light: ColorValue

    /// The override color for a light, high contrast context. Optional.
    var lightHighContrast: ColorValue?

    /// The override color for a light, elevated context. Optional.
    var lightElevated: ColorValue?

    /// The override color for a light, elevated, high contrast context. Optional.
    var lightElevatedHighContrast: ColorValue?

    /// The override color for a dark context. Optional.
    var dark: ColorValue?

    /// The override color for a dark, high contrast context. Optional.
    var darkHighContrast: ColorValue?

    /// The override color for a dark, elevated context. Optional.
    var darkElevated: ColorValue?

    /// The override color for a dark, elevated, high contrast context. Optional.
    var darkElevatedHighContrast: ColorValue?

    // MARK: - Internal functions

    /// Returns an appropriate color value based on the contextual info passed in.
    ///
    /// The decision order for choosing between the colors is based on the following questions, in order:
    /// - Is the current `userInterfaceStyle` `.dark` or `.light`?
    /// - Is the current `userInterfaceLevel` `.base` or `.elevated`?
    /// - Is the current `accessibilityContrast` `.normal` or `.high`?
    ///
    /// - Parameters:
    ///   - colorScheme: The current color scheme, `.dark` or `.light`.
    ///   - contrast: The current contrast value, `.base` or `.elevated`.
    ///   - isElevated: Whether we are in an elevated context.
    func value(colorScheme: ColorScheme,
               contrast: ColorSchemeContrast,
               isElevated: Bool) -> ColorValue {
        if colorScheme == .dark,
           let color = getColor(dark,
                                darkHighContrast,
                                darkElevated,
                                darkElevatedHighContrast,
                                contrast,
                                isElevated) {
            return color
        } else if let color = getColor(light,
                                       lightHighContrast,
                                       lightElevated,
                                       lightElevatedHighContrast,
                                       contrast,
                                       isElevated) {
            return color
        } else {
            preconditionFailure("Unable to choose color. Should not be reachable, as `light` color is non-optional.")
        }
    }

    // MARK: - Private functions

    private func getColorForContrast(_ default: ColorValue?,
                                     _ highContrast: ColorValue?,
                                     _ contrast: ColorSchemeContrast) -> ColorValue? {
        if contrast == .increased, let color = highContrast {
            return color
        }
        return `default`
    }

    private func getColor(_ default: ColorValue?,
                          _ highContrast: ColorValue?,
                          _ elevated: ColorValue?,
                          _ elevatedHighContrast: ColorValue?,
                          _ contrast: ColorSchemeContrast,
                          _ isElevated: Bool) -> ColorValue? {
        if isElevated == true,
           let color = getColorForContrast(elevated, elevatedHighContrast, contrast) {
            return color
        }
        return getColorForContrast(`default`, highContrast, contrast)
    }

}
