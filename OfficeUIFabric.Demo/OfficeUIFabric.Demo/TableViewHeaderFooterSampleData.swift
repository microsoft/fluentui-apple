//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: TableViewHeaderFooterConstants

struct TableViewHeaderFooterConstants {
    static let titleVerticalMargin: CGFloat = 16
    static let titleSpacing: CGFloat = MSTextStyle.headline.font.deviceLineHeightWithLeading + titleVerticalMargin * 2
}

// MARK: - TableViewHeaderFooterSampleData

class TableViewHeaderFooterSampleData: TableViewSampleData {
    static let numberOfItemsInSection: Int = 2
    static let itemTitle: String = "Contoso Survey"

    static let groupedSections: [Section] = [
        Section(title: "Default"),
        Section(title: "Default with accessory button", hasAccessoryView: true),
        Section(title: "Default with multi-line text - A description that starts at the bottom and provides three to two lines of info.", numberOfLines: 0, hasFooter: true, footerText: "Footer - A description that starts at the top and provides three to two lines of info.")
    ]

    static let plainSections: [Section] = [
        Section(title: "Divider Highlighted • Label", headerStyle: .dividerHighlighted),
        Section(title: "Divider • Label", headerStyle: .divider),
        Section(title: "Divider • Label", headerStyle: .divider),
        Section(title: "Divider • Label", headerStyle: .divider)
    ]

    static let groupedTitle: MSLabel = titleLabel(text: "Grouped with default styles")
    static let plainTitle: MSLabel = titleLabel(text: "Plain with divider styles")

    static func titleLabel(text: String) -> MSLabel {
        let label = MSLabel(style: .headline)
        label.text = text
        label.textAlignment = .center
        return label
    }
}
