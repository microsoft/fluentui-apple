//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: TableViewCellDemoController

class TableViewCellDemoController: DemoTableViewController {
    let sections: [TableViewSampleData.Section] = TableViewCellSampleData.sections

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private var isGrouped: Bool = false {
        didSet {
            updateTableView()
        }
    }

    private var isInSelectionMode: Bool = false {
        didSet {
            tableView.allowsMultipleSelection = isInSelectionMode

            for indexPath in tableView?.indexPathsForVisibleRows ?? [] {
                if !sections[indexPath.section].allowsMultipleSelection {
                    continue
                }

                if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                    cell.setIsInSelectionMode(isInSelectionMode, animated: true)
                }
            }

            tableView.indexPathsForSelectedRows?.forEach {
                tableView.deselectRow(at: $0, animated: false)
            }

            updateNavigationTitle()
            editButton?.title = isInSelectionMode ? "Done" : "Select"
        }
    }

    private var styleButtonTitle: String {
        return isGrouped ? "Switch to Plain style" : "Switch to Grouped style"
    }

    private var editButton: UIBarButtonItem?

    private var overrideTokens: [TableViewCellTokenSet.Tokens: ControlTokenValue]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        updateTableView()

        let editButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectionBarButtonTapped))
        navigationItem.rightBarButtonItems?.append(editButton)
        self.editButton = editButton

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: styleButtonTitle, style: .plain, target: self, action: #selector(styleBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    @objc private func selectionBarButtonTapped(sender: UIBarButtonItem) {
        isInSelectionMode = !isInSelectionMode
    }

    @objc private func styleBarButtonTapped(sender: UIBarButtonItem) {
        isGrouped = !isGrouped
        sender.title = styleButtonTitle
    }

    private func updateNavigationTitle() {
        if isInSelectionMode {
            let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
            navigationItem.title = selectedCount == 1 ? "1 item selected" : "\(selectedCount) items selected"
        } else {
            navigationItem.title = title
        }
    }

    private func updateTableView() {
        tableView.backgroundColor = isGrouped ? Colors.tableBackgroundGrouped : Colors.tableBackground
        tableView.reloadData()
    }
}

extension TableViewCellDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TableViewCellTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTableViewCellTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        overrideTokens = isOverrideEnabled ? perControlOverrideTableViewCellTokens : nil
        self.tableView.reloadData()
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TableViewCellTokenSet.self) != nil
    }

    // MARK: - Custom tokens
    private var themeWideOverrideTableViewCellTokens: [TableViewCellTokenSet.Tokens: ControlTokenValue] {
        return [
            .cellBackgroundColor: .dynamicColor {
                // "Berry"
                return DynamicColor(light: GlobalTokens().sharedColors[.berry][.tint50],
                                    dark: GlobalTokens().sharedColors[.berry][.shade40])
            }
        ]
    }

    private var perControlOverrideTableViewCellTokens: [TableViewCellTokenSet.Tokens: ControlTokenValue] {
        return [
            .cellBackgroundColor: .dynamicColor {
                // "Brass"
                return DynamicColor(light: GlobalTokens().sharedColors[.brass][.tint50],
                                    dark: GlobalTokens().sharedColors[.brass][.shade40])
            },
            .accessoryDisclosureIndicatorColor: .dynamicColor {
                // "Forest"
                return DynamicColor(light: GlobalTokens().sharedColors[.forest][.tint10],
                                    dark: GlobalTokens().sharedColors[.forest][.shade40])
            },
            .customViewTrailingMargin: .float {
                return 0
            }
        ]
    }
}

// MARK: - TableViewCellDemoController: UITableViewDataSource

extension TableViewCellDemoController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCellSampleData.numberOfItemsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        let section = sections[indexPath.section]
        let item = section.item
        if section.title == "Inverted double line cell" {
            cell.setup(
                attributedTitle: NSAttributedString(string: item.text1,
                                                    attributes: [.font: TextStyle.footnote.font,
                                                                 .foregroundColor: UIColor.purple]),
                attributedSubtitle: NSAttributedString(string: item.text2,
                                                       attributes: [.font: TextStyle.body.font,
                                                                    .foregroundColor: UIColor.red]),
                footer: TableViewCellSampleData.hasFullLengthLabelAccessoryView(at: indexPath) ? "" : item.text3,
                customView: TableViewSampleData.createCustomView(imageName: item.image),
                customAccessoryView: section.hasAccessory ? TableViewCellSampleData.customAccessoryView : nil,
                accessoryType: TableViewCellSampleData.accessoryType(for: indexPath)
            )
        } else {
            cell.setup(
                title: item.text1,
                subtitle: item.text2,
                footer: TableViewCellSampleData.hasFullLengthLabelAccessoryView(at: indexPath) ? "" : item.text3,
                customView: TableViewSampleData.createCustomView(imageName: item.image),
                customAccessoryView: section.hasAccessory ? TableViewCellSampleData.customAccessoryView : nil,
                accessoryType: TableViewCellSampleData.accessoryType(for: indexPath)
            )
        }

        let showsLabelAccessoryView = TableViewCellSampleData.hasLabelAccessoryViews(at: indexPath)
        cell.titleLeadingAccessoryView = showsLabelAccessoryView ? item.text1LeadingAccessoryView() : nil
        cell.titleTrailingAccessoryView = showsLabelAccessoryView ? item.text1TrailingAccessoryView() : nil
        cell.subtitleLeadingAccessoryView = showsLabelAccessoryView ? item.text2LeadingAccessoryView() : nil
        cell.subtitleTrailingAccessoryView = showsLabelAccessoryView ? item.text2TrailingAccessoryView() : nil
        cell.footerLeadingAccessoryView = showsLabelAccessoryView ? item.text3LeadingAccessoryView() : nil
        cell.footerTrailingAccessoryView = showsLabelAccessoryView ? item.text3TrailingAccessoryView() : nil

        cell.titleNumberOfLines = section.numberOfLines
        cell.subtitleNumberOfLines = section.numberOfLines
        cell.footerNumberOfLines = section.numberOfLines

        cell.titleLineBreakMode = .byTruncatingMiddle

        cell.titleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 3 : TableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.subtitleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : TableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.footerNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : TableViewCell.defaultNumberOfLinesForLargerDynamicType

        cell.backgroundStyleType = isGrouped ? .grouped : .plain
        cell.topSeparatorType = isGrouped && indexPath.row == 0 ? .full : .none
        let isLastInSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.bottomSeparatorType = isLastInSection ? .full : .inset

        cell.isInSelectionMode = section.allowsMultipleSelection ? isInSelectionMode : false

        cell.tokenSet.replaceAllOverrides(with: overrideTokens)

        return cell
    }
}

// MARK: - TableViewCellDemoController: UITableViewDelegate

extension TableViewCellDemoController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let section = sections[section]
        header?.setup(style: section.headerStyle, title: section.title)
        return header
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let title = sections[indexPath.section].item.text1
        showAlertForDetailButtonTapped(title: title)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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

    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
