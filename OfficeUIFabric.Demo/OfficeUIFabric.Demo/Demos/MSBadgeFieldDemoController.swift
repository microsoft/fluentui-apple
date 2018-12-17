//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
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

        let title1 = setupTitle(text: "Badge field with limited number of lines")
        let title2 = setupTitle(text: "Badge field with unlimited number of lines")

        container.addArrangedSubview(title1)
        container.addArrangedSubview(badgeField1)
        container.addArrangedSubview(UIView())
        container.addArrangedSubview(title2)
        container.addArrangedSubview(badgeField2)
    }

    func setupTitle(text: String) -> MSLabel {
        let titleLabel = MSLabel(style: .subhead, colorStyle: .regular)
        titleLabel.text = text
        return titleLabel
    }

    private func setupBadgeField(label: String, dataSources: [MSBadgeViewDataSource]) -> MSBadgeField {
        let badgeField = MSBadgeField()
        badgeField.translatesAutoresizingMaskIntoConstraints = false
        badgeField.hardBadgingCharacters = ",;"
        badgeField.label = label
        badgeField.delegate = self
        badgeField.addBadges(withDataSources: dataSources)
        return badgeField
    }
}

extension MSBadgeFieldDemoController: MSBadgeFieldDelegate {
    func badgeField(_ badgeField: MSBadgeField, badgeDataSourceForText text: String) -> MSBadgeBaseViewDataSource {
        return MSBadgeViewDataSource(text: text, style: .default)
    }

    func badgeField(_ badgeField: MSBadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: MSBadgeBaseViewDataSource) -> Bool {
        return !badgeField.badgeDataSources.contains(where: { $0.text == badgeDataSource.text })
    }

    func badgeField(_ badgeField: MSBadgeField, newBadgeForBadgeDataSource badgeDataSource: MSBadgeBaseViewDataSource) -> MSBadgeBaseView {
        let badgeView = MSBadgeView()
        badgeView.dataSource = badgeDataSource
        return badgeView
    }

    func badgeField(_ badgeField: MSBadgeField, newMoreBadgeForBadgeDataSources badgeDataSources: [MSBadgeBaseViewDataSource]) -> MSBadgeBaseView {
        let badge = MSBadgeView()
        badge.dataSource = MSBadgeViewDataSource(text: "+\(badgeDataSources.count)", style: .default)
        return badge
    }
}
