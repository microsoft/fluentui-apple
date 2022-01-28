//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class DemoTableViewController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Colors.tableBackgroundGrouped
        tableView.separatorStyle = .none
    }

    // MARK: - Demo Appearance Popover

    func configureAppearancePopover(onThemeWideOverrideChanged: @escaping ((_ themeWideOverrideEnabled: Bool) -> Void),
                                    onPerControlOverrideChanged: @escaping ((_ perControlOverrideEnabled: Bool) -> Void)) {

        // Store the callbacks from the individual demo controller
        appearanceController.setupPerDemoCallbacks(onThemeWideOverrideChanged: onThemeWideOverrideChanged,
                                                   onPerControlOverrideChanged: onPerControlOverrideChanged)

        // Display the DemoAppearancePopover button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_fluent_settings_24_regular"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showAppearancePopover))
    }

    @objc func showAppearancePopover(_ sender: UIBarButtonItem) {
        appearanceController.modalPresentationStyle = .popover
        appearanceController.preferredContentSize.height = 375
        appearanceController.popoverPresentationController?.barButtonItem = sender
        appearanceController.popoverPresentationController?.delegate = self
        appearanceController.popoverPresentationController?.permittedArrowDirections = .up
        self.present(appearanceController, animated: true, completion: nil)
    }

    private lazy var appearanceController: DemoAppearanceController = DemoAppearanceController()
}

extension DemoTableViewController: UIPopoverPresentationControllerDelegate {
    /// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
