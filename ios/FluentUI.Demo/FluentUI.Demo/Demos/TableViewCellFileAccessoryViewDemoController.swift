//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TableViewCellFileAccessoryViewDemoController: UITableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateTimePicker.delegate = self

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewCellFileAccessoryViewDemoSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewCellFileAccessoryViewDemoSections.allCases[section] {
        case .demoCells:
            return 2
        case .settings:
            return TableViewCellFileAccessoryViewDemoSettingsRows.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewCellFileAccessoryViewDemoSections.allCases[indexPath.section] {
        case .demoCells:
            return demoCells[indexPath.row]
        case.settings:
            let row = TableViewCellFileAccessoryViewDemoSettingsRows.allCases[indexPath.row]

            switch row {
            case .dynamicWidth,
                 .dynamicPadding,
                 .showDate,
                 .showSharedStatus,
                 .isDocumentShared,
                 .showKeepOfflineButton,
                 .showShareButton,
                 .showPinButton,
                 .showOverflowButton,
                 .disableShareButton,
                 .disablePinButton,
                 .showErrorButton,
                 .showErrorButtonOnTopCellOnly:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                    return UITableViewCell()
                }
                cell.setup(title: row.title, isOn: row.isOn)
                cell.titleNumberOfLines = 0
                cell.onValueChanged = { [weak self, weak cell] in
                    self?.perform(row.action, with: cell)
                }
                return cell
            case .chooseDate,
                 .chooseTime:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                    return UITableViewCell()
                }
                cell.setup(action1Title: row.title)
                if let action = row.action {
                    cell.action1Button.addTarget(self,
                                                 action: action,
                                                 for: .touchUpInside)
                }
                cell.bottomSeparatorType = .full
                return cell
            case .minimumActionsCount,
                 .topActionsOverlap,
                 .bottomActionsOverlap:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                    return UITableViewCell()
                }

                let buttonViews: [UIView] = {
                    switch row {
                    case .minimumActionsCount:
                        return [minusMinActionsButton, plusMinActionsButton]
                    case .topActionsOverlap:
                        return [minusTopOverlapButton, plusTopOverlapButton]
                    case .bottomActionsOverlap:
                        return [minusBottomOverlapButton, plusBottomOverlapButton]
                    default:
                        return []
                    }
                }()

                let stackView = UIStackView(arrangedSubviews: buttonViews)
                stackView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: 100,
                                         height: 40)
                stackView.distribution = .fillEqually
                stackView.alignment = .center
                stackView.spacing = 4

                cell.setup(title: row.title, customAccessoryView: stackView)
                cell.titleNumberOfLines = 0
                return cell
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewCellFileAccessoryViewDemoSections.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return TableViewCellFileAccessoryViewDemoSections.allCases[indexPath.section] == .demoCells
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }

    private var demoCells: [TableViewCell] {
        let cell1 = createCell(title: "Document Title",
                               subtitle: "OneDrive - Microsoft · Microsoft Teams Chat Files",
                               top: true)
        let cell2 = createCell(title: "This is a very long document title that keeps on going forever to test text truncation",
                               subtitle: "This is a very long document subtitle that keeps on going forever to test text truncation",
                               footer: "This is a footer text to validate the 3 line cell scenario and test text truncation",
                               top: false)

        updateActions()
        updateDate()
        updateSharedStatus()
        updateAreDocumentsShared()
        updateCellPadding()

        return [cell1, cell2]
    }

    private enum TableViewCellFileAccessoryViewDemoSections: CaseIterable {
        case demoCells
        case settings

        var title: String {
            switch self {
            case.demoCells:
                return "Demo Cells"
            case .settings:
                return "Settings"
            }
        }
    }

    private enum TableViewCellFileAccessoryViewDemoSettingsRows: CaseIterable {
        case dynamicWidth
        case dynamicPadding
        case showDate
        case chooseDate
        case chooseTime
        case minimumActionsCount
        case topActionsOverlap
        case bottomActionsOverlap
        case showSharedStatus
        case isDocumentShared
        case showKeepOfflineButton
        case showShareButton
        case disableShareButton
        case showPinButton
        case disablePinButton
        case showErrorButton
        case showErrorButtonOnTopCellOnly
        case showOverflowButton

        var title: String {
            switch self {
            case .dynamicWidth:
                return "Dynamic width"
            case .dynamicPadding:
                return "Dynamic padding"
            case .showDate:
                return "Show date"
            case .chooseDate:
                return "Choose date"
            case .chooseTime:
                return "Choose time"
            case .minimumActionsCount:
                return "Minimum actions count"
            case .topActionsOverlap:
                return "Top actions overlap"
            case .bottomActionsOverlap:
                return "Bottom actions overlap"
            case .showSharedStatus:
                return "Show shared status"
            case .isDocumentShared:
                return "Is document shared"
            case .showKeepOfflineButton:
                return "Show keep offline button"
            case .showShareButton:
                return "Show share button"
            case .disableShareButton:
                return "Disable share button"
            case .showPinButton:
                return "Show pin button"
            case .disablePinButton:
                return "Disable pin button"
            case .showErrorButton:
                return "Show error button"
            case .showErrorButtonOnTopCellOnly:
                return "Show error button on top cell only"
            case .showOverflowButton:
                return "Show overflow button"
            }
        }

        var action: Selector? {
            switch self {
            case .dynamicWidth:
                return #selector(toggleDynamicWidth(_:))
            case .dynamicPadding:
                return #selector(toggleDynamicPadding(_:))
            case .showDate:
                return #selector(toggleShowDate(_:))
            case .chooseDate:
                return #selector(presentDatePicker)
            case .chooseTime:
                return #selector(presentTimePicker)
            case .minimumActionsCount, .topActionsOverlap, .bottomActionsOverlap:
                return nil
            case .showSharedStatus:
                return #selector(toggleShowSharedStatus(_:))
            case .isDocumentShared:
                return #selector(toggleAreDocumentsShared(_:))
            case .showKeepOfflineButton:
                return #selector(toggleShowKeepOffline(_:))
            case .showShareButton:
                return #selector(toggleShareButton(_:))
            case .disableShareButton:
                return #selector(toggleShareButtonDisabled(_:))
            case .showPinButton:
                return #selector(togglePin(_:))
            case .disablePinButton:
                return #selector(togglePinButtonDisabled(_:))
            case .showErrorButton:
                return #selector(toggleErrorButton(_:))
            case .showErrorButtonOnTopCellOnly:
                return #selector(toggleErrorOnBottomCellButton(_:))
            case .showOverflowButton:
                return #selector(toggleOverflow(_:))
            }
        }

        var isOn: Bool {
            switch self {
            case .dynamicWidth,
                 .showDate,
                 .showSharedStatus,
                 .isDocumentShared,
                 .showKeepOfflineButton,
                 .showShareButton,
                 .showPinButton,
                 .showOverflowButton:
                return true
            case .dynamicPadding,
                 .chooseDate,
                 .chooseTime,
                 .minimumActionsCount,
                 .topActionsOverlap,
                 .bottomActionsOverlap,
                 .disableShareButton,
                 .disablePinButton,
                 .showErrorButton,
                 .showErrorButtonOnTopCellOnly:
                return false
            }
        }
    }

    private lazy var plusMinActionsButton: UIButton = createPlusMinusButton(plus: true, #selector(incrementMinimumActionsCount))
    private lazy var minusMinActionsButton: UIButton = createPlusMinusButton(plus: false, #selector(decrementMinimumActionsCount))
    private lazy var plusTopOverlapButton: UIButton = createPlusMinusButton(plus: true, #selector(incrementTopActionsOverlap))
    private lazy var minusTopOverlapButton: UIButton = createPlusMinusButton(plus: false, #selector(decrementTopActionsOverlap))
    private lazy var plusBottomOverlapButton: UIButton = createPlusMinusButton(plus: true, #selector(incrementBottomActionsOverlap))
    private lazy var minusBottomOverlapButton: UIButton = createPlusMinusButton(plus: false, #selector(decrementBottomActionsOverlap))

    private func createPlusMinusButton(plus: Bool, _ selector: Selector) -> UIButton {
        let button = Button(style: .secondaryOutline)
        button.image = UIImage(named: plus ? "ic_fluent_add_20_regular" : "ic_fluent_subtract_20_regular")
        button.addTarget(self,
                         action: selector,
                         for: .touchUpInside)
        return button
    }

    @objc private func toggleShowDate(_ cell: BooleanCell) {
        showDate = cell.isOn
    }

    private let dateTimePicker = DateTimePicker()

    @objc func presentDatePicker() {
        dateTimePicker.present(from: self, with: .date, startDate: Date(), endDate: nil, datePickerType: .components)
    }

    @objc func presentTimePicker() {
        dateTimePicker.present(from: self, with: .dateTime, startDate: Date(), endDate: nil, datePickerType: .components)
    }

    @objc private func toggleDynamicWidth(_ cell: BooleanCell) {
        useDynamicWidth = cell.isOn
    }

    @objc private func toggleDynamicPadding(_ cell: BooleanCell) {
        useDynamicPadding = cell.isOn
    }

    @objc private func toggleShowSharedStatus(_ cell: BooleanCell) {
        showSharedStatus = cell.isOn
    }

    @objc private func toggleAreDocumentsShared(_ cell: BooleanCell) {
        areDocumentsShared = cell.isOn
    }

    @objc private func toggleShowKeepOffline(_ cell: BooleanCell) {
        showKeepOfflineAction = cell.isOn
    }

    @objc private func togglePin(_ cell: BooleanCell) {
        showPinAction = cell.isOn
    }

    @objc private func togglePinButtonDisabled(_ cell: BooleanCell) {
        isPinActionDisabled = cell.isOn
    }

    @objc private func toggleShareButton(_ cell: BooleanCell) {
        showShareAction = cell.isOn
    }

    @objc private func toggleShareButtonDisabled(_ cell: BooleanCell) {
        isShareActionDisabled = cell.isOn
    }

    @objc private func toggleErrorButton(_ cell: BooleanCell) {
        showErrorAction = cell.isOn
    }

    @objc private func toggleErrorOnBottomCellButton(_ cell: BooleanCell) {
        showErrorOnBottomCellAction = !cell.isOn
    }

    @objc private func toggleOverflow(_ cell: BooleanCell) {
        showOverflowAction = cell.isOn
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
            let action = FileAccessoryViewAction(title: "Error",
                                                 image: UIImage(named: "ic_fluent_warning_24_regular")!,
                                                 target: self,
                                                 action: #selector(handleErrorAction),
                                                 canHide: false)
            actions.append(action)
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

    private func displayActionAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func createCell(title: String, subtitle: String, footer: String = "", top: Bool) -> TableViewCell {
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
            footer: footer,
            customView: TableViewSampleData.createCustomView(imageName: "wordIcon"),
            customAccessoryView: customAccessoryView,
            accessoryType: .none
        )

        cell.titleNumberOfLines = 1
        cell.subtitleNumberOfLines = 1

        cell.titleLineBreakMode = .byTruncatingMiddle

        cell.titleNumberOfLinesForLargerDynamicType = 3
        cell.subtitleNumberOfLinesForLargerDynamicType = 2

        cell.backgroundColor = Colors.tableCellBackground
        cell.topSeparatorType = .none
        cell.bottomSeparatorType = (top ? .inset : .none)

        return cell
    }

    private struct Constants {
        static let cellPaddingThreshold: CGFloat = 768
        static let largeCellPadding: CGFloat = 16
        static let smallCellPadding: CGFloat = 8
        static let plusMinusButtonWidth: CGFloat = 40
    }

    private var topAccessoryViews: [TableViewCellFileAccessoryView] = []

    private var bottomAccessoryViews: [TableViewCellFileAccessoryView] = []

    private func reloadCells() {
        if let demoSectionIndex = TableViewCellFileAccessoryViewDemoSections.allCases.firstIndex(of: .demoCells) {
            tableView.reloadSections(IndexSet(integer: demoSectionIndex),
                                              with: .none)
        }
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
