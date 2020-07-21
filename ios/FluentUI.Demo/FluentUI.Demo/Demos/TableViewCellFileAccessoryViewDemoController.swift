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

        dateTimePicker.delegate = self

        view.backgroundColor = Colors.surfaceSecondary

        var constraints: [NSLayoutConstraint] = []

        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.stackViewSpacing

        scrollingContainer.addSubview(stackView)

        stackView.addArrangedSubview(settingsView)

        for size in TableViewCellFileAccessoryViewDemoController.cellSizes {
            let cellTitle = Label(style: .subhead, colorStyle: .regular)
            cellTitle.text = "\t\(size)px"
            stackView.addArrangedSubview(cellTitle)

            let cell1 = createCell(title: "Document Title", subtitle: "OneDrive - Microsoft · Microsoft Teams Chat Files")
            let cell2 = createCell(title: "This is a very long document title that keeps on going forever to test text truncation",
                                   subtitle: "This is a very long document subtitle that keeps on going forever to test text truncation")

            let containerView = UIStackView(frame: .zero)
            containerView.axis = .vertical
            containerView.translatesAutoresizingMaskIntoConstraints = false

            containerView.addArrangedSubview(cell1)
            containerView.addArrangedSubview(cell2)
            stackView.addArrangedSubview(containerView)

            constraints.append(contentsOf: [
                containerView.widthAnchor.constraint(equalToConstant: CGFloat(size))
            ])
        }

        constraints.append(contentsOf: [
            stackView.topAnchor.constraint(equalTo: scrollingContainer.topAnchor, constant: Constants.stackViewSpacing),
            stackView.bottomAnchor.constraint(equalTo: scrollingContainer.bottomAnchor, constant: -Constants.stackViewSpacing),
            stackView.leadingAnchor.constraint(equalTo: scrollingContainer.leadingAnchor)
        ])

        NSLayoutConstraint.activate(constraints)

        updateActions()
        updateDate()
    }

    private static let cellSizes: [UInt16] = [320, 375, 414, 423, 424, 503, 504, 583, 584, 615, 616, 751, 752, 899, 900, 923, 924, 1092, 1270]

    private var accessoryViews: [TableViewCellFileAccessoryView] = []

    private struct Constants {
        static let stackViewSpacing: CGFloat = 20.0
        static let labelSwitchSpacing: CGFloat = 10.0
    }

    private func createAccessoryView() -> TableViewCellFileAccessoryView {
        let customAccessoryView = TableViewCellFileAccessoryView.init(frame: .zero)
        return customAccessoryView
    }

    private func actions() -> [FileAccessoryViewAction] {
        var actions: [FileAccessoryViewAction] = []
        if showOverflowAction {
            let action = FileAccessoryViewAction(title: "File actions",
                                                 image: UIImage(named: "Overflow_24")!,
                                                 highlightedImage: UIImage(named: "Overflow_pressed_24")!,
                                                 target: self,
                                                 action: #selector(handleOverflowAction),
                                                 canHide: false)
            actions.append(action)
        }

        if showShareAction {
            let action = FileAccessoryViewAction(title: "Share",
                                                 image: UIImage(named: "Share_24")!,
                                                 highlightedImage: UIImage(named: "Share_pressed_24")!,
                                                 target: self,
                                                 action: #selector(handleShareAction))
            actions.append(action)
        }

        if showPinAction {
            if isPinned {
                let action = FileAccessoryViewAction(title: "Unpin",
                                                     image: UIImage(named: "Pin_pinned_24")!,
                                                     highlightedImage: nil,
                                                     target: self,
                                                     action: #selector(handlePinAction))
                actions.append(action)
            } else {
                let action = FileAccessoryViewAction(title: "Pin",
                                                     image: UIImage(named: "Pin_unpinned_24")!,
                                                     highlightedImage: nil,
                                                     target: self,
                                                     action: #selector(handlePinAction))
                actions.append(action)
            }
        }

        if showKeepOfflineAction {
            let action = FileAccessoryViewAction(title: "Keep Offline",
                                                 image: UIImage(named: "KeepOffline_24")!,
                                                 highlightedImage: UIImage(named: "KeepOffline_pressed_24")!,
                                                 target: self,
                                                 action: #selector(handleKeepOfflineAction))
            actions.append(action)
        }

        if showErrorAction {
            if #available(iOS 13.0, *) {
                let action = FileAccessoryViewAction(title: "Error",
                                                     image: UIImage(named: "Error_24")!,
                                                     highlightedImage: UIImage(named: "Error_pressed_24")!,
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

    private func createCell(title: String, subtitle: String) -> TableViewCell {
        let customAccessoryView = createAccessoryView()
        accessoryViews.append(customAccessoryView)

        let cell = TableViewCell(frame: .zero)
        cell.delegate = customAccessoryView
        customAccessoryView.tableViewCell = cell
        customAccessoryView.showSharedStatus = true

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

    private var showKeepOfflineAction: Bool = true
    private var showShareAction: Bool = true
    private var showPinAction: Bool = true
    private var isPinned: Bool = false
    private var showErrorAction: Bool = false
    private var showOverflowAction: Bool = true

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

    private lazy var settingsView: UIView = {
        let settingsView = UIStackView(frame: .zero)
        settingsView.axis = .horizontal

        let spacingView = UIView(frame: .zero)
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.widthAnchor.constraint(equalToConstant: Constants.stackViewSpacing).isActive = true
        settingsView.addArrangedSubview(spacingView)

        let settingViews: [UIView] = [
            createLabelAndSwitchRow(labelText: "Show date", switchAction: #selector(toggleShowDate(switchView:)), isOn: showDate),
            createButton(title: "Choose date", action: #selector(presentDateTimeRangePicker)),
            createLabelAndSwitchRow(labelText: "Show shared status", switchAction: #selector(toggleShowSharedStatus(switchView:)), isOn: true),
            createLabelAndSwitchRow(labelText: "Is document shared", switchAction: #selector(toggleIsShared(switchView:)), isOn: true),
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

    @objc func presentDateTimeRangePicker() {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate) ?? startDate
        dateTimePicker.present(from: self, with: .dateTimeRange, startDate: startDate, endDate: endDate, datePickerType: .components)
    }

    @objc private func toggleShowSharedStatus(switchView: UISwitch) {
        let showSharedStatus = switchView.isOn

        for accessoryView in accessoryViews {
            accessoryView.showSharedStatus = showSharedStatus
        }
    }

    @objc private func toggleIsShared(switchView: UISwitch) {
        let isShared = switchView.isOn

        for accessoryView in accessoryViews {
            accessoryView.isShared = isShared
        }
    }

    @objc private func toggleShowKeepOffline(switchView: UISwitch) {
        showKeepOfflineAction = switchView.isOn
        updateActions()
    }

    @objc private func togglePin(switchView: UISwitch) {
        showPinAction = switchView.isOn
        updateActions()
    }

    @objc private func toggleShareButton(switchView: UISwitch) {
        showShareAction = switchView.isOn
        updateActions()
    }

    @objc private func toggleErrorButton(switchView: UISwitch) {
        showErrorAction = switchView.isOn
        updateActions()
    }

    @objc private func toggleOverflow(switchView: UISwitch) {
        showOverflowAction = switchView.isOn
        updateActions()
    }

    @objc private func handleErrorAction() {
        displayActionAlert(title: "Error")
    }

    @objc private func handlePinAction() {
        isPinned = !isPinned
        updateActions()
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
