//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

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

    private lazy var homeItem: TabBarItem = homeItem(shouldShowTitle: false)

    private var badgeNumbers: [UInt] = Constants.initialBadgeNumbers
    private var higherBadgeNumbers: [UInt] = Constants.initialHigherBadgeNumbers

    override func viewDidLoad() {
        super.viewDidLoad()

        readmeString = "The tab bar lets people quickly move through the main sections of an app.\n\nTab bars don’t move people in relation to their current page. If you need to let people go back and forth from their current location, try the navigation bar. If your app has the space for it, you can use a left rail instead of a tab bar."

        container.addArrangedSubview(createButton(title: "Show tooltip for Home button", action: #selector(showTooltipForHomeButton)))

        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

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
        var isOpenFileUnread = true
        if let oldTabBarView = tabBarView {
            isOpenFileUnread = oldTabBarView.items[2].isUnreadDotVisible
            if let constraints = tabBarViewConstraints {
                NSLayoutConstraint.deactivate(constraints)
            }
            oldTabBarView.removeFromSuperview()
        }

        let updatedTabBarView = TabBarView(showsItemTitles: showsItemTitles)
        updatedTabBarView.delegate = self

        if showsItemTitles {
            homeItem = homeItem(shouldShowTitle: true)
            updatedTabBarView.items = [
                homeItem,
                TabBarItem(title: "New", image: UIImage(named: "New_24")!, selectedImage: UIImage(named: "New_Selected_24")!),
                TabBarItem(title: "Open", image: UIImage(named: "Open_24")!, selectedImage: UIImage(named: "Open_Selected_24")!)
            ]
        } else {
            homeItem = homeItem(shouldShowTitle: false)
            updatedTabBarView.items = [
                homeItem,
                TabBarItem(title: "New", image: UIImage(named: "New_28")!, selectedImage: UIImage(named: "New_Selected_28")!, landscapeImage: UIImage(named: "New_24")!, landscapeSelectedImage: UIImage(named: "New_Selected_24")!),
                TabBarItem(title: "Open", image: UIImage(named: "Open_28")!, selectedImage: UIImage(named: "Open_Selected_28")!, landscapeImage: UIImage(named: "Open_24")!, landscapeSelectedImage: UIImage(named: "Open_Selected_24")!)
            ]
        }

        // If the open file item has been clicked, maintain that state through to the new item
        updatedTabBarView.items[2].isUnreadDotVisible = isOpenFileUnread

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

    private func homeItem(shouldShowTitle: Bool) -> TabBarItem {
        if shouldShowTitle {
            return TabBarItem(title: "Home",
                              image: UIImage(named: "Home_24")!,
                              selectedImage: UIImage(named: "Home_Selected_24")!)
        }
        return TabBarItem(title: "Home",
                          image: UIImage(named: "Home_28")!,
                          selectedImage: UIImage(named: "Home_Selected_28")!,
                          landscapeImage: UIImage(named: "Home_24")!,
                          landscapeSelectedImage: UIImage(named: "Home_Selected_24")!)
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

    @objc private func showTooltipForHomeButton() {
        guard let tabBarView = tabBarView, let view = tabBarView.itemView(with: homeItem) else {
            return
        }

        Tooltip.shared.show(with: "Tap anywhere to dismiss this tooltip",
                            for: view,
                            preferredArrowDirection: .down,
                            offset: .init(x: 0, y: 6),
                            dismissOn: .tapAnywhere)
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

// MARK: - TabBarViewDemoController: DemoAppearanceDelegate
extension TabBarViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TabBarTokenSet.self,
                             tokenSet: isOverrideEnabled ? perControlOverrideTabBarItemTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        let tokens = isOverrideEnabled ? perControlOverrideTabBarItemTokens : nil
        tabBarView?.tokenSet.replaceAllOverrides(with: tokens)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TabBarTokenSet.self) != nil
    }

    // MARK: - Custom tokens
    private var themeWideOverrideTabBarTokens: [TabBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .tabBarItemSelectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.burgundy, .tint10),
                               lightHighContrast: GlobalTokens.sharedColor(.pumpkin, .tint10),
                               dark: GlobalTokens.sharedColor(.darkTeal, .tint40),
                               darkHighContrast: GlobalTokens.sharedColor(.teal, .tint40))
            },
            .tabBarItemUnselectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.darkTeal, .tint20),
                               lightHighContrast: GlobalTokens.sharedColor(.teal, .tint40),
                               dark: GlobalTokens.sharedColor(.pumpkin, .tint40),
                               darkHighContrast: GlobalTokens.sharedColor(.burgundy, .tint40))
            }
        ]
    }

    private var perControlOverrideTabBarItemTokens: [TabBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .tabBarItemTitleLabelFontPortrait: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0), size: 20.0)
            },
            .tabBarItemTitleLabelFontLandscape: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0), size: 20.0)
            },
            .tabBarItemSelectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.burgundy, .tint10),
                               lightHighContrast: GlobalTokens.sharedColor(.pumpkin, .tint10),
                               dark: GlobalTokens.sharedColor(.darkTeal, .tint40),
                               darkHighContrast: GlobalTokens.sharedColor(.teal, .tint40))
            },
            .tabBarItemUnselectedColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.darkTeal, .tint20),
                               lightHighContrast: GlobalTokens.sharedColor(.teal, .tint40),
                               dark: GlobalTokens.sharedColor(.pumpkin, .tint40),
                               darkHighContrast: GlobalTokens.sharedColor(.burgundy, .tint40))
            }
        ]
    }
}
