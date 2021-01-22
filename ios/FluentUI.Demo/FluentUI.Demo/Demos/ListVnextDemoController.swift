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

        let samplePersonas: [PersonaData] = [
            PersonaData(name: "Kat Larrson", email: "kat.larrson@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_kat_larsson"), color: Colors.Palette.cyanBlue10.color),
            PersonaData(name: "Kristin Patterson", email: "kristin.patterson@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.red10.color),
            PersonaData(name: "Ashley McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy"), color: Colors.Palette.magenta20.color),
            PersonaData(name: "Allan Munger", email: "allan.munger@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_allan_munger"), color: Colors.Palette.green10.color),
            PersonaData(name: "Amanda Brady", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_amanda_brady"), color: Colors.Palette.magentaPink10.color)
        ]

        var avatar: MSFAvatar

        /// AvatarView section
        listSection = MSFListVnextSectionData()
        listSection.title = "AvatarView Section"
        listSection.cells = []
        for index in 0...samplePersonas.count - 1 {
            listCell = MSFListVnextCellData()
            avatar = createAvatarView(size: .medium,
                                      name: samplePersonas[index].name,
                                      image: samplePersonas[index].avatarImage,
                                      style: .default)
            listCell.title = avatar.state.primaryText ?? ""
            listCell.leadingView = avatar.view
            listCell.layoutType = MSFListCellVnextLayoutType.twoLines
            listSection.cells.append(listCell)
        }
        listData.append(listSection)

        /// TableViewCell Sample Data Sections
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
                listCell.leadingView = createCustomView(imageName: cell.image)
                listCell.accessoryType = accessoryType(for: rowIndex)
                listCell.layoutType = updateLayout(subtitle: listCell.subtitle)
                listCell.onTapAction = {
                    indexPath.row = rowIndex
                    indexPath.section = sectionIndex
                    self.showAlertForCellTapped(indexPath: indexPath)
                }
                listSection.cells.append(listCell)
            }
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

    private func createAvatarView(size: MSFAvatarSize,
                                  name: String? = nil,
                                  image: UIImage? = nil,
                                  style: MSFAvatarStyle) -> MSFAvatar {
        let avatarView = MSFAvatar(style: style,
                                        size: size)
        avatarView.state.primaryText = name
        avatarView.state.image = image

        return avatarView
    }

    private func createCustomView(imageName: String, useImageAsTemplate: Bool = false) -> UIImageView? {
        if imageName == "" {
            return nil
        }
        var image = UIImage(named: imageName)
        if useImageAsTemplate {
            image = image?.withRenderingMode(.alwaysTemplate)
        }
        let customView = UIImageView(image: image)
        customView.contentMode = .scaleAspectFit
        customView.tintColor = Colors.Table.Cell.image
        return customView
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
