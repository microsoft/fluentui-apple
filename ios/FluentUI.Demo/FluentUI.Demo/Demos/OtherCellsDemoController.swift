//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: OtherCellsDemoController

class OtherCellsDemoController: DemoController {
    private let sections: [TableViewSampleData.Section] = OtherCellsSampleData.sections

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        tableView.register(ActivityIndicatorCell.self, forCellReuseIdentifier: ActivityIndicatorCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(CenteredLabelCell.self, forCellReuseIdentifier: CenteredLabelCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Colors.tableBackgroundGrouped
        tableView.separatorColor = Colors.Separator.default
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
    }
}

// MARK: - OtherCellsDemoController: UITableViewDataSource

extension OtherCellsDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]

        if section.title == "ActionsCell" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }
            cell.setup(action1Title: item.text1, action2Title: item.text2, action2Type: .destructive)
            let isLastInSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.bottomSeparatorType = isLastInSection ? .full : .inset
            return cell
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: ActivityIndicatorCell.identifier) as? ActivityIndicatorCell,
           section.title == "ActivityIndicatorCell" {
            return cell
        }

        if section.title == "BooleanCell" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }
            cell.setup(title: item.text1, customView: TableViewSampleData.createCustomView(imageName: item.image, useImageAsTemplate: true), isOn: indexPath.row == 0)
            cell.onValueChanged = { [unowned self, unowned cell] in
                self.showAlertForSwitchTapped(isOn: cell.isOn)
            }
            return cell
        }

        if section.title == "CenteredLabelCell" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CenteredLabelCell.identifier) as? CenteredLabelCell else {
                return UITableViewCell()
            }
            cell.setup(text: item.text1)
            return cell
        }

        return UITableViewCell()
    }

    private func showAlertForSwitchTapped(isOn: Bool) {
        let alert = UIAlertController(title: "Switch value: \(isOn)", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
    }
}

// MARK: - OtherCellsDemoController: UITableViewDelegate

extension OtherCellsDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let section = sections[section]
        header?.setup(style: section.headerStyle, title: section.title)
        return header
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.tableCellBackgroundGrouped
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
