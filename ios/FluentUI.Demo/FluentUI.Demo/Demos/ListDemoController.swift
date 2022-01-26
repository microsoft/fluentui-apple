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

        let list: MSFList = MSFList()
        var listCell: MSFListCellState

        //PersonaDataNode creation
        var personaDataNodes: [PersonaDataNode] = []
        for samplePersonaIndex in 0...5 {
            let personaDataNode = PersonaDataNode(personaData: samplePersonas[samplePersonaIndex])
            personaDataNodes.append(personaDataNode)
        }

        personaDataNodes[2].children = [personaDataNodes[4]]

        personaDataNodes[0].children = [personaDataNodes[2], personaDataNodes[3]]

        /// Custom Leading View with collapsible children items
        let collapsibleSection = list.state.createSection()
        collapsibleSection.title = "AvatarSection"
        for samplePersonaIndex in 0...1 {
            let collapsibleCell = collapsibleSection.createCell()
            createSamplePersonaCell(cellState: collapsibleCell, personaDataNode: personaDataNodes[samplePersonaIndex])
        }
        collapsibleSection.hasDividers = true

        /// TableViewCell Sample Data Sections
        for sectionIndex in 0..<sections.count {
            indexPath.section = sectionIndex
            section = sections[sectionIndex]

            let sectionState = list.state.createSection()
            sectionState.title = section.title
            sectionState.style = MSFHeaderFooterStyle.headerSecondary
            sectionState.hasDividers = true
            for rowIndex in 0..<TableViewCellSampleData.numberOfItemsInSection {
                indexPath.row = rowIndex
                showsLabelAccessoryView = TableViewCellSampleData.hasLabelAccessoryViews(at: indexPath)
                cell = section.item
                listCell = sectionState.createCell()
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

                listCell.leadingUIView = createCustomView(imageName: cell.image)
                listCell.trailingUIView = section.hasAccessory ? createCustomView(imageName: cell.image) : nil
                listCell.accessoryType = accessoryType(for: rowIndex)
                listCell.onTapAction = {
                    indexPath.row = rowIndex
                    indexPath.section = sectionIndex
                    self.showAlertForCellTapped(indexPath: indexPath)
                }
            }
        }

        let listView = list.view
        listView.translatesAutoresizingMaskIntoConstraints = false

        let demoControllerView: UIView = self.view
        demoControllerView.addSubview(listView)

        NSLayoutConstraint.activate([demoControllerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: listView.topAnchor),
                                     demoControllerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: listView.bottomAnchor),
                                     demoControllerView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
                                     demoControllerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: listView.trailingAnchor)])
    }

    struct PersonaDataNode {
        var personaData: PersonaData
        var children: [PersonaDataNode] = []
        var isExpanded: Bool = true
    }

    private func createSamplePersonaCell(cellState: MSFListCellState, personaDataNode: PersonaDataNode) {
        let personaData = personaDataNode.personaData
        let personaChildren = personaDataNode.children
        let avatar = createAvatarView(size: .medium,
                                      name: personaData.name,
                                      image: personaData.image,
                                      style: .default)
        cellState.title = avatar.state.primaryText ?? ""
        cellState.leadingUIView = avatar.view
        cellState.isExpanded = personaDataNode.isExpanded
        cellState.hasDivider = true

        guard !personaChildren.isEmpty else {
            cellState.onTapAction = {
                self.showAlertForAvatarTapped(name: personaData.name)
            }
            return
        }

        for index in 0..<personaChildren.count {
            createSamplePersonaCell(cellState: cellState.createChildCell(), personaDataNode: personaChildren[index])
        }
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
