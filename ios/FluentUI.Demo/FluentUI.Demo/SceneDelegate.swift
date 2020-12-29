//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, ColorThemeHosting {
    var window: UIWindow?
    var colorProvider = DemoColorThemeGreenWindow()

    weak var windowScene: UIWindowScene?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
        updateToWindowWith(type: DemoColorThemeDefaultWindow.self, pushing: nil)
    }

    func updateToWindowWith(type: UIWindow.Type, pushing viewController: UIViewController?) {
        let newWindow = type.init(windowScene: windowScene!)
        DemoListViewController.addDemoListTo(window: newWindow, pushing: viewController)
        window = newWindow

        Colors.setProvider(provider: colorProvider, for: window!)
    }
}
