//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: - AvatarGroupDemoController

class AvatarGroupDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        initDemoAvatarGroups()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "An avatar group shows multiple avatars."
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
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = AvatarGroupDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
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

        case .customRingColor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title, isOn: self.isUsingImageBasedCustomColor)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.isUsingImageBasedCustomColor = cell?.isOn ?? true
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
                    return [maxAvatarsTextField, maxAvatarButton]
                case .overflow:
                    return [overflowCountTextField, overflowCountButton]
                default:
                    return []
                }
            }()

            let stackView = UIStackView(arrangedSubviews: buttonView)
            stackView.shouldGroupAccessibilityChildren = true
            stackView.accessibilityElements = buttonView
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

        case .titleSize72,
             .titleSize56,
             .titleSize40,
             .titleSize32,
             .titleSize24,
             .titleSize20,
             .titleSize16:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.accessibilityTraits = .header
            cell.setup(title: row.title)
            cell.titleNumberOfLines = 0
            return cell

        case .groupViewSize72,
             .groupViewSize56,
             .groupViewSize40,
             .groupViewSize32,
             .groupViewSize24,
             .groupViewSize20,
             .groupViewSize16:
            let cell = UITableViewCell()

            guard let avatarGroup = demoAvatarGroupsBySection[section]?[row] else {
                return cell
            }

            let avatarGroupView = avatarGroup
            avatarGroupView.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(avatarGroupView)
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: avatarGroupView.leadingAnchor, constant: -20),
                cell.contentView.topAnchor.constraint(equalTo: avatarGroupView.topAnchor, constant: -15),
                cell.contentView.bottomAnchor.constraint(equalTo: avatarGroupView.bottomAnchor, constant: 15),
                cell.contentView.trailingAnchor.constraint(equalTo: avatarGroupView.trailingAnchor, constant: 20)
            ])

            cell.backgroundConfiguration?.backgroundColor = self.isUsingAlternateBackgroundColor ? TableViewCell.tableCellBackgroundSelectedColor : TableViewCell.tableCellBackgroundColor

            return cell
        }
    }

    // MARK: - Helpers

    private enum AvatarGroupDemoSection: CaseIterable {
        case settings
        case avatarStackNoActivityRing
        case avatarStackWithActivityRing
        case avatarStackWithMixedActivityRing
        case avatarPileNoActivityRing
        case avatarPileWithActivityRing
        case avatarPileWithMixedActivityRing

        var avatarStyle: MSFAvatarGroupStyle {
            switch self {
            case .avatarStackNoActivityRing,
                 .avatarStackWithActivityRing,
                 .avatarStackWithMixedActivityRing:
                return .stack
            case .avatarPileNoActivityRing,
                 .avatarPileWithActivityRing,
                 .avatarPileWithMixedActivityRing:
                return .pile
            case .settings:
                preconditionFailure("Settings rows should not display an Avatar Group")
            }
        }

        var showActivityRing: Bool {
            switch self {
            case .avatarStackNoActivityRing,
                 .avatarPileNoActivityRing:
                return false
            case .avatarStackWithActivityRing,
                 .avatarStackWithMixedActivityRing,
                 .avatarPileWithActivityRing,
                 .avatarPileWithMixedActivityRing:
                return true
            case .settings:
                preconditionFailure("Settings rows should not display an Avatar Group")
            }
        }

        var isMixedActivityRing: Bool {
            switch self {
            case .avatarPileWithMixedActivityRing,
                 .avatarStackWithMixedActivityRing:
                return true
            case .avatarStackWithActivityRing,
                 .avatarStackNoActivityRing,
                 .avatarPileWithActivityRing,
                 .avatarPileNoActivityRing:
                return false
            case .settings:
                preconditionFailure("Settings rows should not display an Avatar Group")
            }
        }

        var isDemoSection: Bool {
            return self != .settings
        }

        var title: String {
            switch self {
            case .settings:
                return "Settings"
            case .avatarStackNoActivityRing:
                return "Avatar Stack No Activity Ring"
            case .avatarStackWithActivityRing:
                return "Avatar Stack With Activity Ring"
            case .avatarStackWithMixedActivityRing:
                return "Avatar Stack With Mixed Activity Ring"
            case .avatarPileNoActivityRing:
                return "Avatar Pile No Activity Ring"
            case .avatarPileWithActivityRing:
                return "Avatar Pile With Activity Ring"
            case .avatarPileWithMixedActivityRing:
                return "Avatar Pile With Mixed Activity Ring"
            }
        }

        var rows: [AvatarGroupDemoRow] {
            switch self {
            case .settings:
                return [.avatarCount,
                        .alternateBackground,
                        .customRingColor,
                        .maxDisplayedAvatars,
                        .overflow]
            case .avatarStackNoActivityRing,
                 .avatarStackWithActivityRing,
                 .avatarStackWithMixedActivityRing,
                 .avatarPileNoActivityRing,
                 .avatarPileWithActivityRing,
                 .avatarPileWithMixedActivityRing:
                return [.titleSize72,
                        .groupViewSize72,
                        .titleSize56,
                        .groupViewSize56,
                        .titleSize40,
                        .groupViewSize40,
                        .titleSize32,
                        .groupViewSize32,
                        .titleSize24,
                        .groupViewSize24,
                        .titleSize20,
                        .groupViewSize20,
                        .titleSize16,
                        .groupViewSize16]
            }
        }
    }

    private enum AvatarGroupDemoRow: CaseIterable {
        case avatarCount
        case alternateBackground
        case customRingColor
        case maxDisplayedAvatars
        case overflow
        case titleSize72
        case groupViewSize72
        case titleSize56
        case groupViewSize56
        case titleSize40
        case groupViewSize40
        case titleSize32
        case groupViewSize32
        case titleSize24
        case groupViewSize24
        case titleSize20
        case groupViewSize20
        case titleSize16
        case groupViewSize16

        var isDemoRow: Bool {
            switch self {
            case .groupViewSize72,
                 .groupViewSize56,
                 .groupViewSize40,
                 .groupViewSize32,
                 .groupViewSize24,
                 .groupViewSize20,
                 .groupViewSize16:
                return true
            case .titleSize72,
                 .titleSize56,
                 .titleSize40,
                 .titleSize32,
                 .titleSize24,
                 .titleSize20,
                 .titleSize16,
                 .avatarCount,
                 .alternateBackground,
                 .customRingColor,
                 .maxDisplayedAvatars,
                 .overflow:
                return false
            }
        }

        var avatarSize: MSFAvatarSize {
            switch self {
            case .groupViewSize72:
                return .size72
            case .groupViewSize56:
                return .size56
            case .groupViewSize40:
                return .size40
            case .groupViewSize32:
                return .size32
            case .groupViewSize24:
                return .size24
            case .groupViewSize20:
                return .size20
            case .groupViewSize16:
                return .size16
            case .titleSize72,
                 .titleSize56,
                 .titleSize40,
                 .titleSize32,
                 .titleSize24,
                 .titleSize20,
                 .titleSize16,
                 .avatarCount,
                 .alternateBackground,
                 .customRingColor,
                 .maxDisplayedAvatars,
                 .overflow:
                preconditionFailure("Row should not display an Avatar Group")
            }
        }

        var title: String {
            switch self {
            case .avatarCount:
                return "Avatar count"
            case .alternateBackground:
                return "Use alternate background color"
            case .customRingColor:
                return "Use image based custom ring color"
            case.maxDisplayedAvatars:
                return "Max displayed avatars"
            case .overflow:
                return "Overflow count"
            case .titleSize72:
                return "Size 72"
            case .titleSize56:
                return "Size 56"
            case .titleSize40:
                return "Size 40"
            case .titleSize32:
                return "Size 32"
            case .titleSize24:
                return "Size 24"
            case .titleSize20:
                return "Size 20"
            case .titleSize16:
                return "Size 16"
            case .groupViewSize72,
                 .groupViewSize56,
                 .groupViewSize40,
                 .groupViewSize32,
                 .groupViewSize24,
                 .groupViewSize20,
                 .groupViewSize16:
                preconditionFailure("Row should not have title")
            }
        }
    }

    private var maxDisplayedAvatars: Int = 3 {
        didSet {
            if oldValue != maxDisplayedAvatars {
                maxAvatarsTextField.text = "\(maxDisplayedAvatars)"

                for avatarGroup in allDemoAvatarGroupsCombined {
                    avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
                }
            }
        }
    }

    private lazy var maxAvatarButton: Button = {
        let button = Button()
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Set", for: .normal)
        button.addTarget(self, action: #selector(setMaxAvatarCount), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    @objc private func setMaxAvatarCount() {
        let oldMax = maxDisplayedAvatars

        if let text = maxAvatarsTextField.text, let newMax = Int(text) {
            if newMax < samplePersonas.count {
                maxDisplayedAvatars = newMax
            } else {
                maxDisplayedAvatars = samplePersonas.endIndex
                maxAvatarsTextField.text = "\(maxDisplayedAvatars)"
            }
            if oldMax < maxDisplayedAvatars {
                updateAvatarsCustomRingColor(for: oldMax..<min(maxDisplayedAvatars, avatarCount))
            }
            maxAvatarButton.isEnabled = false
        }

        maxAvatarsTextField.resignFirstResponder()
    }

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

    private lazy var overflowCountButton: Button = {
        let button = Button()
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Set", for: .normal)
        button.addTarget(self, action: #selector(setOverflowCount), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    @objc private func setOverflowCount() {
        if let text = overflowCountTextField.text, let count = Int(text) {
            overflowCount = count
            overflowCountButton.isEnabled = false
        }

        overflowCountTextField.resignFirstResponder()
    }

    private lazy var overflowCountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(overflowCount)"
        textField.isEnabled = true

        return textField
    }()

    private var avatarCount: Int = 4 {
        didSet {
            guard oldValue != avatarCount && avatarCount >= 0 else {
                return
            }
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
                        for index in 0..<avatarCount {
                            let samplePersona = samplePersonas[index]
                            avatarState!.image = samplePersona.image
                            avatarState!.isRingVisible = section.isMixedActivityRing ? index % 2 == 0 : section.showActivityRing
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
        guard avatarCount < samplePersonas.count else {
            return
        }

        avatarCount += 1
    }

    @objc private func subtractAvatarCount(_ cell: ActionsCell) {
        guard avatarCount > 0 else {
            return
        }

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

    private var isUsingImageBasedCustomColor: Bool = false {
        didSet {
            updateAvatarsCustomRingColor(for: 0..<avatarCount)
        }
    }

    private func updateAvatarsCustomRingColor(for range: Range<Int>) {
        for group in allDemoAvatarGroupsCombined {
            for index in range {
                let avatar = group.state.getAvatarState(at: index)
                avatar.imageBasedRingColor = isUsingImageBasedCustomColor ? AvatarDemoController.colorfulCustomImage : nil
            }
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
                for index in 0..<avatarCount {
                    let avatarState = avatarGroup.state.createAvatar()
                    let samplePersona = samplePersonas[index]
                    avatarState.image = samplePersona.image
                    avatarState.isRingVisible = section.isMixedActivityRing ? index % 2 == 0 : section.showActivityRing
                    avatarState.primaryText = samplePersona.name
                    avatarState.secondaryText = samplePersona.email
                }

                avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
                avatarGroup.state.overflowCount = overflowCount
                avatarGroup.state.isUnread = row.avatarSize == .size20
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
                button.isEnabled = count > 0 && count != maxDisplayedAvatars
            } else {
                button.isEnabled = count > 0 && count != overflowCount
            }
        } else {
            button.isEnabled = false
        }

        return shouldChangeCharacters
    }
}
