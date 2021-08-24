//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Notification Colors

extension Colors {
    struct Notification {
        struct NeutralToast {
            static var background: UIColor = surfaceQuaternary.withAlphaComponent(0.6)
            static var foreground: UIColor = textDominant
        }
        struct PrimaryOutlineBar {
            static var background = UIColor(light: surfacePrimary, dark: surfaceQuaternary).withAlphaComponent(0.6)
        }
        struct NeutralBar {
            static var background: UIColor = NeutralToast.background
            static var foreground: UIColor = NeutralToast.foreground
        }
    }
}

// MARK: - NotificationView

/**
 `NotificationView` can be used to present a toast (`.primaryToast` and `.neutralToast` styles) or a notification bar (`.primaryBar`, `.primaryOutlineBar`, and `.neutralBar` styles) with information and actions at the bottom of the screen.

 This view can be inserted into layout manually, if needed, or by using the `show` and `hide` methods which implement default presentation (with or without animation). Positioning is done using constraints.

 By default only one visible toast is allowed in the app. When a new toast is shown, the previous one is hidden. This behavior can be changed via `allowsMultipleToasts` static property.

 When `action` exists but no `actionTitle` is provided, a "cross" (X) image will be used for action button.

 When used as a notification bar some functionality like `title`, `image` and actions are not supported. A convenience method `setupAsBar` can be used to initialize notification bar and assign only supported properties.
 */
@objc(MSFNotificationView)
open class NotificationView: UIView {
    @objc(MSFNotificationViewStyle)
    public enum Style: Int {
        case primaryToast
        case neutralToast
        case primaryBar
        case primaryOutlineBar
        case neutralBar
        case dangerToast
        case warningToast

        var isToast: Bool {
            switch self {
            case .primaryBar, .primaryOutlineBar, .neutralBar:
                return false
            case .primaryToast, .neutralToast, .dangerToast, .warningToast:
                return true
            }
        }

        func backgroundColor(for window: UIWindow) -> UIColor {
            switch self {
            case .primaryToast:
                return primaryFilledBackground(for: window)
            case .neutralToast:
                return Colors.Notification.NeutralToast.background
            case .primaryBar:
                return primaryFilledBackground(for: window)
            case .primaryOutlineBar:
                return Colors.Notification.PrimaryOutlineBar.background
            case .neutralBar:
                return Colors.Notification.NeutralBar.background
            case .dangerToast:
                return UIColor(light: Colors.Palette.dangerTint40.color, dark: Colors.Palette.dangerPrimary.color)
            case .warningToast:
                return UIColor(light: Colors.Palette.warningTint40.color, dark: Colors.Palette.warningPrimary.color)
            }
        }
        func foregroundColor(for window: UIWindow) -> UIColor {
            switch self {
            case .primaryToast:
                return UIColor(light: Colors.primaryShade20(for: window), dark: .black)
            case .neutralToast:
                return Colors.Notification.NeutralToast.foreground
            case .primaryBar:
                return UIColor(light: Colors.primaryShade20(for: window), dark: .black)
            case .primaryOutlineBar:
                return UIColor(light: Colors.primary(for: window), dark: Colors.textPrimary)
            case .neutralBar:
                return Colors.Notification.NeutralBar.foreground
            case .dangerToast:
                return UIColor(light: Colors.Palette.dangerShade20.color, dark: .black)
            case .warningToast:
                return UIColor(light: Colors.Palette.warningShade30.color, dark: .black)
            }
        }

        var cornerRadius: CGFloat { return isToast ? Constants.cornerRadiusForToast : 0 }
        var presentationOffset: CGFloat { return isToast ? Constants.presentationOffsetForToast : 0 }
        var needsFullWidth: Bool { return !isToast }

        var animationDurationForShow: TimeInterval { return isToast ? Constants.animationDurationForShowToast : Constants.animationDurationForShowBar }
        var animationDurationForHide: TimeInterval { return Constants.animationDurationForHide }
        var animationDampingRatio: CGFloat { return isToast ? Constants.animationDampingRatioForToast : 1 }

        var needsSeparator: Bool { return  self == .primaryOutlineBar }
        var supportsTitle: Bool { return isToast }
        var supportsImage: Bool { return isToast }
        var supportsMessageAction: Bool { return isToast }
        var shouldAlwaysShowActionButton: Bool { return isToast }

        private func primaryFilledBackground(for window: UIWindow) -> UIColor {
            let primaryColor = Colors.primary(for: window)
            return UIColor(light: primaryColor.withAlphaComponent(0.2), dark: primaryColor)
        }

    }

