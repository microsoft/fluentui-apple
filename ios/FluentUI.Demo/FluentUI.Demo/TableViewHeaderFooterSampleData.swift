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
        Section(title: "Primary Title", headerStyle: .headerPrimary),
        Section(title: "Primary Expandable", numberOfLines: 0, headerStyle: .headerPrimary, hasCustomLeadingView: true, hasHandler: true),
        Section(title: "Default"),
        Section(title: "Default with accessory button", numberOfLines: 0, hasAccessory: true),
        Section(title: "Default with primary accessory button", numberOfLines: 0, hasAccessory: true, accessoryButtonStyle: .primary),
        Section(title: "Default with multi-line text - A description that starts at the bottom and provides three to two lines of info.", numberOfLines: 0, hasFooter: true, footerText: "Footer - A description that starts at the top and provides three to two lines of info. Learn More", footerLinkText: "Learn More"),
        Section(title: "Default with multi-line truncated text - A description that starts at the bottom and provides three to two lines of info. Also maybe used for providing detailed documentation for a specific feature.", numberOfLines: 3, hasFooter: true, footerText: "Footer - A description that starts at the top and provides three to two lines of info. Custom Learn More", footerLinkText: "Custom Learn More", hasCustomLinkHandler: true),
        Section(title: "Default with custom accessory view", numberOfLines: 0, hasCustomAccessoryView: true)
    ]
}
