//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        initDemoAvatars()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "An avatar is a graphical representation of a person, group, or entity.\n\nIt can show images or text to represent the person, group, or entity, as well as give additional information like their status and activity. "

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AvatarDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AvatarDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = AvatarDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell

        case .alternateBackground,
             .animating,
             .outOfOffice,
             .pointerInteraction,
             .presence,
             .activity,
             .ringInnerGap,
             .backgroundOutline,
             .defaultImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title, isOn: self.isSettingOn(row: row))
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.updateSetting(for: row, isOn: cell?.isOn ?? true)
            }

            return cell

        case .imageBasedRingColor,
             .ring:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            cell.setup(title: row.title, isOn: self.isSettingOn(row: row))
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.updateSetting(for: row, isOn: cell?.isOn ?? true)
            }

            if row == .imageBasedRingColor {
                customRingIndexPath = indexPath
            } else {
                ringIndexPath = indexPath
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

            let avatarView = avatar

            let titleLabel = Label()
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

            var backgroundConfiguration = UIBackgroundConfiguration.clear()
            backgroundConfiguration.backgroundColor = self.isUsingAlternateBackgroundColor ? TableViewCell.tableCellBackgroundSelectedColor : TableViewCell.tableCellBackgroundColor
            cell.backgroundConfiguration = backgroundConfiguration

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AvatarDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return AvatarDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch AvatarDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(AvatarDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
    }

    private var ringIndexPath: IndexPath?
    private var customRingIndexPath: IndexPath?

    private var isAnimated: Bool = true {
        didSet {
            if oldValue != isAnimated {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.isAnimated = isAnimated
                }
            }
        }
    }

    private var isUsingAlternateBackgroundColor: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    private var isPointerInteractionEnabled: Bool = false {
        didSet {
            if oldValue != isPointerInteractionEnabled {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.hasPointerInteraction = isPointerInteractionEnabled
                }
            }
        }
    }

    private var isShowingPresence: Bool = false {
        didSet {
            if oldValue != isShowingPresence {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.presence = isShowingPresence ? nextPresence() : .none
                }
            }
        }
    }

    private var isShowingActivity: Bool = false {
        didSet {
            if oldValue != isShowingActivity {
                var activityStyle: MSFAvatarActivityStyle
                var isEven: Bool
                for index in 0 ..< allDemoAvatarsCombined.count {
                    isEven = index % 2 == 0
                    activityStyle = isEven ? .circle : .square
                    allDemoAvatarsCombined[index].state.activityStyle = isShowingActivity ? activityStyle : .none
                    allDemoAvatarsCombined[index].state.activityImage = isEven ? UIImage(named: "Placeholder_20")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "excelIcon")
                }
            }
        }
    }

    private var isOutOfOffice: Bool = false {
        didSet {
            if oldValue != isOutOfOffice {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.isOutOfOffice = isOutOfOffice
                }
            }
        }
    }

    private var isShowingRings: Bool = false {
        didSet {
            if oldValue != isShowingRings {
                switchOffCustomRingCell()
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.isRingVisible = isShowingRings
                }
            }
        }
    }

    private func switchOffCustomRingCell() {
        guard let customRingIndexPath = customRingIndexPath, !isShowingRings else {
            return
        }

        let cell = tableView.cellForRow(at: customRingIndexPath) as! BooleanCell
        cell.isOn = false
        updateSetting(for: .imageBasedRingColor, isOn: false)
    }

    private func switchOnRingCell() {
        guard let ringIndexPath = ringIndexPath, isUsingImageBasedCustomColor else {
            return
        }

        let cell = tableView.cellForRow(at: ringIndexPath) as! BooleanCell
        cell.isOn = true
        updateSetting(for: .ring, isOn: true)
    }

    private var isUsingImageBasedCustomColor: Bool = false {
        didSet {
            if oldValue != isUsingImageBasedCustomColor {
                switchOnRingCell()
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.imageBasedRingColor = isUsingImageBasedCustomColor ? AvatarDemoController.colorfulCustomImage : nil
                }
            }
        }
    }

    private var isShowingRingInnerGap: Bool = true {
        didSet {
            if oldValue != isShowingRingInnerGap {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.hasRingInnerGap = isShowingRingInnerGap
                }
            }
        }
    }

    private var hasBackgroundOutline: Bool = false {
        didSet {
            if oldValue != hasBackgroundOutline {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.hasBackgroundOutline = hasBackgroundOutline
                }
            }
        }
    }

    private var useCustomDefaultImage: Bool = false {
        didSet {
            if oldValue != useCustomDefaultImage {
                allDemoAvatarsCombined.forEach { avatar in
                    avatar.state.defaultImage = useCustomDefaultImage ? UIImage(named: "flag-48x48") : nil
                }
            }
        }
    }

    private lazy var presenceIterator = MSFAvatarPresence.allCases.makeIterator()

    static var colorfulCustomImage: UIImage? {
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

    private var demoAvatarsBySection: [AvatarDemoSection: [AvatarDemoRow: MSFAvatar]] = [:]

    private func initDemoAvatars() {
        AvatarDemoSection.allCases.filter({ section in
            return section.isDemoSection
        }).forEach { section in
            var avatarsForCurrentSection: [AvatarDemoRow: MSFAvatar] = [:]

            AvatarDemoRow.allCases.filter({ row in
                return row.isDemoRow
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

        if presence! == .none {
            presence = presenceIterator.next()
        }

        return presence!
    }

    private func updateBackgroundColor() {
        self.tableView.reloadData()
    }

    private func isSettingOn(row: AvatarDemoRow) -> Bool {
        switch row {
        case .accentWithFallback,
             .defaultWithImage,
             .defaultWithInitials,
             .defaultWithFallback,
             .groupWithImage,
             .groupWithInitials,
             .outlinedWithFallback,
             .outlinedPrimaryWithFallback,
             .overflow,
             .swiftUIDemo:
            return true
        case .alternateBackground:
            return self.isUsingAlternateBackgroundColor
        case .animating:
            return self.isAnimated
        case .imageBasedRingColor:
            return self.isUsingImageBasedCustomColor
        case .outOfOffice:
            return self.isOutOfOffice
        case .pointerInteraction:
            return self.isPointerInteractionEnabled
        case .presence:
            return self.isShowingPresence
        case .activity:
            return self.isShowingActivity
        case .ring:
            return self.isShowingRings
        case .ringInnerGap:
            return self.isShowingRingInnerGap
        case .backgroundOutline:
            return self.hasBackgroundOutline
        case .defaultImage:
            return self.useCustomDefaultImage
        }
    }

    private func updateSetting(for row: AvatarDemoRow, isOn: Bool) {
        switch row {
        case .accentWithFallback,
             .defaultWithImage,
             .defaultWithInitials,
             .defaultWithFallback,
             .groupWithImage,
             .groupWithInitials,
             .outlinedWithFallback,
             .outlinedPrimaryWithFallback,
             .overflow,
             .swiftUIDemo:
            return
        case .alternateBackground:
            self.isUsingAlternateBackgroundColor = isOn
        case .animating:
            self.isAnimated = isOn
        case .imageBasedRingColor:
            self.isUsingImageBasedCustomColor = isOn
        case .outOfOffice:
            self.isOutOfOffice = isOn
        case .pointerInteraction:
            self.isPointerInteractionEnabled = isOn
        case .presence:
            self.isShowingPresence = isOn
        case .activity:
            self.isShowingActivity = isOn
        case .ring:
            self.isShowingRings = isOn
        case .ringInnerGap:
            self.isShowingRingInnerGap = isOn
        case .backgroundOutline:
            self.hasBackgroundOutline = isOn
        case .defaultImage:
            self.useCustomDefaultImage = isOn
        }
    }

    private enum AvatarDemoSection: CaseIterable {
        case swiftUI
        case settings
        case size72
        case size56
        case size40
        case size32
        case size24
        case size20
        case size16

        var avatarSize: MSFAvatarSize {
            switch self {
            case .size72:
                return .size72
            case .size56:
                return .size56
            case .size40:
                return .size40
            case .size32:
                return .size32
            case .size24:
                return .size24
            case .size20:
                return .size20
            case .size16:
                return .size16
            case .swiftUI, .settings:
                preconditionFailure("Settings rows should not display an Avatar")
            }
        }

        var isDemoSection: Bool {
            return self != .settings && self != .swiftUI
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .settings:
                return "Settings"
            case .size72:
                return "Size 72"
            case .size56:
                return "Size 56"
            case .size40:
                return "Size 40"
            case .size32:
                return "Size 32"
            case .size24:
                return "Size 24"
            case .size20:
                return "Size 20"
            case .size16:
                return "Size 16"
            }
        }

        var rows: [AvatarDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .settings:
                return [.animating,
                        .alternateBackground,
                        .pointerInteraction,
                        .backgroundOutline,
                        .presence,
                        .activity,
                        .outOfOffice,
                        .ring,
                        .ringInnerGap,
                        .imageBasedRingColor,
                        .defaultImage]
            case .size72,
                 .size56,
                 .size40,
                 .size32,
                 .size24,
                 .size20,
                 .size16:
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

    private enum AvatarDemoRow: CaseIterable {
        case accentWithFallback
        case animating
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
        case activity
        case ring
        case ringInnerGap
        case swiftUIDemo
        case backgroundOutline
        case defaultImage

        var isDemoRow: Bool {
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
                return true
            case .alternateBackground,
                 .animating,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .activity,
                 .ring,
                 .ringInnerGap,
                 .swiftUIDemo,
                 .backgroundOutline,
                 .defaultImage:
                return false
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
                 .animating,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .activity,
                 .ring,
                 .ringInnerGap,
                 .swiftUIDemo,
                 .backgroundOutline,
                 .defaultImage:
                return nil
            }
        }

        var avatarPrimaryText: String? {
            switch self {
            case .defaultWithImage,
                 .defaultWithInitials:
                return "Kat Larsson"
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
                 .animating,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .activity,
                 .ring,
                 .ringInnerGap,
                 .swiftUIDemo,
                 .backgroundOutline,
                 .defaultImage:
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
                 .animating,
                 .imageBasedRingColor,
                 .outOfOffice,
                 .pointerInteraction,
                 .presence,
                 .activity,
                 .ring,
                 .ringInnerGap,
                 .swiftUIDemo,
                 .backgroundOutline,
                 .defaultImage:
                preconditionFailure("Row does not have an associated avatar style")
            }
        }

        var title: String {
            switch self {
            case .accentWithFallback:
                return "Accent style (no initials, no image)"
            case .alternateBackground:
                return "Use alternate background color"
            case .animating:
                return "Animate transitions"
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
            case .activity:
                return "Show activity"
            case .ring:
                return "Show ring"
            case .ringInnerGap:
                return "Set ring inner gap"
            case .swiftUIDemo:
                return "SwiftUI Demo"
            case .backgroundOutline:
                return "Use background outline"
            case .defaultImage:
                return "Use custom default image"
            }
        }
    }
}
