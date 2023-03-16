//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ColorProviding

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The view associated with the passed in theme will display the set colors to allow apps to provide different experiences per each view
@objc(MSFColorProviding)
public protocol ColorProviding {
    /// If this protocol is not conformed to, communicationBlue variants will be used
    @objc var brandBackground1: UIColor { get }
    @objc var brandBackground1Pressed: UIColor { get }
    @objc var brandBackground1Selected: UIColor { get }
    @objc var brandBackground2: UIColor { get }
    @objc var brandBackground2Pressed: UIColor { get }
    @objc var brandBackground2Selected: UIColor { get }
    @objc var brandBackground3: UIColor { get }
    @objc var brandBackgroundTint: UIColor { get }
    @objc var brandBackgroundDisabled: UIColor { get }
    @objc var brandForeground1: UIColor { get }
    @objc var brandForeground1Pressed: UIColor { get }
    @objc var brandForeground1Selected: UIColor { get }
    @objc var brandForegroundTint: UIColor { get }
    @objc var brandForegroundDisabled1: UIColor { get }
    @objc var brandForegroundDisabled2: UIColor { get }
    @objc var brandStroke1: UIColor { get }
    @objc var brandStroke1Pressed: UIColor { get }
    @objc var brandStroke1Selected: UIColor { get }
}

private func brandColorOverrides(provider: ColorProviding) -> [FluentTheme.ColorToken: DynamicColor] {
    var brandColors: [FluentTheme.ColorToken: DynamicColor] = [:]

    brandColors[.brandBackground1] = provider.brandBackground1.dynamicColor
    brandColors[.brandBackground1Pressed] = provider.brandBackground1Pressed.dynamicColor
    brandColors[.brandBackground1Selected] = provider.brandBackground1Selected.dynamicColor
    brandColors[.brandBackground2] = provider.brandBackground2.dynamicColor
    brandColors[.brandBackground2Pressed] = provider.brandBackground2Pressed.dynamicColor
    brandColors[.brandBackground2Selected] = provider.brandBackground2Selected.dynamicColor
    brandColors[.brandBackground3] = provider.brandBackground3.dynamicColor
    brandColors[.brandBackgroundTint] = provider.brandBackgroundTint.dynamicColor
    brandColors[.brandBackgroundDisabled] = provider.brandBackgroundDisabled.dynamicColor
    brandColors[.brandForeground1] = provider.brandForeground1.dynamicColor
    brandColors[.brandForeground1Pressed] = provider.brandForeground1Pressed.dynamicColor
    brandColors[.brandForeground1Selected] = provider.brandForeground1Selected.dynamicColor
    brandColors[.brandForegroundTint] = provider.brandForegroundTint.dynamicColor
    brandColors[.brandForegroundDisabled1] = provider.brandForegroundDisabled1.dynamicColor
    brandColors[.brandForegroundDisabled2] = provider.brandForegroundDisabled2.dynamicColor
    brandColors[.brandStroke1] = provider.brandStroke1.dynamicColor
    brandColors[.brandStroke1Pressed] = provider.brandStroke1Pressed.dynamicColor
    brandColors[.brandStroke1Selected] = provider.brandStroke1Selected.dynamicColor

    return brandColors
}


// MARK: Colors

@objc public extension UIView {
    /// Associates a `ColorProvider2` with a given `UIView`.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider2` whose colors should be used for controls in this theme.
    @objc(setColorProvider:)
    func setColorProvider(_ provider: ColorProviding) {
        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider)
        let fluentTheme = FluentTheme(colorOverrides: brandColors)
        self.fluentTheme = fluentTheme
    }

    /// Removes any associated `ColorProvider` from the given `UIView`.
    @objc(resetFluentTheme)
    func resetFluentTheme() {
        self.fluentTheme = FluentThemeKey.defaultValue
    }
}
