//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A platform-agnostic representation of a 32-bit RGBA color value.
public struct ColorValue {
    var r: UInt8 { UInt8(hexValue & 0xFF000000) }
    var g: UInt8 { UInt8(hexValue & 0x00FF0000) }
    var b: UInt8 { UInt8(hexValue & 0x0000FF00) }
    var a: UInt8 { UInt8(hexValue & 0x000000FF) }

    /// Creates a color value instance
    public init(r: UInt8,
                g: UInt8,
                b: UInt8,
                a: UInt8) {
        hexValue = UInt32((r << 24) | (g << 16) | (b << 8) | a)
    }

    /// C
    public init(_ hexValue: UInt32) {
        self.hexValue = hexValue << 8 | 0xFF
    }

    // Value is stored as RGBA.
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
