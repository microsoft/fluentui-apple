//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class TableViewHeaderFooterSampleData: TableViewSampleData {
    static let numberOfItemsInSection: Int = 5
    static let itemTitle: String = "Contoso Survey"

    static let groupedSections: [Section] = [
        Section(title: "Default"),
        Section(title: "Default with accessory button", hasAccessory: true),
        Section(title: "Default with primary accessory button", hasAccessory: true, accessoryButtonStyle: .primary),
        Section(title: "Default with multi-line text - A description that starts at the bottom and provides three to two lines of info.", numberOfLines: 0, hasFooter: true, footerText: "Footer - A description that starts at the top and provides three to two lines of info. Learn More", footerLinkText: "Learn More"),
        Section(title: "Default with multi-line truncated text - A description that starts at the bottom and provides three to two lines of info. Also maybe used for providing detailed documentation for a specific feature.", numberOfLines: 3, hasFooter: true, footerText: "Footer - A description that starts at the top and provides three to two lines of info. Custom Learn More", footerLinkText: "Custom Learn More", hasCustomLinkHandler: true),
        Section(title: "Default with image-based accessory color", hasAccessory: true, accessoryButtonStyle: .primary, hasColorfulAccessoryButton: true)
    ]

    static let plainSections: [Section] = [
        Section(title: "Divider Highlighted • Label", headerStyle: .dividerHighlighted),
        Section(title: "Divider • Label", headerStyle: .divider),
        Section(title: "Divider • Label", headerStyle: .divider),
        Section(title: "Divider • Label", headerStyle: .divider)
    ]

    static let tabTitles: [String] = ["Default styles", "Divider styles"]
}
