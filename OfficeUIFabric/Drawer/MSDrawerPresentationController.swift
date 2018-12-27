//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerPresentationController

class MSDrawerPresentationController: UIPresentationController {
    private struct Constants {
        static let cornerRadius: CGFloat = 8
        static let minVerticalMargin: CGFloat = 20
    }

    let sourceViewController: UIViewController
    let sourceObject: Any?
    let presentationOrigin: CGFloat?
    let presentationDirection: MSDrawerPresentationDirection

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, source: UIViewController, sourceObject: Any?, presentationOrigin: CGFloat? = nil, presentationDirection: MSDrawerPresentationDirection) {
        sourceViewController = source
        self.sourceObject = sourceObject
        self.presentationOrigin = presentationOrigin
        self.presentationDirection = presentationDirection
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        backgroundView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewTapped(_:)))]
    }

    // Workaround to get Voiceover to ignore the view behind the drawer.
    // Setting accessibilityViewIsModal directly on the container does not work
    private lazy var accessibilityContainer: UIView = {
        let view = UIView()
        view.accessibilityViewIsModal = true
        return view
    }()
    // A transparent view, which if tapped will dismiss the dropdown
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Accessibility.Dismiss.Label".localized
        view.accessibilityHint = "Accessibility.Dismiss.Hint".localized
        view.accessibilityTraits = UIAccessibilityTraitButton
        return view
    }()
    private lazy var dimmingView: MSDimmingView = {
        let view = MSDimmingView(type: .black)
        view.isAccessibilityElement = false
        view.isUserInteractionEnabled = false
        return view
    }()
    // Presented view requires this wrapper view to prevent sliding over the navigation bar
    private lazy var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.isAccessibilityElement = false
        return view
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

        accessibilityContainer.addSubview(contentView)
        contentView.frame = frameForContentView()
        // In non-animated presentations presented view will be force-placed into containerView by UIKit
        // For animated presentations presented view must be inside contentView to not slide over navigation bar/toolbar
        if presentingViewController.transitionCoordinator?.isAnimated == true {
            contentView.addSubview(presentedViewController.view)
        }

        containerView?.addSubview(separator)
        separator.frame = frameForSeparator(in: contentView.frame, withThickness: separator.height)

        backgroundView.alpha = 0.0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, contentView)
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Accessibility.Alert".localized)
        } else {
            accessibilityContainer.removeFromSuperview()
            separator.removeFromSuperview()
            removePresentedViewMask()
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
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, sourceObject)
        }
    }

    // MARK: Layout

    override var frameOfPresentedViewInContainerView: CGRect { return contentView.frame }

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
        }
    }()

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // In non-animated presentations presented view will be force-placed into containerView by UIKit after separator thus hiding it
        containerView?.bringSubview(toFront: separator)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setPresentedViewMask()
    }

    func updateContentViewFrame() {
        let newFrame = frameForContentView()

        guard let presentedView = presentedView else {
            contentView.frame = newFrame
            setPresentedViewMask()
            return
        }

        let animationDuration = MSDrawerTransitionAnimator.animationDuration(forSizeChange: newFrame.height - contentView.height)
        UIView.animate(withDuration: animationDuration) {
            self.contentView.frame = newFrame
            if presentedView.superview == self.containerView {
                presentedView.frame = self.frameOfPresentedViewInContainerView
            }

            self.animatePresentedViewMask(withDuration: animationDuration)
        }
    }

    private func frameForDimmingView(in bounds: CGRect) -> CGRect {
        var margins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            margins.top = actualPresentationOrigin
        case .up:
            margins.bottom = bounds.height - actualPresentationOrigin
        }
        return UIEdgeInsetsInsetRect(bounds, margins)
    }

    private func frameForContentView() -> CGRect {
        // Positioning content view relative to dimming view
        return frameForContentView(in: dimmingView.frame)
    }

    private func frameForContentView(in bounds: CGRect) -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        var contentMargins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            contentMargins.bottom = max(Constants.minVerticalMargin, containerView.safeAreaInsetsIfAvailable.bottom)
        case .up:
            contentMargins.top = max(Constants.minVerticalMargin, containerView.safeAreaInsetsIfAvailable.top)
        }
        var contentFrame = UIEdgeInsetsInsetRect(bounds, contentMargins)

        var contentSize = presentedViewController.preferredContentSize
        switch presentationDirection {
        case .down:
            if actualPresentationOrigin == containerView.bounds.minY {
                contentSize.height += containerView.safeAreaInsetsIfAvailable.top
            }
        case .up:
            if actualPresentationOrigin == containerView.bounds.maxY {
                contentSize.height += containerView.safeAreaInsetsIfAvailable.bottom
            }
        }
        contentSize = CGSize(
            width: min(contentSize.width, contentFrame.width),
            height: min(contentSize.height, contentFrame.height)
        )

        contentFrame.origin.x += (contentFrame.width - contentSize.width) / 2
        if presentationDirection == .up {
            contentFrame.origin.y = contentFrame.maxY - contentSize.height
        }
        contentFrame.size = contentSize

        return contentFrame
    }

    private func frameForSeparator(in bounds: CGRect, withThickness thickness: CGFloat) -> CGRect {
        return CGRect(
            x: bounds.minX,
            y: presentationDirection == .down ? bounds.minY : bounds.maxY - thickness,
            width: bounds.width,
            height: thickness
        )
    }

    private func setPresentedViewMask() {
        // No change of mask when it's being animated
        guard let presentedView = presentedView, !(presentedView.layer.mask?.isAnimating ?? false) else {
            return
        }
        let roundedCorners: UIRectCorner = presentationDirection == .down ? [.bottomLeft, .bottomRight] : [.topLeft, .topRight]
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
        setPresentedViewMask()

        guard let presentedViewMask = presentedView.layer.mask as? CAShapeLayer else {
            return
        }

        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = oldMaskPath
        animation.duration = duration
        // To match default timing function used in UIView.animate
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        presentedViewMask.add(animation, forKey: animation.keyPath)
    }

    // MARK: Actions

    @objc private func handleBackgroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
