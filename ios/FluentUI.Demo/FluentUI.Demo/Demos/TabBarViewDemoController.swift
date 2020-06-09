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

    private let itemTitleVisibilitySwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()

        addRow(text: "Show item titles", items: [itemTitleVisibilitySwitch], textWidth: 110)
        itemTitleVisibilitySwitch.addTarget(self, action: #selector(handleOnSwitchValueChanged), for: .valueChanged)

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
