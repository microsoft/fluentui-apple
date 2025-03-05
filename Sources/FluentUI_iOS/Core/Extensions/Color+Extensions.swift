//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension Color {
    /// Creates a `Color` instance with the specified three-channel, 8-bit-per-channel color value, usually in hex.
    ///
    /// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue. There is no way to specify an
    /// alpha channel via this initializer. For that, use the `.opacity(:)` modifier on the resulting `Color` instance.
    ///
    /// - Parameter hexValue: The color value to store, in 24-bit (three-channel, 8-bit) RGB.
    ///
    /// - Returns: A color object that stores the provided color information.
    public init(hexValue: UInt32) {
        let red: CGFloat = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hexValue & 0x000000FF) / 255.0
        self.init(red: red,
                  green: green,
                  blue: blue)
    }

    /// Creates a custom `Color` that stores a dynamic set of `Color` values.
    ///
    /// - Parameter light: The default `Color` for a light context. Required.
    /// - Parameter dark: The override `Color` for a dark context. Optional.
    /// - Parameter darkElevated: The override `Color` for a dark elevated context. Optional.
    public init(light: Color,
                dark: Color? = nil,
                darkElevated: Color? = nil) {

        let dynamicColor = DynamicColor(light: light, dark: dark, darkElevated: darkElevated)
        self.init(dynamicColor: dynamicColor)
    }

    /// Creates a custom `Color` from a prebuilt `DynamicColor` structure.
    ///
    /// - Parameter dynamicColor: A dynmic color structure that describes the `Color` to be created.
    init(dynamicColor: DynamicColor) {
        if #available(iOS 17, *) {
            self.init(dynamicColor)
        } else {
            self.init(uiColor: UIColor(dynamicColor: dynamicColor))
        }
    }

    var dynamicColor: DynamicColor {
        if #available(iOS 17, *) {
            var lightEnvironment = EnvironmentValues.init()
            lightEnvironment.colorScheme = .light

            var darkEnvironment = EnvironmentValues.init()
            darkEnvironment.colorScheme = .dark

            return DynamicColor(light: Color(self.resolve(in: lightEnvironment)),
                                dark: Color(self.resolve(in: darkEnvironment)))
        } else {
            let uiColor = UIColor(self)
            return DynamicColor(light: Color(uiColor.light),
                                dark: Color(uiColor.dark))
        }
    }
}
