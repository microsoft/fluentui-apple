//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    weak var windowScene: UIWindowScene?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
        window = UIWindow.init(frame: UIScreen.main.bounds)
        DemoListViewController.init().addDemoListTo(window: window!)
        window?.windowScene = windowScene
    }
}
