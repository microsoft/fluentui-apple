//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DemoListViewController: DemoTableViewController {
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
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.toolbar.isTranslucent = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func updateColorProviderFor(window: UIWindow, theme: DemoColorTheme) {
        self.theme = theme
        if let provider = self.provider {
            window.setColorProvider(provider)
            let aliasTokens = self.view.fluentTheme.aliasTokens
            let primaryColor = UIColor(dynamicColor: aliasTokens.colors[.brandBackground1])
            FluentUIFramework.initializeAppearance(with: primaryColor, whenContainedInInstancesOf: [type(of: window)])
        } else {
            FluentUIFramework.initializeAppearance(with: UIColor(light: UIColor(colorValue: GlobalTokens.brandColors(.comm80)), dark: UIColor(colorValue: GlobalTokens.brandColors(.comm90))))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // App title comes from the app, but we want to display the version number from the resource bundle.
        let bundle = Bundle(for: type(of: self))
        guard let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            preconditionFailure("CFBundleName is nil")
        }
        guard let libraryVersion = FluentUIFramework.resourceBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            preconditionFailure("CFBundleShortVersionString is nil")
        }
        navigationItem.title = appName
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: libraryVersion)

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

        if demo.title.compare("TableViewCell", options: .caseInsensitive) == .orderedSame {
            let insetGroupedType = UIAction(title: "insetGrouped") { _ in
                self.showGroupedTableViewCellStyle = true
            }
            let plainType = UIAction(title: "plain") { _ in
                self.showGroupedTableViewCellStyle = false
            }
            cellTypeButton.menu = UIMenu(title: "Type", children: [insetGroupedType, plainType])
            cellTypeButton.showsMenuAsPrimaryAction = true
            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 60, height: 28))
            stackView.addArrangedSubview(cellTypeButton)
            cell.setup(title: demo.title, customAccessoryView: stackView)
        } else {
            cell.setup(title: demo.title, accessoryType: .disclosureIndicator)
        }
        cell.titleNumberOfLinesForLargerDynamicType = 2
        cell.backgroundStyleType = .grouped

        if indexPath.row == DemoControllerSection.allCases[indexPath.section].rows.count - 1 {
            cell.bottomSeparatorType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = DemoControllerSection.allCases[indexPath.section].rows[indexPath.row]
        let demoController: UIViewController
        if demo.title.compare("TableViewCell", options: .caseInsensitive) == .orderedSame {
            // .grouped is used for plain type so that the headerfooterview will scroll with the rest of the plain style cells
            demoController = TableViewCellDemoController.init(style: showGroupedTableViewCellStyle ? .insetGrouped : .plain)
        } else {
            demoController = demo.controllerClass.init(nibName: nil, bundle: nil)
        }
        demoController.title = demo.title
        navigationController?.pushViewController(demoController, animated: true)

        UserDefaults.standard.set(demo.title, forKey: DemoListViewController.lastDemoControllerKey)
    }

    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    let cellReuseIdentifier: String = "TableViewCell"
    private static var isFirstLaunch: Bool = true
    private static let lastDemoControllerKey: String = "LastDemoController"
    private let cellTypeButton: UIButton = {
        let button = MSFButtonLegacy()
        button.setTitle("Type", for: .normal)
        return button
    }()
    private var showGroupedTableViewCellStyle: Bool = true
    private var provider: ColorProviding? = DemoColorTheme.default.provider

    private enum DemoControllerSection: CaseIterable {
        case fluent2Controls
        case fluent2DesignTokens
        case controls
#if DEBUG
        case debug
#endif

        var title: String {
            switch self {
            case .fluent2Controls:
                return "Fluent 2 Controls"
            case .fluent2DesignTokens:
                return "Fluent 2 Design Tokens"
            case .controls:
                return "Controls"
#if DEBUG
            case .debug:
                return "DEBUG"
#endif
            }
        }

        var rows: [DemoDescriptor] {
            switch self {
            case .fluent2Controls:
                return Demos.fluent2
            case .fluent2DesignTokens:
                return Demos.fluent2DesignTokens
            case .controls:
                return Demos.controls
#if DEBUG
            case .debug:
                return Demos.debug
#endif
            }
        }
    }
}
