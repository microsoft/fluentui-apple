//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: TableViewSampleData

class TableViewSampleData {
    struct Section {
        static let itemCount: Int = 4

        let title: String
        let item: Item
        let numberOfLines: Int
        let hasAccessoryView: Bool
        let allowsMultipleSelection: Bool

        init(title: String, item: Item, numberOfLines: Int = 1, hasAccessoryView: Bool = false, allowsMultipleSelection: Bool = true) {
            self.title = title
            self.item = item
            self.numberOfLines = numberOfLines
            self.hasAccessoryView = hasAccessoryView
            self.allowsMultipleSelection = allowsMultipleSelection
        }
    }

    struct Item {
        let title: String
        let subtitle: String
        let footer: String
        let image: String

        init(title: String = "", subtitle: String = "", footer: String = "", image: String = "") {
            self.title = title
            self.subtitle = subtitle
            self.footer = footer
            self.image = image
        }
    }

    static let sections: [Section] = [
        Section(title: "Single line cell", item: Item(title: "Contoso Survey", image: "excelIcon")),
        Section(title: "Double line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", image: "excelIcon")),
        Section(title: "Triple line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", footer: "22 views", image: "excelIcon")),
        Section(title: "Cell without custom view", item: Item(title: "Contoso Survey", subtitle: "Research Notes")),
        Section(title: "Cell with custom accessory view", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", image: "excelIcon"), hasAccessoryView: true),
        Section(title: "Cell with text truncation", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", footer: "This is a cell with a long footer as an example of how this label will render", image: "excelIcon")),
        Section(title: "Cell with text wrapping", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", footer: "This is a cell with a long footer as an example of how this label will render", image: "excelIcon"), numberOfLines: 0, allowsMultipleSelection: false)
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

    static func createCustomView(imageName: String) -> UIImageView? {
        if imageName == "" {
            return nil
        }

        let customView = UIImageView(image: UIImage(named: imageName))
        customView.contentMode = .scaleAspectFit
        return customView
    }
}
