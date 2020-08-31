//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: TableViewHeaderFooterViewDemoController

class TableViewHeaderFooterViewDemoController: DemoController {
    private let groupedSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.groupedSections
    private let plainSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.plainSections

    private let segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl(items: TableViewHeaderFooterSampleData.tabTitles)
        segmentedControl.addTarget(self, action: #selector(updateActiveTabContent), for: .valueChanged)
        return segmentedControl
    }()
    private lazy var groupedTableView: UITableView = createTableView(style: .grouped)
    private lazy var plainTableView: UITableView = createTableView(style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        container.heightAnchor.constraint(equalTo: scrollingContainer.heightAnchor).isActive = true
        container.layoutMargins = .zero
        container.spacing = 0

        container.addArrangedSubview(segmentedControl)
        container.addArrangedSubview(groupedTableView)
        container.addArrangedSubview(plainTableView)

        updateActiveTabContent()
    }

    func createTableView(style: UITableView.Style) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Colors.Table.background
        tableView.separatorStyle = .none
        return tableView
    }

    @objc private func updateActiveTabContent() {
        groupedTableView.isHidden = segmentedControl.selectedSegmentIndex == 1
        plainTableView.isHidden = !groupedTableView.isHidden
    }
}

// MARK: - TableViewHeaderFooterViewDemoController: UITableViewDataSource

extension TableViewHeaderFooterViewDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.style == .grouped ? groupedSections.count : plainSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewHeaderFooterSampleData.numberOfItemsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.setup(title: TableViewHeaderFooterSampleData.itemTitle)
        var isLastInSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        if tableView.style == .grouped {
            if groupedSections[indexPath.section].hasFooter {
                isLastInSection = false
            }
            cell.bottomSeparatorType = isLastInSection ? .full : .inset
        } else {
            cell.bottomSeparatorType = isLastInSection ? .none : .inset
        }
        return cell
    }
}

// MARK: - TableViewHeaderFooterViewDemoController: UITableViewDelegate

extension TableViewHeaderFooterViewDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        return section.hasFooter ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as! TableViewHeaderFooterView
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        if section.hasCustomAccessoryView {
            header.setup(style: section.headerStyle, title: section.title, accessoryView: createCustomAccessoryView())
        } else {
            header.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessory ? "See More" : "")
        }

        header.titleNumberOfLines = section.numberOfLines
        header.accessoryButtonStyle = section.accessoryButtonStyle
        header.onAccessoryButtonTapped = { [unowned self] in self.showAlertForAccessoryTapped(title: section.title) }

        return header
    }

    private func createCustomAccessoryView() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("Custom Accessory", for: .normal)
        button.setTitleColor(.green, for: .normal)
        return button
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.style == .grouped && groupedSections[section].hasFooter {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as! TableViewHeaderFooterView
            let section = groupedSections[section]
            if section.footerLinkText.isEmpty {
                footer.setup(style: .footer, title: section.footerText)
            } else {
                let title = NSMutableAttributedString(string: section.footerText)
                let range = (title.string as NSString).range(of: section.footerLinkText)
                if range.location != -1 {
                    title.addAttribute(.link, value: "https://github.com/microsoft/fluentui-apple", range: range)
                }
                footer.setup(style: .footer, attributedTitle: title)

                if section.hasCustomLinkHandler {
                    footer.delegate = self
                }
            }
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

// MARK: - TableViewHeaderFooterViewDemoController: TableViewHeaderFooterViewDelegate

extension TableViewHeaderFooterViewDemoController: TableViewHeaderFooterViewDelegate {
    func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let alertController = UIAlertController(title: "Link tapped", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return false
    }
}
