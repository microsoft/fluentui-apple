//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class DividerDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DividerDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DividerDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = DividerDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell
        case .dividerDemo:
            let cell = TableViewCell()
            let contentView = cell.contentView

            let spacing: MSFDividerSpacing = section == .defaultMedium ? .medium : .none
            let useCustomColor = section == .customColor

            let verticalStack = UIStackView()
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.axis = .vertical
            verticalStack.isLayoutMarginsRelativeArrangement = true
            verticalStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            verticalStack.addArrangedSubview(makeDivider(spacing: spacing, customColor: useCustomColor))
            verticalStack.distribution = .equalCentering

            let horizontalStack = UIStackView()
            horizontalStack.distribution = .equalCentering
            horizontalStack.addArrangedSubview(makeDivider(orientation: .vertical, spacing: spacing, customColor: useCustomColor))
            let text1 = Label(style: .subhead, colorStyle: .regular)
            text1.text = "Text 1"
            horizontalStack.addArrangedSubview(text1)
            horizontalStack.addArrangedSubview(makeDivider(orientation: .vertical, spacing: spacing, customColor: useCustomColor))
            let text2 = Label(style: .subhead, colorStyle: .regular)
            text2.text = "Text 2"
            horizontalStack.addArrangedSubview(text2)
            horizontalStack.addArrangedSubview(makeDivider(orientation: .vertical, spacing: spacing, customColor: useCustomColor))
            verticalStack.addArrangedSubview(horizontalStack)

            verticalStack.addArrangedSubview(makeDivider(spacing: spacing, customColor: useCustomColor))

            contentView.addSubview(verticalStack)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: verticalStack.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor)
            ])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DividerDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return DividerDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch DividerDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(DividerDemoControllerSwiftUI(),
                                                     animated: true)
        case .dividerDemo:
            break
        }
    }

    private func makeDivider(orientation: MSFDividerOrientation = .horizontal, spacing: MSFDividerSpacing, customColor: Bool) -> MSFDivider {
        let divider = MSFDivider(orientation: orientation, spacing: spacing)
        if customColor, let color = self.view.window?.fluentTheme.aliasTokens.brandColors[.primary] {
            divider.tokenSet[.color] = .dynamicColor({ color })
        }

        dividers.append(divider)

        return divider
    }

    private var dividers: [MSFDivider] = []

    private enum DividerDemoSection: CaseIterable {
        case swiftUI
        case defaultNone
        case defaultMedium
        case customColor

        var spacing: MSFDividerSpacing {
            switch self {
            case .defaultNone,
                    .customColor:
                return .none
            case .defaultMedium:
                return .medium
            case .swiftUI:
                preconditionFailure("SwiftUI row should not display a Divider")
            }
        }

        var isDemoSection: Bool {
            return self != .swiftUI
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .defaultNone:
                return "No spacing"
            case .defaultMedium:
                return "Medium Spacing"
            case .customColor:
                return "Custom Color"
            }
        }

        var rows: [DividerDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .defaultNone,
                    .defaultMedium,
                    .customColor:
                return [.dividerDemo]
            }
        }
    }

    private enum DividerDemoRow: CaseIterable {
        case swiftUIDemo
        case dividerDemo

        var isDemoRow: Bool {
            return self != .swiftUIDemo
        }

        var title: String {
            switch self {
            case .swiftUIDemo:
                return "Swift UI Demo"
            case .dividerDemo:
                return ""
            }
        }
    }
}

extension DividerDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: DividerTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideDividerTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        dividers.forEach { divider in
            divider.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideDividerTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: DividerTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverrideDividerTokens: [DividerTokenSet.Tokens: ControlTokenValue] {
        return [
            .color: .dynamicColor { DynamicColor(light: GlobalTokens.sharedColors(.red, .primary)) }
        ]
    }

    private var perControlOverrideDividerTokens: [DividerTokenSet.Tokens: ControlTokenValue] {
        return [
            .color: .dynamicColor { DynamicColor(light: GlobalTokens.sharedColors(.green, .primary)) }
        ]
    }
}
