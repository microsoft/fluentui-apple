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
    @objc func brandBackground1(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground1Pressed(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground1Selected(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground2(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground2Pressed(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground2Selected(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackground3(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackgroundTint(for themeable: FluentThemeable) -> UIColor?
    @objc func brandBackgroundDisabled(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForeground1(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForeground1Pressed(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForeground1Selected(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForegroundTint(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForegroundDisabled1(for themeable: FluentThemeable) -> UIColor?
    @objc func brandForegroundDisabled2(for themeable: FluentThemeable) -> UIColor?
    @objc func brandStroke1(for themeable: FluentThemeable) -> UIColor?
    @objc func brandStroke1Pressed(for themeable: FluentThemeable) -> UIColor?
    @objc func brandStroke1Selected(for themeable: FluentThemeable) -> UIColor?
}

private func brandColorOverrides(provider: ColorProviding,
                                 for themeable: FluentThemeable) -> [AliasTokens.ColorsTokens: DynamicColor] {
    var brandColors: [AliasTokens.ColorsTokens: DynamicColor] = [:]
    if let brandBackground1 = provider.brandBackground1(for: themeable)?.dynamicColor {
        brandColors[.brandBackground1] = brandBackground1
    }
    if let brandBackground1Pressed = provider.brandBackground1Pressed(for: themeable)?.dynamicColor {
        brandColors[.brandBackground1Pressed] = brandBackground1Pressed
    }
    if let brandBackground1Selected = provider.brandBackground1Selected(for: themeable)?.dynamicColor {
        brandColors[.brandBackground1Selected] = brandBackground1Selected
    }
    if let brandBackground2 = provider.brandBackground2(for: themeable)?.dynamicColor {
        brandColors[.brandBackground2] = brandBackground2
    }
    if let brandBackground2Pressed = provider.brandBackground2Pressed(for: themeable)?.dynamicColor {
        brandColors[.brandBackground2Pressed] = brandBackground2Pressed
    }
    if let brandBackground2Selected = provider.brandBackground2Selected(for: themeable)?.dynamicColor {
        brandColors[.brandBackground2Selected] = brandBackground2Selected
    }
    if let brandBackground3 = provider.brandBackground3(for: themeable)?.dynamicColor {
        brandColors[.brandBackground3] = brandBackground3
    }
    if let brandBackgroundTint = provider.brandBackgroundTint(for: themeable)?.dynamicColor {
        brandColors[.brandBackgroundTint] = brandBackgroundTint
    }
    if let brandBackgroundDisabled = provider.brandBackgroundDisabled(for: themeable)?.dynamicColor {
        brandColors[.brandBackgroundDisabled] = brandBackgroundDisabled
    }
    if let brandForeground1 = provider.brandForeground1(for: themeable)?.dynamicColor {
        brandColors[.brandForeground1] = brandForeground1
    }
    if let brandForeground1Pressed = provider.brandForeground1Pressed(for: themeable)?.dynamicColor {
        brandColors[.brandForeground1Pressed] = brandForeground1Pressed
    }
    if let brandForeground1Selected = provider.brandForeground1Selected(for: themeable)?.dynamicColor {
        brandColors[.brandForeground1Selected] = brandForeground1Selected
    }
    if let brandForegroundTint = provider.brandForegroundTint(for: themeable)?.dynamicColor {
        brandColors[.brandForegroundTint] = brandForegroundTint
    }
    if let brandForegroundDisabled1 = provider.brandForegroundDisabled1(for: themeable)?.dynamicColor {
        brandColors[.brandForegroundDisabled1] = brandForegroundDisabled1
    }
    if let brandForegroundDisabled2 = provider.brandForegroundDisabled2(for: themeable)?.dynamicColor {
        brandColors[.brandForegroundDisabled2] = brandForegroundDisabled2
    }
    if let brandStroke1 = provider.brandStroke1(for: themeable)?.dynamicColor {
        brandColors[.brandStroke1] = brandStroke1
    }
    if let brandStroke1Pressed = provider.brandStroke1Pressed(for: themeable)?.dynamicColor {
        brandColors[.brandStroke1Pressed] = brandStroke1Pressed
    }
    if let brandStroke1Selected = provider.brandStroke1Selected(for: themeable)?.dynamicColor {
        brandColors[.brandStroke1Selected] = brandStroke1Selected
    }
    return brandColors
}

// MARK: Colors

@objc public extension UIView {
    /// Associates a `ColorProvider2` with a given `UIView`.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider2` whose colors should be used for controls in this theme.
    @objc(setColorProvider:)
    @discardableResult
    func setColorProvider(_ provider: ColorProviding) -> FluentTheme {
        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider, for: self)
        let fluentTheme = FluentTheme(colorOverrides: brandColors)
        self.fluentTheme = fluentTheme
        return fluentTheme
    }

    /// Removes any associated `ColorProvider` from the given `UIView`.
    @objc(resetFluentTheme)
    func resetFluentTheme() {
        self.fluentTheme = FluentThemeKey.defaultValue
    }
}
