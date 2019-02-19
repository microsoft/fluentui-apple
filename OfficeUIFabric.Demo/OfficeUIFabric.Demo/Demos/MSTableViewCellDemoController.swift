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
        Section(title: "Single line cell", item: Item(title: "Contoso Survey", image: "excelIcon")),
        Section(title: "Double line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", image: "excelIcon")),
        Section(title: "Triple line cell", item: Item(title: "Contoso Survey", subtitle: "Research Notes", footer: "22 views", image: "excelIcon")),
        Section(title: "Cell without custom view", item: Item(title: "Contoso Survey", subtitle: "Research Notes")),
        Section(title: "Cell with long text", item: Item(title: "This is a cell with a long title as an example of how this label will render", subtitle: "This is a cell with a long subtitle as an example of how this label will render", image: "excelIcon"))
    ]
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

        let item = sections[indexPath.section].item
        let title = item.title
        let subtitle = item.subtitle
        let footer = item.footer
        let image = item.image
        let customView = createCustomView(imageName: image)

        // Demo accessory types based on indexPath row
        var accessoryType: MSTableViewCellAccessoryType
        switch indexPath.row {
        case 0:
            accessoryType = .none
        case 1:
            accessoryType = .disclosureIndicator
        default:
            accessoryType = .detailButton
        }

        cell.setup(title: title, subtitle: subtitle, footer: footer, customView: customView, accessoryType: accessoryType)
        return cell
    }

    private func createCustomView(imageName: String) -> UIImageView? {
        if imageName == "" {
            return nil
        }

        let customView = UIImageView(image: UIImage(named: imageName))
        customView.contentMode = .scaleAspectFit
        return customView
    }
}

// MARK: - MSTableViewCellDemoController: UITableViewDelegate

extension MSTableViewCellDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subtitle = sections[indexPath.section].item.subtitle
        let footer = sections[indexPath.section].item.footer
        if footer == "" {
            if subtitle == "" {
                return MSTableViewCell.smallHeight
            } else {
                return MSTableViewCell.mediumHeight
            }
        } else {
            return MSTableViewCell.largeHeight
        }
    }

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
