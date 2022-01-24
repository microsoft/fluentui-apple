//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI
import SwiftUI

class DemoAppearanceController: UIHostingController<DemoAppearanceView> {
    init() {
        let callbacks = DemoAppearanceView.Callbacks()
        self.callbacks = callbacks

        super.init(rootView: DemoAppearanceView(callbacks: callbacks))
        self.setupCallbacks()
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Ensure that the enclosed SwiftUI view always has the latest up-to-date info.
        self.rootView = DemoAppearanceView(callbacks: callbacks)
                    .theme(currentDemoListViewController?.theme ?? .default)
    }

    var currentDemoListViewController: DemoListViewController? {
        guard let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController,
              let currentDemoListViewController = navigationController.viewControllers.first as? DemoListViewController else {
                  return nil
              }
        return currentDemoListViewController
    }

    func setupCallbacks() {
        callbacks.onColorSchemeChanged = { [weak self] colorScheme in
            guard let window = self?.view.window else {
                return
            }
            let userInterfaceStyle: UIUserInterfaceStyle
            switch colorScheme {
            case .light:
                userInterfaceStyle = .light
            case .dark:
                userInterfaceStyle = .dark
            @unknown default:
                preconditionFailure("Unknown color scheme: \(colorScheme)")
            }
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }

        callbacks.onThemeChanged = { [weak self] theme in
            guard let currentDemoListViewController = self?.currentDemoListViewController,
                  let window = self?.view.window else {
                return
            }
            currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)
        }
    }

    func setupPerDemoCallbacks(onThemeWideOverrideChanged: @escaping ((Bool) -> Void),
                               onPerControlOverrideChanged: @escaping ((Bool) -> Void)) {
        // Passed back to caller
        callbacks.onThemeWideOverrideChanged = onThemeWideOverrideChanged
        callbacks.onPerControlOverrideChanged = onPerControlOverrideChanged
    }

    private var callbacks: DemoAppearanceView.Callbacks
}
