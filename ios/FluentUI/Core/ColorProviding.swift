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
    @objc optional var brandGradient1: UIColor { get }
    @objc optional var brandGradient2: UIColor { get }
    @objc optional var brandGradient3: UIColor { get }
}

private func brandColorOverrides(provider: ColorProviding) -> [FluentTheme.ColorToken: UIColor] {
    var brandColors: [FluentTheme.ColorToken: UIColor] = [:]

    brandColors[.brandBackground1] = provider.brandBackground1
    brandColors[.brandBackground1Pressed] = provider.brandBackground1Pressed
    brandColors[.brandBackground1Selected] = provider.brandBackground1Selected
    brandColors[.brandBackground2] = provider.brandBackground2
    brandColors[.brandBackground2Pressed] = provider.brandBackground2Pressed
    brandColors[.brandBackground2Selected] = provider.brandBackground2Selected
    brandColors[.brandBackground3] = provider.brandBackground3
    brandColors[.brandBackgroundTint] = provider.brandBackgroundTint
    brandColors[.brandBackgroundDisabled] = provider.brandBackgroundDisabled
    brandColors[.brandForeground1] = provider.brandForeground1
    brandColors[.brandForeground1Pressed] = provider.brandForeground1Pressed
    brandColors[.brandForeground1Selected] = provider.brandForeground1Selected
    brandColors[.brandForegroundTint] = provider.brandForegroundTint
    brandColors[.brandForegroundDisabled1] = provider.brandForegroundDisabled1
    brandColors[.brandForegroundDisabled2] = provider.brandForegroundDisabled2
    brandColors[.brandStroke1] = provider.brandStroke1
    brandColors[.brandStroke1Pressed] = provider.brandStroke1Pressed
    brandColors[.brandStroke1Selected] = provider.brandStroke1Selected

    if let brandGradient1 = provider.brandGradient1 {
        brandColors[.brandGradient1] = brandGradient1
    }

    if let brandGradient2 = provider.brandGradient2 {
        brandColors[.brandGradient2] = brandGradient2
    }

    if let brandGradient3 = provider.brandGradient3 {
        brandColors[.brandGradient3] = brandGradient3
    }

#if os(visionOS)
    // Remove the dark values from all our brand colors on visionOS.
    // We only want the light variants.
    brandColors = brandColors.mapValues({ $0.light })
#endif

    return brandColors
}

// MARK: Colors

@objc public extension UIView {
    /// Associates a `ColorProvider` with a given `UIView`.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider` whose colors should be used for controls in this theme.
    @objc(setColorProvider:)
    func setColorProvider(_ provider: ColorProviding) {
        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider)
        let fluentTheme = FluentTheme(colorOverrides: brandColors)
        self.fluentTheme = fluentTheme
    }
}

@objc public extension FluentTheme {
    /// Associates a `ColorProvider` with the default shared `FluentTheme` instance.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider` whose colors should be used for controls in `FluentTheme.shared`. Passing `nil` will reset to the default theme.
    @objc static func setSharedThemeColorProvider(_ provider: ColorProviding?) {
        if let provider {
            let brandColors = brandColorOverrides(provider: provider)
            FluentTheme.shared = FluentTheme(colorOverrides: brandColors)
        } else {
            FluentTheme.shared = .init()
        }
    }
}
