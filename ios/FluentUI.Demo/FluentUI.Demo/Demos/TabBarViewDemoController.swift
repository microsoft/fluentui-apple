//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class TabBarViewDemoController: DemoController {
    private var tabBarView: TabBarView?
    private var tabBarViewConstraints: [NSLayoutConstraint]?
    private var showsItemTitles: Bool { return itemTitleVisibilitySwitch.isOn }
    private var showBadgeNumbers: Bool { return showBadgeNumbersSwitch.isOn }
    private var useHigherBadgeNumbers: Bool { return showBadgeNumbersSwitch.isOn }

    private let itemTitleVisibilitySwitch = UISwitch()
    private let showBadgeNumbersSwitch = UISwitch()
    private let useHigherBadgeNumbersSwitch = UISwitch()

    private enum Constants {
        static let badgeNumbers: [UInt] = [5, 50, 250]
        static let higherBadgeNumbers: [UInt] = [1250, 25505, 305052]
        static let settingsTextWidth: CGFloat = 180
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addRow(text: "Show item titles", items: [itemTitleVisibilitySwitch], textWidth: Constants.settingsTextWidth)
        itemTitleVisibilitySwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        addRow(text: "Show badge numbers", items: [showBadgeNumbersSwitch], textWidth: Constants.settingsTextWidth)
        itemTitleVisibilitySwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        addRow(text: "Use higher badge numbers", items: [useHigherBadgeNumbersSwitch], textWidth: Constants.settingsTextWidth)
        useHigherBadgeNumbersSwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        setupTabBarView()
    }

    private func setupTabBarView() {
        // remove the old tab bar View
        if let oldTabBarView = tabBarView {
            if let constraints = tabBarViewConstraints {
                NSLayoutConstraint.deactivate(constraints)
            }
            oldTabBarView.removeFromSuperview()
        }

        let updatedTabBarView = TabBarView(showsItemTitles: showsItemTitles)
        updatedTabBarView.delegate = self

        if showsItemTitles {
            updatedTabBarView.items = [
                TabBarItem(title: "Home", image: UIImage(named: "Home_24")!, selectedImage: UIImage(named: "Home_Selected_24")!),
                TabBarItem(title: "New", image: UIImage(named: "New_24")!, selectedImage: UIImage(named: "New_Selected_24")!),
              TabBarItem(title: "Open", image: UIImage(named: "Open_24")!, selectedImage: UIImage(named: "Open_Selected_24")!)
            ]
        } else {
            updatedTabBarView.items = [
                TabBarItem(title: "Home", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!, landscapeImage: UIImage(named: "Home_24")!, landscapeSelectedImage: UIImage(named: "Home_Selected_24")!),
                TabBarItem(title: "New", image: UIImage(named: "New_28")!, selectedImage: UIImage(named: "New_Selected_28")!, landscapeImage: UIImage(named: "New_24")!, landscapeSelectedImage: UIImage(named: "New_Selected_24")!),
                TabBarItem(title: "Open", image: UIImage(named: "Open_28")!, selectedImage: UIImage(named: "Open_Selected_28")!, landscapeImage: UIImage(named: "Open_24")!, landscapeSelectedImage: UIImage(named: "Open_Selected_24")!)
            ]
        }

        updatedTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updatedTabBarView)

        tabBarViewConstraints = [
            updatedTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            updatedTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            updatedTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(tabBarViewConstraints!)

        tabBarView = updatedTabBarView

        if showBadgeNumbers {
            let numbers = useHigherBadgeNumbers ? Constants.higherBadgeNumbers : Constants.badgeNumbers

            updatedTabBarView.setBadgeNumber(numbers[0], for: updatedTabBarView.items[0])
            updatedTabBarView.setBadgeNumber(numbers[1], for: updatedTabBarView.items[1])
            updatedTabBarView.setBadgeNumber(numbers[2], for: updatedTabBarView.items[2])
        }
    }

    // Switch toggle handler
    @objc private func handleOnSwitchValueChanged() {
        setupTabBarView()
    }
}

// MARK: - TabBarViewDemoController: TabBarViewDelegate

extension TabBarViewDemoController: TabBarViewDelegate {
    func tabBarView(_ tabBarView: TabBarView, didSelect item: TabBarItem) {
        let alert = UIAlertController(title: "Tab Bar Item \(item.title) was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
