//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSBadgeViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        addTitle(text: "Default badge")
        addBadge(text: "Kat Larrson", style: .default)
        container.addArrangedSubview(UIView())

        addTitle(text: "Error badge")
        addBadge(text: "Allan Munger", style: .error)
        container.addArrangedSubview(UIView())

        addTitle(text: "Warning badge")
        addBadge(text: "Mona Kane", style: .warning)
        container.addArrangedSubview(UIView())

        addTitle(text: "Disabled badge")
        addBadge(text: "Mauricio August", style: .default, isEnabled: false)
    }

    func addBadge(text: String, style: MSBadgeViewStyle, isEnabled: Bool = true) {
        let data = MSBadgeViewDataSource(text: text, style: style)
        let badge = MSBadgeView()
        badge.dataSource = data
        badge.delegate = self
        badge.isEnabled = isEnabled
        container.addArrangedSubview(badge)
    }
}

extension MSBadgeViewDemoController: MSBadgeViewDelegate {
    func didSelectBadge(_ badge: MSBadgeView) { }

    func didTapSelectedBadge(_ badge: MSBadgeView) {
        badge.isSelected = false
        let alert = UIAlertController(title: "A selected badge was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
