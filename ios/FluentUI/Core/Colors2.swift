//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ColorProviding2 - temporary stand-in for ColorProviding so we can replace side by side

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The window in which the color will be shown is sent to allow apps to provide different experiences per each window
@objc(MSFColorProviding2)
public protocol ColorProviding2 {
    /// If this protocol is not conformed to, communicationBlue variants will be used
    @objc func brandBackground1(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground1Pressed(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground1Selected(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground2(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground2Pressed(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground2Selected(for theme: FluentTheme) -> UIColor?
    @objc func brandBackground3(for theme: FluentTheme) -> UIColor?
    @objc func brandBackgroundTint(for theme: FluentTheme) -> UIColor?
    @objc func brandBackgroundDisabled(for theme: FluentTheme) -> UIColor?
    @objc func brandForeground1(for theme: FluentTheme) -> UIColor?
    @objc func brandForeground1Pressed(for theme: FluentTheme) -> UIColor?
    @objc func brandForeground1Selected(for theme: FluentTheme) -> UIColor?
    @objc func brandForegroundTint(for theme: FluentTheme) -> UIColor?
    @objc func brandForegroundDisabled1(for theme: FluentTheme) -> UIColor?
    @objc func brandForegroundDisabled2(for theme: FluentTheme) -> UIColor?
    @objc func brandStroke1(for theme: FluentTheme) -> UIColor?
    @objc func brandStroke1Pressed(for theme: FluentTheme) -> UIColor?
    @objc func brandStroke1Selected(for theme: FluentTheme) -> UIColor?
}

private func brandColorOverrides(provider: ColorProviding2, for theme: FluentTheme) -> [AliasTokens.ColorsTokens: DynamicColor] {
    var brandColors: [AliasTokens.ColorsTokens: DynamicColor] = [:]
    if let brandBackground1 = provider.brandBackground1(for: theme)?.dynamicColor {
        brandColors[.brandBackground1] = brandBackground1
    }
    if let brandBackground1Pressed = provider.brandBackground1Pressed(for: theme)?.dynamicColor {
        brandColors[.brandBackground1Pressed] = brandBackground1Pressed
    }
    if let brandBackground1Selected = provider.brandBackground1Selected(for: theme)?.dynamicColor {
        brandColors[.brandBackground1Selected] = brandBackground1Selected
    }
    if let brandBackground2 = provider.brandBackground2(for: theme)?.dynamicColor {
        brandColors[.brandBackground2] = brandBackground2
    }
    if let brandBackground2Pressed = provider.brandBackground2Pressed(for: theme)?.dynamicColor {
        brandColors[.brandBackground2Pressed] = brandBackground2Pressed
    }
    if let brandBackground2Selected = provider.brandBackground2Selected(for: theme)?.dynamicColor {
        brandColors[.brandBackground2Selected] = brandBackground2Selected
    }
    if let brandBackground3 = provider.brandBackground3(for: theme)?.dynamicColor {
        brandColors[.brandBackground3] = brandBackground3
    }
    if let brandBackgroundTint = provider.brandBackgroundTint(for: theme)?.dynamicColor {
        brandColors[.brandBackgroundTint] = brandBackgroundTint
    }
    if let brandBackgroundDisabled = provider.brandBackgroundDisabled(for: theme)?.dynamicColor {
        brandColors[.brandBackgroundDisabled] = brandBackgroundDisabled
    }
    if let brandForeground1 = provider.brandForeground1(for: theme)?.dynamicColor {
        brandColors[.brandForeground1] = brandForeground1
    }
    if let brandForeground1Pressed = provider.brandForeground1Pressed(for: theme)?.dynamicColor {
        brandColors[.brandForeground1Pressed] = brandForeground1Pressed
    }
    if let brandForeground1Selected = provider.brandForeground1Selected(for: theme)?.dynamicColor {
        brandColors[.brandForeground1Selected] = brandForeground1Selected
    }
    if let brandForegroundTint = provider.brandForegroundTint(for: theme)?.dynamicColor {
        brandColors[.brandForegroundTint] = brandForegroundTint
    }
    if let brandForegroundDisabled1 = provider.brandForegroundDisabled1(for: theme)?.dynamicColor {
        brandColors[.brandForegroundDisabled1] = brandForegroundDisabled1
    }
    if let brandForegroundDisabled2 = provider.brandForegroundDisabled2(for: theme)?.dynamicColor {
        brandColors[.brandForegroundDisabled2] = brandForegroundDisabled2
    }
    if let brandStroke1 = provider.brandStroke1(for: theme)?.dynamicColor {
        brandColors[.brandStroke1] = brandStroke1
    }
    if let brandStroke1Pressed = provider.brandStroke1Pressed(for: theme)?.dynamicColor {
        brandColors[.brandStroke1Pressed] = brandStroke1Pressed
    }
    if let brandStroke1Selected = provider.brandStroke1Selected(for: theme)?.dynamicColor {
        brandColors[.brandStroke1Selected] = brandStroke1Selected
    }
    return brandColors
}

// MARK: Colors

@objc(MSFColors2)
public final class Colors2: NSObject {
    /// Associates a `ColorProvider2` with a given `UIWindow` instance.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider2` whose colors should be used for controls in this window.
    ///   - window: The window where these colors should be applied.
    @objc public static func setProvider(provider: ColorProviding2, for theme: FluentTheme) {
        colorProvidersMap.setObject(provider, forKey: theme)

        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider, for: theme)
        brandColors.forEach { token, value in
            theme.aliasTokens.colors[token] = value
        }
    }

    /// Removes any associated `ColorProvider2` from the given `UIWindow` instance.
    ///
    /// - Parameters:
    ///   - window: The window that should have its `ColorProvider2` removed.
    @objc public static func removeProvider(for theme: FluentTheme) {
        let removedProvider = colorProvidersMap.object(forKey: theme)
        colorProvidersMap.removeObject(forKey: theme)

        guard let removedProvider = removedProvider else {
            return
        }
        let defaultTokens = FluentTheme.shared.aliasTokens
        let brandColors = brandColorOverrides(provider: removedProvider, for: theme)
        brandColors.forEach { token, _ in
            theme.aliasTokens.colors[token] = defaultTokens.colors[token]
        }
    }

    private static var colorProvidersMap = NSMapTable<FluentTheme, ColorProviding2>(keyOptions: .weakMemory, valueOptions: .weakMemory)

    @available(*, unavailable)
    override init() {
        super.init()
    }
}
