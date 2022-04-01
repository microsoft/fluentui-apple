//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class NotificationViewDemoControllerSwiftUI: DemoTableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        initDemoNotification()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NotificationDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NotificationDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = NotificationDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .notification:
            let cell = UITableViewCell()
            let notificationView = notification
            let contentView = cell.contentView
            contentView.addSubview(notificationView)
            notificationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: notificationView.centerXAnchor),
                contentView.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: -15),
                contentView.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 15)
            ])

            return cell

        case .showButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }

            cell.setup(action1Title: "Show", action1Type: .regular)
            cell.action1Button.addTarget(self, action: #selector(showNotification), for: UIControl.Event.touchUpInside)

            return cell

        case .notificationTitle,
                .message,
                .actionButtonTitle,
                .delayTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            let buttonView: [UIView] = {
                switch row {
                case .notificationTitle:
                    return [notificationTitleTextField, notificationTitleButton]
                case .message:
                    return [messageTextField, messageButton]
                case .actionButtonTitle:
                    return [actionButtonTitleTextField, actionButtonTitleButton]
                case .delayTime:
                    return [delayTimeTextField, delayTimeButton]
                default:
                    return []
                }
            }()

            let stackView = UIStackView(arrangedSubviews: buttonView)
            stackView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: 300,
                                     height: 40)
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.spacing = 4

            cell.setup(title: row.title, customAccessoryView: stackView)
            cell.titleNumberOfLines = 0
            return cell

        case .setImage,
                .hasActionButtonAction,
                .hasMessageAction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell else {
                return UITableViewCell()
            }

            let isOn: Bool = {
                switch row {
                case .setImage:
                    return self.setImage
                case .hasActionButtonAction:
                    return hasActionButtonAction
                case .hasMessageAction:
                    return hasMessageAction
                default:
                    return false
                }
            }()

            cell.setup(title: row.title, isOn: isOn)
            cell.titleNumberOfLines = 0
            cell.onValueChanged = { [weak self, weak cell] in
                switch row {
                case .setImage:
                    self?.setImage = cell?.isOn ?? true
                case .hasActionButtonAction:
                    self?.hasActionButtonAction = cell?.isOn ?? true
                case .hasMessageAction:
                    self?.hasMessageAction = cell?.isOn ?? true
                default:
                    break
                }
            }

            return cell

        case .style:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }

            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            let contentView = cell.contentView
            contentView.addSubview(pickerView)
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),
                contentView.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: -15),
                contentView.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 15)
            ])
            return cell
        }
    }

    // MARK: - Picker view data source
    private let pickerView: UIPickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 0, width: 400, height: 100))

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        MSFNotificationStyle.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MSFNotificationStyle.allCases[row].styleString
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        style = MSFNotificationStyle.allCases[row]
    }

    private enum NotificationDemoSection: CaseIterable {
        case notificationDemo
        case content
        case action
        case style

        var isDemoSection: Bool {
            return self == .notificationDemo
        }

        var rows: [NotificationDemoRow] {
            switch self {
            case .notificationDemo:
                return [.notification,
                        .showButton]
            case .content:
                return [.notificationTitle,
                        .message,
                        .actionButtonTitle,
                        .setImage]
            case .action:
                return [.hasActionButtonAction,
                        .hasMessageAction,
                        .delayTime]
            case .style:
                return [.style]
            }
        }

        var title: String {
            switch self {
            case.notificationDemo:
                return "Notification Demo"
            case .content:
                return "Content"
            case .action:
                return "Action"
            case .style:
                return "Style"
            }
        }
    }

    private enum NotificationDemoRow: CaseIterable {
        case notification
        case showButton
        case notificationTitle
        case message
        case actionButtonTitle
        case setImage
        case hasActionButtonAction
        case hasMessageAction
        case delayTime
        case style

        var title: String {
            switch self {
            case .notification:
                return "Notification"
            case .showButton:
                return "Show"
            case .notificationTitle:
                return "Notification Title"
            case .message:
                return "Message"
            case .actionButtonTitle:
                return "Action Button Title"
            case .setImage:
                return "Set Image"
            case .hasActionButtonAction:
                return "Has Action Button Action"
            case .hasMessageAction:
                return "Has Message Action"
            case .delayTime:
                return "Auto-Dismiss Delay Time (Seconds)"
            case .style:
                return "Style"
            }
        }
    }

    private var notificationTitle: String = "" {
        didSet {
            if oldValue != notificationTitle {
                notificationTitleTextField.text = "\(notificationTitle)"
                notification.state.title = notificationTitle
            }
        }
    }

    private lazy var notificationTitleButton: MSFButton = {
        let notificationTitleButton = MSFButton(style: .secondary, size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.notificationTitleTextField.text {
                strongSelf.notificationTitle = text
                button.state.isDisabled = true
            }

            strongSelf.notificationTitleTextField.resignFirstResponder()
        }

        let notificationTitleButtonState = notificationTitleButton.state
        notificationTitleButtonState.text = "Set"
        notificationTitleButtonState.isDisabled = true

        return notificationTitleButton
    }()

    private lazy var notificationTitleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(notificationTitle)"
        textField.isEnabled = true

        return textField
    }()

    private var message: String = "Mail Archived" {
        didSet {
            if oldValue != message {
                messageTextField.text = "\(message)"
                notification.state.message = message
            }
        }
    }

    private lazy var messageButton: MSFButton = {
        let messageButton = MSFButton(style: .secondary, size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.messageTextField.text {
                strongSelf.message = text
                button.state.isDisabled = true
            }

            strongSelf.messageTextField.resignFirstResponder()
        }

        let messageButtonState = messageButton.state
        messageButtonState.text = "Set"
        messageButtonState.isDisabled = true

        return messageButton
    }()

    private lazy var messageTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(message)"
        textField.isEnabled = true

        return textField
    }()

    private var delayTime: TimeInterval = 2.0 {
        didSet {
            if oldValue != delayTime {
                notification.state.delayTime = delayTime
            }
        }
    }

    private lazy var delayTimeButton: MSFButton = {
        let delayTimeButton = MSFButton(style: .secondary, size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.delayTimeTextField.text, let textToTimeInterval = TimeInterval(text) {
                strongSelf.delayTime = textToTimeInterval
                button.state.isDisabled = true
            }

            strongSelf.delayTimeTextField.resignFirstResponder()
        }

        let delayTimeButtonState = delayTimeButton.state
        delayTimeButtonState.text = "Set"
        delayTimeButtonState.isDisabled = true

        return delayTimeButton
    }()

    private lazy var delayTimeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(delayTime)"
        textField.isEnabled = true

        return textField
    }()

    private var actionButtonTitle: String = "Undo" {
        didSet {
            if oldValue != actionButtonTitle {
                actionButtonTitleTextField.text = "\(actionButtonTitle)"
                notification.state.actionButtonTitle = actionButtonTitle
            }
        }
    }

    private lazy var actionButtonTitleButton: MSFButton = {
        let actionButtonTitleButton = MSFButton(style: .secondary, size: .small) { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.actionButtonTitleTextField.text {
                strongSelf.actionButtonTitle = text
                button.state.isDisabled = true
            }

            strongSelf.actionButtonTitleTextField.resignFirstResponder()
        }

        let actionButtonTitleButtonState = actionButtonTitleButton.state
        actionButtonTitleButtonState.text = "Set"
        actionButtonTitleButtonState.isDisabled = true

        return actionButtonTitleButton
    }()

    private lazy var actionButtonTitleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(actionButtonTitle)"
        textField.isEnabled = true

        return textField
    }()

    private var setImage: Bool = false {
        didSet {
            if oldValue != setImage {
                notification.state.image = setImage ? UIImage(named: "play-in-circle-24x24") : nil
            }
        }
    }

    private var hasActionButtonAction: Bool = true {
        didSet {
            if oldValue != hasActionButtonAction {
                notification.state.actionButtonAction = hasActionButtonAction ? { [weak self] in
                    if let actionButtonTitle = self?.actionButtonTitle {
                        if actionButtonTitle.isEmpty {
                            self?.showMessage("`Dismiss` tapped")
                        } else {
                            self?.showMessage("`\(actionButtonTitle)` tapped")
                        }
                    }
                } : nil
            }
        }
    }

    private var hasMessageAction: Bool = false {
        didSet {
            if oldValue != hasMessageAction {
                notification.state.messageButtonAction = hasMessageAction ? { [weak self] in
                    self?.showMessage("Message action tapped")
                } : nil
            }
        }
    }

    private var style: MSFNotificationStyle = MSFNotificationStyle.primaryToast {
        didSet {
            if oldValue != style {
                // Create another instance of the demo notification to show
                notification = MSFNotification(style: style, message: message, delayTime: delayTime)
            }
        }
    }

    private var notification: MSFNotification = MSFNotification(style: .primaryToast, message: "Mail Archived", delayTime: 2.0) {
        didSet {
            if oldValue != notification {
                notification.state.title = oldValue.state.title
                notification.state.image = oldValue.state.image
                notification.state.actionButtonTitle = oldValue.state.actionButtonTitle
                notification.state.actionButtonAction = oldValue.state.actionButtonAction
                notification.state.messageButtonAction = oldValue.state.messageButtonAction
                notification.state.dismissAction = { self.notification.hide() }
                tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
        }
    }

    private func initDemoNotification() {
        let state = notification.state
        state.title = notificationTitle
        state.actionButtonTitle = actionButtonTitle
        state.actionButtonAction = { [weak self] in
            if let actionButtonTitle = self?.actionButtonTitle {
                if actionButtonTitle.isEmpty {
                    self?.showMessage("`Dismiss` tapped")
                } else {
                    self?.showMessage("`\(actionButtonTitle)` tapped")
                }
            }
        }
        state.dismissAction = { [weak self] in
            self?.notification.hide() }
    }

    @objc private func showNotification() {
        // Create another instance of the demo notification to show
        let newNotification = MSFNotification(style: style, message: message, delayTime: delayTime)
        newNotification.state.title = notification.state.title
        newNotification.state.image = notification.state.image
        newNotification.state.actionButtonTitle = notification.state.actionButtonTitle
        newNotification.state.actionButtonAction = notification.state.actionButtonAction
        newNotification.state.messageButtonAction = notification.state.messageButtonAction
        newNotification.state.dismissAction = { newNotification.hide() }
        newNotification.showNotification(in: view) {
            $0.hide(after: newNotification.state.delayTime)
        }
    }
}

// MARK: - NotificationViewDemoControllerSwiftUI: UITextFieldDelegate

extension NotificationViewDemoControllerSwiftUI: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        if textField == notificationTitleTextField {
            notificationTitleButton.state.isDisabled = text == notificationTitle
        } else if textField == messageTextField {
            messageButton.state.isDisabled = text == message
        } else if textField == actionButtonTitleTextField {
            actionButtonTitleButton.state.isDisabled = text == actionButtonTitle
        } else if textField == delayTimeTextField {
            if let timeIntervalText = TimeInterval(text) {
                delayTimeButton.state.isDisabled = timeIntervalText == delayTime
            }
        }

        return true
    }
}

// MARK: - MSFNotificationStyle: styleString extension

extension MSFNotificationStyle {
    var styleString: String {
        switch self {
        case .primaryToast:
            return "Primary Toast"
        case .neutralToast:
            return "Neutral Toast"
        case .primaryBar:
            return "Primary Bar"
        case .primaryOutlineBar:
            return "Primary Outline Bar"
        case .neutralBar:
            return "Neutral Bar"
        case .dangerToast:
            return "Danger Toast"
        case .warningToast:
            return "Warning Toast"
        }
    }
}
