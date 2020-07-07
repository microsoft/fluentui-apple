//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SideTabBarDemoController: DemoController {
    override func loadView() {
        view = UIView(frame: .zero)
        container.addArrangedSubview(createButton(title: "Show side tab bar", action: #selector(presentSideTabBar)))
    }

    private struct Constants {
        static let optionsSpacing: CGFloat = 5.0
        static let labelSwitchSpacing: CGFloat = 10.0
    }

    private let sideTabBar: SideTabBar = {
        return SideTabBar(frame: .zero);
    }()

    private let contentViewController: UIViewController = {
        return UIViewController(nibName: nil, bundle: nil);
    }()

    @objc private func presentSideTabBar() {
        contentViewController.modalPresentationStyle = .fullScreen
        contentViewController.view.backgroundColor = view.backgroundColor

        sideTabBar.insert(in: contentViewController.view)
        sideTabBar.delegate = self

        sideTabBar.topItems = [
            TabBarItem(title: "Home", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!, landscapeImage: nil, landscapeSelectedImage: nil),
            TabBarItem(title: "New", image: UIImage(named: "New_28")!, selectedImage: UIImage(named: "New_Selected_28")!, landscapeImage: nil, landscapeSelectedImage: nil),
            TabBarItem(title: "Open", image: UIImage(named: "Open_28")!, selectedImage: UIImage(named: "Open_Selected_28")!, landscapeImage: nil, landscapeSelectedImage: nil)
        ]

        sideTabBar.bottomItems = [
            TabBarItem(title: "Help", image: UIImage(named: "Help_28")!, selectedImage: UIImage(named: "Help_Selected_28")!, landscapeImage: nil, landscapeSelectedImage: nil),
            TabBarItem(title: "Settings", image: UIImage(named: "Settings_28")!, selectedImage: UIImage(named: "Settings_Selected_28")!, landscapeImage: nil, landscapeSelectedImage: nil)
        ]

        let optionsStackView = UIStackView(frame: .zero)
        optionsStackView.axis = .vertical
        optionsStackView.alignment = .center
        optionsStackView.spacing = Constants.optionsSpacing
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.addSubview(optionsStackView)

        let showAvatarViewRow = createLabelAndSwitchRow(labelText: "Show Avatar View", switchAction: #selector(toggleAvatarView(switchView:)), isOn: true)
        showAvatarViewRow.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.addArrangedSubview(showAvatarViewRow)
        showAvatarView(true)

        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissSideTabBar), for: .touchUpInside)
        optionsStackView.addArrangedSubview(button)

        NSLayoutConstraint.activate([
            optionsStackView.centerXAnchor.constraint(equalTo: contentViewController.view.centerXAnchor),
            optionsStackView.centerYAnchor.constraint(equalTo: contentViewController.view.centerYAnchor),
        ])

        present(contentViewController, animated: false)
    }

    private func createLabelAndSwitchRow(labelText: String, switchAction: Selector, isOn: Bool = false) -> UIView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.labelSwitchSpacing

        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = labelText
        stackView.addArrangedSubview(label)

        let switchView = UISwitch()
        switchView.isOn = isOn
        switchView.addTarget(self, action: switchAction, for: .valueChanged)
        stackView.addArrangedSubview(switchView)

        return stackView;
    }

    @objc private func dismissSideTabBar() {
        dismiss(animated: false, completion: nil)
    }

    @objc private func toggleAvatarView(switchView: UISwitch) {
        showAvatarView(switchView.isOn)
    }

    private func showAvatarView(_ show: Bool) {
        var avatarView: AvatarView?
        if (show) {
            avatarView = AvatarView(avatarSize: .medium, withBorder: false, style: .circle)
            avatarView!.setup(primaryText: "Kat Larson", secondaryText: "", image: UIImage(named: "avatar_kat_larsson")!)
        }

        sideTabBar.avatarView = avatarView;
    }
}

// MARK: - SideTabBarDemoController: SideTabBarDelegate

extension SideTabBarDemoController: SideTabBarDelegate {
    func sideTabBar(_ sideTabBar: SideTabBar, didSelect item: TabBarItem, fromTop: Bool) {
        let alert = UIAlertController(title: "\(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController.present(alert, animated: true)
    }

    func sideTabBar(_ sideTabBar: SideTabBar, didActivate avatarView: AvatarView) {
        let alert = UIAlertController(title: "Avatar view was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController.present(alert, animated: true)
    }
}

