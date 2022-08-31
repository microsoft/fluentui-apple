//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class LeftNavDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Left navigation control")
        addDescription(text: "The LeftNav control is built from a composition of the Avatar, Drawer and List controls.")

        container.addArrangedSubview(navigationButton)

        let isLeadingEdgeLeftToRight = view.effectiveUserInterfaceLayoutDirection == .leftToRight

        let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        leadingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .left : .right
        view.addGestureRecognizer(leadingEdgeGesture)
        navigationController?.navigationController?.interactivePopGestureRecognizer?.require(toFail: leadingEdgeGesture)

        let lefNavController = LeftNavMenuViewController(menuAction: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss(animated: true, completion: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showMessage("Menu item selected.")
            })
        })

        drawerController.contentView = lefNavController.view
        drawerController.presentingGesture = leadingEdgeGesture
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private lazy var navigationButton: UIView = {
        return createButton(title: "Show Left Navigation Menu", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLeftNavButtonTapped()
        })
    }()

    private lazy var drawerController: DrawerController = {
        let drawerController = DrawerController(sourceView: navigationButton,
                                                sourceRect: navigationButton.bounds,
                                                presentationDirection: .fromLeading)
        drawerController.presentationBackground = .black
        drawerController.preferredContentSize.width = 360
        drawerController.resizingBehavior = .dismiss
        return drawerController
    }()

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let sizeCategory = previousTraitCollection?.preferredContentSizeCategory,
            sizeCategory != traitCollection.preferredContentSizeCategory {
            leftNavAccountViewHeightConstraint?.constant = leftNavAccountView.intrinsicContentSize.height
        }
    }

    var menuAction: (() -> Void)?

    private func setPresence(presence: LeftNavPresence) {
        persona.state.presence = presence.avatarPresence

        guard let statusCell = statusCell else {
            return
        }
        statusCell.isExpanded = false
        statusCell.title = presence.cellTitle
        statusCell.leadingUIView = presence.imageView
    }

    private var leftNavAvatar = MSFAvatar(style: .default, size: .xlarge)

    private var persona = MSFPersonaView()

    private var leftNavMenuList = MSFList()

    private var statusCell: MSFListCellState?

    private var leftNavAccountViewHeightConstraint: NSLayoutConstraint?

    private lazy var leftNavAccountView: UIView = {
        let chevron = UIImageView(image: UIImage(named: "ic_fluent_ios_chevron_right_20_filled"))
        chevron.tintColor = Colors.textPrimary
        let personaState = persona.state

        personaState.presence = .available
        personaState.primaryText = "Kat Larrson"
        personaState.secondaryText = "Designer"
        personaState.image = UIImage(named: "avatar_kat_larsson")
        personaState.titleTrailingAccessoryUIView = chevron
        personaState.backgroundColor = .systemBackground
        personaState.onTapAction = {
            self.dismiss(animated: true, completion: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.menuAction?()
            })
        }

        let personaView = persona
        personaView.translatesAutoresizingMaskIntoConstraints = false
        return personaView
    }()

    private var leftNavContentView: UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutMargins = UIEdgeInsets(top: Constant.margin,
                                                 left: Constant.margin,
                                                 bottom: Constant.margin,
                                                 right: Constant.margin)
        let defaultMenuAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.menuAction?()
        }

        let menuSection = leftNavMenuList.state.createSection()

        let statusCellState = menuSection.createCell()
        statusCell = statusCellState

        statusCellState.title = LeftNavPresence.available.cellTitle
        statusCellState.backgroundColor = .systemBackground
        let statusImageView = LeftNavPresence.available.imageView
        statusCellState.leadingUIView = statusImageView

        for presence in LeftNavPresence.allCases {
            let statusCellChild = statusCellState.createChildCell()
            statusCellChild.leadingViewSize = .small
            statusCellChild.title = presence.cellTitle
            statusCellChild.leadingUIView = presence.imageView
            statusCellChild.backgroundColor = .systemBackground
            statusCellChild.onTapAction = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.setPresence(presence: presence)
            }
        }

        let aliasTokens = contentView.fluentTheme.aliasTokens
        let tintDynamicColor = aliasTokens.foregroundColors[.neutral4]
        let tintColor = UIColor(dynamicColor: tintDynamicColor)

        let resetStatusCell = statusCellState.createChildCell()
        resetStatusCell.title = "Reset status"
        resetStatusCell.leadingViewSize = .small
        resetStatusCell.backgroundColor = .systemBackground
        let resetStatusImageView = UIImageView(image: UIImage(named: "ic_fluent_arrow_sync_24_regular"))
        resetStatusImageView.tintColor = tintColor
        resetStatusCell.leadingUIView = resetStatusImageView
        resetStatusCell.onTapAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setPresence(presence: .available)
        }

        let statusMessageCell = menuSection.createCell()
        statusMessageCell.backgroundColor = .systemBackground
        statusMessageCell.title = "Set Status Message"
        let statusMessageImageView = UIImageView(image: UIImage(named: "ic_fluent_status_24_regular"))
        statusMessageImageView.tintColor = tintColor
        statusMessageCell.leadingUIView = statusMessageImageView
        statusMessageCell.onTapAction = defaultMenuAction

        let notificationsCell = menuSection.createCell()
        notificationsCell.backgroundColor = .systemBackground
        notificationsCell.title = "Notifications"
        notificationsCell.subtitle = "On"
        notificationsCell.layoutType = .twoLines
        let notificationsImageView = UIImageView(image: UIImage(named: "ic_fluent_alert_24_regular"))
        notificationsImageView.tintColor = tintColor
        notificationsCell.leadingUIView = notificationsImageView
        notificationsCell.onTapAction = defaultMenuAction

        let settingsCell = menuSection.createCell()
        settingsCell.backgroundColor = .systemBackground
        settingsCell.title = "Settings"
        let settingsImageView = UIImageView(image: UIImage(named: "ic_fluent_settings_24_regular"))
        settingsImageView.tintColor = tintColor
        settingsCell.leadingUIView = settingsImageView
        settingsCell.onTapAction = defaultMenuAction

        let whatsNewCell = menuSection.createCell()
        whatsNewCell.backgroundColor = .systemBackground
        whatsNewCell.title = "What's new"
        let whatsNewImageView = UIImageView(image: UIImage(named: "ic_fluent_lightbulb_24_regular"))
        whatsNewImageView.tintColor = tintColor
        whatsNewCell.leadingUIView = whatsNewImageView
        whatsNewCell.onTapAction = defaultMenuAction

        let accountsSection = leftNavMenuList.state.createSection()
        accountsSection.title = "Accounts and Orgs"
        accountsSection.backgroundColor = .systemBackground

        let microsoftAccountCell = accountsSection.createCell()
        microsoftAccountCell.backgroundColor = .systemBackground
        microsoftAccountCell.layoutType = .twoLines
        microsoftAccountCell.title = "Contoso"
        microsoftAccountCell.subtitle = "kat.larrson@contoso.com"
        microsoftAccountCell.accessoryType = .checkmark
        let orgAvatar = MSFAvatar(style: .group, size: .large)
        orgAvatar.state.primaryText = "Kat Larrson"
        microsoftAccountCell.leadingUIView = orgAvatar
        microsoftAccountCell.leadingViewSize = .large

        let msaAccountCell = accountsSection.createCell()
        msaAccountCell.backgroundColor = .systemBackground
        msaAccountCell.layoutType = .twoLines
        msaAccountCell.title = "Personal"
        msaAccountCell.subtitle = "kat.larrson@live.com"
        let msaAvatar = MSFAvatar(style: .group, size: .large)
        msaAvatar.state.primaryText = "kat.larrson@live.com"
        msaAccountCell.leadingUIView = msaAvatar
        msaAccountCell.leadingViewSize = .large

        let addAccountCell = accountsSection.createCell()
        addAccountCell.backgroundColor = .systemBackground
        addAccountCell.title = "Add Account"
        let addAccountImageView = UIImageView(image: UIImage(named: "ic_fluent_add_24_regular"))
        addAccountImageView.tintColor = tintColor
        addAccountCell.leadingUIView = addAccountImageView
        addAccountCell.onTapAction = defaultMenuAction

        let accountView = leftNavAccountView
        let menuListView = leftNavMenuList
        menuListView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(accountView)
        contentView.addSubview(menuListView)

        let accountViewHeightConstraint = accountView.heightAnchor.constraint(equalToConstant: accountView.intrinsicContentSize.height)
        leftNavAccountViewHeightConstraint = accountViewHeightConstraint

        NSLayoutConstraint.activate([accountViewHeightConstraint,
                                     accountView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     accountView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     accountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     menuListView.topAnchor.constraint(equalTo: accountView.bottomAnchor),
                                     menuListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     menuListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     menuListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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

    var imageView: UIImageView {
        let imageView: UIImageView
        switch self {
        case .available:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_available_16_filled"))
            imageView.tintColor = FluentUI.Colors.Palette.presenceAvailable.color
        case .away, .beRightBack:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_away_16_filled"))
            imageView.tintColor = FluentUI.Colors.Palette.presenceAway.color
        case .busy:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_busy_16_filled"))
            imageView.tintColor = FluentUI.Colors.Palette.presenceBusy.color
        case .doNotDisturb:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_dnd_16_filled"))
            imageView.tintColor = FluentUI.Colors.Palette.presenceDnd.color
        case .offline:
            imageView = UIImageView(image: UIImage(named: "ic_fluent_presence_offline_16_regular"))
            imageView.tintColor = FluentUI.Colors.Palette.presenceOffline.color
        }
        return imageView
    }

    var cellTitle: String {
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

    var avatarPresence: MSFAvatarPresence {
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
