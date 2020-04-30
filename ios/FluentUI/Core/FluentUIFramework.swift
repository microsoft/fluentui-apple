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

    @objc public static func initializeAppearance() {
        initializeUINavigationBarAppearance(UINavigationBar.appearance())
        if #available(iOS 12, *) {
            let light = UITraitCollection(userInterfaceStyle: .light)
            let dark = UITraitCollection(userInterfaceStyle: .dark)
            initializeUINavigationBarAppearance(UINavigationBar.appearance(for: light), traits: light)
            initializeUINavigationBarAppearance(UINavigationBar.appearance(for: dark), traits: dark)
        }

        // UIToolbar
        let toolbar = UIToolbar.appearance()
        toolbar.isTranslucent = false
        toolbar.barTintColor = Colors.Toolbar.background
        toolbar.tintColor = Colors.Toolbar.tint

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        var titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = MSFonts.bodyUnscaled
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        initializeUISwitchAppearance(UISwitch.appearance())

        initializeUIProgressViewAppearance(UIProgressView.appearance())
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
        titleAttributes[.font] = MSFonts.headlineUnscaled
        titleAttributes[.foregroundColor] = Colors.NavigationBar.title
        navigationBar.titleTextAttributes = titleAttributes

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-24x24")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage
    }

    static func initializeUISwitchAppearance(_ `switch`: UISwitch) {
        `switch`.onTintColor = Colors.Switch.onTint
    }

    static func initializeUIProgressViewAppearance(_ progressView: UIProgressView) {
        progressView.progressTintColor = Colors.Progress.progressTint
        progressView.trackTintColor = Colors.Progress.trackTint
    }
}
