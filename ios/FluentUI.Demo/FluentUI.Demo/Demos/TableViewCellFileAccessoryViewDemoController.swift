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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCellPadding()
    }

    private func reloadCells() {
        for view in stackView.arrangedSubviews {
            if view != settingsView {
                view.removeFromSuperview()
            }
        }

        topAccessoryViews.removeAll()
        bottomAccessoryViews.removeAll()

        var layoutConstraints: [NSLayoutConstraint] = []

        for width in Constants.cellWidths {
            if !useDynamicWidth {
                let cellTitle = Label(style: .subhead, colorStyle: .regular)
                cellTitle.text = "\t\(Int(width))px"
                stackView.addArrangedSubview(cellTitle)
            }

            let cell1 = createCell(title: "Document Title", subtitle: "OneDrive - Microsoft · Microsoft Teams Chat Files", top: true)
            let cell2 = createCell(title: "This is a very long document title that keeps on going forever to test text truncation",
                                   subtitle: "This is a very long document subtitle that keeps on going forever to test text truncation", top: false)

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
        updateCellPadding()
    }

    private struct Constants {
        static let stackViewSpacing: CGFloat = 20
        static let cellWidths: [CGFloat] = [320, 375, 414, 423, 424, 503, 504, 583, 584, 615, 616, 751, 752, 899, 900, 924, 950, 1000, 1091, 1092, 1270]
        static let cellPaddingThreshold: CGFloat = 768
        static let largeCellPadding: CGFloat = 16
        static let smallCellPadding: CGFloat = 8
        static let plusMinusButtonWidth: CGFloat = 40
    }

    private var topAccessoryViews: [TableViewCellFileAccessoryView] = []
    private var bottomAccessoryViews: [TableViewCellFileAccessoryView] = []

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

    private func actions(top: Bool) -> [FileAccessoryViewAction] {
        var actions: [FileAccessoryViewAction] = []
        if showOverflowAction {
            let action = FileAccessoryViewAction(title: "File actions",
                                                 image: UIImage(named: "ic_fluent_more_24_regular")!,
                                                 target: self,
                                                 action: #selector(handleOverflowAction),
                                                 canHide: false)
            actions.append(action)
        }

        if showShareAction {
            let action = FileAccessoryViewAction(title: "Share",
                                                 image: UIImage(named: "ic_fluent_share_ios_24_regular")!,
                                                 target: self,
                                                 action: #selector(handleShareAction),
                                                 isEnabled: !isShareActionDisabled)
            actions.append(action)
        }

        if showPinAction {
            if isPinned {
                let action = FileAccessoryViewAction(title: "Unpin",
                                                     image: UIImage(named: "ic_fluent_pin_24_filled")!,
                                                     target: self,
                                                     action: #selector(handlePinAction),
                                                     isEnabled: !isPinActionDisabled,
                                                     useAppPrimaryColor: true)
                actions.append(action)
            } else {
                let action = FileAccessoryViewAction(title: "Pin",
                                                     image: UIImage(named: "ic_fluent_pin_24_regular")!,
                                                     target: self,
                                                     action: #selector(handlePinAction),
                                                     isEnabled: !isPinActionDisabled)
                actions.append(action)
            }
        }

        if showKeepOfflineAction {
            let action = FileAccessoryViewAction(title: "Keep Offline",
                                                 image: UIImage(named: "ic_fluent_cloud_download_24_regular")!,
                                                 target: self,
                                                 action: #selector(handleKeepOfflineAction))
            actions.append(action)
        }

        if showErrorAction && !(!top && !showErrorOnBottomCellAction) {
            if #available(iOS 13.0, *) {
                let action = FileAccessoryViewAction(title: "Error",
                                                     image: UIImage(named: "ic_fluent_warning_24_regular")!,
                                                     target: self,
                                                     action: #selector(handleErrorAction),
                                                     canHide: false)
                actions.append(action)
            }
        }

        return actions
    }

    private func updateActions() {
        let topActionList = actions(top: true)
        for accessoryView in topAccessoryViews {
            accessoryView.actions = topActionList
        }

        let bottomActionList = actions(top: false)
        for accessoryView in bottomAccessoryViews {
            accessoryView.actions = bottomActionList
        }
    }

    private func updateDate() {
        let date = showDate ? self.date : nil
        for accessoryView in topAccessoryViews + bottomAccessoryViews {
            accessoryView.date = date
        }
    }

    private func updateSharedStatus() {
        for accessoryView in topAccessoryViews + bottomAccessoryViews {
            accessoryView.showSharedStatus = showSharedStatus
        }
    }

    private func updateAreDocumentsShared() {
        for accessoryView in topAccessoryViews + bottomAccessoryViews {
            accessoryView.isShared = areDocumentsShared
        }
    }

    private func createCell(title: String, subtitle: String, top: Bool) -> TableViewCell {
        let customAccessoryView = createAccessoryView()

        if top {
            topAccessoryViews.append(customAccessoryView)
        } else {
            bottomAccessoryViews.append(customAccessoryView)
        }

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

    private func updateCellPadding() {
        let extraPadding = view.frame.width >= Constants.cellPaddingThreshold && useDynamicPadding ? Constants.largeCellPadding : Constants.smallCellPadding

        for accessoryView in topAccessoryViews + bottomAccessoryViews {
            if let cell = accessoryView.tableViewCell {
                cell.paddingLeading = TableViewCell.defaultPaddingLeading + extraPadding
                cell.paddingTrailing = TableViewCell.defaultPaddingTrailing + extraPadding
            }
        }
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

    private var isShareActionDisabled: Bool = false {
        didSet {
            updateActions()
        }
    }

    private var showPinAction: Bool = true {
        didSet {
            updateActions()
        }
    }

    private var isPinActionDisabled: Bool = false {
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

    private var showErrorOnBottomCellAction: Bool = true {
        didSet {
            updateActions()
        }
    }

    private var showOverflowAction: Bool = true {
        didSet {
            reloadCells()
        }
    }

    private var useDynamicWidth: Bool = true {
        didSet {
            reloadCells()
        }
    }

    private var useDynamicPadding: Bool = false {
        didSet {
            if oldValue != useDynamicPadding {
                updateCellPadding()
            }
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

    private var minimumActionsCount: UInt = 0 {
        didSet {
            if oldValue != minimumActionsCount {
                for accessoryView in topAccessoryViews + bottomAccessoryViews {
                    accessoryView.minimumActionsCount = minimumActionsCount
                }
            }
        }
    }

    private var topActionsOverlap: UInt = 0 {
        didSet {
            if oldValue != topActionsOverlap {
                for accessoryView in topAccessoryViews {
                    accessoryView.actionsColumnOverlap = topActionsOverlap
                }
            }
        }
    }

    private var bottomActionsOverlap: UInt = 0 {
        didSet {
            if oldValue != bottomActionsOverlap {
                for accessoryView in bottomAccessoryViews {
                    accessoryView.actionsColumnOverlap = bottomActionsOverlap
                }
            }
        }
    }

    private lazy var settingsView: UIView = {
        let settingsView = UIStackView(frame: .zero)
        settingsView.axis = .horizontal

        let spacingView = UIView(frame: .zero)
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.widthAnchor.constraint(equalToConstant: Constants.stackViewSpacing).isActive = true
        settingsView.addArrangedSubview(spacingView)

        let plusMinActionsButton = createPlusMinusButton(plus: true, #selector(incrementMinimumActionsCount))
        let minusMinActionsButton = createPlusMinusButton(plus: false, #selector(decrementMinimumActionsCount))
        let plusTopOverlapButton = createPlusMinusButton(plus: true, #selector(incrementTopActionsOverlap))
        let minusTopOverlapButton = createPlusMinusButton(plus: false, #selector(decrementTopActionsOverlap))
        let plusBottomOverlapButton = createPlusMinusButton(plus: true, #selector(incrementBottomActionsOverlap))
        let minusBottomOverlapButton = createPlusMinusButton(plus: false, #selector(decrementBottomActionsOverlap))

        let settingViews: [UIView] = [
            createLabelAndSwitchRow(labelText: "Dynamic width", switchAction: #selector(toggleDynamicWidth(switchView:)), isOn: useDynamicWidth),
            createLabelAndSwitchRow(labelText: "Dynamic padding", switchAction: #selector(toggleDynamicPadding(switchView:)), isOn: useDynamicPadding),
            createLabelAndSwitchRow(labelText: "Show date", switchAction: #selector(toggleShowDate(switchView:)), isOn: showDate),
            createButton(title: "Choose date", action: #selector(presentDatePicker)),
            createButton(title: "Choose time", action: #selector(presentTimePicker)),
            createLabelAndViewsRow(labelText: "Minimum actions count", views: [plusMinActionsButton, minusMinActionsButton]),
            createLabelAndViewsRow(labelText: "Top actions overlap", views: [plusTopOverlapButton, minusTopOverlapButton]),
            createLabelAndViewsRow(labelText: "Bottom actions overlap", views: [plusBottomOverlapButton, minusBottomOverlapButton]),
            createLabelAndSwitchRow(labelText: "Show shared status", switchAction: #selector(toggleShowSharedStatus(switchView:)), isOn: showSharedStatus),
            createLabelAndSwitchRow(labelText: "Is document shared", switchAction: #selector(toggleAreDocumentsShared(switchView:)), isOn: areDocumentsShared),
            createLabelAndSwitchRow(labelText: "Show keep offline button", switchAction: #selector(toggleShowKeepOffline(switchView:)), isOn: showKeepOfflineAction),
            createLabelAndSwitchRow(labelText: "Show share button", switchAction: #selector(toggleShareButton(switchView:)), isOn: showShareAction),
            createLabelAndSwitchRow(labelText: "Disable share button", switchAction: #selector(toggleShareButtonDisabled(switchView:)), isOn: isShareActionDisabled),
            createLabelAndSwitchRow(labelText: "Show pin button", switchAction: #selector(togglePin(switchView:)), isOn: showPinAction),
            createLabelAndSwitchRow(labelText: "Disable pin button", switchAction: #selector(togglePinButtonDisabled(switchView:)), isOn: isPinActionDisabled),
            createLabelAndSwitchRow(labelText: "Show error button", switchAction: #selector(toggleErrorButton(switchView:)), isOn: showErrorAction),
            createLabelAndSwitchRow(labelText: "Show error button on top cell only", switchAction: #selector(toggleErrorOnBottomCellButton(switchView:)), isOn: !showErrorOnBottomCellAction),
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

    private func createPlusMinusButton(plus: Bool, _ selector: Selector) -> UIButton {
        let button = createButton(title: (plus ? "+" : "-"), action: selector)
        button.widthAnchor.constraint(equalToConstant: Constants.plusMinusButtonWidth).isActive = true
        return button
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

    @objc private func toggleDynamicPadding(switchView: UISwitch) {
        useDynamicPadding = switchView.isOn
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

    @objc private func togglePinButtonDisabled(switchView: UISwitch) {
        isPinActionDisabled = switchView.isOn
    }

    @objc private func toggleShareButton(switchView: UISwitch) {
        showShareAction = switchView.isOn
    }

    @objc private func toggleShareButtonDisabled(switchView: UISwitch) {
        isShareActionDisabled = switchView.isOn
    }

    @objc private func toggleErrorButton(switchView: UISwitch) {
        showErrorAction = switchView.isOn
    }

    @objc private func toggleErrorOnBottomCellButton(switchView: UISwitch) {
        showErrorOnBottomCellAction = !switchView.isOn
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

    @objc private func incrementMinimumActionsCount() {
        minimumActionsCount += 1
    }

    @objc private func decrementMinimumActionsCount() {
        if minimumActionsCount > 0 {
            minimumActionsCount -= 1
        }
    }

    @objc private func incrementTopActionsOverlap() {
        topActionsOverlap += 1
    }

    @objc private func decrementTopActionsOverlap() {
        if topActionsOverlap > 0 {
            topActionsOverlap -= 1
        }
    }

    @objc private func incrementBottomActionsOverlap() {
        bottomActionsOverlap += 1
    }

    @objc private func decrementBottomActionsOverlap() {
        if bottomActionsOverlap > 0 {
            bottomActionsOverlap -= 1
        }
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
