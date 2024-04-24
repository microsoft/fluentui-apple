//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

/// A specialized subclass of `FluentThemedHostingController` that can be used for SwiftUI demo screens.
class DemoHostingController: FluentThemedHostingController {
    init(rootView: AnyView, title: String, readmeText: String? = nil) {
        super.init(rootView: rootView)
        self.title = title
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        super.init(rootView: rootView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearanceAndReadmePopovers()
    }

    // MARK: - Demo Appearance Popover

    func configureAppearanceAndReadmePopovers() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "ic_fluent_settings_24_regular"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showAppearancePopover(_:)))
        navigationItem.rightBarButtonItems = [settingsButton]
        let readmeButton = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(showReadmePopover))
        navigationItem.rightBarButtonItems = [readmeButton, settingsButton]
    }

    @objc func showReadmePopover(_ sender: UIBarButtonItem) {
        readmeViewController.popoverPresentationController?.barButtonItem = sender
        readmeViewController.popoverPresentationController?.delegate = self
        self.present(readmeViewController, animated: true, completion: nil)
    }

    @objc func showAppearancePopover(_ sender: AnyObject, presenter: UIViewController) {
        if let barButtonItem = sender as? UIBarButtonItem {
            appearanceController.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let sourceView = sender as? UIView {
            appearanceController.popoverPresentationController?.sourceView = sourceView
            appearanceController.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        appearanceController.popoverPresentationController?.delegate = self
        presenter.present(appearanceController, animated: true, completion: nil)
    }

    @objc func showAppearancePopover(_ sender: AnyObject) {
        showAppearancePopover(sender, presenter: self)
    }

    private var readmeText: String?

    private lazy var appearanceController: DemoAppearanceController = .init(delegate: self as? DemoAppearanceDelegate)
    private lazy var readmeViewController: ReadmeViewController = .init(readmeString: readmeText)
}

extension DemoHostingController: UIPopoverPresentationControllerDelegate {
    /// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
