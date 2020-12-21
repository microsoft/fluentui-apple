//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ListVnextDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        container.alignment = .leading
        let sections: [TableViewSampleData.Section] = TableViewCellSampleData.sections
        var section: TableViewCellSampleData.Section
        var cell: TableViewCellSampleData.Item
        let numSections = sections.count - 1
        let numRows = TableViewCellSampleData.numberOfItemsInSection - 1

        var list: MSFListVnext
        var listItem: MSFListVnextCell
        var listItems: [MSFListVnextCell]
        let iconStyle = MSFListIconVnextStyle.none

        for count in 0...numSections {
            section = sections[count]

            listItems = []
            for row in 0...numRows {
                cell = section.item
                listItem = MSFListVnextCell()
                listItem.handler = showAlertForCellTapped
                listItem.title = cell.text1
                listItem.subtitle = cell.text2
                listItem.leadingView = UIImage(named: cell.image)
                listItem.trailingView = accessoryType(for: row)
                listItems.append(listItem)
            }

            list = MSFListVnext(cells: listItems, layoutType: updateLayout(subtitle: listItems[0].subtitle), iconStyle: iconStyle)
            addRow(items: [list.view])
        }
        container.addArrangedSubview(UIView())
    }

    private func accessoryType(for indexPath: Int) -> TableViewCellAccessoryType {
        // Demo accessory types based on indexPath row
        switch indexPath {
        case 0:
            return .none
        case 1:
            return .disclosureIndicator
        case 2:
            return .detailButton
        case 3:
            return .checkmark
        case 4:
            return .none
        default:
            return .none
        }
    }

    private func updateLayout(subtitle: String?) -> MSFListCellVnextLayoutType {
        if subtitle != "" {
            return MSFListCellVnextLayoutType.twoLines
        } else {
            return MSFListCellVnextLayoutType.oneLine
        }
    }

    func showAlertForCellTapped() {
        let alert = UIAlertController(title: "A cell was pressed",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
