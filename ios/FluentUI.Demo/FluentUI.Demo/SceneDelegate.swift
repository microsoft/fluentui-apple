//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let window = UIWindow.init(frame: UIScreen.main.bounds)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        DemoListViewController.init(nibName: nil, bundle: nil).addDemoListTo(window: self.window)
        self.window.windowScene = scene as? UIWindowScene
    }
}
