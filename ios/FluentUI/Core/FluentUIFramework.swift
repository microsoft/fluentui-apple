//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
        return resourceBundle
    }()

    @available(*, deprecated, message: "Non-fluent icons no longer supported. Setting this var no longer has any effect and it will be removed in a future update.")
    @objc public static var usesFluentIcons: Bool = true

    @available(*, deprecated, renamed: "initializeAppearance(with:whenContainedInInstancesOf:)")
    @objc public static func initializeAppearance() {
        let primaryColor = FluentTheme.shared.color(.brandBackground1)
        initializeAppearance(with: primaryColor)
    }

    enum NavigationBarStyle {
        case normal
        case dateTimePicker

        func backgroundColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .normal:
                return fluentTheme.color(.background3)
            case .dateTimePicker:
                return UIColor(light: fluentTheme.color(.background2).light,
                               dark: fluentTheme.color(.background2).dark)
            }
        }
    }

    @objc public static func initializeAppearance(with primaryColor: UIColor, whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type]? = nil) {
        initializeAppearance(with: primaryColor, whenContainedInInstancesOf: containerTypes, fluentTheme: nil)
    }

    @objc public static func initializeAppearance(with primaryColor: UIColor, whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type]? = nil, fluentTheme: FluentTheme? = nil) {
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

        let fluentTheme = fluentTheme ?? FluentTheme.shared

        toolbar.barTintColor = fluentTheme.color(.background3)
        toolbar.tintColor = fluentTheme.color(.foreground3)

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        var titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = fluentTheme.typography(.body1)
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        let switchAppearance = containerTypes != nil ? UISwitch.appearance(whenContainedInInstancesOf: containerTypes!) : UISwitch.appearance()
        switchAppearance.onTintColor = primaryColor

        let progressViewAppearance = containerTypes != nil ? UIProgressView.appearance(whenContainedInInstancesOf: containerTypes!) : UIProgressView.appearance()
        progressViewAppearance.progressTintColor = primaryColor
        progressViewAppearance.trackTintColor = fluentTheme.color(.stroke1)
    }

    static func initializeUINavigationBarAppearance(_ navigationBar: UINavigationBar, traits: UITraitCollection? = nil, navigationBarStyle: NavigationBarStyle = .normal, fluentTheme: FluentTheme? = nil) {
        navigationBar.isTranslucent = false

        let standardAppearance = navigationBar.standardAppearance

        let fluentTheme = fluentTheme ?? FluentTheme.shared
        navigationBar.standardAppearance.backgroundColor = navigationBarStyle.backgroundColor(fluentTheme: fluentTheme)

        navigationBar.tintColor = fluentTheme.color(.foreground2)

        let traits = traits ?? navigationBar.traitCollection
        // Removing built-in shadow for Dark Mode
        navigationBar.shadowImage = traits.userInterfaceStyle == .dark ? UIImage() : nil

        var titleAttributes = standardAppearance.titleTextAttributes
        titleAttributes[.font] = fluentTheme.typography(.body1Strong)
        titleAttributes[.foregroundColor] = fluentTheme.color(.foreground1)

        standardAppearance.titleTextAttributes = titleAttributes

        if navigationBarStyle == .dateTimePicker {
            standardAppearance.shadowColor = .clear
        }

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-24x24")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage

        // Update the scroll edge appearance to match the new standard appearance
        navigationBar.scrollEdgeAppearance = standardAppearance
    }

    private static var bundle: Bundle { return Bundle(for: self) }
}
