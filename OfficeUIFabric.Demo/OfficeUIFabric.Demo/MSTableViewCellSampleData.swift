//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSTableViewCellSampleData

class MSTableViewCellSampleData: TableViewSampleData {
    static let numberOfItemsInSection: Int = 4

    static let sections: [Section] = [
        Section(title: "Single line cell", items: [Item(text1: "Contoso Survey", image: "excelIcon")]),
        Section(title: "Double line cell", items: [Item(text1: "Contoso Survey", text2: "Research Notes", image: "excelIcon")]),
        Section(title: "Triple line cell", items: [Item(text1: "Contoso Survey", text2: "Research Notes", text3: "22 views", image: "excelIcon")]),
        Section(title: "Cell without custom view", items: [Item(text1: "Contoso Survey", text2: "Research Notes")]),
        Section(title: "Cell with custom accessory view", items: [Item(text1: "This is a cell with a long text1 as an example of how this label will render", text2: "This is a cell with a long text2 as an example of how this label will render", image: "excelIcon")], hasAccessory: true),
        Section(title: "Cell with text truncation", items: [Item(text1: "This is a cell with a long text1 as an example of how this label will render", text2: "This is a cell with a long text2 as an example of how this label will render", text3: "This is a cell with a long text3 as an example of how this label will render", image: "excelIcon")]),
        Section(title: "Cell with text wrapping", items: [Item(text1: "This is a cell with a long text1 as an example of how this label will render", text2: "This is a cell with a long text2 as an example of how this label will render", text3: "This is a cell with a long text3 as an example of how this label will render", image: "excelIcon")], numberOfLines: 0, allowsMultipleSelection: false)
    ]

    static var customAccessoryView: UIView {
        let label = MSLabel(style: .body, colorStyle: .secondary)
        label.text = "Value"
        label.sizeToFit()
        return label
    }

    static func accessoryType(for indexPath: IndexPath) -> MSTableViewCellAccessoryType {
        // Demo accessory types based on indexPath row
        switch indexPath.row {
        case 0:
            return .none
        case 1:
            return .disclosureIndicator
        case 2:
            return .detailButton
        default:
            return .checkmark
        }
    }
}
