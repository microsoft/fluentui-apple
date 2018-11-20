//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
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

    func addTitle(text: String) {
        let titleLabel = MSLabel(style: .subhead, colorStyle: .regular)
        titleLabel.text = text
        container.addArrangedSubview(titleLabel)
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

extension MSBadgeViewDemoController: MSBadgeBaseViewDelegate {
    func didSelectBadge(_ badge: MSBadgeBaseView) { }

    func didTapSelectedBadge(_ badge: MSBadgeBaseView) {
        badge.isSelected = false
        let alert = UIAlertController(title: "A selected badge was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
