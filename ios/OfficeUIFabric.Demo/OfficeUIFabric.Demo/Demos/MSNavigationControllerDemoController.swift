//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSNavigationControllerDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Large Title with Primary style")
        container.addArrangedSubview(createButton(title: "Show without accessory", action: #selector(showLargeTitle)))
        container.addArrangedSubview(createButton(title: "Show with collapsible search bar", action: #selector(showLargeTitleWithShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show with fixed search bar", action: #selector(showLargeTitleWithFixedAccessory)))

        addTitle(text: "Large Title with System style")
        container.addArrangedSubview(createButton(title: "Show without accessory", action: #selector(showLargeTitleWithSystemStyle)))
        container.addArrangedSubview(createButton(title: "Show without accessory and shadow", action: #selector(showLargeTitleWithSystemStyleAndNoShadow)))
        container.addArrangedSubview(createButton(title: "Show with collapsible search bar", action: #selector(showLargeTitleWithSystemStyleAndShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show with fixed search bar", action: #selector(showLargeTitleWithSystemStyleAndFixedAccessory)))

        addTitle(text: "Regular Title")
        container.addArrangedSubview(createButton(title: "Show \"system\" with collapsible search bar", action: #selector(showRegularTitleWithShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show \"primary\" with fixed search bar", action: #selector(showRegularTitleWithFixedAccessory)))

        addTitle(text: "Size Customization")
        container.addArrangedSubview(createButton(title: "Show with expanded avatar, contracted title", action: #selector(showLargeTitleWithCustomizedElementSizes)))
    }

    @objc func showLargeTitle() {
        presentController(withLargeTitle: true)
    }

    @objc func showLargeTitleWithShyAccessory() {
        presentController(withLargeTitle: true, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: true)
    }

    @objc func showLargeTitleWithFixedAccessory() {
        presentController(withLargeTitle: true, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: false)
    }

    @objc func showLargeTitleWithSystemStyle() {
        presentController(withLargeTitle: true, style: .system)
    }

    @objc func showLargeTitleWithSystemStyleAndNoShadow() {
        presentController(withLargeTitle: true, style: .system, contractNavigationBarOnScroll: false, showShadow: false)
    }

    @objc func showLargeTitleWithSystemStyleAndShyAccessory() {
        presentController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: true)
    }

    @objc func showLargeTitleWithSystemStyleAndFixedAccessory() {
        presentController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: false)
    }

    @objc func showRegularTitleWithShyAccessory() {
        presentController(withLargeTitle: false, style: .system, accessoryView: createAccessoryView(with: .darkContent), contractNavigationBarOnScroll: true)
    }

    @objc func showRegularTitleWithFixedAccessory() {
        presentController(withLargeTitle: false, accessoryView: createAccessoryView(), contractNavigationBarOnScroll: false)
    }

    @objc func showLargeTitleWithCustomizedElementSizes() {
        let controller = presentController(withLargeTitle: true, accessoryView: createAccessoryView())
        controller.msNavigationBar.avatarSize = .expanded
        controller.msNavigationBar.titleSize = .contracted
    }

    @discardableResult
    private func presentController(withLargeTitle useLargeTitle: Bool, style: MSNavigationBar.Style = .primary, accessoryView: UIView? = nil, contractNavigationBarOnScroll: Bool = true, showShadow: Bool = true) -> MSNavigationController {
        let content = RootViewController()
        content.navigationItem.usesLargeTitle = useLargeTitle
        content.navigationItem.navigationBarStyle = style
        content.navigationItem.navigationBarShadow = showShadow ? .automatic : .alwaysHidden
        content.navigationItem.accessoryView = accessoryView
        content.navigationItem.contentScrollView = contractNavigationBarOnScroll ? content.tableView : nil
        content.showsTabs = !showShadow

        let controller = MSNavigationController(rootViewController: content)
        controller.msNavigationBar.avatar = MSPersonaData(name: "Kat Larrson", avatarImage: UIImage(named: "avatar_kat_larsson"))
        controller.msNavigationBar.onAvatarTapped = handleAvatarTapped
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        return controller
    }

    private func createAccessoryView(with style: MSSearchBar.Style = .lightContent) -> UIView {
        let searchBar = MSSearchBar()
        searchBar.style = style
        searchBar.placeholderText = "Search"
        return searchBar
    }

    private func handleAvatarTapped() {
        let meControl = MSLabel(style: .title2, colorStyle: .regular)
        meControl.text = "Me Control goes here"
        meControl.textAlignment = .center

        let controller = MSDrawerController(sourceView: view, sourceRect: .zero, presentationOrigin: .zero, presentationDirection: .fromLeading)
        controller.contentView = meControl
        controller.preferredContentSize.width = 360
        controller.resizingBehavior = .dismiss
        presentedViewController?.present(controller, animated: true)
    }
}

// MARK: - RootViewController

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var container: UIStackView { return view as! UIStackView }
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        return tableView
    }()

    var showsTabs: Bool = false {
        didSet {
            if showsTabs != oldValue {
                segmentedControl = showsTabs ? MSSegmentedControl(items: ["Unread", "All"]) : nil
            }
        }
    }

    private var segmentedControl: MSSegmentedControl? {
        didSet {
            oldValue?.removeFromSuperview()
            if let segmentedControl = segmentedControl {
                container.insertArrangedSubview(segmentedControl, at: 0)
            }
        }
    }

    override func loadView() {
        let container = UIStackView()
        container.axis = .vertical
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container.addArrangedSubview(tableView)
        navigationItem.title = navigationItem.usesLargeTitle ? "Large Title" : "Regular Title"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissSelf)),
            UIBarButtonItem(image: UIImage(named: "3-day-view-28x28"), style: .plain, target: nil, action: nil)
        ]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Cell #\(1 + indexPath.row)", accessoryType: .disclosureIndicator)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChildViewController()
        if navigationItem.accessoryView == nil {
            controller.navigationItem.navigationBarStyle = .system
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func dismissSelf() {
        dismiss(animated: false)
    }
}

// MARK: - ChildViewController

class ChildViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        navigationItem.title = "Regular Title"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Child Cell #\(1 + indexPath.row)")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
