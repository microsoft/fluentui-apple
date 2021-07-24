//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)

        initDemoAvatars()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AvatarDemoSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AvatarDemoSections.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = AvatarDemoSections.allCases[indexPath.section]
        let row = AvatarDemoSections.allCases[indexPath.section].rows[indexPath.row]

        switch row {
        case .alternateBackground,
             .imageBasedRingColor,
             .outOfOffice,
             .pointerInteraction,
             .presence,
             .ringInnerGap,
             .ring,
             .transparency:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title, isOn: self.isSettingOn(row: row))
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.updateSetting(for: row, isOn: cell?.isOn ?? true)
            }

            return cell

        case .accentWithFallback,
             .defaultWithImage,
             .defaultWithInitials,
             .defaultWithFallback,
             .groupWithImage,
             .groupWithInitials,
             .outlinedWithFallback,
             .outlinedPrimaryWithFallback,
             .overflow:
            let cell = UITableViewCell()

            guard let avatar = demoAvatarsBySection[section]?[row] else {
                return cell
            }

            let avatarView = avatar.view

            let titleLabel = Label(style: .body, colorStyle: .regular)
            titleLabel.text = row.title
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

            let avatarContentView = UIStackView(arrangedSubviews: [avatarView, titleLabel])
            avatarContentView.isLayoutMarginsRelativeArrangement = true
            avatarContentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
            avatarContentView.translatesAutoresizingMaskIntoConstraints = false
            avatarContentView.alignment = .leading
            avatarContentView.distribution = .fill
            avatarContentView.spacing = 10

            cell.contentView.addSubview(avatarContentView)
            NSLayoutConstraint.activate([
                avatarView.widthAnchor.constraint(equalToConstant: 100),
                avatarView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                cell.contentView.leadingAnchor.constraint(equalTo: avatarContentView.leadingAnchor),
                cell.contentView.trailingAnchor.constraint(equalTo: avatarContentView.trailingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: avatarContentView.topAnchor),
                cell.contentView.bottomAnchor.constraint(equalTo: avatarContentView.bottomAnchor)
            ])

            cell.backgroundColor = self.isUsingAlternateBackgroundColor ? Colors.tableCellBackgroundSelected : Colors.tableCellBackground

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AvatarDemoSections.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
       return false
    }

    private var isUsingAlternateBackgroundColor: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    private var isPointerInteractionEnabled: Bool = false {
        didSet {
            if oldValue != isPointerInteractionEnabled {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.hasPointerInteraction = isPointerInteractionEnabled
                }
            }
        }
    }

    private var isShowingPresence: Bool = false {
        didSet {
            if oldValue != isShowingPresence {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.presence = isShowingPresence ? nextPresence() : .none
                }
            }
        }
    }

    private var isOutOfOffice: Bool = false {
        didSet {
            if oldValue != isOutOfOffice {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.isOutOfOffice = isOutOfOffice
                }
            }
        }
    }

    private var isShowingRings: Bool = false {
        didSet {
            if oldValue != isShowingRings {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.isRingVisible = isShowingRings
                }
            }
        }
    }

    private var isUsingImageBasedCustomColor: Bool = false {
        didSet {
            if oldValue != isUsingImageBasedCustomColor {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.imageBasedRingColor = isUsingImageBasedCustomColor ? colorfulCustomImage : nil
                }
            }
        }
    }

    private var isShowingRingInnerGap: Bool = true {
        didSet {
            if oldValue != isShowingRingInnerGap {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.hasRingInnerGap = isShowingRingInnerGap
                }
            }
        }
    }

    private var isTransparent: Bool = true {
        didSet {
            if oldValue != isTransparent {
                for avatar in allDemoAvatarsCombined {
                    avatar.state.isTransparent = isTransparent
                }
            }
        }
    }

    private lazy var presenceIterator = MSFAvatarPresence.allCases.makeIterator()

    private var colorfulCustomImage: UIImage? {
        let gradientColors = [
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor,
            UIColor(red: 0.18, green: 0.45, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.36, green: 0.80, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.72, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.97, green: 0.78, blue: 0.27, alpha: 1).cgColor,
            UIColor(red: 0.94, green: 0.52, blue: 0.20, alpha: 1).cgColor,
            UIColor(red: 0.92, green: 0.26, blue: 0.16, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor]

        let colorfulGradient = CAGradientLayer()
        let size = CGSize(width: 76, height: 76)
        colorfulGradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        colorfulGradient.colors = gradientColors
        colorfulGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        colorfulGradient.endPoint = CGPoint(x: 0.5, y: 0)
        colorfulGradient.type = .conic

        var customBorderImage: UIImage?
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            colorfulGradient.render(in: context)
            customBorderImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return customBorderImage
    }

    private var allDemoAvatarsCombined: [MSFAvatar] = []

    private var demoAvatarsBySection: [AvatarDemoSections: [AvatarDemoRows: MSFAvatar]] = [:]

    private func initDemoAvatars() {
        AvatarDemoSections.allCases.filter({ section in
            return !section.isSettingsSection
        }).forEach { section in
            var avatarsForCurrentSection: [AvatarDemoRows: MSFAvatar] = [:]

            AvatarDemoRows.allCases.filter({ row in
                return !row.isSettingsRow
            }).forEach { row in
                let avatar = MSFAvatar(style: row.avatarStyle,
                                       size: section.avatarSize)
                let avatarState = avatar.state
                avatarState.primaryText = row.avatarPrimaryText
                avatarState.image = row.avatarImage

                avatarsForCurrentSection.updateValue(avatar, forKey: row)
                allDemoAvatarsCombined.append(avatar)
            }

            demoAvatarsBySection.updateValue(avatarsForCurrentSection, forKey: section)
        }
    }

    private func nextPresence() -> MSFAvatarPresence {
        var presence = presenceIterator.next()

        if presence == nil {
            presenceIterator = MSFAvatarPresence.allCases.makeIterator()
            presence = presenceIterator.next()
        }

        if presence! ==  .none {
            presence = presenceIterator.next()
        }

        return presence!
    }

    @objc private func toggleEnablePointerInteraction(switchView: UISwitch) {
        isPointerInteractionEnabled = switchView.isOn
    }

    @objc private func toggleShowPresence(switchView: UISwitch) {
        isShowingPresence = switchView.isOn
    }

    @objc private func toggleOutOfOffice(switchView: UISwitch) {
        isOutOfOffice = switchView.isOn
    }

    @objc private func toggleShowRings(switchView: UISwitch) {
        isShowingRings = switchView.isOn
    }

    @objc private func toggleImageBasedCustomRingColor(switchView: UISwitch) {
        isUsingImageBasedCustomColor = switchView.isOn
    }

    @objc private func toggleShowRingInnerGap(switchView: UISwitch) {
        isShowingRingInnerGap = switchView.isOn
    }

    @objc private func toggleAlternateBackground(switchView: UISwitch) {
        isUsingAlternateBackgroundColor = switchView.isOn
    }

    @objc private func toggleOpaqueBorders(switchView: UISwitch) {
        isTransparent = !switchView.isOn
    }

    private func updateBackgroundColor() {
        self.tableView.reloadData()
    }

    private func isSettingOn(row: AvatarDemoRows) -> Bool {
        switch row {
        case .accentWithFallback,
             .defaultWithImage,
             .defaultWithInitials,
             .defaultWithFallback,
             .groupWithImage,
             .groupWithInitials,
             .outlinedWithFallback,
             .outlinedPrimaryWithFallback,
             .overflow:
            return true
        case .alternateBackground:
            return self.isUsingAlternateBackgroundColor
        case .imageBasedRingColor:
            return self.isUsingImageBasedCustomColor
        case .outOfOffice:
            return self.isOutOfOffice
        case .pointerInteraction:
            return self.isPointerInteractionEnabled
        case .presence:
            return self.isShowingPresence
        case .ring:
            return self.isShowingRings
        case .ringInnerGap:
            return self.isShowingRingInnerGap
        case .transparency:
            return self.isTransparent
        }
    }

    private func updateSetting(for row: AvatarDemoRows, isOn: Bool) {
        switch row {
        case .accentWithFallback,
             .defaultWithImage,
             .defaultWithInitials,
             .defaultWithFallback,
             .groupWithImage,
             .groupWithInitials,
             .outlinedWithFallback,
             .outlinedPrimaryWithFallback,
             .overflow:
            return
        case .alternateBackground:
            self.isUsingAlternateBackgroundColor = isOn
        case .imageBasedRingColor:
            self.isUsingImageBasedCustomColor = isOn
        case .outOfOffice:
            self.isOutOfOffice = isOn
        case .pointerInteraction:
            self.isPointerInteractionEnabled = isOn
        case .presence:
            self.isShowingPresence = isOn
        case .ring:
            self.isShowingRings = isOn
        case .ringInnerGap:
            self.isShowingRingInnerGap = isOn
        case .transparency:
            self.isTransparent = isOn
        }
    }

    private enum AvatarDemoSections: CaseIterable {
        case settings
        case xxlarge
        case xlarge
        case large
        case medium
        case small
        case xsmall

        var avatarSize: MSFAvatarSize {
            switch self {
            case .xxlarge:
                return .xxlarge
            case .xlarge:
                return .xlarge
            case .large:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            case .xsmall:
                return .xsmall
            case .settings:
                preconditionFailure("Settings rows should not display an Avatar")
            }
        }

        var isSettingsSection: Bool {
            return self == .settings
        }

        var title: String {
            switch self {
            case .settings:
                return "Settings"
            case .xxlarge:
                return "ExtraExtraLarge"
            case .xlarge:
                return "ExtraLarge"
            case .large:
                return "Large"
            case .medium:
                return "Medium"
            case .small:
                return "Small"
            case .xsmall:
                return "ExtraSmall"
            }
        }

        var rows: [AvatarDemoRows] {
            switch self {
            case .settings:
                return [.alternateBackground,
                        .pointerInteraction,
                        .transparency,
                        .presence,
                        .outOfOffice,
                        .ring,
                        .ringInnerGap,
                        .imageBasedRingColor]
            case .xxlarge,
                 .xlarge,
                 .large,
                 .medium,
                 .small,
                 .xsmall:
                return [.defaultWithImage,
                        .defaultWithInitials,
                        .defaultWithFallback,
                        .accentWithFallback,
                        .outlinedWithFallback,
                        .outlinedPrimaryWithFallback,
                        .groupWithImage,
                        .groupWithInitials,
                        .overflow]
            }
        }
    }

    private enum AvatarDemoRows: CaseIterable {
        case accentWithFallback
        case alternateBackground
        case defaultWithImage
        case defaultWithInitials
        case defaultWithFallback
        case imageBasedRingColor
        case groupWithImage
        case groupWithInitials
        case outlinedWithFallback
        case outlinedPrimaryWithFallback
        case outOfOffice
        case overflow
        case pointerInteraction
        case presence
        case ring
        case ringInnerGap
        case transparency

        var isSettingsRow: Bool {
            switch self {
            case .accentWithFallback,
                 .defaultWithFallback,
                 .defaultWithImage,
                 .defaultWithInitials,
                 .groupWithImage,
                 .groupWithInitials,
                 .outlinedPrimaryWithFallback,
                 .outlinedWithFallback,
                 .overflow:
                return false
            case .alternateBackground,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .ring,
                 .ringInnerGap,
                 .transparency:
                return true
            }
        }

        var avatarImage: UIImage? {
            switch self {
            case .defaultWithImage:
                return UIImage(named: "avatar_kat_larsson")
            case .groupWithImage:
                return UIImage(named: "site")
            case .accentWithFallback,
                 .defaultWithFallback,
                 .defaultWithInitials,
                 .groupWithInitials,
                 .outlinedPrimaryWithFallback,
                 .outlinedWithFallback,
                 .overflow,
                 .alternateBackground,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .ring,
                 .ringInnerGap,
                 .transparency:
                return nil
            }
        }

        var avatarPrimaryText: String? {
            switch self {
            case .defaultWithImage,
                 .defaultWithInitials:
                return "Kat Larrson"
            case .groupWithImage,
                 .groupWithInitials:
                 return "NorthWind Traders"
            case .accentWithFallback,
                 .defaultWithFallback,
                 .outlinedPrimaryWithFallback,
                 .outlinedWithFallback:
                return "+1 (425) 123 4567"
            case .overflow:
                return "20"
            case .alternateBackground,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .ring,
                 .ringInnerGap,
                 .transparency:
                return nil
            }
        }

        var avatarStyle: MSFAvatarStyle {
            switch self {
            case .defaultWithImage,
                 .defaultWithFallback,
                 .defaultWithInitials:
                return .default
            case .groupWithImage,
                 .groupWithInitials:
                return .group
            case .accentWithFallback:
                return .accent
            case .outlinedPrimaryWithFallback:
                return .outlinedPrimary
            case .outlinedWithFallback:
                return .outlined
            case .overflow:
                return .overflow
            case .alternateBackground,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .ring,
                 .ringInnerGap,
                 .transparency:
                preconditionFailure("Row does not have an associated avatar style")
            }
        }

        var title: String {
            switch self {
            case .accentWithFallback:
                return "Accent style (no initials, no image)"
            case .alternateBackground:
                return "Use alternate background color"
            case.defaultWithImage:
                return "Default style (image)"
            case .defaultWithInitials:
                return "Default style (initials)"
            case .defaultWithFallback:
                return "Default style (no initials, no image)"
            case .imageBasedRingColor:
                return "Use image based custom ring color"
            case .groupWithImage:
                return "Group style (image)"
            case .groupWithInitials:
                return "Group style (initials)"
            case .outlinedWithFallback:
                return "Outlined style (no initials, no image)"
            case .outlinedPrimaryWithFallback:
                return "Outlined Primary style (no initials, no image)"
            case .outOfOffice:
                return "Set \"Out Of Office\""
            case .overflow:
                return "Overflow style"
            case .pointerInteraction:
                return "Enable iPad pointer interaction"
            case .presence:
                return "Show presence"
            case .ring:
                return "Show ring"
            case .ringInnerGap:
                return "Set ring inner gap"
            case .transparency:
                return "Use transparency"
            }
        }
    }
}
