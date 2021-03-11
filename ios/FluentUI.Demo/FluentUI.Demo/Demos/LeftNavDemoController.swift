//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class LeftNavDemoController: DemoController, MSFDrawerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Left navigation control")
        addDescription(text: "The LeftNav control is built from a composition of the Avatar, Drawer and List controls.")

        container.addArrangedSubview(createButton(title: "Show Left Navigation Menu", action: { [weak self ] _ in
            if let strongSelf = self {
                strongSelf.showLeftNavButtonTapped()
            }
        }).view)

        let isLeadingEdgeLeftToRight = view.effectiveUserInterfaceLayoutDirection == .leftToRight

        let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        leadingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .left : .right
        view.addGestureRecognizer(leadingEdgeGesture)
        navigationController?.navigationController?.interactivePopGestureRecognizer?.require(toFail: leadingEdgeGesture)

        drawerController = MSFDrawer(contentViewController: LeftNavMenuViewController(menuAction: {
            self.showMessage("Menu item selected.")
        }))
        drawerController.delegate = self
        drawerController.state.presentingGesture = leadingEdgeGesture
        drawerController.state.backgroundDimmed = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private var drawerController: MSFDrawer!

    @objc private func showLeftNavButtonTapped() {
        present(drawerController, animated: true, completion: nil)
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        present(drawerController,
                animated: true,
                completion: nil)
    }
}

class LeftNavMenuViewController: UIViewController {

    init(menuAction: (() -> Void)?) {
        self.menuAction = menuAction

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = leftNavView
    }

    var menuAction: (() -> Void)?

    private func setPresence(presence: LeftNavPresence) {
        self.leftNavAvatar.state.presence = presence.avatarPresence()
        self.statusCell.isExpanded = false
        self.statusCell.title = presence.cellTitle()
        self.statusCell.leadingView = presence.imageView()
    }

    private var leftNavAvatar = MSFAvatar(style: .default, size: .xlarge)

    private var statusCell = MSFListCellState()

    private var leftNavMenuSections: [MSFListSectionState] {
        let defaultMenuAction = {
            self.dismiss(animated: true, completion: {
                guard let menuAction = self.menuAction else {
                    return
                }

                menuAction()
            })
        }

        var statusCellChildren: [MSFListCellState] = []

        for presence in LeftNavPresence.allCases {
            let statusCellChild = MSFListCellState()
            statusCellChild.leadingViewSize = .small
            statusCellChild.title = presence.cellTitle()
            statusCellChild.leadingView = presence.imageView()
            statusCellChild.onTapAction = {
                self.setPresence(presence: presence)
            }

            statusCellChildren.append(statusCellChild)
        }

        let resetStatusCell = MSFListCellState()
        resetStatusCell.title = "Reset status"
        resetStatusCell.leadingViewSize = .small
        let resetStatusImageView = UIImageView(image: UIImage(named: "ic_fluent_arrow_sync_24_regular"))
        resetStatusImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        resetStatusCell.leadingView = resetStatusImageView
        resetStatusCell.onTapAction = {
            self.setPresence(presence: .available)
        }
        statusCellChildren.append(resetStatusCell)

        statusCell.title = LeftNavPresence.available.cellTitle()
        let statusImageView = LeftNavPresence.available.imageView()
        statusImageView.tintColor = FluentUIThemeManager.S.Colors.Presence.available
        statusCell.leadingView = statusImageView
        statusCell.children = statusCellChildren

        let statusMessageCell = MSFListCellState()
        statusMessageCell.title = "Set Status Message"
        let statusMessageImageView = UIImageView(image: UIImage(named: "ic_fluent_status_24_regular"))
        statusMessageImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        statusMessageCell.leadingView = statusMessageImageView
        statusMessageCell.onTapAction = defaultMenuAction

        let notificationsCell = MSFListCellState()
        notificationsCell.title = "Notifications"
        notificationsCell.subtitle = "On"
        notificationsCell.layoutType = .twoLines
        let notificationsImageView = UIImageView(image: UIImage(named: "ic_fluent_alert_24_regular"))
        notificationsImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        notificationsCell.leadingView = notificationsImageView
        notificationsCell.onTapAction = defaultMenuAction

        let settingsCell = MSFListCellState()
        settingsCell.title = "Settings"
        let settingsImageView = UIImageView(image: UIImage(named: "ic_fluent_settings_24_regular"))
        settingsImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        settingsCell.leadingView = settingsImageView
        settingsCell.onTapAction = defaultMenuAction

        let whatsNewCell = MSFListCellState()
        whatsNewCell.title = "What's new"
        let whatsNewImageView = UIImageView(image: UIImage(named: "ic_fluent_lightbulb_24_regular"))
        whatsNewImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        whatsNewCell.leadingView = whatsNewImageView
        whatsNewCell.onTapAction = defaultMenuAction

        let menuSection = MSFListSectionState()
        menuSection.cells = [statusCell, statusMessageCell, notificationsCell, settingsCell, whatsNewCell]

        let microsoftAccountCell = MSFListCellState()
        microsoftAccountCell.layoutType = .twoLines
        microsoftAccountCell.title = "Contoso"
        microsoftAccountCell.subtitle = "kat.larrson@contoso.com"
        microsoftAccountCell.accessoryType = .checkmark
        let orgAvatar = MSFAvatar(style: .group, size: .large)
        orgAvatar.state.primaryText = "Kat Larrson"
        microsoftAccountCell.leadingViewSize = .large

        let msaAccountCell = MSFListCellState()
        msaAccountCell.layoutType = .twoLines
        msaAccountCell.title = "Personal"
        msaAccountCell.subtitle = "kat.larrson@live.com"
        let msaAvatar = MSFAvatar(style: .group, size: .large)
        msaAvatar.state.primaryText = "kat.larrson@live.com"
        msaAccountCell.leadingViewSize = .large

        let addAccountCell = MSFListCellState()
        addAccountCell.title = "Add Account"
        let addAccountImageView = UIImageView(image: UIImage(named: "ic_fluent_add_24_regular"))
        addAccountImageView.tintColor = FluentUIThemeManager.S.Colors.Foreground.neutral4
        addAccountCell.leadingView = addAccountImageView
        addAccountCell.onTapAction = defaultMenuAction

        let accountsSection = MSFListSectionState()
        accountsSection.title = "Accounts and Orgs"
        accountsSection.cells = [microsoftAccountCell, msaAccountCell, addAccountCell]

        return [menuSection, accountsSection]
    }

