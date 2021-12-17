//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BadgeFieldDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let badgeDataSources1 = [
            BadgeViewDataSource(text: "Kat Larrson", style: .default),
            BadgeViewDataSource(text: "Allan Munger", style: .default),
            BadgeViewDataSource(text: "Mona Kane", style: .default),
            BadgeViewDataSource(text: "Mauricio August", style: .default),
            BadgeViewDataSource(text: "Kevin Sturgis", style: .default),
            BadgeViewDataSource(text: "Tim Debeor", style: .default),
            BadgeViewDataSource(text: "Daisy Phillips", style: .default)
        ]
        let badgeDataSources2 = [
            BadgeViewDataSource(text: "Lydia Bauer", style: .default),
            BadgeViewDataSource(text: "Kristin Patterson", style: .default),
            BadgeViewDataSource(text: "Ashley McCarthy", style: .default),
            BadgeViewDataSource(text: "Carole Poland", style: .default),
            BadgeViewDataSource(text: "Amanda Brady", style: .default)
        ]

        let badgeField1 = setupBadgeField(label: "Send to:", dataSources: badgeDataSources1)
        badgeField1.numberOfLines = 1
        let badgeField2 = setupBadgeField(label: "Cc:", dataSources: badgeDataSources2)

        addDescription(text: "Badge field with limited number of lines")
        container.addArrangedSubview(badgeField1)
        container.addArrangedSubview(dividers[0].view)
        container.addArrangedSubview(UIView())
        addDescription(text: "Badge field with unlimited number of lines")
        container.addArrangedSubview(badgeField2)
        container.addArrangedSubview(dividers[1].view)
    }

    private func setupBadgeField(label: String, dataSources: [BadgeViewDataSource]) -> BadgeField {
        let badgeField = BadgeField()
        badgeField.translatesAutoresizingMaskIntoConstraints = false
        badgeField.hardBadgingCharacters = ",;"
        badgeField.label = label
        badgeField.badgeFieldDelegate = self
        badgeField.addBadges(withDataSources: dataSources)
        return badgeField
    }

    private let dividers = [MSFDivider(), MSFDivider()]
}

extension BadgeFieldDemoController: BadgeFieldDelegate {
    func badgeField(_ badgeField: BadgeField, badgeDataSourceForText text: String) -> BadgeViewDataSource {
        return BadgeViewDataSource(text: text, style: .default)
    }

    func badgeField(_ badgeField: BadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: BadgeViewDataSource) -> Bool {
        return !badgeField.badgeDataSources.contains(where: { $0.text == badgeDataSource.text })
    }

    func badgeField(_ badgeField: BadgeField, didTapSelectedBadge badge: BadgeView) {
        badge.isSelected = false
        showMessage("\(badge.dataSource?.text ?? "A selected badge") was tapped")
    }
}
