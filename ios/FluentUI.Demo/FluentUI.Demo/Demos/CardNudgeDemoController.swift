//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CardNudgeDemoController: DemoTableViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // Enable all switches by default
        CardNudgeDemoRow.allCases.forEach { row in
            self.updateSetting(for: row, isOn: true)
        }
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CardNudgeDemoController.controlReuseIdentifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCardNudgeSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        self.configureAppearancePopover()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return CardNudgeDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardNudgeDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = CardNudgeDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .standardCard,
             .outlineCard:
            let cell = tableView.dequeueReusableCell(withIdentifier: CardNudgeDemoController.controlReuseIdentifier, for: indexPath)

            let view = cardNudges[indexPath.row].view
            let contentView = cell.contentView
            contentView.addSubview(view)
            cell.selectionStyle = .none
            cell.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false

            let constraints = [
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                view.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ]

            contentView.addConstraints(constraints)

            return cell

        case .mainIcon,
             .subtitle,
             .accentIcon,
             .accentText,
             .dismissButton,
             .actionButton:
            guard let cell: BooleanCell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier, for: indexPath) as? BooleanCell else {
                preconditionFailure("Wrong kind of cell in BooleanCell index path")
            }
            setupPropertyToggleCell(cell, for: row)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CardNudgeDemoSection.allCases[section].title
    }

    // MARK: - Custom tokens

    private func configureAppearancePopover() {
        super.configureAppearancePopover { [weak self] themeWideOverrideEnabled in
            guard let fluentTheme = self?.view.window?.fluentTheme else {
                return
            }

            var tokensClosure: ((CardNudge) -> CardNudgeTokens)?
            if themeWideOverrideEnabled {
                tokensClosure = { _ in
                    return ThemeWideOverrideCardNudgeTokens()
                }
            }

            fluentTheme.register(controlType: CardNudge.self, tokens: tokensClosure)

        } onPerControlOverrideChanged: { [weak self] perControlOverrideEnabled in
            self?.cardNudges.forEach({ cardNudge in
                let tokens = perControlOverrideEnabled ? PerControlOverrideCardNudgeTokens() : nil
                cardNudge.state.overrideTokens = tokens
            })
        }
    }

    private class ThemeWideOverrideCardNudgeTokens: CardNudgeTokens {
        override var backgroundColor: DynamicColor {
            // "Seafoam"
            return DynamicColor(light: ColorValue(0xFBD2EB),
                                dark: ColorValue(0x44002A))
        }
    }

    private class PerControlOverrideCardNudgeTokens: CardNudgeTokens {
        override var backgroundColor: DynamicColor {
            // "Hot Pink"
            return DynamicColor(light: ColorValue(0xCFF7E4),
                                dark: ColorValue(0x003D20))
        }
    }

    // MARK: - Helpers

    private func updateSetting(for row: CardNudgeDemoRow, isOn: Bool) {
        switch row {
        case .standardCard,
             .outlineCard:
            // No-op
            break
        case .mainIcon:
            cardNudges.forEach { cardNudge in
                cardNudge.state.mainIcon = (isOn ? UIImage(systemName: "gamecontroller") : nil)
            }
        case .subtitle:
            cardNudges.forEach { cardNudge in
                cardNudge.state.subtitle = (isOn ? "Subtitle" : nil)
            }
        case .accentIcon:
            cardNudges.forEach { cardNudge in
                cardNudge.state.accentIcon = (isOn ? UIImage(named: "ic_fluent_presence_blocked_10_regular", in: FluentUIFramework.resourceBundle, with: nil) : nil)
            }
        case .accentText:
            cardNudges.forEach { cardNudge in
                cardNudge.state.accentText = (isOn ? "Accent" : nil)
            }
        case .dismissButton:
            cardNudges.forEach { cardNudge in
                cardNudge.state.dismissButtonAction = (isOn ? { state in
                    let alert = UIAlertController(title: "\(state.title) was dismissed", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } : nil)
            }
        case .actionButton:
            cardNudges.forEach { cardNudge in
                cardNudge.state.actionButtonTitle = (isOn ? "Action" : nil)
                cardNudge.state.actionButtonAction = (isOn ? { state in
                    let alert = UIAlertController(title: "\(state.title) action performed", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } : nil)
            }
        }
    }

    private func setupPropertyToggleCell(_ cell: BooleanCell, for row: CardNudgeDemoRow) {
        cell.setup(title: "\(row.text)")
        cell.selectionStyle = .none
        cell.isOn = true
        cell.onValueChanged = { [weak self, row, weak cell] in
            guard let isOn = cell?.isOn, let strongSelf = self else {
                return
            }
            strongSelf.updateSetting(for: row, isOn: isOn)
            strongSelf.updateCardNudgeSize()
        }
    }

    @objc private func updateCardNudgeSize() {
        // Needs a delay because the constraints update asynchronously, but we don't
        // have a good way to know when it's done.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView?.reloadSections(IndexSet([0]), with: .none)
        }
    }

    private var cardNudges: [MSFCardNudge] = {
        var cardNudges: [MSFCardNudge] = []
        MSFCardNudgeStyle.allCases.forEach { style in
            let nudge = MSFCardNudge(style: style, title: (style == .outline ? "Outline" : "Standard"))
            cardNudges.append(nudge)
        }

        return cardNudges
    }()

    private static let controlReuseIdentifier: String = "controlReuseIdentifier"

    private enum CardNudgeDemoSection: CaseIterable {
        case cards
        case settings

        var title: String {
            switch self {
            case .cards:
                return "Cards"
            case .settings:
                return "Settings"
            }
        }

        var rows: [CardNudgeDemoRow] {
            switch self {
            case .cards:
                return [.standardCard,
                        .outlineCard]
            case .settings:
                return [.mainIcon,
                        .subtitle,
                        .accentIcon,
                        .accentText,
                        .dismissButton,
                        .actionButton]
            }
        }
    }

    enum CardNudgeDemoRow: CaseIterable {
        case standardCard
        case outlineCard
        case mainIcon
        case subtitle
        case accentIcon
        case accentText
        case dismissButton
        case actionButton

        var text: String {
            switch self {
            case .standardCard,
                 .outlineCard:
                return ""
            case .mainIcon:
                return "Main Icon"
            case .subtitle:
                return "Subtitle"
            case .accentIcon:
                return "Accent Icon"
            case .accentText:
                return "Accent"
            case .dismissButton:
                return "Dismiss Button"
            case .actionButton:
                return "Action Button"
            }
        }
    }
}