    private var leftNavMenuList = MSFList(sections: [])

    private var leftNavAccountView: UIView {
        leftNavAvatar.state.presence = .available
        leftNavAvatar.state.primaryText = "Kat Larrson"
        leftNavAvatar.state.secondaryText = "Designer"
        leftNavAvatar.state.image = UIImage(named: "avatar_kat_larsson")

        let chevron = UIImageView(image: UIImage(named: "ic_fluent_ios_chevron_right_20_filled"))
        chevron.tintColor = Colors.textPrimary

        let personaState = MSFPersonaCellState()
        personaState.leadingView = leftNavAvatar.view
        personaState.title = leftNavAvatar.state.primaryText ?? ""
        personaState.subtitle = leftNavAvatar.state.secondaryText ?? ""
        personaState.titleTrailingAccessoryView = chevron
        let persona = MSFListPersona(state: personaState)

        let personaView = UIStackView(arrangedSubviews: [persona.view])

        personaView.translatesAutoresizingMaskIntoConstraints = false
        personaView.axis = .vertical
        personaView.spacing = Constant.verticalSpacing

        let accountView = UIView()
        accountView.addSubview(personaView)

        accountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personaView.leadingAnchor.constraint(equalTo: accountView.leadingAnchor),
            personaView.trailingAnchor.constraint(equalTo: accountView.trailingAnchor)

        ])

        return accountView
    }

    private var leftNavContentView: UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = UIEdgeInsets(top: Constant.margin,
                                                 left: Constant.margin,
                                                 bottom: Constant.margin,
                                                 right: Constant.margin)
        let accountView = leftNavAccountView
        let menuListView = leftNavMenuList.view
        menuListView.translatesAutoresizingMaskIntoConstraints = false
        leftNavMenuList.state.sections = leftNavMenuSections

        contentView.addSubview(accountView)
        contentView.addSubview(menuListView)

        NSLayoutConstraint.activate([accountView.heightAnchor.constraint(equalToConstant: 84),
                                     contentView.topAnchor.constraint(equalTo: accountView.topAnchor),
                                     contentView.leadingAnchor.constraint(equalTo: accountView.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: accountView.trailingAnchor),
                                     accountView.bottomAnchor.constraint(equalTo: menuListView.topAnchor),
                                     contentView.leadingAnchor.constraint(equalTo: menuListView.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: menuListView.trailingAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: menuListView.bottomAnchor)
        ])

        return contentView
    }

    private var leftNavView: UIView {
        let container = UIView(frame: .zero)

        let contentView = leftNavContentView
        container.addSubview(contentView)

        container.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([container.safeAreaLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
        return container
    }

    private func addBackgroundColor(_ stackview: UIStackView, color: UIColor) {
        let subView = UIView(frame: stackview.bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackview.insertSubview(subView, at: 0)
    }

    private enum Constant {
        static let margin: CGFloat = 16
        static let verticalSpacing: CGFloat = 5
    }
}

enum LeftNavPresence: Int, CaseIterable {
    case available
    case busy
    case doNotDisturb
    case beRightBack
    case away
    case offline

    func imageView() -> UIImageView {
        let imageView: UIImageView

        switch self {
        case .available:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_available_16_filled"))
            imageView.tintColor = FluentUIThemeManager.S.Colors.Presence.available
        case .away, .beRightBack:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_away_16_filled"))
            imageView.tintColor = FluentUIThemeManager.S.Colors.Presence.away
        case .busy:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_busy_16_filled"))
            imageView.tintColor = FluentUIThemeManager.S.Colors.Presence.busy
        case .doNotDisturb:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_dnd_16_filled"))
            imageView.tintColor = FluentUIThemeManager.S.Colors.Presence.doNotDisturb
        case .offline:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_offline_16_regular"))
            imageView.tintColor = FluentUIThemeManager.S.Colors.Presence.offline
        }

        return imageView
    }

    func cellTitle() -> String {
        let cellTitle: String
        switch self {
        case .available:
            cellTitle = "Available"
        case .busy:
            cellTitle = "Busy"
        case .doNotDisturb:
            cellTitle = "Do not disturb"
        case .beRightBack:
            cellTitle = "Be right back"
        case .away:
            cellTitle = "Appear away"
        case .offline:
            cellTitle = "Appear offline"
        }

        return cellTitle
    }

    func avatarPresence() -> MSFAvatarPresence {
        switch self {
        case .available:
            return .available
        case .busy:
            return .busy
        case .doNotDisturb:
            return .doNotDisturb
        case .away, .beRightBack:
            return .away
        case .offline:
            return .offline
        }
    }
}
