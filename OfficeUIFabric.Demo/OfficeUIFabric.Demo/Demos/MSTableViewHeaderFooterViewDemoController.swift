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

    private let segmentedControl: MSSegmentedControl = {
        let segmentedControl = MSSegmentedControl(items: TableViewHeaderFooterSampleData.tabTitles)
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
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        tableView.register(MSTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MSTableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = MSColors.Table.background
        tableView.separatorStyle = .none
        return tableView
    }

    @objc private func updateActiveTabContent() {
        groupedTableView.isHidden = segmentedControl.selectedSegmentIndex == 1
        plainTableView.isHidden = !groupedTableView.isHidden
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

// MARK: - MSTableViewHeaderFooterViewDemoController: UITableViewDelegate

extension MSTableViewHeaderFooterViewDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        return section.hasFooter ? UITableView.automaticDimension : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
        let section = tableView.style == .grouped ? groupedSections[section] : plainSections[section]
        header.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessory ? "See More" : "")
        header.titleNumberOfLines = section.numberOfLines
        header.accessoryButtonStyle = section.accessoryButtonStyle
        header.onAccessoryButtonTapped = { [unowned self] in self.showAlertForAccessoryTapped(title: section.title) }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.style == .grouped && groupedSections[section].hasFooter {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSTableViewHeaderFooterView.identifier) as! MSTableViewHeaderFooterView
            let section = groupedSections[section]
            if section.footerLinkText.isEmpty {
                footer.setup(style: .footer, title: section.footerText)
            } else {
                let title = NSMutableAttributedString(string: section.footerText)
                let range = (title.string as NSString).range(of: section.footerLinkText)
                if range.location != -1 {
                    title.addAttribute(.link, value: "https://github.com/OfficeDev/ui-fabric-ios", range: range)
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

// MARK: - MSTableViewHeaderFooterViewDemoController: MSTableViewHeaderFooterViewDelegate

extension MSTableViewHeaderFooterViewDemoController: MSTableViewHeaderFooterViewDelegate {
    func headerFooterView(_ headerFooterView: MSTableViewHeaderFooterView, didInteractWithURL url: URL) {
        let alertController = UIAlertController(title: "Link tapped", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
