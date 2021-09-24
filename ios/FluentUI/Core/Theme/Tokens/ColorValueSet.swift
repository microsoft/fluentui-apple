//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// An alias that represents a three-channel, 8-bit-per-channel color value, usually in hex.
///
/// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue.
typealias ColorValue = UInt32

/// Represents a set of color values to be used in different contexts.
public struct ColorValueSet {
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
}
