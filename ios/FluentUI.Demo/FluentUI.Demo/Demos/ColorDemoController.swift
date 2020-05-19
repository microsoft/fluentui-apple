//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ColorDemoController: UIViewController {
    private var sections: [DemoColorSection] = [
        DemoColorSection(text: "App specific color", items: [
            DemoColorItem(text: "Shade30", color: Colors.primaryShade30),
            DemoColorItem(text: "Shade20", color: Colors.primaryShade20),
            DemoColorItem(text: "Shade10", color: Colors.primaryShade10),
            DemoColorItem(text: "Primary", color: Colors.primary),
            DemoColorItem(text: "Tint10", color: Colors.primaryTint10),
            DemoColorItem(text: "Tint20", color: Colors.primaryTint20),
            DemoColorItem(text: "Tint30", color: Colors.primaryTint30),
            DemoColorItem(text: "Tint40", color: Colors.primaryTint40)
        ], accessoryTitle: "Change color"),
        DemoColorSection(text: "Neutral colors", items: [
            DemoColorItem(text: "gray950", color: Colors.gray950),
            DemoColorItem(text: "gray900", color: Colors.gray900),
            DemoColorItem(text: "gray800", color: Colors.gray800),
            DemoColorItem(text: "gray700", color: Colors.gray700),
            DemoColorItem(text: "gray600", color: Colors.gray600),
            DemoColorItem(text: "gray500", color: Colors.gray500),
            DemoColorItem(text: "gray400", color: Colors.gray400),
            DemoColorItem(text: "gray300", color: Colors.gray300),
            DemoColorItem(text: "gray200", color: Colors.gray200),
            DemoColorItem(text: "gray100", color: Colors.gray100),
            DemoColorItem(text: "gray50", color: Colors.gray50),
            DemoColorItem(text: "gray25", color: Colors.gray25)
        ]),
        DemoColorSection(text: "Shared colors", items: [
            DemoColorItem(text: Colors.Palette.pinkRed10.name, color: Colors.Palette.pinkRed10.color),
            DemoColorItem(text: Colors.Palette.red20.name, color: Colors.Palette.red20.color),
            DemoColorItem(text: Colors.Palette.red10.name, color: Colors.Palette.red10.color),
            DemoColorItem(text: Colors.Palette.orange30.name, color: Colors.Palette.orange30.color),
            DemoColorItem(text: Colors.Palette.orange20.name, color: Colors.Palette.orange20.color),
            DemoColorItem(text: Colors.Palette.orangeYellow20.name, color: Colors.Palette.orangeYellow20.color),
            DemoColorItem(text: Colors.Palette.green20.name, color: Colors.Palette.green20.color),
            DemoColorItem(text: Colors.Palette.green10.name, color: Colors.Palette.green10.color),
            DemoColorItem(text: Colors.Palette.cyan30.name, color: Colors.Palette.cyan30.color),
            DemoColorItem(text: Colors.Palette.cyan20.name, color: Colors.Palette.cyan20.color),
            DemoColorItem(text: Colors.Palette.cyanBlue20.name, color: Colors.Palette.cyanBlue20.color),
            DemoColorItem(text: Colors.Palette.blue10.name, color: Colors.Palette.blue10.color),
            DemoColorItem(text: Colors.Palette.blueMagenta30.name, color: Colors.Palette.blueMagenta30.color),
            DemoColorItem(text: Colors.Palette.blueMagenta20.name, color: Colors.Palette.blueMagenta20.color),
            DemoColorItem(text: Colors.Palette.magenta20.name, color: Colors.Palette.magenta20.color),
            DemoColorItem(text: Colors.Palette.magenta10.name, color: Colors.Palette.magenta10.color),
            DemoColorItem(text: Colors.Palette.magentaPink10.name, color: Colors.Palette.magentaPink10.color),
            DemoColorItem(text: Colors.Palette.gray40.name, color: Colors.Palette.gray40.color),
            DemoColorItem(text: Colors.Palette.gray30.name, color: Colors.Palette.gray30.color),
            DemoColorItem(text: Colors.Palette.gray20.name, color: Colors.Palette.gray20.color)
        ]),
        DemoColorSection(text: "Message colors", items: [
            DemoColorItem(text: Colors.Palette.dangerShade30.name, color: Colors.Palette.dangerShade30.color),
            DemoColorItem(text: Colors.Palette.dangerShade20.name, color: Colors.Palette.dangerShade20.color),
            DemoColorItem(text: Colors.Palette.dangerShade10.name, color: Colors.Palette.dangerShade10.color),
            DemoColorItem(text: Colors.Palette.dangerPrimary.name, color: Colors.Palette.dangerPrimary.color),
            DemoColorItem(text: Colors.Palette.dangerTint10.name, color: Colors.Palette.dangerTint10.color),
            DemoColorItem(text: Colors.Palette.dangerTint20.name, color: Colors.Palette.dangerTint20.color),
            DemoColorItem(text: Colors.Palette.dangerTint30.name, color: Colors.Palette.dangerTint30.color),
            DemoColorItem(text: Colors.Palette.dangerTint40.name, color: Colors.Palette.dangerTint40.color),
            DemoColorItem(text: Colors.Palette.warningShade30.name, color: Colors.Palette.warningShade30.color),
            DemoColorItem(text: Colors.Palette.warningShade20.name, color: Colors.Palette.warningShade20.color),
            DemoColorItem(text: Colors.Palette.warningShade10.name, color: Colors.Palette.warningShade10.color),
            DemoColorItem(text: Colors.Palette.warningPrimary.name, color: Colors.Palette.warningPrimary.color),
            DemoColorItem(text: Colors.Palette.warningTint10.name, color: Colors.Palette.warningTint10.color),
            DemoColorItem(text: Colors.Palette.warningTint20.name, color: Colors.Palette.warningTint20.color),
            DemoColorItem(text: Colors.Palette.warningTint30.name, color: Colors.Palette.warningTint30.color),
            DemoColorItem(text: Colors.Palette.warningTint40.name, color: Colors.Palette.warningTint40.color),
            DemoColorItem(text: Colors.Palette.successShade30.name, color: Colors.Palette.successShade30.color),
            DemoColorItem(text: Colors.Palette.successShade20.name, color: Colors.Palette.successShade20.color),
            DemoColorItem(text: Colors.Palette.successShade10.name, color: Colors.Palette.successShade10.color),
            DemoColorItem(text: Colors.Palette.successPrimary.name, color: Colors.Palette.successPrimary.color),
            DemoColorItem(text: Colors.Palette.successTint10.name, color: Colors.Palette.successTint10.color),
            DemoColorItem(text: Colors.Palette.successTint20.name, color: Colors.Palette.successTint20.color),
            DemoColorItem(text: Colors.Palette.successTint30.name, color: Colors.Palette.successTint30.color),
            DemoColorItem(text: Colors.Palette.successTint40.name, color: Colors.Palette.successTint40.color)
        ])
    ]
    private var tableView: UITableView!
    private var usingDefaultPrimaryColor: Bool = false

    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.Table.background
    }

    private func accessoryTapped() {
        if usingDefaultPrimaryColor {
            Colors.primary = Colors.communicationBlue
            Colors.primaryTint10 = Colors.Palette.communicationBlueTint10.color
            Colors.primaryTint20 = Colors.Palette.communicationBlueTint20.color
            Colors.primaryTint30 = Colors.Palette.communicationBlueTint30.color
            Colors.primaryTint40 = Colors.Palette.communicationBlueTint40.color
            Colors.primaryShade10 = Colors.Palette.communicationBlueShade10.color
            Colors.primaryShade20 = Colors.Palette.communicationBlueShade20.color
            Colors.primaryShade30 = Colors.Palette.communicationBlueShade30.color
        } else {
            Colors.primary = UIColor(named: "Colors/DemoPrimaryColor") ?? Colors.communicationBlue
            Colors.primaryTint10 = UIColor(named: "Colors/DemoPrimaryTint10Color") ?? Colors.Palette.communicationBlueTint10.color
            Colors.primaryTint20 = UIColor(named: "Colors/DemoPrimaryTint20Color") ?? Colors.Palette.communicationBlueTint20.color
            Colors.primaryTint30 = UIColor(named: "Colors/DemoPrimaryTint30Color") ?? Colors.Palette.communicationBlueTint30.color
            Colors.primaryTint40 = UIColor(named: "Colors/DemoPrimaryTint40Color") ?? Colors.Palette.communicationBlueTint40.color
            Colors.primaryShade10 = UIColor(named: "Colors/DemoPrimaryShade10Color") ?? Colors.Palette.communicationBlueShade10.color
            Colors.primaryShade20 = UIColor(named: "Colors/DemoPrimaryShade20Color") ?? Colors.Palette.communicationBlueShade20.color
            Colors.primaryShade30 = UIColor(named: "Colors/DemoPrimaryShade30Color") ?? Colors.Palette.communicationBlueShade30.color
        }

        sections[0].items = [
            DemoColorItem(text: "Shade30", color: Colors.primaryShade30),
            DemoColorItem(text: "Shade20", color: Colors.primaryShade20),
            DemoColorItem(text: "Shade10", color: Colors.primaryShade10),
            DemoColorItem(text: "Primary", color: Colors.primary),
            DemoColorItem(text: "Tint10", color: Colors.primaryTint10),
            DemoColorItem(text: "Tint20", color: Colors.primaryTint20),
            DemoColorItem(text: "Tint30", color: Colors.primaryTint30),
            DemoColorItem(text: "Tint40", color: Colors.primaryTint40)
        ]

        usingDefaultPrimaryColor = !usingDefaultPrimaryColor
        tableView.reloadSections([0], with: .automatic)
    }
}

// MARK: - ColorDemoController: UITableViewDelegate

extension ColorDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as! TableViewHeaderFooterView
        let section = sections[section]
        header.setup(style: .header, title: section.text, accessoryButtonTitle: section.hasAccessoryTitle ? section.accessoryTitle! : "")

        if section.hasAccessoryTitle {
            header.accessoryButtonStyle = .primary
            header.onAccessoryButtonTapped = { [unowned self] in self.accessoryTapped() }
        }
        return header
    }
}

// MARK: - ColorDemoController: UITableViewDataSource

extension ColorDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as! TableViewCell
        cell.setup(title: item.text, customView: DemoColorView(color: item.color))
        return cell
    }

}

class DemoColorView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }

    public init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}

struct DemoColorItem {
    let text: String
    let color: UIColor
}

struct DemoColorSection {
    let text: String
    var items: [DemoColorItem]
    var hasAccessoryTitle: Bool = false
    let accessoryTitle: String?

    init(text: String, items: [DemoColorItem], accessoryTitle: String? = nil) {
        self.text = text
        self.items = items
        self.accessoryTitle = accessoryTitle
        self.hasAccessoryTitle = accessoryTitle != nil
    }
}
