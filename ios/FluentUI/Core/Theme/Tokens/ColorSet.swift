//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// An alias that represents a three-channel, 8-bit-per-channel color value, usually in hex.
///
/// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue.
typealias ColorValue = UInt32

/// Represents a set of color values to be used in different contexts.
public struct ColorSet {
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
