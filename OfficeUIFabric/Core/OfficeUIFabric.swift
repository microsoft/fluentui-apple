//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class OfficeUIFabricFramework: NSObject {
    public static var bundle: Bundle { return Bundle(for: self) }
    public static var resourceBundle: Bundle {
        guard let url = bundle.resourceURL?.appendingPathComponent("OfficeUIFabricResources.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
            fatalError("OfficeUIFabric: resource bundle is not found")
        }
        return bundle
  }

    public static func initializeAppearance() {
        initializeUINavigationBarAppearance(UINavigationBar.appearance())

        // UIToolbar
        let toolbar = UIToolbar.appearance()
        toolbar.isTranslucent = false
        toolbar.barTintColor = MSColors.Toolbar.background
        toolbar.tintColor = MSColors.Toolbar.tint

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        var titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = MSFonts.bodyUnscaled
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        initializeUISwitchAppearance(UISwitch.appearance())
    }

    static func initializeUINavigationBarAppearance(_ navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = MSColors.NavigationBar.background
        navigationBar.tintColor = MSColors.NavigationBar.tint

        var titleAttributes = navigationBar.titleTextAttributes ?? [:]
        titleAttributes[.font] = MSFonts.headlineUnscaled
        titleAttributes[.foregroundColor] = MSColors.NavigationBar.title
        navigationBar.titleTextAttributes = titleAttributes

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-25x25")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage
    }

    static func initializeUISwitchAppearance(_ `switch`: UISwitch) {
        `switch`.onTintColor = MSColors.Switch.onTint
    }
}
