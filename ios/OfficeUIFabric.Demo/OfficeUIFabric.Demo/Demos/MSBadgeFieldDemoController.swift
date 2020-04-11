//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MSBadgeFieldDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let badgeDataSources1 = [
            MSBadgeViewDataSource(text: "Kat Larrson", style: .default),
            MSBadgeViewDataSource(text: "Allan Munger", style: .default),
            MSBadgeViewDataSource(text: "Mona Kane", style: .default),
            MSBadgeViewDataSource(text: "Mauricio August", style: .default),
            MSBadgeViewDataSource(text: "Kevin Sturgis", style: .default),
            MSBadgeViewDataSource(text: "Tim Debeor", style: .default),
            MSBadgeViewDataSource(text: "Daisy Phillips", style: .default)
        ]
        let badgeDataSources2 = [
            MSBadgeViewDataSource(text: "Lydia Bauer", style: .default),
            MSBadgeViewDataSource(text: "Kristin Patterson", style: .default),
            MSBadgeViewDataSource(text: "Ashley McCarthy", style: .default),
            MSBadgeViewDataSource(text: "Carole Poland", style: .default),
            MSBadgeViewDataSource(text: "Amanda Brady", style: .default)
        ]

        let badgeField1 = setupBadgeField(label: "Send to:", dataSources: badgeDataSources1)
        badgeField1.numberOfLines = 1
        let badgeField2 = setupBadgeField(label: "Cc:", dataSources: badgeDataSources2)

        addDescription(text: "Badge field with limited number of lines")
        container.addArrangedSubview(badgeField1)
        container.addArrangedSubview(UIView())
        addDescription(text: "Badge field with unlimited number of lines")
        container.addArrangedSubview(badgeField2)
    }

    private func setupBadgeField(label: String, dataSources: [MSBadgeViewDataSource]) -> MSBadgeField {
        let badgeField = MSBadgeField()
        badgeField.translatesAutoresizingMaskIntoConstraints = false
        badgeField.hardBadgingCharacters = ",;"
        badgeField.label = label
        badgeField.badgeFieldDelegate = self
        badgeField.addBadges(withDataSources: dataSources)
        return badgeField
    }
}

extension MSBadgeFieldDemoController: MSBadgeFieldDelegate {
    func badgeField(_ badgeField: MSBadgeField, badgeDataSourceForText text: String) -> MSBadgeViewDataSource {
        return MSBadgeViewDataSource(text: text, style: .default)
    }

    func badgeField(_ badgeField: MSBadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: MSBadgeViewDataSource) -> Bool {
        return !badgeField.badgeDataSources.contains(where: { $0.text == badgeDataSource.text })
    }

    func badgeField(_ badgeField: MSBadgeField, didTapSelectedBadge badge: MSBadgeView) {
        badge.isSelected = false
        showMessage("\(badge.dataSource?.text ?? "A selected badge") was tapped")
    }
}
