//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ActivityIndicatorDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ActivityIndicatorDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityIndicatorDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = ActivityIndicatorDemoSection.allCases[indexPath.section].rows[indexPath.row]

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
        case.demoOfSize:
            let cell = UITableViewCell()

            let activityIndicatorSize = MSFActivityIndicatorSize.allCases.reversed()[indexPath.row]
            let activityIndicatorDictionaries = [defaultColorIndicators, customColorIndicators]
            let activityIndicatorPath = indexPath.section - 2
            guard let activityIndicator = activityIndicatorDictionaries[activityIndicatorPath][activityIndicatorSize] else {
                return cell
            }

            let titleLabel = Label(style: .body, colorStyle: .regular)
            titleLabel.text = activityIndicatorSize.description
            titleLabel.numberOfLines = 0

            let contentStack = UIStackView(arrangedSubviews: [activityIndicator, titleLabel])
            contentStack.isLayoutMarginsRelativeArrangement = true
            contentStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            contentStack.alignment = .center
            contentStack.distribution = .fill
            contentStack.spacing = 10

            cell.contentView.addSubview(contentStack)
            NSLayoutConstraint.activate([
                activityIndicator.widthAnchor.constraint(equalToConstant: xLargeSize),
                cell.contentView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
                cell.contentView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: contentStack.topAnchor),
                cell.contentView.bottomAnchor.constraint(equalTo: contentStack.bottomAnchor)
            ])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ActivityIndicatorDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return ActivityIndicatorDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch ActivityIndicatorDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(ActivityIndicatorDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
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

    private enum ActivityIndicatorDemoRow: CaseIterable {
        case swiftUIDemo
        case hidesWhenStopped
        case startStopActivity
        case demoOfSize

        var title: String {
            switch self {
            case .swiftUIDemo:
                return "SwiftUI Demo"
            case .hidesWhenStopped:
                return "Hides when stopped"
            case .startStopActivity:
                return "Start / Stop activity"
            case .demoOfSize:
                return ""
            }
        }
    }

    private enum ActivityIndicatorDemoSection: CaseIterable {
        case swiftUI
        case settings
        case defaultColor
        case customColor

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .settings:
                return "Settings"
            case .defaultColor:
                return "Default Color"
            case .customColor:
                return "Custom Color"
            }
        }

        var rows: [ActivityIndicatorDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .settings:
                return [.hidesWhenStopped, .startStopActivity]
            case .defaultColor, .customColor:
                return [ActivityIndicatorDemoRow](repeating: .demoOfSize,
                                                  count: MSFActivityIndicatorSize.allCases.count)
            }
        }

    }

    private let xLargeSize: CGFloat = 36

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

extension ActivityIndicatorDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }
        fluentTheme.register(tokenSetType: ActivityIndicatorTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideActivityIndicatorTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        defaultColorIndicators.values.forEach { activityIndicator in
            activityIndicator.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideActivityIndicatorTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: ActivityIndicatorTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens

    private var themeWideOverrideActivityIndicatorTokens: [ActivityIndicatorTokenSet.Tokens: ControlTokenValue] {
        return [
            .defaultColor: .dynamicColor { DynamicColor(light: GlobalTokens().sharedColors[.red][.primary]) },
            .thickness: .float { 20.0 }
        ]
    }

    private var perControlOverrideActivityIndicatorTokens: [ActivityIndicatorTokenSet.Tokens: ControlTokenValue] {
        return [
            .defaultColor: .dynamicColor { DynamicColor(light: GlobalTokens().sharedColors[.green][.primary]) },
            .thickness: .float { 10.0 }
        ]
    }
}
