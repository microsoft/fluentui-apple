//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SideTabBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        presentSideTabBar()
    }

    private struct Constants {
        static let initialBadgeNumbers: [UInt] = [5, 50, 250, 4, 65, 135]
        static let initialHigherBadgeNumbers: [UInt] = [1250, 25505, 3050528, 50890, 2304, 28745]
        static let optionsSpacing: CGFloat = 5.0
    }

    private let sideTabBar: SideTabBar = {
        return SideTabBar(frame: .zero)
    }()

    private var contentViewController: UIViewController?

    private var badgeNumbers: [UInt] = Constants.initialBadgeNumbers
    private var higherBadgeNumbers: [UInt] = Constants.initialHigherBadgeNumbers

    private var showBadgeNumbers: Bool = false {
        didSet {
            updateBadgeNumbers()
            updateBadgeButtons()
        }
    }

    private var useHigherBadgeNumbers: Bool = false {
        didSet {
            updateBadgeNumbers()
        }
    }

    private lazy var incrementBadgeButton: MSFButton = {
        let incrementBadgeButton = MSFButton(style: .secondary,
                                             size: .small) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.modifyBadgeNumbers(increment: 1)
        }
        incrementBadgeButton.state.image = UIImage(named: "ic_fluent_add_20_regular")
        incrementBadgeButton.state.accessibilityLabel = "Increment badge numbers"

        return incrementBadgeButton
    }()

    private lazy var decrementBadgeButton: MSFButton = {
        let decrementBadgeButton = MSFButton(style: .secondary,
                                             size: .small) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.modifyBadgeNumbers(increment: -1)
        }
        decrementBadgeButton.state.image = UIImage(named: "ic_fluent_subtract_20_regular")
        decrementBadgeButton.state.accessibilityLabel = "Decrement badge numbers"

        return decrementBadgeButton
    }()

    private lazy var homeItem: TabBarItem = {
        return TabBarItem(title: "Home", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!)
    }()

    private func presentSideTabBar() {
        let contentViewController = UIViewController(nibName: nil, bundle: nil)
        self.contentViewController = contentViewController

        contentViewController.modalPresentationStyle = .fullScreen
        contentViewController.view.backgroundColor = view.backgroundColor
        contentViewController.view.addSubview(sideTabBar)

        sideTabBar.delegate = self

        sideTabBar.topItems = [
            homeItem,
            TabBarItem(title: "New", image: UIImage(named: "New_28")!, selectedImage: UIImage(named: "New_Selected_28")!),
            TabBarItem(title: "Open", image: UIImage(named: "Open_28")!, selectedImage: UIImage(named: "Open_Selected_28")!)
        ]

        var premiumImage = UIImage(named: "ic_fluent_premium_24_regular")!
        if let window = view.window {
            let primaryColor = Colors.primary(for: window)
            premiumImage = premiumImage.image(withPrimaryColor: primaryColor)
        }

        sideTabBar.bottomItems = [
            TabBarItem(title: "Go Premium", image: premiumImage),
            TabBarItem(title: "Help", image: UIImage(named: "Help_24")!),
            TabBarItem(title: "Settings", image: UIImage(named: "Settings_24")!)
        ]

        let contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.insertSubview(contentView, belowSubview: sideTabBar)

        let optionTableView = UITableView(frame: .zero, style: .plain)
        optionTableView.translatesAutoresizingMaskIntoConstraints = false
        optionTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        optionTableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        optionTableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none
        contentView.addSubview(optionTableView)

        showAvatarView(true)

        NSLayoutConstraint.activate([
            sideTabBar.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
            sideTabBar.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            sideTabBar.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: sideTabBar.trailingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
            optionTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            optionTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        present(contentViewController, animated: false)

        updateBadgeNumbers()
        updateBadgeButtons()
    }

    @objc private func showTooltipForSettingsButton() {
        guard let view = sideTabBar.itemView(with: homeItem) else {
            return
        }

        Tooltip.shared.show(with: "Tap anywhere to dismiss this tooltip",
                            for: view,
                            preferredArrowDirection: .left,
                            offset: .init(x: 9, y: 0),
                            dismissOn: .tapAnywhere)
    }

    @objc private func dismissSideTabBar() {
        dismiss(animated: false) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func toggleAvatarView(_ cell: BooleanCell) {
        showAvatarView(cell.isOn)
    }

    @objc private func toggleShowBadgeNumbers(_ cell: BooleanCell) {
        showBadgeNumbers = cell.isOn
    }

    @objc private func toggleUseHigherBadgeNumbers(_ cell: BooleanCell) {
        useHigherBadgeNumbers = cell.isOn
    }

    @objc private func toggleShowTopItemTitles(_ cell: BooleanCell) {
        sideTabBar.showTopItemTitles = cell.isOn
    }

    @objc private func toggleShowBottomItemTitles(_ cell: BooleanCell) {
        sideTabBar.showBottomItemTitles = cell.isOn
    }

    private func showAvatarView(_ show: Bool) {
        var avatar: MSFAvatar?
        if let image = UIImage(named: "avatar_kat_larsson"), show {
            avatar = MSFAvatar(style: .accent,
                               size: .medium)
            if let avatarState = avatar?.state {
                avatarState.primaryText = "Kat Larson"
                avatarState.image = image
                avatarState.hasPointerInteraction = true
            }
        }

        sideTabBar.avatar = avatar
    }

    private func updateBadgeNumbers() {
        var numbers = useHigherBadgeNumbers ? higherBadgeNumbers : badgeNumbers
        if !showBadgeNumbers {
            numbers = [0, 0, 0, 0, 0, 0]
        }

        sideTabBar.topItems[0].setBadgeNumber(numbers[0])
        sideTabBar.topItems[1].setBadgeNumber(numbers[1])
        sideTabBar.topItems[2].setBadgeNumber(numbers[2])
        sideTabBar.bottomItems[0].setBadgeNumber(numbers[3])
        sideTabBar.bottomItems[1].setBadgeNumber(numbers[4])
        sideTabBar.bottomItems[2].setBadgeNumber(numbers[5])
    }

    private func updateBadgeButtons() {
        incrementBadgeButton.state.isDisabled = !showBadgeNumbers
        decrementBadgeButton.state.isDisabled = !showBadgeNumbers
    }

    private func modifyBadgeNumbers(increment: Int) {
        var numbers = useHigherBadgeNumbers ? higherBadgeNumbers : badgeNumbers
        for (index, value) in numbers.enumerated() {
            let newValue = Int(value) + increment
            if newValue > 0 {
                numbers[index] = UInt(newValue)
            } else {
                numbers[index] = 0
            }
        }

        if useHigherBadgeNumbers {
            higherBadgeNumbers = numbers
        } else {
            badgeNumbers = numbers
        }

        updateBadgeNumbers()
    }

    private let optionsCellItems: [CellItem] = {
        return [CellItem(title: "Show Avatar View", type: .boolean, action: #selector(toggleAvatarView(_:)), isOn: true),
                CellItem(title: "Show top item titles", type: .boolean, action: #selector(toggleShowTopItemTitles(_:))),
                CellItem(title: "Show bottom item titles", type: .boolean, action: #selector(toggleShowBottomItemTitles(_:))),
                CellItem(title: "Show badge numbers", type: .boolean, action: #selector(toggleShowBadgeNumbers(_:))),
                CellItem(title: "Use higher badge numbers", type: .boolean, action: #selector(toggleUseHigherBadgeNumbers(_:))),
                CellItem(title: "Modify badge numbers", type: .stepper, action: nil),
                CellItem(title: "Show tooltip for Home button", type: .action, action: #selector(showTooltipForSettingsButton)),
                CellItem(title: "Dismiss", type: .action, action: #selector(dismissSideTabBar))
        ]
    }()
}

// MARK: - SideTabBarDemoController: SideTabBarDelegate

extension SideTabBarDemoController: SideTabBarDelegate {
    func sideTabBar(_ sideTabBar: SideTabBar, didSelect item: TabBarItem, fromTop: Bool) {
        let alert = UIAlertController(title: "\(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController?.present(alert, animated: true)
    }

    func sideTabBar(_ sideTabBar: SideTabBar, didActivate avatarView: MSFAvatar) {
        let alert = UIAlertController(title: "Avatar view was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController?.present(alert, animated: true)
    }
}

extension SideTabBarDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsCellItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = optionsCellItems[indexPath.row]

        if item.type == .boolean {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }
            cell.setup(title: item.title, isOn: item.isOn)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                self?.perform(item.action, with: cell)
            }
            return cell
        } else if item.type == .action {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }
            cell.setup(action1Title: item.title)
            if let action = item.action {
                cell.action1Button.addTarget(self, action: action, for: .touchUpInside)
            }
            cell.bottomSeparatorType = .full
            return cell
        } else if item.type == .stepper {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            stackView.addArrangedSubview(decrementBadgeButton.view)
            stackView.addArrangedSubview(incrementBadgeButton.view)
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 4

            cell.setup(title: item.title, customAccessoryView: stackView)
            cell.titleNumberOfLines = 0
            return cell
        }

        return UITableViewCell()
    }
}

extension SideTabBarDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
       return false
    }
}

enum CellType {
    case action
    case boolean
    case stepper
}

struct CellItem {
    let title: String
    let type: CellType
    let action: Selector?
    var isOn: Bool = false
}
