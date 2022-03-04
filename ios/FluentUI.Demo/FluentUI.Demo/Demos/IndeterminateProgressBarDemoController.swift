//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class IndeterminateProgressBarDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return IndeterminateProgressBarDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IndeterminateProgressBarDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = IndeterminateProgressBarDemoSection.allCases[indexPath.section].rows[indexPath.row]

        switch row {
        case .hidesWhenStopped:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title, isOn: self.shouldHideWhenStopped)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.shouldHideWhenStopped = cell?.isOn ?? true
            }
            return cell
        case .startStopActivity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }

            cell.setup(action1Title: row.title)
            cell.action1Button.addTarget(self,
                                         action: #selector(startStopActivity),
                                         for: .touchUpInside)
            cell.bottomSeparatorType = .full
            return cell
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell
        case.demoProgressBar:
            let cell = TableViewCell()

            let rowContentView = UIStackView(arrangedSubviews: [indeterminateProgressBar.view])
            rowContentView.isLayoutMarginsRelativeArrangement = true
            rowContentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)
            rowContentView.translatesAutoresizingMaskIntoConstraints = false
            rowContentView.alignment = .leading
            rowContentView.distribution = .fill

            cell.contentView.addSubview(rowContentView)
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: rowContentView.leadingAnchor),
                cell.contentView.trailingAnchor.constraint(equalTo: rowContentView.trailingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: rowContentView.topAnchor),
                cell.contentView.bottomAnchor.constraint(equalTo: rowContentView.bottomAnchor)
            ])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return IndeterminateProgressBarDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return IndeterminateProgressBarDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch IndeterminateProgressBarDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(IndeterminateProgressBarDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
    }

    private var shouldHideWhenStopped: Bool = true {
        didSet {
            if oldValue != shouldHideWhenStopped {
                indeterminateProgressBar.configuration.hidesWhenStopped = shouldHideWhenStopped
            }
        }
    }

    private var isAnimating: Bool = true {
        didSet {
            if oldValue != isAnimating {
                indeterminateProgressBar.configuration.isAnimating = isAnimating
            }
        }
    }

    private let indeterminateProgressBar: MSFIndeterminateProgressBar = {
        let indeterminateProgressBar = MSFIndeterminateProgressBar()
        indeterminateProgressBar.configuration.isAnimating = true

        return indeterminateProgressBar
    }()

    private enum IndeterminateProgressBarDemoRow: CaseIterable {
        case swiftUIDemo
        case hidesWhenStopped
        case startStopActivity
        case demoProgressBar

        var title: String {
            switch self {
            case .swiftUIDemo:
                return "SwiftUI Demo"
            case .hidesWhenStopped:
                return "Hides when stopped"
            case .startStopActivity:
                return "Start / Stop activity"
            case .demoProgressBar:
                return ""
            }
        }
    }

    private enum IndeterminateProgressBarDemoSection: CaseIterable {
        case swiftUI
        case settings
        case progressBar

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .settings:
                return "Settings"
            case .progressBar:
                return "Progress Bar"
            }
        }

        var rows: [IndeterminateProgressBarDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .settings:
                return [.hidesWhenStopped, .startStopActivity]
            case .progressBar:
                return [.demoProgressBar]
            }
        }

    }

    @objc private func startStopActivity() {
        isAnimating.toggle()
    }
}
