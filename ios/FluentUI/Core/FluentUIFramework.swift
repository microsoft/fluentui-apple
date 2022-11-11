//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Note: SWIFT_PACKAGE is automatically defined whenever the code is being built by the Swift Package Manager.
#if SWIFT_PACKAGE
import FluentUIResources
#endif
import UIKit

// MARK: Colors

public extension Colors {
    internal struct Progress {
        static var trackTint = UIColor(light: surfaceQuaternary, dark: surfaceTertiary)
    }

    internal struct NavigationBar {
        static var background = UIColor(light: surfacePrimary, dark: gray900)
        static var tint: UIColor = iconPrimary
        static var title: UIColor = textDominant
    }

    internal struct Toolbar {
        static var background: UIColor = NavigationBar.background
        static var tint: UIColor = NavigationBar.tint
    }

    // Objective-C support
    @objc static var navigationBarBackground: UIColor { return NavigationBar.background }
}

// MARK: - FluentUIFramework

public class FluentUIFramework: NSObject {
    @objc public static let resourceBundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        guard let url = bundle.resourceURL?.appendingPathComponent("FluentUIResources-ios.bundle", isDirectory: true),
              let bundle = Bundle(url: url) else {
            preconditionFailure("FluentUI resource bundle is not found")
        }
        return bundle
        #endif
    }()
    @objc public static let colorsBundle: Bundle = {
        #if SWIFT_PACKAGE
        return SharedResources.colorsBundle
        #else
        return resourceBundle
        #endif
    }()

    @available(*, deprecated, message: "Non-fluent icons no longer supported. Setting this var no longer has any effect and it will be removed in a future update.")
    @objc public static var usesFluentIcons: Bool = true

    @available(*, deprecated, renamed: "initializeAppearance(with:whenContainedInInstancesOf:)")
    @objc public static func initializeAppearance() {
        initializeAppearance(with: Colors.primary)
    }

    @objc public static func initializeAppearance(with primaryColor: UIColor, whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type]? = nil) {
        let navigationBarAppearance = containerTypes != nil ? UINavigationBar.appearance(whenContainedInInstancesOf: containerTypes!) : UINavigationBar.appearance()
        initializeUINavigationBarAppearance(navigationBarAppearance)
        let light = UITraitCollection(userInterfaceStyle: .light)
        let dark = UITraitCollection(userInterfaceStyle: .dark)
        let navigationBarLightAppearance = containerTypes != nil ? UINavigationBar.appearance(for: light, whenContainedInInstancesOf: containerTypes!) : UINavigationBar.appearance(for: light)
        let navigationBarDarkAppearance = containerTypes != nil ? UINavigationBar.appearance(for: dark, whenContainedInInstancesOf: containerTypes!) : UINavigationBar.appearance(for: dark)
        initializeUINavigationBarAppearance(navigationBarLightAppearance, traits: light)
        initializeUINavigationBarAppearance(navigationBarDarkAppearance, traits: dark)

        // UIToolbar
        let toolbar = UIToolbar.appearance()
        toolbar.isTranslucent = false
        toolbar.barTintColor = Colors.Toolbar.background
        toolbar.tintColor = Colors.Toolbar.tint

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        var titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = Fonts.body
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        let switchAppearance = containerTypes != nil ? UISwitch.appearance(whenContainedInInstancesOf: containerTypes!) : UISwitch.appearance()
        switchAppearance.onTintColor = primaryColor

        let progressViewAppearance = containerTypes != nil ? UIProgressView.appearance(whenContainedInInstancesOf: containerTypes!) : UIProgressView.appearance()
        progressViewAppearance.progressTintColor = primaryColor
        progressViewAppearance.trackTintColor = Colors.Progress.trackTint
    }

    static func initializeUINavigationBarAppearance(_ navigationBar: UINavigationBar, traits: UITraitCollection? = nil) {
        navigationBar.isTranslucent = false

        let standardAppearance = navigationBar.standardAppearance
        navigationBar.tintColor = Colors.NavigationBar.tint

        navigationBar.standardAppearance.backgroundColor = Colors.NavigationBar.background

        let traits = traits ?? navigationBar.traitCollection
        // Removing built-in shadow for Dark Mode
        navigationBar.shadowImage = traits.userInterfaceStyle == .dark ? UIImage() : nil

        var titleAttributes = standardAppearance.titleTextAttributes
        titleAttributes[.font] = Fonts.headline
        titleAttributes[.foregroundColor] = Colors.NavigationBar.title
        standardAppearance.titleTextAttributes = titleAttributes

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-24x24")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage

        // Update the scroll edge appearance to match the new standard appearance
        navigationBar.scrollEdgeAppearance = standardAppearance
    }

    private static var bundle: Bundle { return Bundle(for: self) }
}
