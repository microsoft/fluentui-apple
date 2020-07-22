//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

// MARK: TableViewCellFileAccessoryViewDemoController

class TableViewCellFileAccessoryViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.surfaceSecondary

        dateTimePicker.delegate = self

        scrollingContainer.addSubview(stackView)
        stackView.addArrangedSubview(settingsView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollingContainer.topAnchor, constant: Constants.stackViewSpacing),
            stackView.bottomAnchor.constraint(equalTo: scrollingContainer.bottomAnchor, constant: -Constants.stackViewSpacing),
            stackView.leadingAnchor.constraint(equalTo: scrollingContainer.leadingAnchor)
        ])

        reloadCells()
    }

    private func reloadCells() {
        for view in stackView.arrangedSubviews {
            if view != settingsView {
                view.removeFromSuperview()
            }
        }

        accessoryViews.removeAll()

        var layoutConstraints: [NSLayoutConstraint] = []

        for width in Constants.cellWidths {
            if !useDynamicWidth {
                let cellTitle = Label(style: .subhead, colorStyle: .regular)
                cellTitle.text = "\t\(Int(width))px"
                stackView.addArrangedSubview(cellTitle)
            }

            let cell1 = createCell(title: "Document Title", subtitle: "OneDrive - Microsoft · Microsoft Teams Chat Files")
            let cell2 = createCell(title: "This is a very long document title that keeps on going forever to test text truncation",
                                   subtitle: "This is a very long document subtitle that keeps on going forever to test text truncation")

            let containerView = UIStackView(frame: .zero)
            containerView.axis = .vertical
            containerView.translatesAutoresizingMaskIntoConstraints = false

            containerView.addArrangedSubview(cell1)
            containerView.addArrangedSubview(cell2)
            stackView.addArrangedSubview(containerView)

            if useDynamicWidth {
                layoutConstraints.append(contentsOf: [
                    cell1.widthAnchor.constraint(equalTo: scrollingContainer.widthAnchor),
                    cell2.widthAnchor.constraint(equalTo: scrollingContainer.widthAnchor)
                ])

                break
            } else {
                layoutConstraints.append(containerView.widthAnchor.constraint(equalToConstant: width))
            }
        }

        NSLayoutConstraint.activate(layoutConstraints)

        updateActions()
        updateDate()
        updateSharedStatus()
        updateAreDocumentsShared()
    }

    private struct Constants {
        static let stackViewSpacing: CGFloat = 20.0
        static let labelSwitchSpacing: CGFloat = 10.0
        static let cellWidths: [CGFloat] = [320.0, 375.0, 414.0, 423.0, 424.0, 503.0, 504.0, 583.0, 584.0, 615.0, 616.0, 751.0, 752.0, 899.0, 900.0, 924.0, 950.0, 1000.0, 1091.0, 1092.0, 1270.0]
    }

    private var accessoryViews: [TableViewCellFileAccessoryView] = []

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.stackViewSpacing

        return stackView
    }()

    private func createAccessoryView() -> TableViewCellFileAccessoryView {
        let customAccessoryView = TableViewCellFileAccessoryView.init(frame: .zero)
        return customAccessoryView
    }

    private func actions() -> [FileAccessoryViewAction] {
        var actions: [FileAccessoryViewAction] = []
        if showOverflowAction {
            let action = FileAccessoryViewAction(title: "File actions",
                                                 image: UIImage(named: "Overflow_24")!,
                                                 target: self,
                                                 action: #selector(handleOverflowAction),
                                                 canHide: false)
            actions.append(action)
        }

        if showShareAction {
            let action = FileAccessoryViewAction(title: "Share",
                                                 image: UIImage(named: "Share_24")!,
                                                 target: self,
                                                 action: #selector(handleShareAction))
            actions.append(action)
        }

        if showPinAction {
            if isPinned {
                let action = FileAccessoryViewAction(title: "Unpin",
                                                     image: UIImage(named: "Pin_pinned_24")!,
                                                     target: self,
                                                     action: #selector(handlePinAction),
                                                     useAppPrimaryColor: true)
                actions.append(action)
            } else {
                let action = FileAccessoryViewAction(title: "Pin",
                                                     image: UIImage(named: "Pin_unpinned_24")!,
                                                     target: self,
                                                     action: #selector(handlePinAction))
                actions.append(action)
            }
        }

        if showKeepOfflineAction {
            let action = FileAccessoryViewAction(title: "Keep Offline",
                                                 image: UIImage(named: "KeepOffline_24")!,
                                                 target: self,
                                                 action: #selector(handleKeepOfflineAction))
            actions.append(action)
        }

        if showErrorAction {
            if #available(iOS 13.0, *) {
                let action = FileAccessoryViewAction(title: "Error",
                                                     image: UIImage(named: "Error_24")!,
                                                     target: self,
                                                     action: #selector(handleErrorAction),
                                                     canHide: false)
                actions.append(action)
            }
        }

        return actions
    }

    private func updateActions() {
        let actionList = actions()
        for accessoryView in accessoryViews {
            accessoryView.actions = actionList
        }
    }

    private func updateDate() {
        let date = showDate ? self.date : nil
        for accessoryView in accessoryViews {
            accessoryView.date = date
        }
    }

    private func updateSharedStatus() {
        for accessoryView in accessoryViews {
            accessoryView.showSharedStatus = showSharedStatus
        }
    }

    private func updateAreDocumentsShared() {
        for accessoryView in accessoryViews {
            accessoryView.isShared = areDocumentsShared
        }
    }

    private func createCell(title: String, subtitle: String) -> TableViewCell {
        let customAccessoryView = createAccessoryView()
        accessoryViews.append(customAccessoryView)

        let cell = TableViewCell(frame: .zero)
        customAccessoryView.tableViewCell = cell

        cell.setup(
            title: title,
            subtitle: subtitle,
            footer: "",
            customView: TableViewSampleData.createCustomView(imageName: "wordIcon"),
            customAccessoryView: customAccessoryView,
            accessoryType: .none
        )

        cell.titleNumberOfLines = 1
        cell.subtitleNumberOfLines = 1

        cell.titleLineBreakMode = .byTruncatingMiddle

        cell.titleNumberOfLinesForLargerDynamicType = 3
        cell.subtitleNumberOfLinesForLargerDynamicType = 2

        cell.backgroundColor = Colors.Table.Cell.background
        cell.topSeparatorType = .none
        cell.bottomSeparatorType = .none

        return cell
    }

    private var showKeepOfflineAction: Bool = true {
        didSet {
            updateActions()
        }
    }

    private var showShareAction: Bool = true {
        didSet {
            updateActions()
        }
    }

    private var showPinAction: Bool = true {
        didSet {
            updateActions()
        }
    }

    private var isPinned: Bool = false {
        didSet {
            reloadCells()
        }
    }

    private var showErrorAction: Bool = false {
        didSet {
            updateActions()
        }
    }

    private var showOverflowAction: Bool = true {
        didSet {
            reloadCells()
        }
    }

    private var useDynamicWidth: Bool = false {
        didSet {
            reloadCells()
        }
    }

    private var date = Date() {
        didSet {
            updateDate()
        }
    }

    private var showDate: Bool = true {
        didSet {
            updateDate()
        }
    }

    private var showSharedStatus: Bool = true {
        didSet {
            updateSharedStatus()
        }
    }

    private var areDocumentsShared: Bool = true {
        didSet {
            updateAreDocumentsShared()
        }
    }

    private lazy var settingsView: UIView = {
        let settingsView = UIStackView(frame: .zero)
        settingsView.axis = .horizontal

        let spacingView = UIView(frame: .zero)
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.widthAnchor.constraint(equalToConstant: Constants.stackViewSpacing).isActive = true
        settingsView.addArrangedSubview(spacingView)

        let settingViews: [UIView] = [
            createLabelAndSwitchRow(labelText: "Dynamic width", switchAction: #selector(toggleDynamicWidth(switchView:)), isOn: useDynamicWidth),
            createLabelAndSwitchRow(labelText: "Show date", switchAction: #selector(toggleShowDate(switchView:)), isOn: showDate),
            createButton(title: "Choose date", action: #selector(presentDatePicker)),
            createButton(title: "Choose time", action: #selector(presentTimePicker)),
            createLabelAndSwitchRow(labelText: "Show shared status", switchAction: #selector(toggleShowSharedStatus(switchView:)), isOn: showSharedStatus),
            createLabelAndSwitchRow(labelText: "Is document shared", switchAction: #selector(toggleAreDocumentsShared(switchView:)), isOn: areDocumentsShared),
            createLabelAndSwitchRow(labelText: "Show keep offline button", switchAction: #selector(toggleShowKeepOffline(switchView:)), isOn: showKeepOfflineAction),
            createLabelAndSwitchRow(labelText: "Show share button", switchAction: #selector(toggleShareButton(switchView:)), isOn: showShareAction),
            createLabelAndSwitchRow(labelText: "Show pin button", switchAction: #selector(togglePin(switchView:)), isOn: showPinAction),
            createLabelAndSwitchRow(labelText: "Show error button", switchAction: #selector(toggleErrorButton(switchView:)), isOn: showErrorAction),
            createLabelAndSwitchRow(labelText: "Show overflow button", switchAction: #selector(toggleOverflow(switchView:)), isOn: showOverflowAction)
        ]

        let verticalSettingsView = UIStackView(frame: .zero)
        verticalSettingsView.translatesAutoresizingMaskIntoConstraints = false
        verticalSettingsView.axis = .vertical
        verticalSettingsView.spacing = Constants.stackViewSpacing

        for settingView in settingViews {
            verticalSettingsView.addArrangedSubview(settingView)
        }

        settingsView.addArrangedSubview(verticalSettingsView)

        return settingsView
    }()

    private func createLabelAndSwitchRow(labelText: String, switchAction: Selector, isOn: Bool = false) -> UIView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.labelSwitchSpacing

        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = labelText
        stackView.addArrangedSubview(label)

        let switchView = UISwitch()
        switchView.isOn = isOn
        switchView.addTarget(self, action: switchAction, for: .valueChanged)
        stackView.addArrangedSubview(switchView)

        return stackView
    }

    @objc private func toggleShowDate(switchView: UISwitch) {
        showDate = switchView.isOn
    }

    private let dateTimePicker = DateTimePicker()

    @objc func presentDatePicker() {
        dateTimePicker.present(from: self, with: .date, startDate: Date(), endDate: nil, datePickerType: .components)
    }

    @objc func presentTimePicker() {
        dateTimePicker.present(from: self, with: .dateTime, startDate: Date(), endDate: nil, datePickerType: .components)
    }

    @objc private func toggleDynamicWidth(switchView: UISwitch) {
        useDynamicWidth = switchView.isOn
    }

    @objc private func toggleShowSharedStatus(switchView: UISwitch) {
        showSharedStatus = switchView.isOn
    }

    @objc private func toggleAreDocumentsShared(switchView: UISwitch) {
        areDocumentsShared = switchView.isOn
    }

    @objc private func toggleShowKeepOffline(switchView: UISwitch) {
        showKeepOfflineAction = switchView.isOn
    }

    @objc private func togglePin(switchView: UISwitch) {
        showPinAction = switchView.isOn
    }

    @objc private func toggleShareButton(switchView: UISwitch) {
        showShareAction = switchView.isOn
    }

    @objc private func toggleErrorButton(switchView: UISwitch) {
        showErrorAction = switchView.isOn
    }

    @objc private func toggleOverflow(switchView: UISwitch) {
        showOverflowAction = switchView.isOn
    }

    @objc private func handleErrorAction() {
        displayActionAlert(title: "Error")
    }

    @objc private func handlePinAction() {
        isPinned = !isPinned
    }

    @objc private func handleShareAction() {
        displayActionAlert(title: "Share")
    }

    @objc private func handleOverflowAction() {
        displayActionAlert(title: "Overflow")
    }

    @objc private func handleKeepOfflineAction() {
        displayActionAlert(title: "Keep offline")
    }

    private func displayActionAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - TableViewCellFileAccessoryViewDemoController: MSDatePickerDelegate

extension TableViewCellFileAccessoryViewDemoController: DateTimePickerDelegate {
    func dateTimePicker(_ dateTimePicker: DateTimePicker, didPickStartDate startDate: Date, endDate: Date) {
        date = startDate
        updateDate()
    }

    func dateTimePicker(_ dateTimePicker: DateTimePicker, shouldEndPickingStartDate startDate: Date, endDate: Date) -> Bool {
        return true
    }
}
