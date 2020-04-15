//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: OtherCellsSampleData

class OtherCellsSampleData: TableViewSampleData {
    static let sections: [Section] = [
        Section(title: "MSActionsCell", items: [
            Item(text1: "Search Directory"),
            Item(text1: "Done", text2: "Cancel")
        ]),
        Section(title: "MSActivityIndicatorCell", items: [Item()]),
        Section(title: "MSBooleanCell", items: [
            Item(text1: "Allow notifications"),
            Item(text1: "Allow notifications", image: "mail-unread-24x24")
        ]),
        Section(title: "MSCenteredLabelCell", items: [Item(text1: "3 results found from directory")])
    ]
}
