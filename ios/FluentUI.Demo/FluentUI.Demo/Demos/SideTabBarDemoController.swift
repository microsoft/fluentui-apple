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

    private lazy var incrementBadgeButton: Button = {
        return createButton(title: "+", action: #selector(incrementBadgeNumbers))
    }()

    private lazy var decrementBadgeButton: Button = {
        return createButton(title: "-", action: #selector(decrementBadgeNumbers))
    }()

    private func presentSideTabBar() {
        let contentViewController = UIViewController(nibName: nil, bundle: nil)
        self.contentViewController = contentViewController

        contentViewController.modalPresentationStyle = .fullScreen
        contentViewController.view.backgroundColor = view.backgroundColor
        contentViewController.view.addSubview(sideTabBar)

        sideTabBar.delegate = self

        sideTabBar.topItems = [
            TabBarItem(title: "Home", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!),
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
        contentViewController.view.addSubview(contentView)

        let optionsStackView = UIStackView(frame: .zero)
        optionsStackView.axis = .vertical
        optionsStackView.alignment = .center
        optionsStackView.spacing = Constants.optionsSpacing
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(optionsStackView)

        let showAvatarViewRow = createLabelAndSwitchRow(labelText: "Show Avatar View", switchAction: #selector(toggleAvatarView(switchView:)), isOn: true)
        showAvatarViewRow.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(showAvatarViewRow)
        showAvatarView(true)

        let showTopTitlesView = createLabelAndSwitchRow(labelText: "Show top item titles",
                                                        switchAction: #selector(toggleShowTopItemTitles(switchView:)),
                                                        isOn: false)
        showTopTitlesView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(showTopTitlesView)

        let showBottomTitlesView = createLabelAndSwitchRow(labelText: "Show bottom item titles",
                                                           switchAction: #selector(toggleShowBottomItemTitles(switchView:)),
                                                           isOn: false)
        showBottomTitlesView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(showBottomTitlesView)

        let showBadgeNumbersView = createLabelAndSwitchRow(labelText: "Show badge numbers",
                                                           switchAction: #selector(toggleShowBadgeNumbers(switchView:)),
                                                           isOn: showBadgeNumbers)
        showBadgeNumbersView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(showBadgeNumbersView)

        let useHigherBadgeNumbersView = createLabelAndSwitchRow(labelText: "Use higher badge numbers",
                                                                switchAction: #selector(toggleUseHigherBadgeNumbers(switchView:)),
                                                                isOn: useHigherBadgeNumbers)
        useHigherBadgeNumbersView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(useHigherBadgeNumbersView)

        let modifyBadgeNumbersView = createLabelAndViewsRow(labelText: "Modify badge numbers", views: [incrementBadgeButton, decrementBadgeButton])
        modifyBadgeNumbersView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(modifyBadgeNumbersView)

        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissSideTabBar), for: .touchUpInside)
        optionsStackView.addArrangedSubview(button)

        NSLayoutConstraint.activate([
            sideTabBar.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
            sideTabBar.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            sideTabBar.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: sideTabBar.trailingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor),
            optionsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            optionsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        present(contentViewController, animated: false)

        updateBadgeNumbers()
        updateBadgeButtons()
    }

    @objc private func dismissSideTabBar() {
        dismiss(animated: false) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func toggleAvatarView(switchView: UISwitch) {
        showAvatarView(switchView.isOn)
    }

    @objc private func toggleShowBadgeNumbers(switchView: UISwitch) {
        showBadgeNumbers = switchView.isOn
    }

    @objc private func toggleUseHigherBadgeNumbers(switchView: UISwitch) {
        useHigherBadgeNumbers = switchView.isOn
    }

    @objc private func toggleShowTopItemTitles(switchView: UISwitch) {
        sideTabBar.showTopItemTitles = switchView.isOn
    }

    @objc private func toggleShowBottomItemTitles(switchView: UISwitch) {
        sideTabBar.showBottomItemTitles = switchView.isOn
    }

    private func showAvatarView(_ show: Bool) {
        var avatarView: AvatarView?
        if let image = UIImage(named: "avatar_kat_larsson"), show {
            avatarView = AvatarView(avatarSize: .medium, withBorder: false, style: .circle, preferredFallbackImageStyle: .onAccentFilled)
            avatarView?.setup(primaryText: "Kat Larson", secondaryText: "", image: image)
            avatarView?.hasPointerInteraction = true
        }

        sideTabBar.avatarView = avatarView
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
        incrementBadgeButton.isEnabled = showBadgeNumbers
        decrementBadgeButton.isEnabled = showBadgeNumbers
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

    @objc private func incrementBadgeNumbers() {
        modifyBadgeNumbers(increment: 1)
    }

    @objc private func decrementBadgeNumbers() {
        modifyBadgeNumbers(increment: -1)
    }
}

// MARK: - SideTabBarDemoController: SideTabBarDelegate

extension SideTabBarDemoController: SideTabBarDelegate {
    func sideTabBar(_ sideTabBar: SideTabBar, didSelect item: TabBarItem, fromTop: Bool) {
        let alert = UIAlertController(title: "\(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController?.present(alert, animated: true)
    }

    func sideTabBar(_ sideTabBar: SideTabBar, didActivate avatarView: AvatarView) {
        let alert = UIAlertController(title: "Avatar view was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController?.present(alert, animated: true)
    }
}
