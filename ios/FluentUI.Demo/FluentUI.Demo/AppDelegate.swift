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
import FluentUI
import UIKit

#if DOGFOOD
// Provide App Center secret here and in the target settings: APPCENTER_SECRET user-defined setting
private let appCenterSecret = app_center_secret_to_be_supplied_before_building
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate, ColorThemeHosting {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if #available(iOS 13, *) {
			// Configured in Scene Delegate
		} else {
			updateToWindowWith(type: DemoColorThemeDefaultWindow.self, pushing: nil)
		}

		#if DOGFOOD
        MSAppCenter.start(appCenterSecret, withServices: [
            MSAnalytics.self,
            MSCrashes.self,
            MSDistribute.self
        ])
        #endif

        return true
    }

	func updateToWindowWith(type: UIWindow.Type, pushing viewController: UIViewController?) {
		let newWindow = type.init(frame: UIScreen.main.bounds)
		Self.addDemoListTo(window: newWindow, pushing: viewController)
		window = newWindow
	}

	static func addDemoListTo(window: UIWindow, pushing viewController: UIViewController?) {
		let demoListViewController = DemoListViewController(nibName: nil, bundle: nil)
		let navigationController = UINavigationController(rootViewController: demoListViewController)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		if let colorProvider = window as? ColorProviding {
			Colors.setProvider(provider: colorProvider, for: window)
			FluentUIFramework.initializeAppearance(with: colorProvider.primaryColor(for: window)!, whenContainedInInstancesOf: [type(of: window)])
		}

		if let viewController = viewController {
			navigationController.pushViewController(viewController, animated: false)

		}
	}

}
