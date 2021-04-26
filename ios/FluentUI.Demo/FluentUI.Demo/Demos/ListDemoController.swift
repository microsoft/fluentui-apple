//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ListDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let sections = TableViewCellSampleData.sections
        var section: TableViewCellSampleData.Section
        var cell: TableViewCellSampleData.Item
        var indexPath = IndexPath(row: 0, section: 0)
        var showsLabelAccessoryView: Bool

        var list: MSFList
        var listCell: MSFListCellState
        var listSection: MSFListSectionState
        var listData: [MSFListSectionState] = []

        let samplePersonas: [PersonaData] = [
            PersonaData(name: "Kat Larrson", email: "kat.larrson@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_kat_larsson"), color: Colors.Palette.cyanBlue10.color),
            PersonaData(name: "Kristin Patterson", email: "kristin.patterson@contoso.com", subtitle: "Software Engineer", color: Colors.Palette.red10.color),
            PersonaData(name: "Ashley McCarthy", avatarImage: UIImage(named: "avatar_ashley_mccarthy"), color: Colors.Palette.magenta20.color),
            PersonaData(name: "Allan Munger", email: "allan.munger@contoso.com", subtitle: "Designer", avatarImage: UIImage(named: "avatar_allan_munger"), color: Colors.Palette.green10.color),
            PersonaData(name: "Amanda Brady", subtitle: "Program Manager", avatarImage: UIImage(named: "avatar_amanda_brady"), color: Colors.Palette.magentaPink10.color)
        ]

        var avatar: MSFAvatar

        /// Subchildren list items
        var subchildren: [MSFListCellState] = []
        listCell = MSFListCellState()
        avatar = createAvatarView(size: .medium,
                                  name: samplePersonas[4].name,
                                  image: samplePersonas[4].avatarImage,
                                  style: .default)
        listCell.title = avatar.state.primaryText ?? ""
        listCell.leadingUIView = avatar.view
        listCell.onTapAction = {
            self.showAlertForAvatarTapped(name: samplePersonas[4].name)
        }
        subchildren.append(listCell)

        /// Children list items
        var children: [MSFListCellState] = []
        for index in 2...3 {
            listCell = MSFListCellState()
            avatar = createAvatarView(size: .medium,
                                      name: samplePersonas[index].name,
                                      image: samplePersonas[index].avatarImage,
                                      style: .default)
            listCell.title = avatar.state.primaryText ?? ""
            listCell.leadingUIView = avatar.view
            children.append(listCell)
        }
        children[0].children = subchildren
        children[0].isExpanded = true
        children[1].onTapAction = {
            self.showAlertForAvatarTapped(name: samplePersonas[3].name)
        }

        /// Custom Leading View with collapsible children items
        listSection = MSFListSectionState()
        listSection.title = "Avatar Section"
        listSection.cells = []
        for index in 0...1 {
            listCell = MSFListCellState()
            avatar = createAvatarView(size: .medium,
                                      name: samplePersonas[index].name,
                                      image: samplePersonas[index].avatarImage,
                                      style: .default)
            listCell.title = avatar.state.primaryText ?? ""
            listCell.leadingUIView = avatar.view
            listSection.cells.append(listCell)
        }
        listSection.cells[0].children = children
        listSection.cells[0].isExpanded = true
        listSection.cells[1].onTapAction = {
            self.showAlertForAvatarTapped(name: samplePersonas[1].name)
        }
        listData.append(listSection)

        /// TableViewCell Sample Data Sections
        for sectionIndex in 0...sections.count - 1 {
            indexPath.section = sectionIndex
            section = sections[sectionIndex]

            listSection = MSFListSectionState()
            listSection.title = section.title
            listSection.cells = []
            listSection.style = MSFHeaderFooterStyle.headerSecondary
            for rowIndex in 0...TableViewCellSampleData.numberOfItemsInSection - 1 {
                indexPath.row = rowIndex
                showsLabelAccessoryView = TableViewCellSampleData.hasLabelAccessoryViews(at: indexPath)
                cell = section.item
                listCell = MSFListCellState()
                listCell.title = cell.text1
                listCell.subtitle = cell.text2
                listCell.footnote = cell.text3
                if !listCell.subtitle.isEmpty {
                    listCell.leadingViewSize = MSFListCellLeadingViewSize.large
                    listCell.subtitleLeadingAccessoryUIView = showsLabelAccessoryView ? createCustomView(imageName: "success-12x12", imageType: "subtitle") : nil
                    listCell.subtitleTrailingAccessoryUIView = showsLabelAccessoryView ? createCustomView(imageName: "chevron-down-20x20", imageType: "subtitle") : nil
                }

                listCell.titleLeadingAccessoryUIView = showsLabelAccessoryView ? createCustomView(imageName: "ic_fluent_presence_available_16_filled", imageType: "title") : nil
                listCell.titleTrailingAccessoryUIView = showsLabelAccessoryView ? createCustomView(imageName: "chevron-right-20x20", imageType: "title") : nil

                listCell.titleLineLimit = section.numberOfLines
                listCell.subtitleLineLimit = section.numberOfLines
                listCell.footnoteLineLimit = section.numberOfLines
                listCell.leadingUIView = createCustomView(imageName: cell.image)
                listCell.trailingUIView = section.hasAccessory ? createCustomView(imageName: cell.image) : nil
                listCell.accessoryType = accessoryType(for: rowIndex)
                listCell.onTapAction = {
                    indexPath.row = rowIndex
                    indexPath.section = sectionIndex
                    self.showAlertForCellTapped(indexPath: indexPath)
                }
                listSection.cells.append(listCell)
                listSection.hasDividers = true
            }
            listData.append(listSection)
        }

        list = MSFList(sections: listData)

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

    private func createCustomView(imageName: String,
                                  useImageAsTemplate: Bool = false,
                                  imageType: String = "") -> UIImageView? {
        if imageName == "" {
            return nil
        }
        var image = UIImage(named: imageName)
        if useImageAsTemplate {
            image = image?.withRenderingMode(.alwaysTemplate)
        }
        let customView = UIImageView(image: image)
        customView.contentMode = .scaleAspectFit

        switch imageType {
        case "title":
            customView.tintColor = Colors.textPrimary
        case "subtitle":
            customView.tintColor = Colors.textSecondary
        default:
            customView.tintColor = Colors.iconSecondary
        }
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

    private func showAlertForCellTapped(indexPath: IndexPath) {
        let title = TableViewCellSampleData.sections[indexPath.section].title
        let alert = UIAlertController(title: "Row #\(indexPath.row + 1) in the \(title) section has been pressed.",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func showAlertForAvatarTapped(name: String) {
        let alert = UIAlertController(title: "\(name) selected.",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
