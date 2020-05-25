//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class FluentUIFramework: NSObject {
    @objc public static var bundle: Bundle { return Bundle(for: self) }
    @objc public static let resourceBundle: Bundle = {
        guard let url = bundle.resourceURL?.appendingPathComponent("FluentUIResources-ios.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
            preconditionFailure("FluentUI resource bundle is not found")
        }
        return bundle
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
        if #available(iOS 12, *) {
            let light = UITraitCollection(userInterfaceStyle: .light)
            let dark = UITraitCollection(userInterfaceStyle: .dark)
            let navigationBarLightAppearance = containerTypes != nil ? UINavigationBar.appearance(for: light, whenContainedInInstancesOf: containerTypes!) : UINavigationBar.appearance(for: light)
            let navigationBarDarkAppearance = containerTypes != nil ? UINavigationBar.appearance(for: dark, whenContainedInInstancesOf: containerTypes!) : UINavigationBar.appearance(for: dark)
            initializeUINavigationBarAppearance(navigationBarLightAppearance, traits: light)
            initializeUINavigationBarAppearance(navigationBarDarkAppearance, traits: dark)
        }

        // UIToolbar
        let toolbar = UIToolbar.appearance()
        toolbar.isTranslucent = false
        toolbar.barTintColor = Colors.Toolbar.background
        toolbar.tintColor = Colors.Toolbar.tint

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        var titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = Fonts.bodyUnscaled
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        let switchAppearance = containerTypes != nil ? UISwitch.appearance(whenContainedInInstancesOf: containerTypes!) : UISwitch.appearance()
        switchAppearance.onTintColor = primaryColor

        let progressViewAppearance = containerTypes != nil ? UIProgressView.appearance(whenContainedInInstancesOf: containerTypes!) : UIProgressView.appearance()
        progressViewAppearance.progressTintColor = primaryColor
        progressViewAppearance.trackTintColor = Colors.Progress.trackTint
    }

    static func initializeUINavigationBarAppearance(_ navigationBar: UINavigationBar, traits: UITraitCollection? = nil) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Colors.NavigationBar.background
        navigationBar.tintColor = Colors.NavigationBar.tint
        if #available(iOS 12, *) {
            let traits = traits ?? navigationBar.traitCollection
            // Removing built-in shadow for Dark Mode
            navigationBar.shadowImage = traits.userInterfaceStyle == .dark ? UIImage() : nil
        }

        var titleAttributes = navigationBar.titleTextAttributes ?? [:]
        titleAttributes[.font] = Fonts.headlineUnscaled
        titleAttributes[.foregroundColor] = Colors.NavigationBar.title
        navigationBar.titleTextAttributes = titleAttributes

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-24x24")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage
    }

}
