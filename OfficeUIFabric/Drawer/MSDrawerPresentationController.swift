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
    let presentationIsInteractive: Bool

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, source: UIViewController, sourceObject: Any?, presentationOrigin: CGFloat?, presentationDirection: MSDrawerPresentationDirection, presentationOffset: CGFloat, presentationBackground: MSDrawerPresentationBackground, presentationIsInteractive: Bool) {
        sourceViewController = source
        self.sourceObject = sourceObject
        self.presentationOrigin = presentationOrigin
        self.presentationDirection = presentationDirection
        self.presentationOffset = presentationOffset
        self.presentationBackground = presentationBackground
        self.presentationIsInteractive = presentationIsInteractive
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        backgroundView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewTapped(_:)))]
    }

    // Workaround to get Voiceover to ignore the view behind the drawer.
    // Setting accessibilityViewIsModal directly on the container does not work.
    // Presented view requires a mask on its container to prevent sliding over the navigation bar or exposing shadow over it.
    private lazy var accessibilityContainer: UIView = {
        let view = UIView()
        view.accessibilityViewIsModal = true
        view.layer.mask = CALayer()
        view.layer.mask?.backgroundColor = UIColor.white.cgColor
        return view
    }()
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
        containerView?.addSubview(accessibilityContainer)
        accessibilityContainer.fitIntoSuperview()

        accessibilityContainer.addSubview(backgroundView)
        backgroundView.fitIntoSuperview()
        backgroundView.addSubview(dimmingView)
        dimmingView.frame = frameForDimmingView(in: backgroundView.bounds)
        accessibilityContainer.layer.mask?.frame = dimmingView.frame

        accessibilityContainer.addSubview(contentView)
        contentView.frame = frameForContentView()
        contentView.addSubview(shadowView)
        shadowView.owner = presentedViewController.view
        // In non-animated presentations presented view will be force-placed into containerView by UIKit
        // For animated presentations presented view must be inside contentView to not slide over navigation bar/toolbar
        if presentingViewController.transitionCoordinator?.isAnimated == true {
            contentView.addSubview(presentedViewController.view)
        }

        if presentationDirection.isVertical && actualPresentationOffset == 0 {
            containerView?.addSubview(separator)
            separator.frame = frameForSeparator(in: contentView.frame, withThickness: separator.height)
        }

        backgroundView.alpha = 0.0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            UIAccessibility.post(notification: .screenChanged, argument: contentView)
            UIAccessibility.post(notification: .announcement, argument: "Accessibility.Alert".localized)
        } else {
            accessibilityContainer.removeFromSuperview()
            separator.removeFromSuperview()
            removePresentedViewMask()
            shadowView.owner = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        // For animated presentations presented view must be inside contentView to not slide over navigation bar/toolbar
        if presentingViewController.transitionCoordinator?.isAnimated == true {
            contentView.addSubview(presentedViewController.view)
            presentedViewController.view.frame = contentView.bounds
        }

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0.0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            accessibilityContainer.removeFromSuperview()
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
    private lazy var actualPresentationOrigin: CGFloat = {
        if let presentationOrigin = presentationOrigin {
            return presentationOrigin
        }
        switch presentationDirection {
        case .down:
            var controller = sourceViewController
            while let navigationController = controller.navigationController {
                let navigationBar = navigationController.navigationBar
                if !navigationBar.isHidden, let navigationBarParent = navigationBar.superview {
                    return navigationBarParent.convert(navigationBar.frame, to: nil).maxY
                }
                controller = navigationController
            }
            return UIScreen.main.bounds.minY
        case .up:
            return UIScreen.main.bounds.maxY
        case .fromLeading:
            return UIScreen.main.bounds.minX
        case .fromTrailing:
            return UIScreen.main.bounds.maxX
        }
    }()
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
                return containerView.safeAreaInsets.bottom
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

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // In non-animated presentations presented view will be force-placed into containerView by UIKit after separator thus hiding it
        containerView?.bringSubviewToFront(separator)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setPresentedViewMask()
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

    func updateContentViewFrame(animated: Bool) {
        let newFrame = frameForContentView()
        if animated {
            let sizeChange = presentationDirection.isVertical ? newFrame.height - contentView.height : newFrame.width - contentView.width
            let animationDuration = MSDrawerTransitionAnimator.animationDuration(forSizeChange: sizeChange)
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.layoutSubviews], animations: {
                self.setContentViewFrame(newFrame)
                self.animatePresentedViewMask(withDuration: animationDuration)
            })
        } else {
            setContentViewFrame(newFrame)
            setPresentedViewMask()
        }
    }

    private func setContentViewFrame(_ frame: CGRect) {
        contentView.frame = frame
        if let presentedView = presentedView, presentedView.superview == containerView {
            presentedView.frame = frameOfPresentedViewInContainerView
        }
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
            if actualPresentationOffset == 0 {
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
        return CGRect(
            x: bounds.minX,
            y: presentationDirection == .down ? bounds.minY : bounds.maxY - thickness,
            width: bounds.width,
            height: thickness
        )
    }

    // MARK: Presented View Mask

    private func setPresentedViewMask() {
        // No change of mask when it's being animated
        guard let presentedView = presentedView, !(presentedView.layer.mask?.isAnimating ?? false) else {
            return
        }
        // TODO: use layer.maskedCorners
        let roundedCorners: UIRectCorner
        if actualPresentationOffset == 0 {
            switch presentationDirection {
            case .down:
                roundedCorners = [.bottomLeft, .bottomRight]
            case .up:
                roundedCorners = [.topLeft, .topRight]
            case .fromLeading, .fromTrailing:
                roundedCorners = []
            }
        } else {
            roundedCorners = .allCorners
        }
        presentedView.layer.mask = presentedView.layer(withRoundedCorners: roundedCorners, radius: Constants.cornerRadius)
    }

    private func removePresentedViewMask() {
        presentedView?.layer.mask = nil
    }

    private func animatePresentedViewMask(withDuration duration: TimeInterval) {
        guard let presentedView = presentedView else {
            return
        }

        let oldMaskPath = (presentedView.layer.mask as? CAShapeLayer)?.path
        shadowView.animate(withDuration: duration) {
            setPresentedViewMask()
        }

        guard let presentedViewMask = presentedView.layer.mask as? CAShapeLayer else {
            return
        }

        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = oldMaskPath
        animation.duration = duration
        // To match default timing function used in UIView.animate
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        presentedViewMask.add(animation, forKey: animation.keyPath)
    }

    // MARK: Actions

    @objc private func handleBackgroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
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
