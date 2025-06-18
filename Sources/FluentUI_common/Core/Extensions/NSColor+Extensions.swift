//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSColor {

    /// Creates a dynamic color object that returns the appropriate color value based on the current
    /// rendering context.
    ///
    /// The decision order for choosing between the colors is based on the following questions, in order:
    /// - Is the current `userInterfaceStyle` `.dark` or `.light`?
    ///
    /// - Parameter light: The default color for a light context. Required.
    /// - Parameter dark: The override color for a dark context. Optional.
    @objc public convenience init(light: NSColor,
                                  dark: NSColor? = nil) {
        self.init(name: nil) { appearance -> NSColor in
            let isDarkMode = appearance.bestMatch(from:[NSAppearance.Name.darkAqua]) == NSAppearance.Name.darkAqua
            return isDarkMode ? (dark ?? light) : light
        }
    }

    /// Creates an `NSColor` instance with the specified three-channel, 8-bit-per-channel color value, usually in hex.
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

    @objc public var light: NSColor {
        return resolvedColorValue(appearance: NSAppearance(named: .aqua))
    }

    @objc public var dark: NSColor {
        return resolvedColorValue(appearance: NSAppearance(named: .darkAqua))
    }

    convenience init(dynamicColor: DynamicColor) {
        self.init(light: NSColor(dynamicColor.light),
                  dark: dynamicColor.dark.map { NSColor($0) })
    }

    /// Returns the version of the current color that results from the specified traits as an `NSColor`.
    ///
    /// - Parameter appearance: The user interface appearance to use when resolving the color information.
    ///
    /// - Returns: The version of the color to display for the specified appearance.
    private func resolvedColorValue(appearance: NSAppearance?) -> NSColor {
        guard let appearance else {
            return self
        }

        /// `NSAppearance.performAsCurrentDrawingAppearance` will let us
        /// retrieve NSColor variants for a given drawing appearance.
        /// Unfortunately there's no direct way to pass data out of the closure
        /// passed into this method, so create a local class that can shuttle
        /// values in and out.
        class ColorHolder {
            var cgColor: CGColor = .black
        }

        let holder = ColorHolder()
        appearance.performAsCurrentDrawingAppearance { [holder] in
            // Use `cgColor` to force `NSColor` to flatten into the appropriate
            // set of values for this appearance.
            holder.cgColor = self.cgColor
        }

        guard let nsColorValue = NSColor(cgColor: holder.cgColor) else {
            preconditionFailure("Should not be possible to fail to create NSColor here!")
        }
        return nsColorValue
    }
}
#endif // canImport(AppKit)
