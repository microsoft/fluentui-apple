//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSTableViewHeaderFooterViewDemoController

class MSTableViewHeaderFooterViewDemoController: DemoController {
    private let groupedSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.groupedSections
    private let plainSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.plainSections

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.backgroundLightGray

        let groupedTitle = TableViewHeaderFooterSampleData.groupedTitle
        let plainTitle = TableViewHeaderFooterSampleData.plainTitle

        let groupedTableView = createTableView(style: .grouped)
        let plainTableView = createTableView(style: .plain)

        container.addArrangedSubview(groupedTitle)
        container.addArrangedSubview(groupedTableView)
        container.addArrangedSubview(plainTitle)
        container.addArrangedSubview(plainTableView)

        groupedTableView.heightAnchor.constraint(equalTo: plainTableView.heightAnchor).isActive = true

        container.heightAnchor.constraint(equalTo: scrollingContainer.heightAnchor).isActive = true
        container.layoutMargins.left = 0
        container.layoutMargins.right = 0
        container.layoutMargins.bottom = 0
    }

    func createTableView(style: UITableView.Style) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        tableView.register(MSTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MSTableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = MSColors.background
        tableView.separatorStyle = .none
        return tableView
    }
}

// MARK: - MSTableViewHeaderFooterViewDemoController: UITableViewDataSource

extension MSTableViewHeaderFooterViewDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.style == .grouped ? groupedSections.count : plainSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewHeaderFooterSampleData.numberOfItemsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier) as! MSTableViewCell
        cell.setup(title: TableViewHeaderFooterSampleData.itemTitle)
        return cell
    }
}

// MARK: - MSTableViewHeaderFooterViewDemoController: UITableViewDelegate

extension MSTableViewHeaderFooterViewDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        return section.hasFooter ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        header.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessoryView ? "See More" : "")
        header.titleNumberOfLines = section.numberOfLines
        header.onAccessoryButtonTapped = { [unowned self] in self.showAlertForAccessoryTapped(title: section.title) }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.style == .grouped && groupedSections[section].hasFooter {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
            let section = groupedSections[section]
            footer.setup(style: .footer, title: section.footerText)
            footer.titleNumberOfLines = section.numberOfLines
            return footer
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showAlertForAccessoryTapped(title: String) {
        let alert = UIAlertController(title: "\(title) was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
