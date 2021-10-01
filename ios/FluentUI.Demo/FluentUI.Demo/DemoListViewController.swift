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

        let demoListViewController = DemoListViewController(nibName: nil, bundle: nil)

        let navigationController = UINavigationController(rootViewController: demoListViewController)
        navigationController.navigationBar.isTranslucent = true

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

    let demos: [(title: String, controllerClass: UIViewController.Type)] = FluentUI_Demo.demos.filter { demo in
#if DEBUG
        return true
#else
        return !demo.title.hasPrefix("DEBUG")
#endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let title = FluentUIFramework.bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as? String else {
            return assertionFailure("CFBundleExecutable is nil")
        }
        let titleView = TwoLineTitleView()
        titleView.setup(
            title: title,
            subtitle: FluentUIFramework.bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        )
        navigationItem.titleView = titleView
        // Fluent UI design recommends not showing "Back" title. However, VoiceOver still correctly says "Back" even if the title is hidden.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        tableView.backgroundColor = Colors.Table.background
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if DemoListViewController.isFirstLaunch {
            if let lastDemoController = UserDefaults.standard.string(forKey: DemoListViewController.lastDemoControllerKey),
                let index = demos.firstIndex(where: { $0.title == lastDemoController }) {
                tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
            }

            DemoListViewController.isFirstLaunch = false
        } else {
            UserDefaults.standard.set(nil, forKey: DemoListViewController.lastDemoControllerKey)
        }
    }

    // MARK: Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.setup(title: demos[indexPath.row].title, accessoryType: .disclosureIndicator)
        cell.titleNumberOfLinesForLargerDynamicType = 2
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[indexPath.row]
        let demoController = demo.controllerClass.init(nibName: nil, bundle: nil)
        demoController.title = demo.title
        navigationController?.pushViewController(demoController, animated: true)

        UserDefaults.standard.set(demo.title, forKey: DemoListViewController.lastDemoControllerKey)
    }

    let cellReuseIdentifier: String = "TableViewCell"
    private static var isFirstLaunch: Bool = true
    private static let lastDemoControllerKey: String = "LastDemoController"
}
