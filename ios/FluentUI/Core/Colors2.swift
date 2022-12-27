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

    /// Removes any associated `ColorProvider` from the given `UIWindow` instance.
    ///
    /// - Parameters:
    ///   - window: The window that should have its `ColorProvider` removed.
    @objc public static func removeProvider(for theme: FluentTheme) {
        colorProvidersMap.removeObject(forKey: theme)
        // TODO: what is the equivalent function here?
        // window.fluentTheme = FluentThemeKey.defaultValue
    }

    // MARK: Primary

    /// Use these funcs to grab a color customized by a ColorProviding object for a specific window. If no colorProvider exists for the window, falls back to deprecated singleton theme color
    @objc public static func brandBackground1(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground1(for: theme) ?? FallbackThemeColor.brandBackground1
    }

    @objc public static func brandBackground1Pressed(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground1Pressed(for: theme) ?? FallbackThemeColor.brandBackground1Pressed
    }

    @objc public static func brandBackground1Selected(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground1Selected(for: theme) ?? FallbackThemeColor.brandBackground1Selected
    }

    @objc public static func brandBackground2(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground2(for: theme) ?? FallbackThemeColor.brandBackground2
    }

    @objc public static func brandBackground2Pressed(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground2Pressed(for: theme) ?? FallbackThemeColor.brandBackground2Pressed
    }

    @objc public static func brandBackground2Selected(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground2Selected(for: theme) ?? FallbackThemeColor.brandBackground2Selected
    }

    @objc public static func brandBackground3(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackground3(for: theme) ?? FallbackThemeColor.brandBackground3
    }

    @objc public static func brandBackgroundTint(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandBackgroundTint(for: theme) ?? FallbackThemeColor.brandBackgroundTint
    }

    @objc public static func brandForeground1(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForeground1(for: theme) ?? FallbackThemeColor.brandForeground1
    }

    @objc public static func brandForeground1Pressed(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForeground1Pressed(for: theme) ?? FallbackThemeColor.brandForeground1Pressed
    }

    @objc public static func brandForeground1Selected(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForeground1Selected(for: theme) ?? FallbackThemeColor.brandForeground1Selected
    }

    @objc public static func brandForegroundTint(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForegroundTint(for: theme) ?? FallbackThemeColor.brandForegroundTint
    }

    @objc public static func brandForegroundDisabled1(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForegroundDisabled1(for: theme) ?? FallbackThemeColor.brandForegroundDisabled1
    }

    @objc public static func brandForegroundDisabled2(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandForegroundDisabled2(for: theme) ?? FallbackThemeColor.brandForegroundDisabled2
    }

    @objc public static func brandStroke1(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandStroke1(for: theme) ?? FallbackThemeColor.brandStroke1
    }

    @objc public static func brandStroke1Pressed(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandStroke1Pressed(for: theme) ?? FallbackThemeColor.brandStroke1Pressed
    }

    @objc public static func brandStroke1Selected(for theme: FluentTheme) -> UIColor {
        return colorProvidersMap.object(forKey: theme)?.brandStroke1Selected(for: theme) ?? FallbackThemeColor.brandStroke1Selected
    }

    private static var colorProvidersMap = NSMapTable<FluentTheme, ColorProviding2>(keyOptions: .weakMemory, valueOptions: .weakMemory)

    /// A namespace for holding fallback theme colors (empty enum is an uninhabited type)
    private enum FallbackThemeColor {
        static var brandBackground1: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground1])

        static var brandBackground1Pressed: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground1Pressed])

        static var brandBackground1Selected: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground1Selected])

        static var brandBackground2: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground2])

        static var brandBackground2Pressed: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground2Pressed])

        static var brandBackground2Selected: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground2Selected])

        static var brandBackground3: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackground3])

        static var brandBackgroundTint: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandBackgroundTint])

        static var brandForeground1: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandForeground1])

        static var brandForeground1Pressed: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandForeground1Selected])

        static var brandForeground1Selected: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandStroke1Selected])

        static var brandForegroundTint: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandForegroundTint])

        static var brandForegroundDisabled1: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandForegroundDisabled1])

        static var brandForegroundDisabled2: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandForegroundDisabled2])

        static var brandStroke1: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandStroke1])

        static var brandStroke1Pressed: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandStroke1Pressed])

        static var brandStroke1Selected: UIColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.brandStroke1Selected])
    }

    @available(*, unavailable)
    override init() {
        super.init()
    }
}
