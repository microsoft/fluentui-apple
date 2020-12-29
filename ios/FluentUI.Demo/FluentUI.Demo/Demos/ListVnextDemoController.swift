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
        var indexPath = IndexPath(row: 0, section: 0)

        var list: MSFListVnext
        var listItem: MSFListVnextCellData
        var listItems: [MSFListVnextCellData]
        let iconStyle = MSFListIconVnextStyle.none

        for sectionCount in 0...numSections {
            section = sections[sectionCount]

            listItems = []
            for row in 0...numRows {
                cell = section.item
                listItem = MSFListVnextCellData()
                listItem.title = cell.text1
                listItem.subtitle = cell.text2
                listItem.leadingIcon = UIImage(named: cell.image)
                listItem.trailingIcon = accessoryType(for: row)
                listItem.onTapAction = {
                    indexPath.row = row
                    indexPath.section = sectionCount
                    self.showAlertForCellTapped(indexPath: indexPath)
                }
                listItems.append(listItem)
            }

            list = MSFListVnext(cells: listItems, layoutType: updateLayout(subtitle: listItems[0].subtitle), iconStyle: iconStyle)
            list.state.sectionTitle = section.title
            addRow(items: [list.view])
        }
        container.addArrangedSubview(UIView())
    }

    private func accessoryType(for indexPath: Int) -> MSFListAccessoryType {
        switch indexPath {
        case 0:
            return .none
        case 1:
            return .disclosure
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

    private func showAlertForCellTapped(indexPath: IndexPath) {
        let title = TableViewCellSampleData.sections[indexPath.section].title
        let alert = UIAlertController(title: "Row #\(indexPath.row + 1) in the \(title) section has been pressed.",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
