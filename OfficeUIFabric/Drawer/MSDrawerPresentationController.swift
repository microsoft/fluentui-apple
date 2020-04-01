//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDrawerPresentationController

class MSDrawerPresentationController: UIPresentationController {
    private struct Constants {
        static let cornerRadius: CGFloat = 14
        static let minHorizontalMargin: CGFloat = 44
        static let minVerticalMargin: CGFloat = 20
    }

    let sourceViewController: UIViewController
    let sourceObject: Any?
    let presentationOrigin: CGFloat?
    let presentationDirection: MSDrawerPresentationDirection
    let presentationOffset: CGFloat
    let presentationBackground: MSDrawerPresentationBackground

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, source: UIViewController, sourceObject: Any?, presentationOrigin: CGFloat?, presentationDirection: MSDrawerPresentationDirection, presentationOffset: CGFloat, presentationBackground: MSDrawerPresentationBackground, adjustHeightForKeyboard: Bool) {
        sourceViewController = source
        self.sourceObject = sourceObject
        self.presentationOrigin = presentationOrigin
        self.presentationDirection = presentationDirection
        self.presentationOffset = presentationOffset
        self.presentationBackground = presentationBackground
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        backgroundView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewTapped(_:)))]

        if adjustHeightForKeyboard {
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        }
    }

    // A transparent view, which if tapped will dismiss the dropdown
    private lazy var backgroundView: UIView = {
        let view = BackgroundView()
        view.backgroundColor = .clear
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Accessibility.Dismiss.Label".localized
        view.accessibilityHint = "Accessibility.Dismiss.Hint".localized
        view.accessibilityTraits = .button
        // Workaround for a bug in iOS: if the resizing handle happens to be in the middle of the backgroundView, VoiceOver will send touch event to it (according to the backgroundView's accessibilityActivationPoint) even though it's not parented in backgroundView or even interactable - this will prevent backgroundView from receiving touch and dismissing controller
        view.onAccessibilityActivate = { [unowned self] in
            self.presentingViewController.dismiss(animated: true)
        }
        return view
    }()
    private lazy var dimmingView: MSDimmingView = {
        let view = MSDimmingView(type: presentationBackground.dimmingViewType)
        view.isUserInteractionEnabled = false
        return view
    }()
    // `contentView` contains content in majority of cases with 2 exceptions: after horizontal presentations and in non-animated presentations. `containerView` contains everything directly or indirectly, in some cases (2 cases described above) it will also contain content (but use `contentView` for layout information).
    private lazy var contentView = UIView()
    // Shadow behind presented view (cannot be done on presented view itself because it's masked)
    private lazy var shadowView: DrawerShadowView = {
        // Uses function initializer to workaround a Swift compiler bug in Xcode 10.1
        return DrawerShadowView(shadowDirection: actualPresentationOffset == 0 ? presentationDirection : nil)
    }()
    // Imitates the bottom shadow of navigation bar or top shadow of toolbar because original ones are hidden by presented view
    private lazy var separator = MSSeparator(style: .shadow)

    // MARK: Presentation

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(backgroundView)
        backgroundView.fitIntoSuperview()
        backgroundView.addSubview(dimmingView)

        containerView?.addSubview(contentView)
        if presentationDirection.isVertical && actualPresentationOffset == 0 {
            containerView?.addSubview(separator)
        }

        updateLayout()

        contentView.addSubview(shadowView)
        shadowView.owner = presentedViewController.view
        // In non-animated presentations presented view will be force-placed into containerView by UIKit
        // For animated presentations presented view must be inside contentView to not slide over navigation bar/toolbar
        if presentingViewController.transitionCoordinator?.isAnimated == true {
            // Avoiding content animation due to showing of the keyboard (when presented view contains the first responder)
            presentedViewController.view.frame = contentView.bounds
            presentedViewController.view.layoutIfNeeded()

            contentView.addSubview(presentedViewController.view)
        }
        setPresentedViewMask()

        backgroundView.alpha = 0.0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            let focusElement: UIView?
            // Horizontally presented drawers must be inside containerView in order for device rotation animation to work correctly
            if presentationDirection.isHorizontal {
                containerView?.addSubview(presentedViewController.view)
                presentedViewController.view.frame = frameOfPresentedViewInContainerView
                focusElement = containerView
            } else {
                focusElement = contentView
            }
            UIAccessibility.post(notification: .screenChanged, argument: focusElement)
            UIAccessibility.post(notification: .announcement, argument: "Accessibility.Alert".localized)
        } else {
            separator.removeFromSuperview()
            removePresentedViewMask()
            shadowView.owner = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        // For animated presentations presented view must be inside contentView to not slide over navigation bar/toolbar
        if let transitionCoordinator = presentingViewController.transitionCoordinator, transitionCoordinator.isAnimated == true {
            contentView.addSubview(presentedViewController.view)
            presentedViewController.view.frame = contentView.bounds

            transitionCoordinator.animate(alongsideTransition: { _ in
                self.backgroundView.alpha = 0.0
            })
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            separator.removeFromSuperview()
            removePresentedViewMask()
            shadowView.owner = nil
            UIAccessibility.post(notification: .screenChanged, argument: sourceObject)
        }
    }

    // MARK: Layout

    enum ExtraContentSizeEffect {
        case move
        case resize
    }

    override var frameOfPresentedViewInContainerView: CGRect { return contentView.frame }

    var extraContentSizeEffectWhenCollapsing: ExtraContentSizeEffect = .move

    private var actualPresentationOffset: CGFloat {
        if presentationDirection.isVertical && traitCollection.horizontalSizeClass == .regular {
            return presentationOffset
        }
        return 0
    }
    private var actualPresentationOrigin: CGFloat {
        if let presentationOrigin = presentationOrigin {
            return presentationOrigin
        }

        let containerBounds = containerView?.bounds ?? UIScreen.main.bounds
        switch presentationDirection {
        case .down:
            var controller = sourceViewController
            while let navigationController = controller.navigationController {
                let navigationBar = navigationController.navigationBar
                if !navigationBar.isHidden, let navigationBarParent = navigationBar.superview {
                    return navigationBarParent.convert(navigationBar.frame, to: containerView).maxY
                }
                controller = navigationController
            }
            return containerBounds.minY
        case .up:
            return containerBounds.maxY
        case .fromLeading:
            return containerBounds.minX
        case .fromTrailing:
            return containerBounds.maxX
        }
    }
    private var extraContentSize: CGFloat = 0
    private var safeAreaPresentationOffset: CGFloat {
        guard let containerView = containerView else {
            return 0
        }
        switch presentationDirection {
        case .down:
            if actualPresentationOrigin == containerView.bounds.minY {
                return containerView.safeAreaInsets.top
            }
        case .up:
            if actualPresentationOrigin == containerView.bounds.maxY {
                return containerView.safeAreaInsets.bottom + keyboardHeight
            }
        case .fromLeading:
            if actualPresentationOrigin == containerView.bounds.minX {
                return containerView.safeAreaInsets.left
            }
        case .fromTrailing:
            if actualPresentationOrigin == containerView.bounds.maxX {
                return containerView.safeAreaInsets.right
            }
        }
        return 0
    }
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            if keyboardHeight != oldValue {
                updateContentViewFrame(animated: true, animationDuration: keyboardAnimationDuration)
                separator.isHidden = keyboardHeight != 0
            }
        }
    }
    private var keyboardAnimationDuration: Double?

    private var isUpdatingContentViewFrame: Bool = false

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        updateLayout()
        // In non-animated presentations presented view will be force-placed into containerView by UIKit after separator thus hiding it
        containerView?.bringSubviewToFront(separator)
    }

    func setExtraContentSize(_ extraContentSize: CGFloat, updatingLayout updateLayout: Bool = true, animated: Bool = false) {
        if self.extraContentSize == extraContentSize {
            return
        }
        self.extraContentSize = extraContentSize
        if updateLayout {
            updateContentViewFrame(animated: animated)
        }
    }

    func updateContentViewFrame(animated: Bool, animationDuration: TimeInterval? = nil) {
        if isUpdatingContentViewFrame {
            return
        }
        isUpdatingContentViewFrame = true

        let newFrame = frameForContentView()
        if animated {
            let sizeChange = presentationDirection.isVertical ? newFrame.height - contentView.frame.height : newFrame.width - contentView.frame.width
            let animationDuration = animationDuration ?? MSDrawerTransitionAnimator.animationDuration(forSizeChange: sizeChange)
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.layoutSubviews], animations: {
                self.setContentViewFrame(newFrame)
                self.isUpdatingContentViewFrame = false
            })
        } else {
            setContentViewFrame(newFrame)
            isUpdatingContentViewFrame = false
        }
    }

    private func setContentViewFrame(_ frame: CGRect) {
        contentView.frame = frame
        if let presentedView = presentedView, presentedView.superview == containerView {
            presentedView.frame = frameOfPresentedViewInContainerView
        }
        if separator.superview != nil {
            separator.frame = frameForSeparator(in: contentView.frame, withThickness: separator.frame.height)
        }
        updateBackgroundAccessibilityFrame()
    }

    private func updateLayout() {
        dimmingView.frame = frameForDimmingView(in: backgroundView.bounds)
        setContentViewFrame(frameForContentView())
    }

    private func updateBackgroundAccessibilityFrame() {
        let bounds = contentView.frame
        var margins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            margins.top = bounds.height
        case .up:
            margins.bottom = bounds.height
        case .fromLeading:
            margins.left = bounds.width
        case .fromTrailing:
            margins.right = bounds.width
        }
        backgroundView.accessibilityFrame = dimmingView.frame.inset(by: margins)
    }

    private func frameForDimmingView(in bounds: CGRect) -> CGRect {
        var margins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            margins.top = actualPresentationOrigin
        case .up:
            margins.bottom = bounds.height - actualPresentationOrigin
        case .fromLeading:
            margins.left = actualPresentationOrigin
        case .fromTrailing:
            margins.right = bounds.width - actualPresentationOrigin
        }
        return bounds.inset(by: margins)
    }

    private func frameForContentView() -> CGRect {
        // Positioning content view relative to dimming view
        return frameForContentView(in: dimmingView.frame)
    }

    private func frameForContentView(in bounds: CGRect) -> CGRect {
        var contentFrame = bounds.inset(by: marginsForContentView())

        var contentSize = presentedViewController.preferredContentSize
        if presentationDirection.isVertical {
            if contentSize.width == 0 || traitCollection.horizontalSizeClass == .compact {
                contentSize.width = contentFrame.width
            }
            if actualPresentationOffset == 0 && (presentationDirection == .down || keyboardHeight == 0) {
                contentSize.height += safeAreaPresentationOffset
            }
            contentSize.height = min(contentSize.height, contentFrame.height)
            if extraContentSize >= 0 || extraContentSizeEffectWhenCollapsing == .resize {
                contentSize.height = min(contentSize.height + extraContentSize, contentFrame.height)
            }

            contentFrame.origin.x += (contentFrame.width - contentSize.width) / 2
            if presentationDirection == .up {
                contentFrame.origin.y = contentFrame.maxY - contentSize.height
            }
            if extraContentSize < 0 && extraContentSizeEffectWhenCollapsing == .move {
                contentFrame.origin.y += presentationDirection == .down ? extraContentSize : -extraContentSize
            }
        } else {
            if actualPresentationOffset == 0 {
                contentSize.width += safeAreaPresentationOffset
            }
            contentSize.width = min(contentSize.width, contentFrame.width)
            contentSize.height = contentFrame.height

            if presentationDirection == .fromTrailing {
                contentFrame.origin.x = contentFrame.maxX - contentSize.width
            }
            if extraContentSize < 0 && extraContentSizeEffectWhenCollapsing == .move {
                contentFrame.origin.x += presentationDirection == .fromLeading ? extraContentSize : -extraContentSize
            }
        }
        contentFrame.size = contentSize

        return contentFrame
    }

    private func marginsForContentView() -> UIEdgeInsets {
        guard let containerView = containerView else {
            return .zero
        }

        let presentationOffsetMargin = actualPresentationOffset > 0 ? safeAreaPresentationOffset + actualPresentationOffset : 0
        var margins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            margins.top = presentationOffsetMargin
            margins.bottom = max(Constants.minVerticalMargin, containerView.safeAreaInsets.bottom)
        case .up:
            margins.top = max(Constants.minVerticalMargin, containerView.safeAreaInsets.top)
            margins.bottom = presentationOffsetMargin
            if actualPresentationOffset == 0 && keyboardHeight > 0 {
                margins.bottom += safeAreaPresentationOffset
            }
        case .fromLeading:
            margins.left = presentationOffsetMargin
            margins.right = max(Constants.minHorizontalMargin, containerView.safeAreaInsets.right)
        case .fromTrailing:
            margins.left = max(Constants.minHorizontalMargin, containerView.safeAreaInsets.left)
            margins.right = presentationOffsetMargin
        }
        return margins
    }

    private func frameForSeparator(in bounds: CGRect, withThickness thickness: CGFloat) -> CGRect {
        var bounds = bounds
        // Separator should stay fixed even when content view is moving - compensating for move
        if extraContentSize < 0 && extraContentSizeEffectWhenCollapsing == .move {
            bounds.origin.y += presentationDirection == .down ? -extraContentSize : extraContentSize
        }

        return CGRect(
            x: bounds.minX,
            y: presentationDirection == .down ? bounds.minY : bounds.maxY - thickness,
            width: bounds.width,
            height: thickness
        )
    }

    // MARK: Presented View Mask

    private func setPresentedViewMask() {
        let maskedCorners: CACornerMask
        if actualPresentationOffset == 0 {
            switch presentationDirection {
            case .down:
                maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .up:
                maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .fromLeading, .fromTrailing:
                maskedCorners = []
            }
        } else {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        presentedView?.layer.masksToBounds = true
        presentedView?.layer.maskedCorners = maskedCorners
        presentedView?.layer.cornerRadius = Constants.cornerRadius
    }

    private func removePresentedViewMask() {
        presentedView?.layer.maskedCorners = []
    }

    // MARK: Actions

    @objc private func handleBackgroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }

    @objc private func handleKeyboardWillChangeFrame(notification: Notification) {
        guard let containerView = containerView, let notificationInfo = notification.userInfo else {
            return
        }

        let isLocalNotification = (notificationInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
        if isLocalNotification == false {
            return
        }

        guard var keyboardFrame = (notificationInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        keyboardAnimationDuration = (notificationInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue

        keyboardFrame = containerView.convert(keyboardFrame, from: nil)
        keyboardHeight = max(0, containerView.bounds.maxY - containerView.safeAreaInsets.bottom - keyboardFrame.minY)
    }
}

// MARK: - BackgroundView

// Used for workaround for a bug in iOS: if the resizing handle happens to be in the middle of the backgroundView, VoiceOver will send touch event to it (according to the backgroundView's accessibilityActivationPoint) even though it's not parented in backgroundView or even interactable - this will prevent backgroundView from receiving touch and dismissing controller. This view overrides the default behavior of sending touch event to a view at the activation point and provides a way for custom handling.
private class BackgroundView: UIView {
    var onAccessibilityActivate: (() -> Void)?

    override func accessibilityActivate() -> Bool {
        onAccessibilityActivate?()
        return true
    }
}
