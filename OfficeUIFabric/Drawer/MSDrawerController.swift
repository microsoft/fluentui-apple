//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerPresentationDirection

@objc public enum MSDrawerPresentationDirection: Int {
    case down   // drawer animated down from a top base
    case up     // drawer animated up from a bottom base
}

// MARK: - MSDrawerController

/**
 `MSDrawerController` is used to present a portion of UI in a slider frame that shows up or down on iPhone and in a popover on iPad.

 Use `presentationDirection` to pick the direction of presentation and `presentationOrigin` to specify the vertical offset (in screen coordinates) from which to show drawer. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.

 `MSDrawerController` will be presented as a popover on iPad and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.

 Override `preferredWidth` to provide a custom preferred width for presentation on iPad or landscape iPhone.

 Set either `contentController` or `contentView` to provide content for the drawer. Desired content size can be specified by using either drawer's or content controller's `preferredContentSize`.
 */
open class MSDrawerController: UIViewController {
    private struct Constants {
        static let preferredWidthForLandscapePhone: CGFloat = 400
        static let preferredWidthForPad: CGFloat = 300
    }

    private enum PresentationStyle {
        case slideover
        case popover
    }

    /**
     Set `contentController` to provide a controller that will represent drawer's content. Its view will be hosted in the root view of the drawer and will be sized and positioned to accommodate any shell UI of the drawer.

     Content controller can provide `preferredContentSize` which will be used as a content size to calculate the size of the drawer on screen.
     */
    @objc open var contentController: UIViewController? {
        didSet {
            if contentController == oldValue {
                return
            }
            if _contentView != nil {
                fatalError("MSDrawerController: contentController cannot be set while contentView is assigned")
            }

            if let oldContentController = oldValue {
                removeChildController(oldContentController)
            }
            if let contentController = contentController {
                addChildController(contentController)
            }
        }
    }
    private var _contentView: UIView?
    /**
     Set `contentView` to provide a view that will represent drawer's content. It will be hosted in the root view of the drawer and will be sized and positioned to accommodate any shell UI of the drawer.

     If you want to specify the size of the content inside the drawer then you can do this through drawer's `preferredContentSize` which will be used to calculate the size of the drawer on screen.
     */
    @objc open var contentView: UIView? {
        get {
            return contentController?.view ?? _contentView
        }
        set {
            if contentView == newValue {
                return
            }
            if contentController != nil {
                fatalError("MSDrawerController: contentView cannot be set while contentController is assigned")
            }

            _contentView?.removeFromSuperview()
            _contentView = newValue
            if let contentView = _contentView {
                view.addSubview(contentView)
            }
        }
    }

    /**
     Set `isExpanded` to `true` to maximize the drawer's height to fill the device screen vertically minus the safe areas. Set to `false` to restore it to the normal size.

     Transition is always animated when drawer is visible.
     */
    @objc open var isExpanded: Bool = false {
        didSet {
            if isExpanded == oldValue {
                return
            }
            isExpandedBeingChanged = true
            if isExpanded {
                normalPreferredContentHeight = preferredContentSize.height
                preferredContentSize.height = UIScreen.main.bounds.height
            } else {
                preferredContentSize.height = normalPreferredContentHeight
            }
            isExpandedBeingChanged = false
        }
    }

    /// Use `permittedArrowDirections` to specify the direction of the popover arrow for popover presentation on iPad.
    @objc open var permittedArrowDirections: UIPopoverArrowDirection = .any
    ///  Override `preferredWidth` to provide a custom preferred width for presentation on iPad or landscape iPhone.
    open var preferredWidth: CGFloat {
        if UIDevice.isPhone {
            let maxWidth = presentingViewController?.view?.window?.bounds.width ?? .infinity
            return min(UIScreen.isPortrait ? UIScreen.main.bounds.width : Constants.preferredWidthForLandscapePhone, maxWidth)
        } else {
            return Constants.preferredWidthForPad
        }
    }

