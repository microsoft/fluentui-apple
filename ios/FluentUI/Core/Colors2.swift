//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ColorProviding2 - temporary stand-in for ColorProviding so we can replace side by side

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The view associated with the passed in theme will display the set colors to alllow apps to provide different experiences per each view
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

public enum BrandColorsForOverriding: CaseIterable {
    case brandBackground1
    case brandBackground1Pressed
    case brandBackground1Selected
    case brandBackground2
    case brandBackground2Pressed
    case brandBackground2Selected
    case brandBackground3
    case brandBackgroundTint
    case brandBackgroundDisabled
    case brandForeground1
    case brandForeground1Pressed
    case brandForeground1Selected
    case brandForegroundTint
    case brandForegroundDisabled1
    case brandForegroundDisabled2
    case brandStroke1
    case brandStroke1Pressed
    case brandStroke1Selected

    var equivalentAliasToken: AliasTokens.ColorsTokens {
        switch self {
        case .brandBackground1:
            return .brandBackground1
        case .brandBackground1Pressed:
            return .brandBackground1Pressed
        case .brandBackground1Selected:
            return .brandBackground1Selected
        case .brandBackground2:
            return .brandBackground2
        case .brandBackground2Pressed:
            return .brandBackground2Pressed
        case .brandBackground2Selected:
            return .brandBackground2Selected
        case .brandBackground3:
            return .brandBackground3
        case .brandBackgroundTint:
            return .brandBackgroundTint
        case .brandBackgroundDisabled:
            return .brandBackgroundDisabled
        case .brandForeground1:
            return .brandForeground1
        case .brandForeground1Pressed:
            return .brandForeground1Pressed
        case .brandForeground1Selected:
            return .brandForeground1Selected
        case .brandForegroundTint:
            return .brandForegroundTint
        case .brandForegroundDisabled1:
            return .brandForegroundDisabled1
        case .brandForegroundDisabled2:
            return .brandForegroundDisabled2
        case .brandStroke1:
            return .brandStroke1
        case .brandStroke1Pressed:
            return .brandStroke1Pressed
        case .brandStroke1Selected:
            return .brandStroke1Selected
        }
    }
}

public extension FluentTheme {
    /// Associates a `ColorProvider2` with a given `FluentTheme` instance.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider2` whose colors should be used for controls in this theme.
    ///   - theme: The theme where these colors should be applied.
    @objc static func setProvider(provider: ColorProviding2, for theme: FluentTheme) {
        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider, for: theme)
        brandColors.forEach { token, value in
            theme.aliasTokens.colors[token] = value
        }
    }

    /// Removes any associated `ColorProvider2` from the given `FluentTheme` instance.
    ///
    /// - Parameters:
    ///   - theme: The theme that should have its `ColorProvider2` removed.
    @objc static func removeProvider(for theme: FluentTheme) {
        for brandColor in BrandColorsForOverriding.allCases {
            theme.aliasTokens.colors.removeOverride(brandColor.equivalentAliasToken)
        }
    }
}
