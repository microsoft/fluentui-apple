//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objcMembers
open class MSNotificationView: UIView {
    @objc(MSNotificationViewStyle)
    public enum Style: Int {
        case primaryToast
        case neutralToast
        case primaryBar
        case neutralBar

        var isToast: Bool { self == .primaryToast || self == .neutralToast }

        var backgroundColor: UIColor {
            switch self {
            case .primaryToast:
                return MSColors.Notification.PrimaryToast.background
            case .neutralToast:
                return MSColors.Notification.NeutralToast.background
            case .primaryBar:
                return MSColors.Notification.PrimaryBar.background
            case .neutralBar:
                return MSColors.Notification.NeutralBar.background
            }
        }
        var foregroundColor: UIColor {
            switch self {
            case .primaryToast:
                return MSColors.Notification.PrimaryToast.foreground
            case .neutralToast:
                return MSColors.Notification.NeutralToast.foreground
            case .primaryBar:
                return MSColors.Notification.PrimaryBar.foreground
            case .neutralBar:
                return MSColors.Notification.NeutralBar.foreground
            }
        }

        var cornerRadius: CGFloat { return isToast ? Constants.cornerRadiusForToast : 0 }
        var messageAlignment: NSTextAlignment { return isToast ? .natural : .center }
        var messageStyle: MSTextStyle { return isToast ? Constants.messageTextStyle : Constants.messageTextStyleForBar }

        var needsSeparator: Bool { return !isToast }
        var supportsImage: Bool { return isToast }
        var supportsAction: Bool { return isToast }
    }

    private struct Constants {
        static let cornerRadiusForToast: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 14
        static let verticalPaddingForOneLine: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16

        static let titleTextStyle: MSTextStyle = .button1
        static let messageTextStyle: MSTextStyle = .subhead
        static let messageTextStyleForBar: MSTextStyle = .button1
        static let actionButtonTextStyle: MSTextStyle = .button1
    }

    private var style: Style = .primaryToast {
        didSet {
            if style != oldValue {
                updateForStyle()
            }
        }
    }

    private var action: (() -> Void)?
    private var messageAction: (() -> Void)?

    private let backgroundView = MSBlurringView(style: .regular)
    private let container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.isLayoutMarginsRelativeArrangement = true
        // Trailing margin will be set in updateHorizontalPadding
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: Constants.horizontalPadding, bottom: 0, trailing: 0)
        container.isAccessibilityElement = true
        return container
    }()
    private let textContainer: UIStackView = {
        let textContainer = UIStackView()
        textContainer.axis = .vertical
        textContainer.isLayoutMarginsRelativeArrangement = true
        // Actual vertical margins will be set in updateVerticalPadding later
        textContainer.layoutMargins = .zero
        return textContainer
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    private let titleLabel = MSLabel(style: Constants.titleTextStyle)
    private let messageLabel: MSLabel = {
        let messageLabel = MSLabel(style: Constants.messageTextStyle)
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    private let actionButton: UIButton = {
        let actionButton = UIButton(type: .system)
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.horizontalSpacing, bottom: 0, right: Constants.horizontalPadding)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return actionButton
    }()
    private let separator = MSSeparator(style: .shadow, orientation: .horizontal)

    private var messageLabelBoundsObservation: NSKeyValueObservation?

    private var hasSingleLineLayout: Bool {
        return titleLabel.text?.isEmpty != false && messageLabel.height == messageLabel.font.deviceLineHeight
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    open func initialize() {
        addSubview(backgroundView)
        backgroundView.fitIntoSuperview(usingConstraints: true)

        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: topAnchor)
        ])

        addSubview(container)
        container.fitIntoSuperview(usingConstraints: true)
        container.addArrangedSubview(imageView)
        container.setCustomSpacing(Constants.horizontalSpacing, after: imageView)
        container.addArrangedSubview(textContainer)
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(messageLabel)
        container.addArrangedSubview(actionButton)

        updateForStyle()
        updateActionButtonFont()

        accessibilityElements = [container, actionButton]

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMessageTap)))

        messageLabelBoundsObservation = messageLabel.observe(\.bounds) { [unowned self] (_, _) in
            self.updateVerticalPadding()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateActionButtonFont), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    deinit {
        messageLabelBoundsObservation = nil
    }

    open func setup(style: Style, title: String = "", message: String, image: UIImage? = nil, actionTitle: String = "", action: (() -> Void)? = nil, messageAction: (() -> Void)? = nil) {
        self.style = style
        let image = style.supportsImage ? image : nil
        let actionTitle = style.supportsAction ? actionTitle : ""
        let action = style.supportsAction ? action : nil
        let messageAction = style.supportsAction ? messageAction : nil

        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
        messageLabel.text = message

        imageView.image = image?.renderingMode == .automatic ? image?.withRenderingMode(.alwaysTemplate) : image
        imageView.isHidden = image == nil

        if actionTitle.isEmpty {
            let actionImage = UIImage.staticImageNamed("dismiss-20x20")?.withRenderingMode(.alwaysTemplate)
            actionImage?.accessibilityLabel = "Accessibility.Dismiss.Label".localized
            actionButton.setImage(actionImage, for: .normal)
            actionButton.setTitle(nil, for: .normal)
        } else {
            actionButton.setImage(nil, for: .normal)
            actionButton.setTitle(actionTitle, for: .normal)
        }
        actionButton.isHidden = actionTitle.isEmpty && action == nil

        self.action = action
        self.messageAction = messageAction

        updateHorizontalPadding()
        updateVerticalPadding()

        updateAccessibility(title: title, message: message, hasMessageAction: messageAction != nil)
    }

    private func updateForStyle() {
        clipsToBounds = !style.needsSeparator
        layer.cornerRadius = style.cornerRadius
        backgroundView.updateBackground(backgroundColor: style.backgroundColor)
        separator.isHidden = !style.needsSeparator

        messageLabel.textAlignment = style.messageAlignment
        messageLabel.style = style.messageStyle

        imageView.tintColor = style.foregroundColor
        titleLabel.textColor = style.foregroundColor
        messageLabel.textColor = style.foregroundColor
        actionButton.tintColor = style.foregroundColor
    }

    private func updateHorizontalPadding() {
        // Action button includes trailing margin as its padding
        container.directionalLayoutMargins.trailing = actionButton.isHidden ? Constants.horizontalPadding : 0
    }

    private func updateVerticalPadding() {
        textContainer.layoutMargins.top = hasSingleLineLayout ? Constants.verticalPaddingForOneLine : Constants.verticalPadding
        textContainer.layoutMargins.bottom = textContainer.layoutMargins.top
    }

    @objc private func updateActionButtonFont() {
        actionButton.titleLabel?.font = Constants.actionButtonTextStyle.font
    }

    private func updateAccessibility(title: String, message: String, hasMessageAction: Bool) {
        container.accessibilityLabel = "\(title), \(message)"
        container.accessibilityTraits = hasMessageAction ? .button : .staticText
    }

    @objc private func handleActionButtonTap() {
        action?()
    }

    @objc private func handleMessageTap() {
        messageAction?()
    }
}