    private struct Constants {
        static let cornerRadiusForToast: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let verticalPaddingForOneLine: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16
        static let presentationOffsetForToast: CGFloat = 12
        static let minHeight: CGFloat = 64.0
        static let minHeightForOneLine: CGFloat = 52.0

        static let titleTextStyle: TextStyle = .button1
        static let messageTextStyle: TextStyle = .subhead
        static let actionButtonTextStyle: TextStyle = .button1

        static let animationDurationForShowToast: TimeInterval = 0.6
        static let animationDurationForShowBar: TimeInterval = 0.3
        static let animationDurationForHide: TimeInterval = 0.25
        static let animationDampingRatioForToast: CGFloat = 0.5
    }

    @objc public static var allowsMultipleToasts: Bool = false

    private static var currentToast: NotificationView? {
        didSet {
            if allowsMultipleToasts {
                currentToast = nil
            }
        }
    }

    @objc open private(set) var isShown: Bool = false

    private var style: Style = .primaryToast {
        didSet {
            if style != oldValue {
                updateForStyle()
            }
        }
    }

    private var isHiding: Bool = false
    private var completionsForHide: [() -> Void] = []

    private var action: (() -> Void)?
    private var messageAction: (() -> Void)?

    private let backgroundView = BlurringView(style: .regular)
    private let container: UIStackView = {
        let container = UIStackView()
        container.distribution = .fill
        container.alignment = .center
        container.axis = .horizontal
        container.isAccessibilityElement = true
        container.spacing = Constants.horizontalSpacing
        container.layoutMargins = UIEdgeInsets(top: Constants.verticalPadding, left: 0, bottom: Constants.verticalPadding, right: 0)
        return container
    }()
    private let textContainer: UIStackView = {
        let textContainer = UIStackView()
        textContainer.axis = .vertical
        textContainer.setContentCompressionResistancePriority(.required, for: .vertical)
        textContainer.setContentHuggingPriority(.required, for: .vertical)
        return textContainer
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    private let titleLabel: Label = {
        let titleLabel = Label(style: Constants.titleTextStyle)
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        return titleLabel
    }()
    private let messageLabel: Label = {
        let messageLabel = Label(style: Constants.messageTextStyle)
        messageLabel.numberOfLines = 0
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
        return messageLabel
    }()
    private let actionButton: UIButton = {
        let actionButton = UIButton(type: .system)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.titleLabel?.font = Constants.actionButtonTextStyle.font
        actionButton.titleLabel?.adjustsFontForContentSizeCategory = true
        return actionButton
    }()
    private let separator = Separator(style: .shadow, orientation: .horizontal)

    private var hasSingleLineLayout: Bool {
        return titleLabel.text?.isEmpty == true && messageLabel.frame.height == messageLabel.font.deviceLineHeight
    }
    private var constraintWhenHidden: NSLayoutConstraint!
    private var constraintWhenShown: NSLayoutConstraint!

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    open override func removeFromSuperview() {
        super.removeFromSuperview()

        isShown = false
        if NotificationView.currentToast == self {
            NotificationView.currentToast = nil
        }
    }

    @objc open func initialize() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addArrangedSubview(imageView)
        container.addArrangedSubview(textContainer)
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(messageLabel)
        container.addArrangedSubview(actionButton)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: topAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            container.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding)
        ])

        updateForStyle()

        accessibilityElements = [container, actionButton]

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMessageTap)))

        actionButton.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
    }

    /// `setup` is used to initialize the view before showing.
    /// - Parameters:
    ///   - style: The style that defines presentation and functionality of the view.
    ///   - title: The title text that is shown on the top of the view (only supported in toasts).
    ///   - message: The message text that is shown below title (if present) or vertically centered in the view.
    ///   - image: The image that is shown at the leading edge of the view (only supported in toasts).
    ///   - actionTitle: The title for action on the trailing edge of the view.
    ///   - action: The closure to be called when action button is tapped by a user.
    ///   - messageAction: The closure to be called when the body of the view (except action button) is tapped by a user (only supported in toasts).
    ///  - Returns: Reference to this view that can be used for "chained" calling of `show`. Can be ignored.
    @discardableResult
    @objc open func setup(style: Style, title: String = "", message: String, image: UIImage? = nil, actionTitle: String = "", action: (() -> Void)? = nil, messageAction: (() -> Void)? = nil) -> Self {
        self.style = style
        let title = style.supportsTitle ? title : ""
        let image = style.supportsImage ? image : nil
        let messageAction = style.supportsMessageAction ? messageAction : nil

        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
        messageLabel.text = message

        imageView.image = image?.renderingMode == .automatic ? image?.withRenderingMode(.alwaysTemplate) : image
        imageView.isHidden = image == nil

        if action != nil || style.shouldAlwaysShowActionButton {
            if actionTitle.isEmpty {
                let actionImage = UIImage.staticImageNamed("dismiss-20x20")
                actionImage?.accessibilityLabel = "Accessibility.Dismiss.Label".localized
                actionButton.setImage(actionImage, for: .normal)
                actionButton.setTitle(nil, for: .normal)
            } else {
                actionButton.setImage(nil, for: .normal)
                actionButton.setTitle(actionTitle, for: .normal)
            }
            actionButton.isHidden = false
            messageLabel.textAlignment = .natural
        } else {
            actionButton.isHidden = true
            messageLabel.textAlignment = .center
        }

        self.action = action
        self.messageAction = messageAction

        updateAccessibility(title: title, message: message, hasMessageAction: messageAction != nil)

        return self
    }

    /// `show` is used to present the view inside a container view: insert into layout and show with optional animation. Constraints are used for the view positioning.
    /// - Parameters:
    ///   - view: The container view where this view will be presented.
    ///   - anchorView: The view used as the bottom anchor for presentation (notification view is always presented up from the anchor). When no anchor view is provided the bottom anchor of the container's safe area is used.
    ///   - animated: Indicates whether to use animation during presentation or not.
    ///   - completion: The closure to be called after presentation is completed. Can be used to call `hide` with a delay.
    @objc open func show(in view: UIView, from anchorView: UIView? = nil, animated: Bool = true, completion: ((NotificationView) -> Void)? = nil) {
        if isShown {
            return
        }

        if style.isToast, let currentToast = NotificationView.currentToast {
            currentToast.hide(animated: animated) {
                self.show(in: view, from: anchorView, animated: animated, completion: completion)
            }
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        if let anchorView = anchorView, anchorView.superview == view {
            view.insertSubview(self, belowSubview: anchorView)
        } else {
            view.addSubview(self)
        }

        let anchor = anchorView?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor
        constraintWhenHidden = topAnchor.constraint(equalTo: anchor)
        constraintWhenShown = bottomAnchor.constraint(equalTo: anchor, constant: -style.presentationOffset)

        var constraints = [NSLayoutConstraint]()
        constraints.append(animated ? constraintWhenHidden : constraintWhenShown)
        if style.needsFullWidth {
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor))
        } else {
            constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor))
            constraints.append(widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -2 * style.presentationOffset))
        }
        NSLayoutConstraint.activate(constraints)

        isShown = true
        if style.isToast {
            NotificationView.currentToast = self
        }

        let completionForShow = { (_: Bool) in
            UIAccessibility.post(notification: .layoutChanged, argument: self)
            completion?(self)
        }
        if animated {
            view.layoutIfNeeded()
            UIView.animate(withDuration: style.animationDurationForShow, delay: 0, usingSpringWithDamping: style.animationDampingRatio, initialSpringVelocity: 0, animations: {
                self.constraintWhenHidden.isActive = false
                self.constraintWhenShown.isActive = true
                view.layoutIfNeeded()
            }, completion: completionForShow)
        } else {
            completionForShow(true)
        }
    }

    /// `show` is used to present the view inside a container controller: insert into controller's view layout and show with optional animation. When container is a `UINavigationController` then its toolbar (if visible) is used as the bottom anchor for presentation. When container is `UITabBarController`, its tab bar is used as the anchor. Constraints are used for the view positioning.
    /// - Parameters:
    ///   - controller: The container controller whose view will be used for this view's presentation.
    ///   - animated: Indicates whether to use animation during presentation or not.
    ///   - completion: The closure to be called after presentation is completed. Can be used to call `hide` with a delay.
    @objc open func show(from controller: UIViewController, animated: Bool = true, completion: ((NotificationView) -> Void)? = nil) {
        if isShown {
            return
        }

        var anchorView: UIView?
        if let controller = controller as? UINavigationController, !controller.isToolbarHidden {
            anchorView = controller.toolbar
        }
        if let controller = controller as? UITabBarController {
            anchorView = controller.tabBar
        }

        show(in: controller.view, from: anchorView, animated: animated, completion: completion)
    }

    /// `hide` is used to dismiss the presented view: hide with optional animation and remove from the container.
    /// - Parameters:
    ///   - delay: The delay used for the start of dismissal. Default is 0.
    ///   - animated: Indicates whether to use animation during dismissal or not.
    ///   - completion: The closure to be called after dismissal is completed.
    @objc open func hide(after delay: TimeInterval = 0, animated: Bool = true, completion: (() -> Void)? = nil) {
        if !isShown || delay == .infinity {
            return
        }

        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.hide(animated: animated, completion: completion)
            }
            return
        }

        if let completion = completion {
            completionsForHide.append(completion)
        }
        let completionForHide = {
            self.removeFromSuperview()
            UIAccessibility.post(notification: .layoutChanged, argument: nil)

            self.completionsForHide.forEach { $0() }
            self.completionsForHide.removeAll()
        }
        if animated {
            if !isHiding {
                isHiding = true
                UIView.animate(withDuration: style.animationDurationForHide, animations: {
                    self.constraintWhenShown.isActive = false
                    self.constraintWhenHidden.isActive = true
                    self.superview?.layoutIfNeeded()
                }, completion: { _ in
                    self.isHiding = false
                    completionForHide()
                })
            }
        } else {
            completionForHide()
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateWindowSpecificColors()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var suggestedWidth: CGFloat = size.width
        var availableLabelWidth = suggestedWidth

        if style.needsFullWidth {
            if let windowWidth = window?.safeAreaLayoutGuide.layoutFrame.width {
                availableLabelWidth = windowWidth
            }
        } else {
            if let windowWidth = window?.frame.width {
                suggestedWidth = windowWidth
            }

            // for iPad regular width size, notification toast might look too wide
            if traitCollection.userInterfaceIdiom == .pad &&
                traitCollection.horizontalSizeClass == .regular &&
                traitCollection.preferredContentSizeCategory < .accessibilityMedium {
                suggestedWidth = max(suggestedWidth / 2, 375.0)
            } else {
                suggestedWidth -= (safeAreaInsets.left + safeAreaInsets.right + 2 * style.presentationOffset)
            }
            suggestedWidth = ceil(suggestedWidth)
            availableLabelWidth = suggestedWidth
        }

        availableLabelWidth -= (2 * Constants.horizontalPadding)
        if !actionButton.isHidden {
            let actionButtonSize = actionButton.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            availableLabelWidth -= (actionButtonSize.width + Constants.horizontalSpacing)
        }
        if !imageView.isHidden {
            let imageSize = imageView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            availableLabelWidth -= (imageSize.width + Constants.horizontalSpacing)
        }

        var suggesgedHeight: CGFloat
        let messagelabelSize = messageLabel.systemLayoutSizeFitting(CGSize(width: availableLabelWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
        suggesgedHeight = messagelabelSize.height

        // there are different veritcal padding depending on the text we show
        // `Constants.verticalPaddingForOneLine` is used when only messagelabel is shown and all the text fits in oneline
        // Otherwise, use `Constants.veritcalPadding` for top and bottom
        var hasSingleLineLayout = false
        if titleLabel.text?.isEmpty == true {
            hasSingleLineLayout = (messagelabelSize.height == messageLabel.font.deviceLineHeight)
        } else {
            let titleLabelSize = titleLabel.systemLayoutSizeFitting(CGSize(width: availableLabelWidth, height: 0), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultHigh)
            suggesgedHeight += titleLabelSize.height
        }

        let suggestedVerticalPadding = hasSingleLineLayout ? Constants.verticalPaddingForOneLine : Constants.verticalPadding
        suggesgedHeight += 2 * suggestedVerticalPadding
        suggesgedHeight = ceil(max(suggesgedHeight, hasSingleLineLayout ? Constants.minHeightForOneLine : Constants.minHeight))
        container.layoutMargins = UIEdgeInsets(top: suggestedVerticalPadding, left: 0, bottom: suggestedVerticalPadding, right: 0)

        return CGSize(width: suggestedWidth, height: suggesgedHeight)
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    private func updateForStyle() {
        clipsToBounds = !style.needsSeparator
        layer.cornerRadius = style.cornerRadius
        layer.cornerCurve = .continuous

        separator.isHidden = !style.needsSeparator

        updateWindowSpecificColors()
    }

    private func updateWindowSpecificColors() {
        if let window = window {
            backgroundView.updateBackground(backgroundColor: style.backgroundColor(for: window))
            let foregroundColor = style.foregroundColor(for: window)
            imageView.tintColor = foregroundColor
            titleLabel.textColor = foregroundColor
            messageLabel.textColor = foregroundColor
            actionButton.tintColor = foregroundColor
        }
    }

    private func updateAccessibility(title: String, message: String, hasMessageAction: Bool) {
        container.accessibilityLabel = "\(title), \(message)"
        container.accessibilityTraits = hasMessageAction ? .button : .staticText
    }

    @objc private func handleActionButtonTap() {
        hide(animated: true)
        action?()
    }

    @objc private func handleMessageTap() {
        guard let messageAction = messageAction else {
            return
        }
        hide(animated: true)
        messageAction()
    }
}
