//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ListVnextDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let sections = TableViewCellSampleData.sections
        var section: TableViewCellSampleData.Section
        var cell: TableViewCellSampleData.Item
        var indexPath = IndexPath(row: 0, section: 0)

        var list: MSFListVnext
        var listCell: MSFListVnextCellData
        var listSection: MSFListVnextSectionData
        var listData: [MSFListVnextSectionData] = []
        let iconStyle = MSFListIconVnextStyle.none

        for sectionIndex in 0...sections.count - 1 {
            section = sections[sectionIndex]

            listSection = MSFListVnextSectionData()
            listSection.title = section.title
            listSection.cells = []
            for rowIndex in 0...TableViewCellSampleData.numberOfItemsInSection - 1 {
                cell = section.item
                listCell = MSFListVnextCellData()
                listCell.title = cell.text1
                listCell.subtitle = cell.text2
                listCell.leadingIcon = UIImage(named: cell.image)
                listCell.accessoryType = accessoryType(for: rowIndex)
                listCell.onTapAction = {
                    indexPath.row = rowIndex
                    indexPath.section = sectionIndex
                    self.showAlertForCellTapped(indexPath: indexPath)
                }
                listSection.cells.append(listCell)
            }
            listSection.layoutType = updateLayout(subtitle: listSection.cells[0].subtitle)
            listData.append(listSection)
        }
        list = MSFListVnext(sections: listData, iconStyle: iconStyle)

        let listView = list.view
        listView.translatesAutoresizingMaskIntoConstraints = false

        let demoControllerView: UIView = self.view
        demoControllerView.addSubview(listView)

        NSLayoutConstraint.activate([demoControllerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: listView.topAnchor),
                                     demoControllerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: listView.bottomAnchor),
                                     demoControllerView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
                                     demoControllerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: listView.trailingAnchor)])
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
        if let subtitle = subtitle, !subtitle.isEmpty {
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
