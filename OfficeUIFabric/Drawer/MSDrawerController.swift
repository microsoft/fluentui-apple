//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerPresentationDirection

@objc public enum MSDrawerPresentationDirection: Int {
    case down   // drawer animated down from a top base
    case up     // drawer animated up from a bottom base
}

// MARK: - MSDrawerControllerDelegate

@objc public protocol MSDrawerControllerDelegate: class {
    /**
     Called when a user resizes the drawer enough to change its expanded state. Use `isExpanded` property to get the current state.

     Use this method to turn on/off specific UI features of your drawer's content that depend on expanded state. Method is called after expanded state has been changed but before animation is completed.
    */
    @objc optional func drawerControllerDidChangeExpandedState(_ controller: MSDrawerController)

    /// Called when drawer is being dismissed.
    @objc optional func drawerControllerWillDismiss(_ controller: MSDrawerController)
    /// Called after drawer has been dismissed.
    @objc optional func drawerControllerDidDismiss(_ controller: MSDrawerController)
}

// MARK: - MSDrawerController

// TODO: Visual "handle" for resizing

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
        static let resizingThreshold: CGFloat = 30
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
     When `allowsResizing` is `true` a user can resize the drawer by tapping and dragging any area that does not handle this geature itself. For example, if `contentController` constains a `UINavigationController`, a user can tap and drag navigation bar to resize the drawer.

     By resizing a drawer a user can switch between several predefined states:
     - a drawer can be expanded (see `isExpanded` property);
     - returned to normal state from expanded state;
     - or dismissed.

     The corresponding `delegate` methods will be called for these state changes: see `drawerControllerDidChangeExpandedState` and `drawerControllerWillDismiss`/`drawerControllerDidDismiss`.

     Resizing is supported only on iPhone in compact environment (when drawer is presented as a slideover).
     */
    @objc open var allowsResizing: Bool = false
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
                (presentationController as? MSDrawerPresentationController)?.updateContentViewFrame(animated: true)
            }
        }
    }

    /// `onDismiss` is called when drawer is being dismissed.
    @objc open var onDismiss: (() -> Void)?
    /// `onDismissCompleted` is called after drawer has been dismissed.
    @objc open var onDismissCompleted: (() -> Void)?

    @objc public weak var delegate: MSDrawerControllerDelegate?

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

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentationController is MSDrawerPresentationController && allowsResizing {
            if resizingGestureRecognizer == nil {
                resizingGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleResizingGesture))
            }
        } else {
            resizingGestureRecognizer = nil
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
            delegate?.drawerControllerWillDismiss?(self)
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismissCompleted?()
            delegate?.drawerControllerDidDismiss?(self)
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

    // MARK: Resizing

    private var resizingGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            if let oldRecognizer = oldValue {
                view.removeGestureRecognizer(oldRecognizer)
            }
            if let newRecognizer = resizingGestureRecognizer {
                view.addGestureRecognizer(newRecognizer)
            }
        }
    }

    @objc private func handleResizingGesture(gesture: UIPanGestureRecognizer) {
        guard let presentationController = presentationController as? MSDrawerPresentationController else {
            fatalError("MSDrawerController cannot handle resizing without MSDrawerPresentationController")
        }

        let translation = gesture.translation(in: nil)
        let offset: CGFloat
        switch presentationDirection {
        case .down:
            offset = translation.y
        case .up:
            offset = -translation.y
        }

        switch gesture.state {
        case .changed:
            presentationController.setExtraContentHeight(offset)
        case .ended:
            if offset >= Constants.resizingThreshold {
                if isExpanded {
                    presentationController.setExtraContentHeight(0, animated: true)
                } else {
                    presentationController.setExtraContentHeight(0, updatingLayout: false)
                    isExpanded = true
                    delegate?.drawerControllerDidChangeExpandedState?(self)
                }
            } else if offset <= -Constants.resizingThreshold {
                if isExpanded {
                    presentationController.setExtraContentHeight(0, updatingLayout: false)
                    isExpanded = false
                    delegate?.drawerControllerDidChangeExpandedState?(self)
                } else {
                    presentingViewController?.dismiss(animated: true)
                }
            } else {
                presentationController.setExtraContentHeight(0, animated: true)
            }
        case .cancelled:
            presentationController.setExtraContentHeight(0, animated: true)
        default:
            break
        }
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
            return MSDrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source, sourceObject: sourceView ?? barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection, presentationIsInteractive: allowsResizing)
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
