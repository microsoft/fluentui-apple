//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

class TableViewHeaderFooterSampleData: TableViewSampleData {
    static let numberOfItemsInSection: Int = 5
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

    static let tabTitles: [String] = ["Default styles", "Divider styles"]
}
