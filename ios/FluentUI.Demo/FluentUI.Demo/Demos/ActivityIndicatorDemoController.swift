//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ActivityIndicatorDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
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
        return ActivityIndicatorDemoSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityIndicatorDemoSections.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = ActivityIndicatorDemoSections.allCases[indexPath.section].rows[indexPath.row]

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
        case.demoOfSize:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let activityIndicatorSize = MSFActivityIndicatorSize.allCases.reversed()[indexPath.row]
            let activityIndicatorDictionaries = [defaultColorIndicators, customColorIndicators]
            let activityIndicatorPath = indexPath.section - 1
            let activityIndicator = activityIndicatorDictionaries[activityIndicatorPath][activityIndicatorSize]

            cell.setup(title: activityIndicatorSize.description,
                       customView: activityIndicator?.view)
            cell.titleNumberOfLines = 0
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ActivityIndicatorDemoSections.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
       return false
    }

    private var shouldHideWhenStopped: Bool = true {
        didSet {
            if oldValue != shouldHideWhenStopped {
                defaultColorIndicators.values.forEach { indicator in
                    indicator.state.hidesWhenStopped = shouldHideWhenStopped
                }

                customColorIndicators.values.forEach { indicator in
                    indicator.state.hidesWhenStopped = shouldHideWhenStopped
                }
            }
        }
    }

    private var isAnimating: Bool = true {
        didSet {
            if oldValue != isAnimating {
                defaultColorIndicators.values.forEach { indicator in
                    indicator.state.isAnimating = isAnimating
                }

                customColorIndicators.values.forEach { indicator in
                    indicator.state.isAnimating = isAnimating
                }
            }
        }
    }

    private var defaultColorIndicators: [MSFActivityIndicatorSize: MSFActivityIndicator] = {
        var defaultColorIndicators: [MSFActivityIndicatorSize: MSFActivityIndicator] = [:]

        MSFActivityIndicatorSize.allCases.forEach { size in
            let indicator = MSFActivityIndicator(size: size)
            indicator.state.isAnimating = true
            defaultColorIndicators.updateValue(indicator, forKey: size)
        }

        return defaultColorIndicators
    }()

    private var customColorIndicators: [MSFActivityIndicatorSize: MSFActivityIndicator] = {
        var customColorIndicators: [MSFActivityIndicatorSize: MSFActivityIndicator] = [:]

        MSFActivityIndicatorSize.allCases.forEach { size in
            let indicator = MSFActivityIndicator(size: size)
            indicator.state.isAnimating = true
            indicator.state.color = Colors.communicationBlue
            customColorIndicators.updateValue(indicator, forKey: size)
        }

        return customColorIndicators
    }()

    private enum ActivityIndicatorDemoRows: CaseIterable {
        case hidesWhenStopped
        case startStopActivity
        case demoOfSize

        var title: String {
            switch self {
            case .hidesWhenStopped:
                return "Hides when stopped"
            case .startStopActivity:
                return "Start / Stop activity"
            case .demoOfSize:
                return ""
            }
        }
    }

    private enum ActivityIndicatorDemoSections: CaseIterable {
        case settings
        case defaultColor
        case customColor

        var title: String {
            switch self {
            case .settings:
                return "Settings"
            case .defaultColor:
                return "Default Color"
            case .customColor:
                return "Custom Color"
            }
        }

        var rows: [ActivityIndicatorDemoRows] {
            switch self {
            case .settings:
                return [.hidesWhenStopped, .startStopActivity]
            case .defaultColor, .customColor:
                return [ActivityIndicatorDemoRows](repeating: .demoOfSize,
                                                   count: MSFActivityIndicatorSize.allCases.count)
            }
        }

    }

    @objc private func startStopActivity() {
        isAnimating.toggle()
    }
}

extension MSFActivityIndicatorSize {
    var description: String {
        switch self {
        case .xSmall:
            return "xSmall"
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        case .xLarge:
            return "xLarge"
        }
    }
}
