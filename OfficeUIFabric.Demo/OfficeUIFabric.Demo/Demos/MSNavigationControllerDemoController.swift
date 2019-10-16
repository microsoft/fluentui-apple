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
        container.addArrangedSubview(createButton(title: "Show with collapsible search bar", action: #selector(showLargeTitleWithSystemStyleAndShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show with fixed search bar", action: #selector(showLargeTitleWithSystemStyleAndFixedAccessory)))

        addTitle(text: "Regular Title")
        container.addArrangedSubview(createButton(title: "Show \"system\" with collapsible search bar", action: #selector(showRegularTitleWithShyAccessory)))
        container.addArrangedSubview(createButton(title: "Show \"primary\" with fixed search bar", action: #selector(showRegularTitleWithFixedAccessory)))
    }

    @objc func showLargeTitle() {
        presentTitleController(withLargeTitle: true)
    }

    @objc func showLargeTitleWithShyAccessory() {
        presentTitleController(withLargeTitle: true, accessoryView: createAccessoryView(), hideAccessoryOnScroll: true)
    }

    @objc func showLargeTitleWithFixedAccessory() {
        presentTitleController(withLargeTitle: true, accessoryView: createAccessoryView(), hideAccessoryOnScroll: false)
    }

    @objc func showLargeTitleWithSystemStyle() {
        presentTitleController(withLargeTitle: true, style: .system)
    }

    @objc func showLargeTitleWithSystemStyleAndShyAccessory() {
        presentTitleController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), hideAccessoryOnScroll: true)
    }

    @objc func showLargeTitleWithSystemStyleAndFixedAccessory() {
        presentTitleController(withLargeTitle: true, style: .system, accessoryView: createAccessoryView(with: .darkContent), hideAccessoryOnScroll: false)
    }

    @objc func showRegularTitleWithShyAccessory() {
        presentTitleController(withLargeTitle: false, style: .system, accessoryView: createAccessoryView(with: .darkContent), hideAccessoryOnScroll: true)
    }

    @objc func showRegularTitleWithFixedAccessory() {
        presentTitleController(withLargeTitle: false, accessoryView: createAccessoryView(), hideAccessoryOnScroll: false)
    }

    private func presentTitleController(withLargeTitle useLargeTitle: Bool, style: MSNavigationBar.Style = .primary, accessoryView: UIView? = nil, hideAccessoryOnScroll: Bool = true) {
        let content = RootViewController()
        content.navigationItem.usesLargeTitle = useLargeTitle
        content.navigationItem.navigationBarStyle = style
        content.navigationItem.accessoryView = accessoryView
        content.navigationItem.contentScrollView = hideAccessoryOnScroll ? content.tableView : nil

        let controller = MSNavigationController(rootViewController: content)
        controller.msNavigationBar.avatar = MSPersonaData(name: "Kat Larrson", avatarImage: UIImage(named: "avatar_kat_larsson"))
        controller.msNavigationBar.onAvatarTapped = handleAvatarTapped
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
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

class RootViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        navigationItem.title = navigationItem.usesLargeTitle ? "Large Title" : "Regular Title"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissSelf)),
            UIBarButtonItem(image: UIImage(named: "3-day-view-28x28"), style: .plain, target: nil, action: nil)
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as! MSTableViewCell
        cell.setup(title: "Cell #\(1 + indexPath.row)")
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
