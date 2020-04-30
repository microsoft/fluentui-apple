//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BadgeViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addBadgeSection(title: "Default badge", style: .default)
        addBadgeSection(title: "Error badge", style: .error)
        addBadgeSection(title: "Warning badge", style: .warning)
        addBadgeSection(title: "Disabled badge", style: .default, isEnabled: false)
    }

    func createBadge(text: String, style: BadgeView.Style, size: BadgeView.Size, isEnabled: Bool) -> BadgeView {
        let badge = BadgeView(dataSource: BadgeViewDataSource(text: text, style: style, size: size))
        badge.delegate = self
        badge.isActive = isEnabled
        return badge
    }

    func addBadgeSection(title: String, style: BadgeView.Style, isEnabled: Bool = true) {
        addTitle(text: title)
        for size in BadgeView.Size.allCases.reversed() {
            let badge = createBadge(text: "Kat Larrson", style: style, size: size, isEnabled: isEnabled)
            addRow(text: size.description, items: [badge])
        }
        container.addArrangedSubview(UIView())
    }
}

extension BadgeViewDemoController: BadgeViewDelegate {
    func didSelectBadge(_ badge: BadgeView) { }

    func didTapSelectedBadge(_ badge: BadgeView) {
        badge.isSelected = false
        let alert = UIAlertController(title: "A selected badge was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension BadgeView.Size {
    var description: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        }
    }
}
