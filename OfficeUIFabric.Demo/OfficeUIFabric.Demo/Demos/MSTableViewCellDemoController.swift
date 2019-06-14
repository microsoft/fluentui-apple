//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSTableViewCellDemoController

class MSTableViewCellDemoController: DemoController {
    private let sections: [TableViewSampleData.Section] = MSTableViewCellSampleData.sections

    private var isInSelectionMode: Bool = false {
        didSet {
            tableView.allowsMultipleSelection = isInSelectionMode

            for indexPath in tableView?.indexPathsForVisibleRows ?? [] {
                if !sections[indexPath.section].allowsMultipleSelection {
                    continue
                }

                let cell = tableView.cellForRow(at: indexPath) as! MSTableViewCell
                cell.setIsInSelectionMode(isInSelectionMode, animated: true)
            }

            tableView.indexPathsForSelectedRows?.forEach {
                tableView.deselectRow(at: $0, animated: false)
            }

            updateNavigationTitle()
            navigationItem.rightBarButtonItem?.title = isInSelectionMode ? "Done" : "Select"
        }
    }

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        tableView.register(MSTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MSTableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = MSColors.background
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(barButtonTapped))
    }

    @objc private func barButtonTapped(sender: UIBarButtonItem) {
        isInSelectionMode = !isInSelectionMode
    }

    private func updateNavigationTitle() {
        if isInSelectionMode {
            let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
            navigationItem.title = selectedCount == 1 ? "1 item selected" : "\(selectedCount) items selected"
        } else {
            navigationItem.title = title
        }
    }
}

// MARK: - MSTableViewCellDemoController: UITableViewDataSource

extension MSTableViewCellDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MSTableViewCellSampleData.numberOfItemsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.item

        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier) as! MSTableViewCell
        cell.setup(
            title: item.text1,
            subtitle: item.text2,
            footer: item.text3,
            customView: TableViewSampleData.createCustomView(imageName: item.image),
            customAccessoryView: section.hasAccessoryView ? MSTableViewCellSampleData.customAccessoryView : nil,
            accessoryType: MSTableViewCellSampleData.accessoryType(for: indexPath)
        )
        cell.titleNumberOfLines = section.numberOfLines
        cell.subtitleNumberOfLines = section.numberOfLines
        cell.footerNumberOfLines = section.numberOfLines
        cell.titleLineBreakMode = .byTruncatingMiddle
        cell.isInSelectionMode = section.allowsMultipleSelection ? isInSelectionMode : false
        return cell
    }
}

// MARK: - MSTableViewCellDemoController: UITableViewDelegate

extension MSTableViewCellDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
        let section = sections[section]
        header.setup(style: section.headerStyle, title: section.title)
        return header
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let title = sections[indexPath.section].item.text1
        showAlertForDetailButtonTapped(title: title)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        }
    }

    private func showAlertForDetailButtonTapped(title: String) {
        let alert = UIAlertController(title: "\(title) detail button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
