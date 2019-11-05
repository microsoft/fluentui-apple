//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDrawerResizingBehavior

@objc public enum MSDrawerResizingBehavior: Int {
    case none
    case dismiss
    case dismissOrExpand
}

// MARK: - MSDrawerPresentationDirection

@objc public enum MSDrawerPresentationDirection: Int {
    /// Drawer animated down from a top base
    case down
    /// Drawer animated up from a bottom base
    case up
    /// Drawer animated right from a left base (flipped for RTL)
    case fromLeading
    /// Drawer animated left from a right base (flipped for RTL)
    case fromTrailing

    var isVertical: Bool { return self == .down || self == .up }
    var isHorizontal: Bool { return !isVertical }
}

// MARK: - MSDrawerPresentationStyle

@objc public enum MSDrawerPresentationStyle: Int {
    /// Always `.slideover` for horizontal presentation. For vertical presentation results in `.slideover` in horizontally compact environments, `.popover` otherwise.
    case automatic = -1
    case slideover
    case popover
}

// MARK: - MSDrawerPresentationBackground

@objc public enum MSDrawerPresentationBackground: Int {
    /// Clear background
    case none
    /// Black semi-transparent background
    case black

    var dimmingViewType: MSDimmingViewType {
        switch self {
        case .none:
            return .none
        case .black:
            return .black
        }
    }
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

/**
 `MSDrawerController` is used to present a portion of UI in a slider frame that shows from a side on iPhone/iPad and in a popover on iPad.

 Use `presentationDirection` to pick the direction of presentation and `presentationOrigin` to specify the offset (in screen coordinates) from which to show drawer. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.

 `MSDrawerController` will be presented as a popover on iPad (for vertical presentation) and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.

 Set either `contentController` or `contentView` to provide content for the drawer. Desired content size can be specified by using either drawer's or content controller's `preferredContentSize`. If the size is not specified by these means, it will be auto-calculated from the fitting size of the content view.

 Use `resizingBehavior` to allow a user to resize or dismiss the drawer by tapping and dragging any area that does not handle this gesture itself.
 */
open class MSDrawerController: UIViewController {
    private struct Constants {
        static let resistanceCoefficient: CGFloat = 0.1
        static let resizingThreshold: CGFloat = 30
    }

    private enum PresentationStyle: Int {
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

     If you want to specify the size of the content inside the drawer then you can do this through drawer's `preferredContentSize` which will be used to calculate the size of the drawer on screen. Otherwise the fitting size of the content view will be used.
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

    /// When `presentationStyle` is `.automatic` (the default value) drawer is presented as a slideover in horizontally compact environments and as a popover otherwise. For horizontal presentation a slideover is always used. Set this property to a specific presentation style to enforce it in all environments.
    @objc open var presentationStyle: MSDrawerPresentationStyle = .automatic
    /// Use `presentationOffset` to offset drawer from the presentation base in the direction of presentation. Only supported in horizontally regular environments for vertical presentation.
    @objc open var presentationOffset: CGFloat = 0 {
        didSet {
            if presentationDirection.isVertical {
                presentationOffset = max(0, presentationOffset)
            } else {
                presentationOffset = 0
            }
        }
    }
    @objc open var presentationBackground: MSDrawerPresentationBackground = .black

