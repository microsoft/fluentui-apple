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

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = TableViewCell.tableBackgroundGroupedColor
        tableView.separatorStyle = .none

        configureAppearancePopover()
    }

    func showMessage(_ message: String, autoDismiss: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        present(alert, animated: true)

        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: completion)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }
    }

    // MARK: - Demo Appearance Popover

    func configureAppearancePopover() {
        // Display the DemoAppearancePopover button
        let settingsButton = UIBarButtonItem(image: UIImage(named: "ic_fluent_settings_24_regular"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showAppearancePopover))
        let readmeButton = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(showReadmePopover))
        navigationItem.rightBarButtonItems = [readmeButton, settingsButton]
    }

    @objc func showAppearancePopover(_ sender: UIBarButtonItem) {
        appearanceController.popoverPresentationController?.barButtonItem = sender
        appearanceController.popoverPresentationController?.delegate = self
        self.present(appearanceController, animated: true, completion: nil)
    }

    @objc func showReadmePopover(_ sender: UIBarButtonItem) {
        readmeViewController.popoverPresentationController?.barButtonItem = sender
        readmeViewController.popoverPresentationController?.delegate = self
        self.present(readmeViewController, animated: true, completion: nil)
    }

    var readmeString: String?

    private lazy var appearanceController: DemoAppearanceController = .init(delegate: self as? DemoAppearanceDelegate)
    private lazy var readmeViewController: ReadmeViewController = .init(readmeString: readmeString)
}

extension DemoTableViewController: UIPopoverPresentationControllerDelegate {
    /// Overridden to allow for popover-style modal presentation on compact (e.g. iPhone) devices.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
