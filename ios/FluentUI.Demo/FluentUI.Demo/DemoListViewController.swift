//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI

class DemoListViewController: UITableViewController {

    static func addDemoListTo(window: UIWindow, pushing viewController: UIViewController?) {
        if let colorProvider = window as? ColorProviding {
            Colors.setProvider(provider: colorProvider, for: window)
            FluentUIFramework.initializeAppearance(with: colorProvider.primaryColor(for: window)!, whenContainedInInstancesOf: [type(of: window)])
        } else {
            FluentUIFramework.initializeAppearance()
        }

        let demoListViewController = DemoListViewController(nibName: nil, bundle: nil)

        let navigationController = UINavigationController(rootViewController: demoListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if let viewController = viewController {
            navigationController.pushViewController(viewController, animated: false)
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
        let titleView = TwoLineTitleView()
        titleView.setup(
            title: FluentUIFramework.bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as! String,
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

        if didAutoLaunch {
            UserDefaults.standard.set(0, forKey: DemoListViewController.lastDemoControllerKey)
        } else {
            let lastDemoController = UserDefaults.standard.integer(forKey: DemoListViewController.lastDemoControllerKey)
            if lastDemoController != 0 {
                tableView(tableView, didSelectRowAt: IndexPath(row: lastDemoController - 1, section: 0))
            }

            didAutoLaunch = true
        }
    }

    // MARK: Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        cell.setup(title: demos[indexPath.row].title, accessoryType: .disclosureIndicator)
        cell.titleNumberOfLinesForLargerDynamicType = 2
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = demos[indexPath.row]
        let demoController = demo.controllerClass.init(nibName: nil, bundle: nil)
        demoController.title = demo.title
        navigationController?.pushViewController(demoController, animated: true)

        UserDefaults.standard.set(indexPath.row + 1, forKey: DemoListViewController.lastDemoControllerKey)
    }

    let cellReuseIdentifier: String = "TableViewCell"
    private var didAutoLaunch: Bool = false
    private static let lastDemoControllerKey: String = "LastDemoController"
}