    /**
     When `resizingBehavior` is not `.none` a user can resize the drawer by tapping and dragging any area that does not handle this gesture itself. For example, if `contentController` constains a `UINavigationController`, a user can tap and drag navigation bar to resize the drawer.

     By resizing a drawer a user can switch between several predefined states:
     - a drawer can be expanded (see `isExpanded` property, only for vertical presentation);
     - returned to normal state from expanded state;
     - or dismissed.

     When `resizingBehavior` is `.dismiss` the expanding behavior is not available - drawer can only be dismissed.

     The corresponding `delegate` methods will be called for these state changes: see `drawerControllerDidChangeExpandedState` and `drawerControllerWillDismiss`/`drawerControllerDidDismiss`.

     Resizing is supported only when drawer is presented as a slideover. `.dismissOrExpand` is not supported for horizontal presentation.
     */
    @objc open var resizingBehavior: MSDrawerResizingBehavior = .none {
        didSet {
            if presentationDirection.isHorizontal && resizingBehavior == .dismissOrExpand {
                resizingBehavior = .dismiss
            }
        }
    }
    /**
     Set `isExpanded` to `true` to maximize the drawer's height to fill the device screen vertically minus the safe areas. Set to `false` to restore it to the normal size.

     Not supported for horizontal presentation. Transition is always animated when drawer is visible.
     */
    @objc open var isExpanded: Bool = false {
        didSet {
            if presentationDirection.isHorizontal || isExpanded == oldValue {
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

    open override var preferredContentSize: CGSize {
        get {
            var preferredContentSize = super.preferredContentSize

            let updatePreferredContentSize = { (getWidth: @autoclosure () -> CGFloat, getHeight: @autoclosure () -> CGFloat) in
                if preferredContentSize.width == 0 {
                    preferredContentSize.width = getWidth()
                }
                if preferredContentSize.height == 0 {
                    preferredContentSize.height = getHeight()
                    if preferredContentSize.height != 0 && self.showsResizingHandle {
                        preferredContentSize.height += MSResizingHandleView.height
                    }
                }
            }

            updatePreferredContentSize(preferredContentWidth, preferredContentHeight)
            if let contentController = contentController {
                let contentSize = contentController.preferredContentSize
                updatePreferredContentSize(contentSize.width, contentSize.height)
            }

            if let contentView = contentView, preferredContentSize.width == 0 || preferredContentSize.height == 0 {
                var contentSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                contentSize = CGRect(origin: .zero, size: contentSize).inset(by: contentView.safeAreaInsets).size
                updatePreferredContentSize(contentSize.width, contentSize.height)
            }

            return preferredContentSize.roundedToDevicePixels
        }
        set {
            var newValue = newValue
            if isExpanded && !isExpandedBeingChanged {
                normalPreferredContentHeight = newValue.height
                newValue.height = preferredContentSize.height
            }

            let needsContentViewFrameUpdate = presentingViewController != nil && preferredContentSize != newValue

            super.preferredContentSize = newValue

            if needsContentViewFrameUpdate {
                (presentationController as? MSDrawerPresentationController)?.updateContentViewFrame(animated: true)
            }
        }
    }
    // Override to provide the preferred size based on specifics of the concrete drawer subclass (see popup menu, for example)
    var preferredContentWidth: CGFloat { return 0 }
    var preferredContentHeight: CGFloat { return 0 }

    open override var shouldAutorotate: Bool {
        return presentingViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return presentingViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    /// `onDismiss` is called when drawer is being dismissed.
    @objc open var onDismiss: (() -> Void)?
    /// `onDismissCompleted` is called after drawer has been dismissed.
    @objc open var onDismissCompleted: (() -> Void)?

    @objc public weak var delegate: MSDrawerControllerDelegate?

    private let sourceView: UIView?
    private let sourceRect: CGRect?
    private let barButtonItem: UIBarButtonItem?
    private let presentationOrigin: CGFloat?
    private let presentationDirection: MSDrawerPresentationDirection

    private var isExpandedBeingChanged: Bool = false
    private var normalPreferredContentHeight: CGFloat = -1

    /**
     Initializes `MSDrawerController` to be presented as a popover from `sourceRect` in `sourceView` on iPad and as a slideover on iPhone/iPad.

     - Parameter sourceView: The view containing the anchor rectangle for the popover.
     - Parameter sourceRect: The rectangle in the specified view in which to anchor the popover.
     - Parameter presentationOrigin: The offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.
     - Parameter presentationDirection: The direction of slideover presentation.
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
     Initializes `MSDrawerController` to be presented as a popover from `barButtonItem` on iPad and as a slideover on iPhone/iPad.

     - Parameter barButtonItem: The bar button item on which to anchor the popover.
     - Parameter presentationOrigin: The offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.
     - Parameter presentationDirection: The direction of slideover presentation.
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

    open func willDismiss() {
        onDismiss?()
        delegate?.drawerControllerWillDismiss?(self)
    }

    open func didDismiss() {
        onDismissCompleted?()
        delegate?.drawerControllerDidDismiss?(self)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.Drawer.background
        view.isAccessibilityElement = false
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if canResize {
            if showsResizingHandle {
                if resizingHandleView == nil {
                    resizingHandleView = MSResizingHandleView()
                }
            } else {
                resizingHandleView = nil
            }
            if resizingGestureRecognizer == nil {
                resizingGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleResizingGesture))
            }
        } else {
            resizingHandleView = nil
            resizingGestureRecognizer = nil
        }
        resizingGestureRecognizer?.isEnabled = false
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resizingGestureRecognizer?.isEnabled = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            willDismiss()
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            didDismiss()
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

        var frame = view.bounds

        if let resizingHandleView = resizingHandleView {
            let frames = frame.divided(
                atDistance: resizingHandleView.height,
                from: presentationDirection(for: view) == .down ? .maxYEdge : .minYEdge
            )
            resizingHandleView.frame = frames.slice
            frame = frames.remainder
        }

        contentView?.frame = frame
    }

    open override func accessibilityPerformEscape() -> Bool {
        presentingViewController?.dismiss(animated: true)
        return true
    }

    // Change of presentation direction's orientation is not supported
    private func presentationDirection(for view: UIView) -> MSDrawerPresentationDirection {
        if presentationDirection.isHorizontal && view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            return presentationDirection == .fromLeading ? .fromTrailing : .fromLeading
        }
        return presentationDirection
    }

    private func presentationStyle(for sourceViewController: UIViewController) -> PresentationStyle {
        if presentationStyle != .automatic {
            return PresentationStyle(rawValue: presentationStyle.rawValue)!
        }

        if presentationDirection.isVertical {
            if let window = sourceViewController.view?.window {
                return window.traitCollection.horizontalSizeClass == .compact ? .slideover : .popover
            } else {
                // No window, use the device type as last resort.
                // It will be a problem:
                //   - on iPhone Plus/X in landscape orientation
                //   - on iPad in split view
                return UIDevice.isPhone ? .slideover : .popover
            }
        } else {
            return .slideover
        }
    }

    // MARK: Resizing

    private var canResize: Bool {
        return presentationController is MSDrawerPresentationController && resizingBehavior != .none
    }
    private var showsResizingHandle: Bool {
        return canResize && presentationDirection.isVertical
    }

    private var resizingHandleView: MSResizingHandleView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let newView = resizingHandleView {
                view.addSubview(newView)
            }
        }
    }
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

    private func offset(forResizingGesture gesture: UIPanGestureRecognizer) -> CGFloat {
        let presentationDirection = self.presentationDirection(for: view)
        let translation = gesture.translation(in: nil)
        var offset: CGFloat
        switch presentationDirection {
        case .down:
            offset = translation.y
        case .up:
            offset = -translation.y
        case .fromLeading:
            offset = translation.x
        case .fromTrailing:
            offset = -translation.x
        }
        if resizingBehavior == .dismiss {
            if presentationDirection == .up && gesture.state == .changed {
                offset = offsetWithResistance(for: offset)
            } else {
                offset = min(offset, 0)
            }
        }
        // Rounding to precision used for layout
        return UIScreen.main.roundToDevicePixels(offset)
    }

    private func offsetWithResistance(for offset: CGFloat) -> CGFloat {
        return offset > 0 ? Constants.resistanceCoefficient * offset : offset
    }

    @objc private func handleResizingGesture(gesture: UIPanGestureRecognizer) {
        guard let presentationController = presentationController as? MSDrawerPresentationController else {
            fatalError("MSDrawerController cannot handle resizing without MSDrawerPresentationController")
        }

        let offset = self.offset(forResizingGesture: gesture)

        switch gesture.state {
        case .began:
            presentationController.extraContentSizeEffectWhenCollapsing = isExpanded ? .resize : .move
        case .changed:
            presentationController.setExtraContentSize(offset)
        case .ended:
            if offset >= Constants.resizingThreshold {
                if isExpanded {
                    presentationController.setExtraContentSize(0, animated: true)
                } else {
                    presentationController.setExtraContentSize(0, updatingLayout: false)
                    isExpanded = true
                    delegate?.drawerControllerDidChangeExpandedState?(self)
                }
            } else if offset <= -Constants.resizingThreshold {
                if isExpanded {
                    presentationController.setExtraContentSize(0, updatingLayout: false)
                    isExpanded = false
                    delegate?.drawerControllerDidChangeExpandedState?(self)
                } else {
                    presentingViewController?.dismiss(animated: true)
                }
            } else {
                presentationController.setExtraContentSize(0, animated: true)
            }
        case .cancelled:
            presentationController.setExtraContentSize(0, animated: true)
        default:
            break
        }
    }
}

// MARK: - MSDrawerController: UIViewControllerTransitioningDelegate

extension MSDrawerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presentationStyle(for: source) == .slideover {
            return MSDrawerTransitionAnimator(presenting: true, presentationDirection: presentationDirection(for: source.view))
        }
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let controller = dismissed.presentationController as? MSDrawerPresentationController {
            return MSDrawerTransitionAnimator(presenting: false, presentationDirection: controller.presentationDirection)
        }
        return nil
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presentationStyle(for: source) {
        case .slideover:
            return MSDrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source, sourceObject: sourceView ?? barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection(for: source.view), presentationOffset: presentationOffset, presentationBackground: presentationBackground, presentationIsInteractive: resizingBehavior != .none)
        case .popover:
            let presentationController = UIPopoverPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.backgroundColor = MSColors.Drawer.background
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