    open override var preferredContentSize: CGSize {
        get {
            var preferredContentSize = super.preferredContentSize

            if let contentController = contentController {
                let contentSize = contentController.preferredContentSize
                if preferredContentSize.width == 0 {
                    preferredContentSize.width = contentSize.width
                }
                if preferredContentSize.height == 0 {
                    preferredContentSize.height = contentSize.height
                }
            }

            if preferredContentSize.width == 0 {
                preferredContentSize.width = preferredWidth
            }

            return preferredContentSize
        }
        set {
            var newValue = newValue
            if isExpanded && !isExpandedBeingChanged {
                normalPreferredContentHeight = newValue.height
                newValue.height = preferredContentSize.height
            }

            let hasChanges = preferredContentSize != newValue

            super.preferredContentSize = newValue

            if hasChanges && presentingViewController != nil {
                (presentationController as? MSDrawerPresentationController)?.updateContentViewFrame()
            }
        }
    }

    /// `onDismiss` is called when popup menu is being dismissed.
    @objc open var onDismiss: (() -> Void)?
    /// `onDismissCompleted` is called after popup menu was dismissed.
    @objc open var onDismissCompleted: (() -> Void)?

    private let sourceView: UIView?
    private let sourceRect: CGRect?
    private let barButtonItem: UIBarButtonItem?
    /// The `y` position the slideover should slide from
    private let presentationOrigin: CGFloat?
    private let presentationDirection: MSDrawerPresentationDirection

    private var isExpandedBeingChanged: Bool = false
    private var normalPreferredContentHeight: CGFloat = -1

    /**
     Initializes `MSDrawerController` to be presented as a popover from `sourceRect` in `sourceView` on iPad and as a slideover on iPhone.

     - Parameter sourceView: The view containing the anchor rectangle for the popover.
     - Parameter sourceRect: The rectangle in the specified view in which to anchor the popover.
     - Parameter presentationOrigin: The vertical offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.
     - Parameter presentationDirection: The direction of slideover presentation (`.down` or `.up`).
     */
    @objc public init(sourceView: UIView, sourceRect: CGRect, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection) {
        self.sourceView = sourceView
        self.sourceRect = sourceRect
        self.barButtonItem = nil
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    /**
     Initializes `MSDrawerController` to be presented as a popover from `barButtonItem` on iPad and as a slideover on iPhone.

     - Parameter barButtonItem: The bar button item on which to anchor the popover.
     - Parameter presentationOrigin: The vertical offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.
     - Parameter presentationDirection: The direction of slideover presentation (`.down` or `.up`).
     */
    @objc public init(barButtonItem: UIBarButtonItem, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection) {
        self.sourceView = nil
        self.sourceRect = nil
        self.barButtonItem = barButtonItem
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func initialize() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background
        view.isAccessibilityElement = false
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismissCompleted?()
        }
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if !isBeingPresented && presentationController is MSDrawerPresentationController {
            // The top offset is no longer accurate, and we cannot recalculate
            presentingViewController?.dismiss(animated: false)
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView?.frame = view.bounds
    }

    open override func accessibilityPerformEscape() -> Bool {
        presentingViewController?.dismiss(animated: true)
        return true
    }

    private func presentationStyle(for sourceViewController: UIViewController) -> PresentationStyle {
        guard let window = sourceViewController.view?.window else {
            // No window, use the device type as last resort.
            // It will be a problem:
            //   - on iPhone Plus/X in landscape orientation
            //   - on iPad in split view 
            return UIDevice.isPhone ? .slideover : .popover
        }
        return window.traitCollection.horizontalSizeClass == .compact ? .slideover : .popover
    }
}

// MARK: - MSDrawerController: UIViewControllerTransitioningDelegate

extension MSDrawerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presentationStyle(for: source) == .slideover {
            return MSDrawerTransitionAnimator(presenting: true, presentationDirection: presentationDirection)
        }
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.presentationController is MSDrawerPresentationController {
            return MSDrawerTransitionAnimator(presenting: false, presentationDirection: presentationDirection)
        }
        return nil
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presentationStyle(for: source) {
        case .slideover:
            return MSDrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source, sourceObject: sourceView ?? barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        case .popover:
            let presentationController = UIPopoverPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.backgroundColor = MSColors.background
            presentationController.permittedArrowDirections = permittedArrowDirections
            presentationController.delegate = self

            if let sourceView = sourceView {
                presentationController.sourceView = sourceView
                if let sourceRect = sourceRect {
                    presentationController.sourceRect = sourceRect
                }
            } else if let barButtonItem = barButtonItem {
                presentationController.barButtonItem = barButtonItem
            } else {
                fatalError("A UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs.")
            }

            return presentationController
        }
    }
}

// MARK: - MSDrawerController: UIPopoverPresentationControllerDelegate

extension MSDrawerController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
