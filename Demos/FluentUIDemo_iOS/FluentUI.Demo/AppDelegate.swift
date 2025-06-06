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
import SwiftUI
import UIKit

#if DOGFOOD
// Provide App Center secret here and in the target settings: APPCENTER_SECRET user-defined setting
private let appCenterSecret = app_center_secret_to_be_supplied_before_building
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: UIApplicationDelegate

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        for _ in 0..<100000 {
            print("queueing")
            DispatchQueue.global(qos: .background).async {
                let color = FluentTheme.shared.color(.background1)

//                let colorHex = Color(hexValue: 0xFF0000)
//                let color = UIColor(colorHex)
                print(color)
            }
        }

        #if DOGFOOD
        AppCenter.start(withAppSecret: appCenterSecret, services: [
            Analytics.self,
            Crashes.self,
            Distribute.self
        ])
        #endif

        return true
    }
}
