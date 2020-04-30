//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: TableViewCellSampleData

class TableViewCellSampleData: TableViewSampleData {
    static let numberOfItemsInSection: Int = 5
    static let numberOfItemsInSectionForShimmer: Int = 3

    static let sections: [Section] = [
        Section(
            title: "Single line cell",
            items: [
                Item(text1: "Contoso Survey",
                     image: "excelIcon",
                     text1LeadingAccessoryView: { createIconsAccessoryView(images: ["success-12x12"]) })
            ]
        ),
        Section(
            title: "Double line cell",
            items: [
                Item(text1: "Contoso Survey",
                     text2: "Research Notes",
                     image: "excelIcon",
                     text2LeadingAccessoryView: { createIconsAccessoryView(images: ["shared-12x12", "success-12x12"]) })
            ]
        ),
        Section(
            title: "Triple line cell",
            items: [
                Item(text1: "Contoso Survey",
                     text2: "Research Notes",
                     text3: "22 views",
                     image: "excelIcon",
                     text2TrailingAccessoryView: { createIconsAccessoryView(images: ["shared-12x12", "success-12x12"]) },
                     text3TrailingAccessoryView: { createProgressAccessoryView() })
            ],
            hasFullLengthLabelAccessoryView: true
        ),
        Section(
            title: "Cell without custom view",
            items: [
                Item(text1: "Contoso Survey",
                     text2: "Research Notes",
                     text1TrailingAccessoryView: { createTextAccessoryView(text: "8:13 AM") },
                     text2LeadingAccessoryView: { createIconsAccessoryView(images: ["success-12x12"]) },
                     text2TrailingAccessoryView: { createIconsAccessoryView(images: ["at-12x12"], rightAligned: true) })
            ]
        ),
        Section(
            title: "Cell with custom accessory view",
            items: [
                Item(text1: "Format")
            ],
            hasAccessory: true
        ),
        Section(
            title: "Cell with text truncation",
            items: [
                Item(text1: "This is a cell with a long text1 as an example of how this label will render",
                     text2: "This is a cell with a long text2 as an example of how this label will render",
                     text3: "This is a cell with a long text3 as an example of how this label will render",
                     image: "excelIcon",
                     text1TrailingAccessoryView: { createTextAccessoryView(text: "10:21 AM") },
                     text2TrailingAccessoryView: { createIconsAccessoryView(images: ["at-12x12"], rightAligned: true) },
                     text3TrailingAccessoryView: { createTextAccessoryView(text: "2", withBorder: true) })
            ]
        ),
        Section(
            title: "Cell with text wrapping",
            items: [
                Item(text1: "This is a cell with a long text1 as an example of how this label will render",
                     text2: "This is a cell with a long text2 as an example of how this label will render",
                     text3: "This is a cell with a long text3 as an example of how this label will render",
                     image: "excelIcon",
                     text1TrailingAccessoryView: { createTextAccessoryView(text: "10:21 AM") },
                     text2TrailingAccessoryView: { createIconsAccessoryView(images: ["at-12x12"], rightAligned: true) },
                     text3TrailingAccessoryView: { createTextAccessoryView(text: "2", withBorder: true) })
            ],
            numberOfLines: 0,
            allowsMultipleSelection: false
        )
    ]

    static var customAccessoryView: UIView {
        let label = Label(style: .body, colorStyle: .secondary)
        label.text = "PowerPoint Presentation"
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }

    static func hasLabelAccessoryViews(at indexPath: IndexPath) -> Bool {
        return indexPath.row == 4
    }

    static func hasFullLengthLabelAccessoryView(at indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        return section.hasFullLengthLabelAccessoryView && hasLabelAccessoryViews(at: indexPath)
    }

    static func accessoryType(for indexPath: IndexPath) -> TableViewCellAccessoryType {
        // Demo accessory types based on indexPath row
        switch indexPath.row {
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

    static func labelAccessoryView(accessories: [UIView], spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = alignment

        let accessoryView = UIStackView()
        accessoryView.axis = .horizontal
        accessoryView.alignment = .center
        accessoryView.spacing = spacing

        accessories.forEach { accessoryView.addArrangedSubview($0) }

        container.addArrangedSubview(accessoryView)

        return container
    }

    static func createIconsAccessoryView(images: [String], rightAligned: Bool = false) -> UIView {
        let iconSpacing: CGFloat = 6
        var icons: [UIImageView] = []

        images.forEach {
            icons.append(UIImageView(image: UIImage(named: $0)))
        }

        return labelAccessoryView(accessories: icons, spacing: iconSpacing, alignment: rightAligned ? .trailing : .leading )
    }

    static func createProgressAccessoryView() -> UIView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.5
        return labelAccessoryView(accessories: [progressView], spacing: 0, alignment: .fill)
    }

    static func createTextAccessoryView(text: String, withBorder: Bool = false) -> UIView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical

        let label = Label(style: .footnote)
        label.textColor = Colors.foreground3
        label.text = text
        stackView.addArrangedSubview(label)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)

        let container = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: container.topAnchor),
                                     stackView.heightAnchor.constraint(equalTo: container.heightAnchor),
                                     stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                     stackView.widthAnchor.constraint(equalTo: container.widthAnchor)])

        if withBorder {
            container.layer.borderWidth = UIScreen.main.devicePixel
            container.layer.borderColor = Colors.foreground6b.cgColor
            container.layer.cornerRadius = 3
        }

        return labelAccessoryView(accessories: [container], spacing: 0, alignment: .trailing)
    }
}
