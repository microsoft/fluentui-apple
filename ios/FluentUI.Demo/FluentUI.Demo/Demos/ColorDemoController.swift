//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

protocol ColorThemeHosting {
    func updateToWindowWith(type: UIWindow.Type, pushing viewController: UIViewController?)
}

class ColorDemoController: UIViewController {
    private var sections: [DemoColorSection] = [
        DemoColorSection(text: "App specific color", colorViews: [
            DemoColorView(text: "Shade30", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryShade30(for: window) }),
            DemoColorView(text: "Shade20", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryShade20(for: window) }),
            DemoColorView(text: "Shade10", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryShade10(for: window) }),
            DemoColorView(text: "Primary", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primary(for: window) }),
            DemoColorView(text: "Tint10", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryTint10(for: window) }),
            DemoColorView(text: "Tint20", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryTint20(for: window) }),
            DemoColorView(text: "Tint30", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryTint30(for: window) }),
            DemoColorView(text: "Tint40", colorProvider: { (window: UIWindow) -> UIColor in return Colors.primaryTint40(for: window) })
        ]),
        DemoColorSection(text: "Neutral colors", colorViews: [
            DemoColorView(text: "gray950", color: Colors.gray950),
            DemoColorView(text: "gray900", color: Colors.gray900),
            DemoColorView(text: "gray800", color: Colors.gray800),
            DemoColorView(text: "gray700", color: Colors.gray700),
            DemoColorView(text: "gray600", color: Colors.gray600),
            DemoColorView(text: "gray500", color: Colors.gray500),
            DemoColorView(text: "gray400", color: Colors.gray400),
            DemoColorView(text: "gray300", color: Colors.gray300),
            DemoColorView(text: "gray200", color: Colors.gray200),
            DemoColorView(text: "gray100", color: Colors.gray100),
            DemoColorView(text: "gray50", color: Colors.gray50),
            DemoColorView(text: "gray25", color: Colors.gray25)
        ]),
        DemoColorSection(text: "Shared colors", colorViews: [
            DemoColorView(text: Colors.Palette.pinkRed10.name, color: Colors.Palette.pinkRed10.color),
            DemoColorView(text: Colors.Palette.red20.name, color: Colors.Palette.red20.color),
            DemoColorView(text: Colors.Palette.red10.name, color: Colors.Palette.red10.color),
            DemoColorView(text: Colors.Palette.orange30.name, color: Colors.Palette.orange30.color),
            DemoColorView(text: Colors.Palette.orange20.name, color: Colors.Palette.orange20.color),
            DemoColorView(text: Colors.Palette.orangeYellow20.name, color: Colors.Palette.orangeYellow20.color),
            DemoColorView(text: Colors.Palette.green20.name, color: Colors.Palette.green20.color),
            DemoColorView(text: Colors.Palette.green10.name, color: Colors.Palette.green10.color),
            DemoColorView(text: Colors.Palette.cyan30.name, color: Colors.Palette.cyan30.color),
            DemoColorView(text: Colors.Palette.cyan20.name, color: Colors.Palette.cyan20.color),
            DemoColorView(text: Colors.Palette.cyanBlue20.name, color: Colors.Palette.cyanBlue20.color),
            DemoColorView(text: Colors.Palette.blue10.name, color: Colors.Palette.blue10.color),
            DemoColorView(text: Colors.Palette.blueMagenta30.name, color: Colors.Palette.blueMagenta30.color),
            DemoColorView(text: Colors.Palette.blueMagenta20.name, color: Colors.Palette.blueMagenta20.color),
            DemoColorView(text: Colors.Palette.magenta20.name, color: Colors.Palette.magenta20.color),
            DemoColorView(text: Colors.Palette.magenta10.name, color: Colors.Palette.magenta10.color),
            DemoColorView(text: Colors.Palette.magentaPink10.name, color: Colors.Palette.magentaPink10.color),
            DemoColorView(text: Colors.Palette.gray40.name, color: Colors.Palette.gray40.color),
            DemoColorView(text: Colors.Palette.gray30.name, color: Colors.Palette.gray30.color),
            DemoColorView(text: Colors.Palette.gray20.name, color: Colors.Palette.gray20.color)
        ]),
        DemoColorSection(text: "Message colors", colorViews: [
            DemoColorView(text: Colors.Palette.dangerShade30.name, color: Colors.Palette.dangerShade30.color),
            DemoColorView(text: Colors.Palette.dangerShade20.name, color: Colors.Palette.dangerShade20.color),
            DemoColorView(text: Colors.Palette.dangerShade10.name, color: Colors.Palette.dangerShade10.color),
            DemoColorView(text: Colors.Palette.dangerPrimary.name, color: Colors.Palette.dangerPrimary.color),
            DemoColorView(text: Colors.Palette.dangerTint10.name, color: Colors.Palette.dangerTint10.color),
            DemoColorView(text: Colors.Palette.dangerTint20.name, color: Colors.Palette.dangerTint20.color),
            DemoColorView(text: Colors.Palette.dangerTint30.name, color: Colors.Palette.dangerTint30.color),
            DemoColorView(text: Colors.Palette.dangerTint40.name, color: Colors.Palette.dangerTint40.color),
            DemoColorView(text: Colors.Palette.warningShade30.name, color: Colors.Palette.warningShade30.color),
            DemoColorView(text: Colors.Palette.warningShade20.name, color: Colors.Palette.warningShade20.color),
            DemoColorView(text: Colors.Palette.warningShade10.name, color: Colors.Palette.warningShade10.color),
            DemoColorView(text: Colors.Palette.warningPrimary.name, color: Colors.Palette.warningPrimary.color),
            DemoColorView(text: Colors.Palette.warningTint10.name, color: Colors.Palette.warningTint10.color),
            DemoColorView(text: Colors.Palette.warningTint20.name, color: Colors.Palette.warningTint20.color),
            DemoColorView(text: Colors.Palette.warningTint30.name, color: Colors.Palette.warningTint30.color),
            DemoColorView(text: Colors.Palette.warningTint40.name, color: Colors.Palette.warningTint40.color),
            DemoColorView(text: Colors.Palette.successShade30.name, color: Colors.Palette.successShade30.color),
            DemoColorView(text: Colors.Palette.successShade20.name, color: Colors.Palette.successShade20.color),
            DemoColorView(text: Colors.Palette.successShade10.name, color: Colors.Palette.successShade10.color),
            DemoColorView(text: Colors.Palette.successPrimary.name, color: Colors.Palette.successPrimary.color),
            DemoColorView(text: Colors.Palette.successTint10.name, color: Colors.Palette.successTint10.color),
            DemoColorView(text: Colors.Palette.successTint20.name, color: Colors.Palette.successTint20.color),
            DemoColorView(text: Colors.Palette.successTint30.name, color: Colors.Palette.successTint30.color),
            DemoColorView(text: Colors.Palette.successTint40.name, color: Colors.Palette.successTint40.color)
        ]),
        DemoColorSection(text: "Presence colors", colorViews: [
            DemoColorView(text: Colors.Palette.presenceAvailable.name, color: Colors.Palette.presenceAvailable.color),
            DemoColorView(text: Colors.Palette.presenceAway.name, color: Colors.Palette.presenceAway.color),
            DemoColorView(text: Colors.Palette.presenceBlocked.name, color: Colors.Palette.presenceBlocked.color),
            DemoColorView(text: Colors.Palette.presenceBusy.name, color: Colors.Palette.presenceBusy.color),
            DemoColorView(text: Colors.Palette.presenceDnd.name, color: Colors.Palette.presenceDnd.color),
            DemoColorView(text: Colors.Palette.presenceOffline.name, color: Colors.Palette.presenceOffline.color),
            DemoColorView(text: Colors.Palette.presenceOof.name, color: Colors.Palette.presenceOof.color),
            DemoColorView(text: Colors.Palette.presenceUnknown.name, color: Colors.Palette.presenceUnknown.color)
        ])
    ]

    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view = UIView(frame: .zero)
        view.addSubview(stackView)
        view.backgroundColor = Colors.tableBackground

        let safeAreaLayoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window {
            segmentedControl.selectedSegmentIndex = colorProviderThemedWindowTypes.firstIndex(where: { return window.isKind(of: $0.windowType) }) ?? 0
        }
    }
    private lazy var segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl(items: colorProviderThemedWindowTypes.map({ return $0.name }), style: .tabs)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        return segmentedControl
    }()

    @objc private func segmentedControlValueChanged(sender: Any) {
        if let segmentedControl = sender as? SegmentedControl {
            let windowType = colorProviderThemedWindowTypes[segmentedControl.selectedSegmentIndex].windowType
            let colorThemeHost = view.window?.windowScene?.delegate as? ColorThemeHosting

            if let navigationController = navigationController {
                navigationController.popViewController(animated: false)
                colorThemeHost?.updateToWindowWith(type: windowType, pushing: self)
            }
        }
    }

    private let colorProviderThemedWindowTypes: [(name: String, windowType: UIWindow.Type)] = [("Default", DemoColorThemeDefaultWindow.self),
                                                                                               ("Green", DemoColorThemeGreenWindow.self),
                                                                                               ("None", UIWindow.self)]
}

// MARK: - ColorDemoController: UITableViewDelegate

extension ColorDemoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let section = sections[section]
        header?.setup(style: .header, title: section.text)
        return header
    }
}

// MARK: - ColorDemoController: UITableViewDataSource

extension ColorDemoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].colorViews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        let section = sections[indexPath.section]
        let colorView = section.colorViews[indexPath.row]

        cell.setup(title: colorView.text, customView: colorView)
        return cell
    }

}

class DemoColorView: UIView {
    let text: String
    var colorProvider: ((UIWindow) -> (UIColor))?

    init(text: String, color: UIColor) {
        self.text = text
        super.init(frame: .zero)
        backgroundColor = color
    }

    init(text: String, colorProvider: @escaping (UIWindow) -> (UIColor)) {
        self.text = text
        super.init(frame: .zero)
        self.colorProvider = colorProvider
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let colorProvider = colorProvider,
            let window = window {
            backgroundColor = colorProvider(window)
        }
    }
}

struct DemoColorSection {
    let text: String
    let colorViews: [DemoColorView]

    init(text: String, colorViews: [DemoColorView]) {
        self.text = text
        self.colorViews = colorViews
    }
}
