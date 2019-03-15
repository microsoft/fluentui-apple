//
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
//

import Foundation
import OfficeUIFabric

// MARK: MSTableViewSampleData

class MSTableViewSampleData {
    struct Section {
        let title: String
        let item: Item
        let numberOfLines: Int
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
        Section(title: "Single line cell", item: Item(title: "Contoso Survey", image: "excelIcon"), numberOfLines: 1),
        Section(title: "Double line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", image: "excelIcon"), numberOfLines: 1),
        Section(title: "Triple line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", footer: "22 views", image: "excelIcon"), numberOfLines: 1),
        Section(title: "Cell without custom view", item: Item(title: "Contoso Survey", subtitle: "Research Notes"), numberOfLines: 1),
        Section(title: "Cell with text truncation", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", footer: "This is a cell with a long footer as an example of how this label will render", image: "excelIcon"), numberOfLines: 1),
        Section(title: "Cell with text wrapping", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", footer: "This is a cell with a long footer as an example of how this label will render", image: "excelIcon"), numberOfLines: 0)
    ]

    static func accessoryType(for indexPath: IndexPath) -> MSTableViewCellAccessoryType {
        // Demo accessory types based on indexPath row
        switch indexPath.row {
        case 0:
            return .none
        case 1:
            return .disclosureIndicator
        default:
            return .detailButton
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

// MARK: - MSTableViewCellDemoController

class MSTableViewCellDemoController: DemoController {
    private let headerViewHeight: CGFloat = 50

    private let sections: [MSTableViewSampleData.Section] = MSTableViewSampleData.sections

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = MSColors.background
        tableView.separatorColor = MSColors.separator
        tableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(tableView)
    }
}

// MARK: - MSTableViewCellDemoController: UITableViewDataSource

extension MSTableViewCellDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier) as! MSTableViewCell
        let section = sections[indexPath.section]
        let item = section.item
        let customView = MSTableViewSampleData.createCustomView(imageName: item.image)
        let accessoryType = MSTableViewSampleData.accessoryType(for: indexPath)

        cell.setup(title: item.title, subtitle: item.subtitle, footer: item.footer, customView: customView, accessoryType: accessoryType)
        cell.titleNumberOfLines = section.numberOfLines
        cell.subtitleNumberOfLines = section.numberOfLines
        cell.footerNumberOfLines = section.numberOfLines
        cell.titleLineBreakMode = .byTruncatingMiddle
        return cell
    }
}

// MARK: - MSTableViewCellDemoController: UITableViewDelegate

extension MSTableViewCellDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = MSColors.background

        let label = MSLabel(style: .footnote)
        label.text = sections[section].title
        label.textColor = MSColors.darkGray
        label.autoresizingMask = .flexibleWidth

        let horizontalOffset: CGFloat = 16
        let verticalOffset: CGFloat = 8
        let labelHeight = label.font.deviceLineHeight
        label.frame = CGRect(
            x: horizontalOffset,
            y: headerViewHeight - labelHeight - verticalOffset,
            width: tableView.width - horizontalOffset,
            height: labelHeight
        )

        view.contentView.addSubview(label)

        return view
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let title = sections[indexPath.section].item.title
        showAlertForDetailButtonTapped(title: title)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showAlertForDetailButtonTapped(title: String) {
        let alert = UIAlertController(title: "\(title) detail button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
