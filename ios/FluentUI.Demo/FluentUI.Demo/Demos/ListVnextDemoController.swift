//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
  import UIKit

  class ListVnextDemoController: VXTViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let sections: [TableViewSampleData.Section] = TableViewCellSampleData.sections
        var section: TableViewCellSampleData.Section
        var cell: TableViewCellSampleData.Item
        let numSections = sections.count - 1

        var list: MSFListVnext?
        var listItem: MSFListItem
        var listItems: [MSFListItem]
        let style = MSFListAccessoryVnextStyle.iconOnly
        let size = MSFListAccessoryVnextSize.icon

        for count in 0...numSections {
            section = sections[count]
            cell = section.item
            listItem = MSFListItem()
            listItem.title = cell.text1
            listItem.subtitle = cell.text2
            listItem.leadingView = cell.image
            listItems = [listItem, listItem, listItem, listItem, listItem]
            list = MSFListVnext(cells: listItems, style: style, size: size)

            if let controller = list?.hostingController {
                add(controller)
            }
        }
    }
  }
