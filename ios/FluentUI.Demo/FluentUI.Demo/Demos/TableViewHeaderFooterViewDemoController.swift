//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: TableViewHeaderFooterViewDemoController

class TableViewHeaderFooterViewDemoController: DemoTableViewController {
    private let groupedSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.groupedSections
    private var collapsedSections: [Bool] = [Bool](repeating: false, count: TableViewHeaderFooterSampleData.groupedSections.count)
    private var overrideTokens: [TableViewHeaderFooterViewTokenSet.Tokens: ControlTokenValue]?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.separatorStyle = .none
    }

    private func updateTableView() {
        tableView.backgroundColor = TableViewCell.tableBackgroundGroupedColor
        tableView.reloadData()
    }
}

// MARK: - TableViewHeaderFooterViewDemoController: UITableViewDataSource

extension TableViewHeaderFooterViewDemoController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  groupedSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collapsedSections[section] ? 0 : TableViewHeaderFooterSampleData.numberOfItemsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundStyleType = TableViewCellBackgroundStyleType.custom
        cell.backgroundColor = view.fluentTheme.color(.background2)
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

extension TableViewHeaderFooterViewDemoController {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = groupedSections[section]
        return section.hasFooter ? UITableView.automaticDimension : 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let index = section
        let section = groupedSections[section]
        if let header = header, section.hasHandler {
            header.onHeaderViewTapped = { [weak self] in self?.forHeaderTapped(header: header, section: index) }
        }

        if section.hasCustomAccessoryView {
            header?.setup(style: section.headerStyle, title: section.title, accessoryView: createCustomAccessoryView(), leadingView: section.hasCustomLeadingView ? createCustomLeadingView(section: index) : nil)
        } else {
            header?.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessory ? "See More" : "", leadingView: section.hasCustomLeadingView ? createCustomLeadingView(section: index) : nil)
        }

        header?.titleNumberOfLines = section.numberOfLines
        header?.accessoryButtonStyle = section.accessoryButtonStyle
        header?.onAccessoryButtonTapped = { [weak self] in self?.showAlertForAccessoryTapped(title: section.title) }
        header?.tokenSet.replaceAllOverrides(with: overrideTokens)

        return header
    }

    private func createCustomAccessoryView() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("Custom Accessory", for: .normal)
        button.setTitleColor(GlobalTokens.sharedColor(.red, .primary), for: .normal)
        return button
    }

    private func createCustomLeadingView(section: Int) -> UIView {
        let imageName = collapsedSections[section] ? "chevron-right-20x20" : "chevron-down-20x20"
        let chevron = UIImageView(image: UIImage(named: imageName))
        chevron.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImageView(image: UIImage(named: "image-24x24"))
        image.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = GlobalTokens.spacing(.size40)
        stackView.addArrangedSubview(chevron)
        stackView.addArrangedSubview(image)

        return stackView
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.style != .plain && groupedSections[section].hasFooter {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
            let section = groupedSections[section]
            if section.footerLinkText.isEmpty {
                footer?.setup(style: .footer, title: section.footerText)
            } else {
                let title = NSMutableAttributedString(string: section.footerText)
                let range = (title.string as NSString).range(of: section.footerLinkText)
                if range.location != -1 {
                    title.addAttribute(.link, value: "https://github.com/microsoft/fluentui-apple", range: range)
                }
                footer?.setup(style: .footer, attributedTitle: title)

#if os(iOS)
                if section.hasCustomLinkHandler {
                    footer?.delegate = self
                }
#endif
            }
            footer?.titleNumberOfLines = section.numberOfLines
            footer?.tokenSet.replaceAllOverrides(with: overrideTokens)
            return footer
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showAlertForAccessoryTapped(title: String) {
        let alert = UIAlertController(title: "\(title) was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func forHeaderTapped(header: TableViewHeaderFooterView, section: Int) {
        collapsedSections[section] = !collapsedSections[section]
        tableView.reloadSections(IndexSet(integer: section), with: UITableView.RowAnimation.fade)
    }
}

// MARK: - TableViewHeaderFooterViewDemoController: TableViewHeaderFooterViewDelegate

#if os(iOS)
extension TableViewHeaderFooterViewDemoController: TableViewHeaderFooterViewDelegate {
    func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let alertController = UIAlertController(title: "Link tapped", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return false
    }
}
#endif

extension TableViewHeaderFooterViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TableViewHeaderFooterViewTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTableViewHeaderFooterTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        overrideTokens = isOverrideEnabled ? perControlOverrideTableViewHeaderFooterTokens : nil
        self.tableView.reloadData()
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TableViewHeaderFooterViewTokenSet.self) != nil
    }

    // MARK: - Custom tokens
    private var themeWideOverrideTableViewHeaderFooterTokens: [TableViewHeaderFooterViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .textColor: .uiColor {
                // "Grape"
                return UIColor(light: GlobalTokens.sharedColor(.grape, .tint10),
                               dark: GlobalTokens.sharedColor(.grape, .shade40))
            }
        ]
    }

    private var perControlOverrideTableViewHeaderFooterTokens: [TableViewHeaderFooterViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .textFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 20.0), size: 20.0)
            },
            .accessoryButtonTextColor: .uiColor {
                // "Hot Pink"
                return UIColor(light: GlobalTokens.sharedColor(.hotPink, .tint10),
                               dark: GlobalTokens.sharedColor(.hotPink, .shade40))
            }
        ]
    }
}
