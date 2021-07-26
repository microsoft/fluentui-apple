//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CardNudgeDemoController: UITableViewController {
    enum CardControls: Int, CaseIterable {
        case mainIcon
        case subtitle
        case accentIcon
        case accentText
        case dismissButton
        case actionButton

        var text: String {
            switch self {
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .plain)

        self.prepareCardNudgeViews()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CardNudgeDemoController.controlReuseIdentifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return CardNudgeViewStyle.allCases.count
        case 1:
            return CardControls.allCases.count
        default:
            preconditionFailure("Counting rows in unknown section")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CardNudgeDemoController.controlReuseIdentifier, for: indexPath)

            let view = cardNudges[indexPath.item]
            cell.contentView.addSubview(view)
            cell.selectionStyle = .none
            cell.backgroundColor = .systemBackground
            view.translatesAutoresizingMaskIntoConstraints = false

            let constraints = [
                view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
                view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
            ]

            cell.contentView.addConstraints(constraints)

            return cell
        } else {
            if let cell: BooleanCell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier, for: indexPath) as? BooleanCell {
                setupPropertyToggleCell(cell, at: indexPath)
                return cell
            } else {
                preconditionFailure("Wrong kind of cell in BooleanCell index path")
            }
        }
    }

    // MARK: - Helpers

    fileprivate func setupPropertyToggleCell(_ cell: BooleanCell, at indexPath: IndexPath) {
        let control = CardControls.allCases[indexPath.item]
        cell.setup(title: "\(control.text)")
        cell.selectionStyle = .none
        cell.onValueChanged = { [weak tableView, control, cardNudges, weak cell] in
            guard let isOn = cell?.isOn else {
                return
            }
            switch control {
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
                    cardNudge.state.accentText = (isOn ? "Accent Text" : nil)
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

            // Needs a delay because the constraints update asynchronously, but we don't
            // have a good way to know when it's done.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                tableView?.reloadSections(IndexSet([0]), with: .none)
            }
        }
    }

    private func prepareCardNudgeViews() {
        CardNudgeViewStyle.allCases.forEach { style in
            let nudge = MSFCardNudgeView(style: style, title: (style == .outline ? "Outline" : "Standard"))
            cardNudges.append(nudge)
        }
    }

    private var cardNudges: [MSFCardNudgeView] = []

    private static let controlReuseIdentifier: String = "controlReuseIdentifier"
}
