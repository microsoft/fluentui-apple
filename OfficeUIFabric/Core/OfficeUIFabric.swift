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
        // UINavigationBar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = MSColors.background
        navigationBar.tintColor = MSColors.primary

        var titleAttributes = navigationBar.titleTextAttributes ?? [:]
        titleAttributes[.font] = MSFonts.headline
        titleAttributes[.foregroundColor] = MSColors.primary
        navigationBar.titleTextAttributes = titleAttributes

        navigationBar.backIndicatorImage = UIImage.staticImageNamed("back-25x25")
        navigationBar.backIndicatorTransitionMaskImage = navigationBar.backIndicatorImage

        // UIToolbar
        let toolbar = UIToolbar.appearance()
        toolbar.isTranslucent = false
        toolbar.barTintColor = MSColors.background
        toolbar.tintColor = MSColors.primary

        // UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        titleAttributes = barButtonItem.titleTextAttributes(for: .normal) ?? [:]
        titleAttributes[.font] = MSFonts.body
        barButtonItem.setTitleTextAttributes(titleAttributes, for: .normal)

        initializeUISwitchAppearance(UISwitch.appearance())
    }

    static func initializeUISwitchAppearance(_ `switch`: UISwitch) {
        `switch`.onTintColor = MSColors.switchOnTint
    }
}
