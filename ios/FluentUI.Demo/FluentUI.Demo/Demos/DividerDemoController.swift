//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DividerDemoController: UITableViewController {
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

            let spacing: MSFDividerSpacing = section == .defaultMedium ? .medium : .none
            let color = section == .customColor ? Colors.communicationBlue : nil

            let verticalStack = UIStackView()
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.axis = .vertical
            verticalStack.addArrangedSubview(divider(spacing: spacing, color: color).view)

            let horizontalStack = UIStackView()
            horizontalStack.addArrangedSubview(divider(orientation: .vertical, spacing: spacing, color: color).view)
            horizontalStack.addArrangedSubview(divider(orientation: .vertical, spacing: spacing, color: color).view)
            horizontalStack.addArrangedSubview(divider(orientation: .vertical, spacing: spacing, color: color).view)
            verticalStack.addArrangedSubview(horizontalStack)

            verticalStack.addArrangedSubview(divider(spacing: spacing, color: color).view)

            cell.contentView.addSubview(verticalStack)
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
                cell.contentView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: verticalStack.topAnchor),
                cell.contentView.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor)
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

    private func divider(orientation: MSFDividerOrientation = .horizontal, spacing: MSFDividerSpacing, color: UIColor?) -> MSFDivider {
        let divider = MSFDivider(orientation: orientation, spacing: spacing)
        divider.state.color = color
        return divider
    }

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
                return "SwfitUI"
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
