//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `MSNotificationView` can be used to present a toast (`.primaryToast` and `.neutralToast` styles) or a notification bar (`.primaryBar`, `.primaryOutlineBar`, and `.neutralBar` styles) with information and actions at the bottom of the screen.

 This view can be inserted into layout manually, if needed, or by using the `show` and `hide` methods which implement default presentation (with or without animation). Positioning is done using constraints.

 By default only one visible toast is allowed in the app. When a new toast is shown, the previous one is hidden. This behavior can be changed via `allowsMultipleToasts` static property.

 When `action` exists but no `actionTitle` is provided, a "cross" (X) image will be used for action button.

 When used as a notification bar some functionality like `title`, `image` and actions are not supported. A convenience method `setupAsBar` can be used to initialize notification bar and assign only supported properties.
 */
open class MSNotificationView: UIView {
    @objc(MSNotificationViewStyle)
    public enum Style: Int {
        case primaryToast
        case neutralToast
        case primaryBar
        case primaryOutlineBar
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
            case .primaryOutlineBar:
                return MSColors.Notification.PrimaryOutlineBar.background
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
            case .primaryOutlineBar:
                return MSColors.Notification.PrimaryOutlineBar.foreground
            case .neutralBar:
                return MSColors.Notification.NeutralBar.foreground
            }
        }

        var cornerRadius: CGFloat { return isToast ? Constants.cornerRadiusForToast : 0 }
        var messageAlignment: NSTextAlignment { return isToast ? .natural : .center }
        var messageStyle: MSTextStyle { return isToast ? Constants.messageTextStyle : Constants.messageTextStyleForBar }
        var presentationOffset: CGFloat { return isToast ? Constants.presentationOffsetForToast : 0 }
        var needsFullWidth: Bool { return !isToast }

        var animationDurationForShow: TimeInterval { return isToast ? Constants.animationDurationForShowToast : Constants.animationDurationForShowBar }
        var animationDurationForHide: TimeInterval { return Constants.animationDurationForHide }
        var animationDampingRatio: CGFloat { return isToast ? Constants.animationDampingRatioForToast : 1 }

        var needsSeparator: Bool { return  self == .primaryOutlineBar }
        var supportsTitle: Bool { return isToast }
        var supportsImage: Bool { return isToast }
        var supportsAction: Bool { return isToast }
    }

    private struct Constants {
        static let cornerRadiusForToast: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 14
        static let verticalPaddingForOneLine: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16
        static let presentationOffsetForToast: CGFloat = 12

        static let titleTextStyle: MSTextStyle = .button1
        static let messageTextStyle: MSTextStyle = .subhead
        static let messageTextStyleForBar: MSTextStyle = .button1
        static let actionButtonTextStyle: MSTextStyle = .button1

        static let animationDurationForShowToast: TimeInterval = 0.6
        static let animationDurationForShowBar: TimeInterval = 0.3
        static let animationDurationForHide: TimeInterval = 0.25
        static let animationDampingRatioForToast: CGFloat = 0.5
    }

    @objc public static var allowsMultipleToasts: Bool = false

    private static var currentToast: MSNotificationView? {
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

    private let backgroundView = MSBlurringView(style: .regular)
    private let container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.isLayoutMarginsRelativeArrangement = true
        container.insetsLayoutMarginsFromSafeArea = false
        // Actual horizontal margins will be set in updateHorizontalPadding later
        container.layoutMargins = .zero
        container.isAccessibilityElement = true
        return container
    }()
    private let textContainer: UIStackView = {
        let textContainer = UIStackView()
        textContainer.axis = .vertical
        textContainer.isLayoutMarginsRelativeArrangement = true
        textContainer.insetsLayoutMarginsFromSafeArea = false
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
        return actionButton
    }()
    private let separator = MSSeparator(style: .shadow, orientation: .horizontal)

    private var messageLabelBoundsObservation: NSKeyValueObservation?

    private var hasSingleLineLayout: Bool {
        return titleLabel.text?.isEmpty != false && messageLabel.frame.height == messageLabel.font.deviceLineHeight
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

    @objc open func initialize() {
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

        actionButton.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)

        messageLabelBoundsObservation = messageLabel.observe(\.bounds) { [unowned self] (_, _) in
            self.updateVerticalPadding()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateActionButtonFont), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    deinit {
        messageLabelBoundsObservation = nil
    }

    /// `setup` is used to initialize the view before showing.
    /// - Parameters:
    ///   - style: The style that defines presentation and functionality of the view.
    ///   - title: The title text that is shown on the top of the view (only supported in toasts).
    ///   - message: The message text that is shown below title (if present) or vertically centered in the view.
    ///   - image: The image that is shown at the leading edge of the view (only supported in toasts).
    ///   - actionTitle: The title for action on the trailing edge of the view (only supported in toasts).
    ///   - action: The closure to be called when action button is tapped by a user (only supported in toasts).
    ///   - messageAction: The closure to be called when the body of the view (except action button) is tapped by a user (only supported in toasts).
    ///  - Returns: Reference to this view that can be used for "chained" calling of `show`. Can be ignored.
    @discardableResult
    @objc open func setup(style: Style, title: String = "", message: String, image: UIImage? = nil, actionTitle: String = "", action: (() -> Void)? = nil, messageAction: (() -> Void)? = nil) -> Self {
        self.style = style
        let title = style.supportsTitle ? title : ""
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
            let actionImage = UIImage.staticImageNamed("dismiss-20x20")
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

        return self
    }

    /// `show` is used to present the view inside a container view: insert into layout and show with optional animation. Constraints are used for the view positioning.
    /// - Parameters:
    ///   - view: The container view where this view will be presented.
    ///   - anchorView: The view used as the bottom anchor for presentation (notification view is always presented up from the anchor). When no anchor view is provided the bottom anchor of the container's safe area is used.
    ///   - animated: Indicates whether to use animation during presentation or not.
    ///   - completion: The closure to be called after presentation is completed. Can be used to call `hide` with a delay.
    @objc open func show(in view: UIView, from anchorView: UIView? = nil, animated: Bool = true, completion: ((MSNotificationView) -> Void)? = nil) {
        if isShown {
            return
        }

        if style.isToast, let currentToast = MSNotificationView.currentToast {
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
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: style.needsFullWidth ? view.leadingAnchor : view.safeAreaLayoutGuide.leadingAnchor, constant: style.presentationOffset),
            trailingAnchor.constraint(equalTo: style.needsFullWidth ? view.trailingAnchor : view.safeAreaLayoutGuide.trailingAnchor, constant: -style.presentationOffset),
            animated ? constraintWhenHidden : constraintWhenShown
        ])

        isShown = true
        if style.isToast {
            MSNotificationView.currentToast = self
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
    @objc open func show(from controller: UIViewController, animated: Bool = true, completion: ((MSNotificationView) -> Void)? = nil) {
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

            self.isShown = false
            if MSNotificationView.currentToast == self {
                MSNotificationView.currentToast = nil
            }

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

    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        updateHorizontalPadding()
    }

    private func updateForStyle() {
        clipsToBounds = !style.needsSeparator
        layer.cornerRadius = style.cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
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
        // Since container.insetsLayoutMarginsFromSafeArea is false we need to manually add horizontal insets
        let insets = directionalSafeAreaInsets
        container.directionalLayoutMargins.leading = (style.needsFullWidth ? insets.leading : 0) + Constants.horizontalPadding
        // Action button includes trailing margin as its padding
        container.directionalLayoutMargins.trailing = (style.needsFullWidth ? insets.trailing : 0) + (actionButton.isHidden ? Constants.horizontalPadding : 0)
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
