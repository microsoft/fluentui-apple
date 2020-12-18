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

        var list: MSFListVnext
        var listItem: MSFListVnextCell
        var listItems: [MSFListVnextCell]
        let iconStyle = MSFListIconVnextStyle.none

        for count in 0...numSections {
            section = sections[count]
            cell = section.item
            listItem = MSFListVnextCell()
            listItem.title = cell.text1
            listItem.subtitle = cell.text2
            listItem.leadingView = UIImage(named: cell.image)
            listItems = [listItem, listItem, listItem, listItem, listItem]
            list = MSFListVnext(cells: listItems, layoutType: updateLayout(subtitle: listItem.subtitle), iconStyle: iconStyle)
            addRow(items: [list.view])
        }
        container.addArrangedSubview(UIView())
    }

    private func updateLayout(subtitle: String?) -> MSFListCellVnextLayoutType {
        if subtitle != "" {
            return MSFListCellVnextLayoutType.twoLines
        } else {
            return MSFListCellVnextLayoutType.oneLine
        }
    }
}
