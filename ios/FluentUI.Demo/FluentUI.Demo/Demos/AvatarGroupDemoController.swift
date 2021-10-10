//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: - AvatarGroupDemoController

class AvatarGroupDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)

        initDemoAvatarGroups()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return AvatarGroupDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AvatarGroupDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AvatarGroupDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return AvatarGroupDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch AvatarGroupDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(AvatarGroupDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = AvatarGroupDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell

        case .avatarCount:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }

            cell.setup(action1Title: "Increase Avatar Count", action2Title: "Decrease Avatar Count", action1Type: .regular, action2Type: .regular)
            cell.action1Button.addTarget(self, action: #selector(addAvatarCount(_:)), for: UIControl.Event.touchUpInside)
            cell.action2Button.addTarget(self, action: #selector(subtractAvatarCount(_:)), for: UIControl.Event.touchUpInside)

            return cell

        case .alternateBackground:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title, isOn: self.isUsingAlternateBackgroundColor)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.isUsingAlternateBackgroundColor = cell?.isOn ?? true
            }

            return cell

        case .maxDisplayedAvatars,
             .overflow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let buttonView: [UIView] = {
                switch row {
                case .maxDisplayedAvatars:
                    return [maxAvatarsTextField, maxAvatarButton.view]
                case .overflow:
                    return [overflowCountTextField, overflowCountButton.view]
                default:
                    return []
                }
            }()

            let stackView = UIStackView(arrangedSubviews: buttonView)
            stackView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: 120,
                                     height: 40)
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 4

            cell.setup(title: row.title, customAccessoryView: stackView)
            cell.titleNumberOfLines = 0
            return cell

        case .xxlargeTitle,
             .xlargeTitle,
             .largeTitle,
             .mediumTitle,
             .smallTitle,
             .xsmallTitle:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title)
            cell.titleNumberOfLines = 0
            return cell

        case .xxlargeGroupView,
             .xlargeGroupView,
             .largeGroupView,
             .mediumGroupView,
             .smallGroupView,
             .xsmallGroupView:
            let cell = UITableViewCell()

            guard let avatarGroup = demoAvatarGroupsBySection[section]?[row] else {
                return cell
            }

            let avatarGroupView = avatarGroup.view
            avatarGroupView.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(avatarGroupView)
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: avatarGroupView.leadingAnchor, constant: -20),
                cell.contentView.topAnchor.constraint(equalTo: avatarGroupView.topAnchor, constant: -15),
                cell.contentView.bottomAnchor.constraint(equalTo: avatarGroupView.bottomAnchor, constant: 15)
            ])

            cell.backgroundColor = self.isUsingAlternateBackgroundColor ? Colors.tableCellBackgroundSelected : Colors.tableCellBackground

            return cell
        }
    }

    // MARK: - Helpers

    private let avatarSizes: [MSFAvatarSize] = MSFAvatarSize.allCases.reversed()

    private enum AvatarGroupDemoSection: CaseIterable {
        case swiftUI
        case settings
        case avatarStackNoBorder
        case avatarStackWithBorder
        case avatarStackWithMixedBorder
        case avatarPileNoBorder
        case avatarPileWithBorder
        case avatarPileWithMixedBorder

        var avatarStyle: MSFAvatarGroupStyle {
            switch self {
            case .avatarStackNoBorder,
                 .avatarStackWithBorder,
                 .avatarStackWithMixedBorder:
                return .stack
            case .avatarPileNoBorder,
                 .avatarPileWithBorder,
                 .avatarPileWithMixedBorder:
                return .pile
            case .settings,
                 .swiftUI:
                preconditionFailure("\(self.title) rows should not display an Avatar Group")
            }
        }

        var showBorders: Bool {
            switch self {
            case .avatarStackNoBorder,
                 .avatarPileNoBorder:
                return false
            case .avatarStackWithBorder,
                 .avatarStackWithMixedBorder,
                 .avatarPileWithBorder,
                 .avatarPileWithMixedBorder:
                return true
            case .settings,
                 .swiftUI:
                preconditionFailure("\(self.title) rows should not display an Avatar Group")
            }
        }

        var isMixedBorder: Bool {
            switch self {
            case .avatarPileWithMixedBorder,
                 .avatarStackWithMixedBorder:
                return true
            case .avatarStackWithBorder,
                 .avatarStackNoBorder,
                 .avatarPileWithBorder,
                 .avatarPileNoBorder:
                return false
            case .settings,
                 .swiftUI:
                preconditionFailure("\(self.title) rows should not display an Avatar Group")
            }
        }

        var isDemoSection: Bool {
            switch self {
            case .avatarPileWithMixedBorder,
                 .avatarStackWithMixedBorder,
                 .avatarStackWithBorder,
                 .avatarStackNoBorder,
                 .avatarPileWithBorder,
                 .avatarPileNoBorder:
                return true
            case .settings,
                 .swiftUI:
                return false
            }
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .settings:
                return "Settings"
            case .avatarStackNoBorder:
                return "Avatar Stack No Border"
            case .avatarStackWithBorder:
                return "Avatar Stack With Border"
            case .avatarStackWithMixedBorder:
                return "Avatar Stack With Mixed Border"
            case .avatarPileNoBorder:
                return "Avatar Pile No Border"
            case .avatarPileWithBorder:
                return "Avatar Pile With Border"
            case .avatarPileWithMixedBorder:
                return "Avatar Pile With Mixed Border"
            }
        }

        var rows: [AvatarGroupDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .settings:
                return [.avatarCount,
                        .alternateBackground,
                        .maxDisplayedAvatars,
                        .overflow]
            case .avatarStackNoBorder,
                 .avatarStackWithBorder,
                 .avatarStackWithMixedBorder,
                 .avatarPileNoBorder,
                 .avatarPileWithBorder,
                 .avatarPileWithMixedBorder:
                return [.xxlargeTitle,
                        .xxlargeGroupView,
                        .xlargeTitle,
                        .xlargeGroupView,
                        .largeTitle,
                        .largeGroupView,
                        .mediumTitle,
                        .mediumGroupView,
                        .smallTitle,
                        .smallGroupView,
                        .xsmallTitle,
                        .xsmallGroupView]
            }
        }
    }

    private enum AvatarGroupDemoRow: CaseIterable {
        case swiftUIDemo
        case avatarCount
        case alternateBackground
        case maxDisplayedAvatars
        case overflow
        case xxlargeTitle
        case xxlargeGroupView
        case xlargeTitle
        case xlargeGroupView
        case largeTitle
        case largeGroupView
        case mediumTitle
        case mediumGroupView
        case smallTitle
        case smallGroupView
        case xsmallTitle
        case xsmallGroupView

        var isDemoRow: Bool {
            switch self {
            case .xxlargeGroupView,
                 .xlargeGroupView,
                 .largeGroupView,
                 .mediumGroupView,
                 .smallGroupView,
                 .xsmallGroupView:
                return true
            case .xxlargeTitle,
                 .xlargeTitle,
                 .largeTitle,
                 .mediumTitle,
                 .smallTitle,
                 .xsmallTitle,
                 .avatarCount,
                 .alternateBackground,
                 .maxDisplayedAvatars,
                 .overflow,
                 .swiftUIDemo:
                return false
            }
        }

        var avatarSize: MSFAvatarSize {
            switch self {
            case .xxlargeGroupView:
                return .xxlarge
            case .xlargeGroupView:
                return .xlarge
            case .largeGroupView:
                return .large
            case .mediumGroupView:
                return .medium
            case .smallGroupView:
                return .small
            case .xsmallGroupView:
                return .xsmall
            case .xxlargeTitle,
                 .xlargeTitle,
                 .largeTitle,
                 .mediumTitle,
                 .smallTitle,
                 .xsmallTitle,
                 .avatarCount,
                 .alternateBackground,
                 .maxDisplayedAvatars,
                 .overflow,
                 .swiftUIDemo:
                preconditionFailure("Row should not display an Avatar Group")
            }
        }

        var title: String {
            switch self {
            case .avatarCount:
                return "Avatar count"
            case .alternateBackground:
                return "Use alternate background color"
            case.maxDisplayedAvatars:
                return "Max displayed avatars"
            case .overflow:
                return "Overflow count"
            case .swiftUIDemo:
                return "SwiftUI Demo"
            case .xxlargeTitle:
                return "ExtraExtraLarge"
            case .xlargeTitle:
                return "ExtraLarge"
            case .largeTitle:
                return "Large"
            case .mediumTitle:
                return "Medium"
            case .smallTitle:
                return "Small"
            case .xsmallTitle:
                return "ExtraSmall"
            case .xxlargeGroupView,
                 .xlargeGroupView,
                 .largeGroupView,
                 .mediumGroupView,
                 .smallGroupView,
                 .xsmallGroupView:
                preconditionFailure("Row should not have title")
            }
        }
    }

    private var maxDisplayedAvatars: Int = 4 {
        didSet {
            if oldValue != maxDisplayedAvatars {
                maxAvatarsTextField.text = "\(maxDisplayedAvatars)"

                for avatarGroup in allDemoAvatarGroupsCombined {
                    avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
                }
            }
        }
    }

    private lazy var maxAvatarButton: MSFButton = {
        let maxAvatarButton = MSFButton(style: .secondary,
                                        size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.maxAvatarsTextField.text,
               let count = Int(text) {
                strongSelf.maxDisplayedAvatars = count
                button.state.isDisabled = true
            }

            strongSelf.maxAvatarsTextField.resignFirstResponder()
        }

        let maxAvatarButtonState = maxAvatarButton.state
        maxAvatarButtonState.text = "Set"
        maxAvatarButtonState.isDisabled = true

        return maxAvatarButton
    }()

    private lazy var maxAvatarsTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(maxDisplayedAvatars)"
        textField.isEnabled = true

        return textField
    }()

    private var overflowCount: Int = 0 {
        didSet {
            if oldValue != overflowCount {
                overflowCountTextField.text = "\(overflowCount)"

                for avatarGroup in allDemoAvatarGroupsCombined {
                    avatarGroup.state.overflowCount = overflowCount
                }
            }
        }
    }

    private lazy var overflowCountButton: MSFButton = {
        let overflowCountButton = MSFButton(style: .secondary, size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.overflowCountTextField.text,
               let count = Int(text) {
                strongSelf.overflowCount = count
                button.state.isDisabled = true
            }

            strongSelf.overflowCountTextField.resignFirstResponder()
        }

        let overflowCountButtonState = overflowCountButton.state
        overflowCountButtonState.text = "Set"
        overflowCountButtonState.isDisabled = true

        return overflowCountButton
    }()

    private lazy var overflowCountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(overflowCount)"
        textField.isEnabled = true

        return textField
    }()

    private var avatarCount: Int = 5 {
        didSet {
            AvatarGroupDemoSection.allCases.filter({ section in
                return section.isDemoSection
            }).forEach { section in
                var avatarGroupsForCurrentSection: [AvatarGroupDemoRow: MSFAvatarGroup] = [:]

                AvatarGroupDemoRow.allCases.filter({ row in
                    return row.isDemoRow
                }).forEach { row in
                    let avatarGroup = demoAvatarGroupsBySection[section]![row]
                    if oldValue < avatarCount {
                        let avatarState = avatarGroup?.state.createAvatar()
                        for index in 0...avatarCount - 1 {
                            let samplePersona = samplePersonas[index]
                            avatarState!.image = samplePersona.image
                            avatarState!.isRingVisible = section.isMixedBorder ? index % 2 == 0 : section.showBorders
                            avatarState!.primaryText = samplePersona.name
                            avatarState!.secondaryText = samplePersona.email
                        }
                    } else {
                        avatarGroup?.state.removeAvatar(at: avatarCount)
                    }

                    avatarGroupsForCurrentSection.updateValue(avatarGroup!, forKey: row)
                }
                demoAvatarGroupsBySection.updateValue(avatarGroupsForCurrentSection, forKey: section)
            }
        }
    }

    @objc private func addAvatarCount(_ cell: ActionsCell) {
        avatarCount += 1
    }

    @objc private func subtractAvatarCount(_ cell: ActionsCell) {
        avatarCount -= 1
    }

    @objc private func toggleAlternateBackground(_ cell: BooleanCell) {
        isUsingAlternateBackgroundColor = cell.isOn
    }

    private var isUsingAlternateBackgroundColor: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    private func updateBackgroundColor() {
        self.tableView.reloadData()
    }

    private var allDemoAvatarGroupsCombined: [MSFAvatarGroup] = []

    private var demoAvatarGroupsBySection: [AvatarGroupDemoSection: [AvatarGroupDemoRow: MSFAvatarGroup]] = [:]

    private func initDemoAvatarGroups() {
        AvatarGroupDemoSection.allCases.filter({ section in
            return section.isDemoSection
        }).forEach { section in
            var avatarGroupsForCurrentSection: [AvatarGroupDemoRow: MSFAvatarGroup] = [:]

            AvatarGroupDemoRow.allCases.filter({ row in
                return row.isDemoRow
            }).forEach { row in
                let avatarGroup = MSFAvatarGroup(style: section.avatarStyle,
                                       size: row.avatarSize)
                for index in 0...avatarCount - 1 {
                    let avatarState = avatarGroup.state.createAvatar()
                    let samplePersona = samplePersonas[index]
                    avatarState.image = samplePersona.image
                    avatarState.isRingVisible = section.isMixedBorder ? index % 2 == 0 : section.showBorders
                    avatarState.primaryText = samplePersona.name
                    avatarState.secondaryText = samplePersona.email
                }

                avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
                avatarGroup.state.overflowCount = overflowCount
                avatarGroupsForCurrentSection.updateValue(avatarGroup, forKey: row)
                allDemoAvatarGroupsCombined.append(avatarGroup)
            }
            demoAvatarGroupsBySection.updateValue(avatarGroupsForCurrentSection, forKey: section)
        }
    }
}

// MARK: - AvatarGroupDemoController: UITextFieldDelegate

extension AvatarGroupDemoController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        guard let stringRange = Range(range, in: text) else {
            return false
        }

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        var shouldChangeCharacters = allowedCharacters.isSuperset(of: characterSet)

        if shouldChangeCharacters {
            text = text.replacingCharacters(in: stringRange, with: string)
            shouldChangeCharacters = text.count <= 4
        }

        let button = textField == maxAvatarsTextField ? maxAvatarButton : overflowCountButton
        if let count = UInt(text) {
            if textField == maxAvatarsTextField {
                button.state.isDisabled = count <= 0 || count == maxDisplayedAvatars
            } else {
                button.state.isDisabled = count == overflowCount
            }
        } else {
            button.state.isDisabled = true
        }

        return shouldChangeCharacters
    }
}
