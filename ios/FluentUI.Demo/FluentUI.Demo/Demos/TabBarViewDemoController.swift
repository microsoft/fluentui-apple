//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class TabBarViewDemoController: DemoController {
    private enum Constants {
        static let initialBadgeNumbers: [UInt] = [5, 50, 250]
        static let initialHigherBadgeNumbers: [UInt] = [1250, 25505, 3050528]
        static let switchSettingTextWidth: CGFloat = 180
        static let buttonSettingTextWidth: CGFloat = 150
    }

    private var tabBarView: TabBarView?
    private var tabBarViewConstraints: [NSLayoutConstraint]?
    private var showsItemTitles: Bool { return itemTitleVisibilitySwitch.isOn }
    private var showBadgeNumbers: Bool { return showBadgeNumbersSwitch.isOn }
    private var useHigherBadgeNumbers: Bool { return useHigherBadgeNumbersSwitch.isOn }

    private let itemTitleVisibilitySwitch = UISwitch()
    private let showBadgeNumbersSwitch = UISwitch()
    private let useHigherBadgeNumbersSwitch = UISwitch()

    private lazy var incrementBadgeButton: Button = {
        return createButton(title: "+", action: #selector(incrementBadgeNumbers))
    }()

    private lazy var decrementBadgeButton: Button = {
        return createButton(title: "-", action: #selector(decrementBadgeNumbers))
    }()

    private var badgeNumbers: [UInt] = Constants.initialBadgeNumbers
    private var higherBadgeNumbers: [UInt] = Constants.initialHigherBadgeNumbers

    override func viewDidLoad() {
        super.viewDidLoad()

        addRow(text: "Show item titles", items: [itemTitleVisibilitySwitch], textWidth: Constants.switchSettingTextWidth)
        itemTitleVisibilitySwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        addRow(text: "Show badge numbers", items: [showBadgeNumbersSwitch], textWidth: Constants.switchSettingTextWidth)
        showBadgeNumbersSwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        addRow(text: "Use higher badge numbers", items: [useHigherBadgeNumbersSwitch], textWidth: Constants.switchSettingTextWidth)
        useHigherBadgeNumbersSwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

        addRow(text: "Modify badge numbers", items: [incrementBadgeButton, decrementBadgeButton], textWidth: Constants.buttonSettingTextWidth)

        setupTabBarView()
        updateBadgeButtons()
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

        updateBadgeButtons()
        updateBadgeNumbers()
    }

    private func updateBadgeNumbers() {
        if showBadgeNumbers, let tabBarView = tabBarView {
            let numbers = useHigherBadgeNumbers ? higherBadgeNumbers : badgeNumbers

            tabBarView.items[0].setBadgeNumber(numbers[0])
            tabBarView.items[1].setBadgeNumber(numbers[1])
            tabBarView.items[2].setBadgeNumber(numbers[2])
        }
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

    @objc private func handleOnSwitchValueChanged() {
        setupTabBarView()
    }

    @objc private func incrementBadgeNumbers() {
        modifyBadgeNumbers(increment: 1)
    }

    @objc private func decrementBadgeNumbers() {
        modifyBadgeNumbers(increment: -1)
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
