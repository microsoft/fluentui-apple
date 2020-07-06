//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SideBarDemoController: DemoController {
    override func loadView() {
        view = UIView(frame: .zero)
        container.addArrangedSubview(createButton(title: "Show side bar", action: #selector(presentSideBar)))
    }

    private struct Constants {
        static let optionsSpacing: CGFloat = 5.0
        static let labelSwitchSpacing: CGFloat = 10.0
    }

    private let sideBar: SideBar = {
        return SideBar(frame: .zero);
    }()

    private let contentViewController: UIViewController = {
        return UIViewController(nibName: nil, bundle: nil);
    }()

    @objc private func presentSideBar() {
        contentViewController.modalPresentationStyle = .fullScreen
        contentViewController.view.backgroundColor = view.backgroundColor

        sideBar.insert(in: contentViewController.view)
        sideBar.delegate = self

        sideBar.topItems = [
            TabBarItem(title: "Home", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!, landscapeImage: UIImage(named: "Home_24")!, landscapeSelectedImage: UIImage(named: "Home_Selected_24")!),
            TabBarItem(title: "New", image: UIImage(named: "New_28")!, selectedImage: UIImage(named: "New_Selected_28")!, landscapeImage: UIImage(named: "New_24")!, landscapeSelectedImage: UIImage(named: "New_Selected_24")!),
            TabBarItem(title: "Open", image: UIImage(named: "Open_28")!, selectedImage: UIImage(named: "Open_Selected_28")!, landscapeImage: UIImage(named: "Open_24")!, landscapeSelectedImage: UIImage(named: "Open_Selected_24")!)
        ]

        sideBar.bottomItems = [
            TabBarItem(title: "Help", image: UIImage(named: "Help_28")!, selectedImage: UIImage(named: "Help_Selected_28")!, landscapeImage: UIImage(named: "Help_24")!, landscapeSelectedImage: UIImage(named: "Help_Selected_24")!),
            TabBarItem(title: "Settings", image: UIImage(named: "Settings_28")!, selectedImage: UIImage(named: "Settings_Selected_28")!, landscapeImage: UIImage(named: "Settings_24")!, landscapeSelectedImage: UIImage(named: "Settings_Selected_24")!)
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
        button.addTarget(self, action: #selector(dismissSideBar), for: .touchUpInside)
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

    @objc private func dismissSideBar() {
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

        sideBar.avatarView = avatarView;
    }
}

// MARK: - SideBarDemoController: SideBarDelegate

extension SideBarDemoController: SideBarDelegate {
    func sideBar(_ sideBar: SideBar, didSelect item: TabBarItem, fromTop: Bool) {
        let alert = UIAlertController(title: "\(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController.present(alert, animated: true)
    }

    func sideBar(_ sideBar: SideBar, didActivate avatarView: AvatarView) {
        let alert = UIAlertController(title: "Avatar view was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        contentViewController.present(alert, animated: true)
    }
}

