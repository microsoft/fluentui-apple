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
    init(hexValue: UInt32) {
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
    init(light: Color,
         dark: Color? = nil,
         darkElevated: Color? = nil) {

        let dynamicColor = DynamicColor(light: light, dark: dark, darkElevated: darkElevated)
        if #available(iOS 17, *) {
            self.init(dynamicColor)
        } else {
            self.init(uiColor: UIColor(dynamicColor: dynamicColor))
        }
    }

    init(dynamicColor: DynamicColor) {
        if #available(iOS 17, *) {
            self.init(dynamicColor)
        } else {
            self.init(uiColor: UIColor(dynamicColor: dynamicColor))
        }
    }
}

/// A container that stores a dynamic set of `Color` values.
struct DynamicColor: Hashable {

    /// Creates a custom `ShapeStyle` that stores a dynamic set of `Color` values.
    ///
    /// - Parameter light: The default `Color` for a light context. Required.
    /// - Parameter dark: The override `Color` for a dark context. Optional.
    /// - Parameter darkElevated: The override `Color` for a dark elevated context. Optional.
    init(light: Color,
         dark: Color? = nil,
         darkElevated: Color? = nil) {
        self.light = light
        self.dark = dark
        self.darkElevated = darkElevated
    }

    init(uiColor: UIColor) {
        self.init(light: Color(uiColor.light),
                  dark: Color(uiColor.dark),
                  darkElevated: Color(uiColor.darkElevated))
    }

    let light: Color
    let dark: Color?
    let darkElevated: Color?
}

@available(iOS 17, *)
extension DynamicColor: ShapeStyle {
    /// Evaluate to a resolved `Color` (in the form of a `ShapeStyle`) given the current `environment`.
    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        if environment.colorScheme == .dark {
            if environment.isPresented, let darkElevated = darkElevated {
                return darkElevated.resolve(in: environment)
            } else if let dark = dark {
                return dark.resolve(in: environment)
            }
        }

        // default
        return light.resolve(in: environment)
    }
}
