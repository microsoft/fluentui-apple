//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DemoListViewController: UITableViewController {

    private var provider: ColorProviding? = DemoColorTheme.default.provider
    public var theme: DemoColorTheme = DemoColorTheme.default {
        didSet {
            provider = theme.provider
        }
    }

    func addDemoListTo(window: UIWindow) {
        updateColorProviderFor(window: window, theme: self.theme)

        let demoListViewController = DemoListViewController(style: .insetGrouped)

        let navigationController = UINavigationController(rootViewController: demoListViewController)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.prefersLargeTitles = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func updateColorProviderFor(window: UIWindow, theme: DemoColorTheme) {
        self.theme = theme
        if let provider = self.provider, let primaryColor = provider.primaryColor(for: window) {
            Colors.setProvider(provider: provider, for: window)
            FluentUIFramework.initializeAppearance(with: primaryColor, whenContainedInInstancesOf: [type(of: window)])
        } else {
            FluentUIFramework.initializeAppearance(with: Colors.primary(for: window))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let title = FluentUIFramework.bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as? String else {
            return assertionFailure("CFBundleExecutable is nil")
        }
        let subtitle = FluentUIFramework.bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        navigationItem.title = title
        navigationItem.largeTitleDisplayMode = .always

        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: subtitle)
        } else {
            // Fluent UI design recommends not showing "Back" title. However, VoiceOver still correctly says "Back" even if the title is hidden.
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: subtitle, style: .plain, target: nil, action: nil)
        }

        tableView.backgroundColor = Colors.Table.backgroundGrouped

        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if DemoListViewController.isFirstLaunch {
            if let lastDemoController = UserDefaults.standard.string(forKey: DemoListViewController.lastDemoControllerKey) {
                for (sectionIndex, section) in DemoControllerSection.allCases.enumerated() {
                    if let index = section.rows.firstIndex(where: { $0.title == lastDemoController }) {
                        tableView(tableView, didSelectRowAt: IndexPath(row: index, section: sectionIndex))
                        break
                    }
                }
            }

            DemoListViewController.isFirstLaunch = false
        } else {
            UserDefaults.standard.set(nil, forKey: DemoListViewController.lastDemoControllerKey)
        }
    }

    // MARK: Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DemoControllerSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DemoControllerSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoControllerSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let demo = DemoControllerSection.allCases[indexPath.section].rows[indexPath.row]
        cell.setup(title: demo.title, accessoryType: .disclosureIndicator)
        cell.titleNumberOfLinesForLargerDynamicType = 2
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = DemoControllerSection.allCases[indexPath.section].rows[indexPath.row]
        let demoController = demo.controllerClass.init(nibName: nil, bundle: nil)
        demoController.title = demo.title
        navigationController?.pushViewController(demoController, animated: true)

        UserDefaults.standard.set(demo.title, forKey: DemoListViewController.lastDemoControllerKey)
    }

    let cellReuseIdentifier: String = "TableViewCell"
    private static var isFirstLaunch: Bool = true
    private static let lastDemoControllerKey: String = "LastDemoController"

    private enum DemoControllerSection: CaseIterable {
        case vNext
        case legacy

        var title: String {
            switch self {
            case .vNext:
                return "vNext"
            case .legacy:
                return "Legacy"
            }
        }

        var rows: [DemoDescriptor] {
            switch self {
            case .vNext:
                return Demos.vNext
            case .legacy:
                return Demos.legacy
            }
        }
    }
}
