//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if DOGFOOD
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterDistribute
#endif
import OfficeUIFabric
import UIKit

#if DOGFOOD
// Provide App Center secret here and in the target settings: APPCENTER_SECRET user-defined setting
private let appCenterSecret = app_center_secret_to_be_supplied_before_building
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OfficeUIFabricFramework.usesFluentIcons = true
        OfficeUIFabricFramework.initializeAppearance()

        let splitViewController = window!.rootViewController as! UISplitViewController
        let masterContainer = splitViewController.viewControllers.first as! UINavigationController
        let masterController = masterContainer.topViewController as! MasterViewController
        let detailContainer = splitViewController.viewControllers.last as! UINavigationController
        let detailController = detailContainer.topViewController!

        masterController.demoPlaceholder = detailController
        detailController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self

        #if DOGFOOD
        MSAppCenter.start(appCenterSecret, withServices: [
            MSAnalytics.self,
            MSCrashes.self,
            MSDistribute.self
        ])
        #endif

        return true
    }

    // MARK: Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true to indicate that we don't care about DetailViewController - it will be removed
        return (secondaryViewController as? UINavigationController)?.topViewController is DetailViewController
    }
}
