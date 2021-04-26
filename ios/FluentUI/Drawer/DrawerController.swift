//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DrawerResizingBehavior

@available(*, deprecated, renamed: "DrawerResizingBehavior")
public typealias MSDrawerResizingBehavior = DrawerResizingBehavior

@objc(MSFDrawerResizingBehavior)
public enum DrawerResizingBehavior: Int {
    case none
    case dismiss
    case expand
    case dismissOrExpand
}

// MARK: - DrawerPresentationDirection

@available(*, deprecated, renamed: "DrawerPresentationDirection")
public typealias MSDrawerPresentationDirection = DrawerPresentationDirection

@objc(MSFDrawerPresentationDirection)
public enum DrawerPresentationDirection: Int {
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

// MARK: - DrawerPresentationStyle

@available(*, deprecated, renamed: "DrawerPresentationStyle")
public typealias MSDrawerPresentationStyle = DrawerPresentationStyle

@objc(MSFDrawerPresentationStyle)
public enum DrawerPresentationStyle: Int {
    /// Always `.slideover` for horizontal presentation. For vertical presentation results in `.slideover` in horizontally compact environments, `.popover` otherwise.
    case automatic = -1
    case slideover
    case popover
}

// MARK: - DrawerPresentationBackground

@available(*, deprecated, renamed: "DrawerPresentationBackground")
public typealias MSDrawerPresentationBackground = DrawerPresentationBackground

@objc(MSFDrawerPresentationBackground)
public enum DrawerPresentationBackground: Int {
    /// Clear background
    case none
    /// Black semi-transparent background
    case black

    var dimmingViewType: DimmingViewType {
        switch self {
        case .none:
            return .none
        case .black:
            return .black
        }
    }
}

// MARK: - Drawer Color

public extension Colors {
    private struct Drawer {
        static var background = UIColor(light: surfacePrimary, dark: surfaceSecondary)
        static var popoverBackground = UIColor(light: surfacePrimary, dark: surfaceQuaternary)
    }

    // Objective-C support
    @objc static var drawerBackground: UIColor { return Drawer.background }
    @objc static var popoverBackground: UIColor { return Drawer.popoverBackground }
}

// MARK: - DrawerControllerDelegate

@available(*, deprecated, renamed: "DrawerControllerDelegate")
public typealias MSDrawerControllerDelegate = DrawerControllerDelegate

@objc(MSFDrawerControllerLegacyDelegate)
public protocol DrawerControllerDelegate: AnyObject {
    /**
     Called when a user resizes the drawer enough to change its expanded state. Use `isExpanded` property to get the current state.

     Use this method to turn on/off specific UI features of your drawer's content that depend on expanded state. Method is called after expanded state has been changed but before animation is completed.
     */
    @objc optional func drawerControllerDidChangeExpandedState(_ controller: DrawerController)

    /// Called when drawer is being dismissed.
    @objc optional func drawerControllerWillDismiss(_ controller: DrawerController)

    /// Called after drawer has been dismissed.
    @objc optional func drawerControllerDidDismiss(_ controller: DrawerController)

    /// Called when drawer is getting dismissed when user tries to dismiss drawer by tapping in background, using resizing handle or dragging drawer to bottom. Use this method to prevent the drawer from being dismissed in these scenarios.
    @objc optional func drawerControllerShouldDismissDrawer(_ controller: DrawerController) -> Bool
}

// MARK: - DrawerController

/**
 `DrawerController` is used to present a portion of UI in a slider frame that shows from a side on iPhone/iPad and in a popover on iPad.

 Use `presentationDirection` to pick the direction of presentation and `presentationOrigin` to specify the offset (in screen coordinates) from which to show drawer. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.

 `DrawerController` will be presented as a popover on iPad (for vertical presentation) and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.

 Set either `contentController` or `contentView` to provide content for the drawer. Desired content size can be specified by using either drawer's or content controller's `preferredContentSize`. If the size is not specified by these means, it will be auto-calculated from the fitting size of the content view.

 Use `resizingBehavior` to allow a user to resize or dismiss the drawer by tapping and dragging any area that does not handle this gesture itself.
 */
@available(*, deprecated, renamed: "DrawerController")
public typealias MSDrawerController = DrawerController

@objc(MSFDrawerController)
open class DrawerController: UIViewController {
    private struct Constants {
        static let resistanceCoefficient: CGFloat = 0.1
        static let resizingThreshold: CGFloat = 30
        static let shadowOffset: CGFloat = 8
    }

    private enum PresentationStyle: Int {
        case slideover
        case popover
    }

    /// Set `backgroundColor` to customize background color of the drawer
    @objc open var backgroundColor: UIColor = Colors.drawerBackground {
        didSet {
            useCustomBackgroundColor = true
            view.backgroundColor = backgroundColor
        }
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
                preconditionFailure("DrawerController: contentController cannot be set while contentView is assigned")
            }

            if let oldContentController = oldValue {
                oldContentController.willMove(toParent: nil)
                oldContentController.view.removeFromSuperview()
                oldContentController.removeFromParent()

            }
            if let contentController = contentController {
                addChild(contentController)
                containerView.addArrangedSubview(contentController.view)
                contentController.didMove(toParent: self)
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
                preconditionFailure("DrawerController: contentView cannot be set while contentController is assigned")
            }

            _contentView?.removeFromSuperview()
            _contentView = newValue
            if let contentView = _contentView {
                containerView.addArrangedSubview(contentView)
            }
        }
    }

    /// Set `contentScrollView` to allow drawer to resize as the result of scrolling in this view (scrolling will be blocked until drawer cannot resize anymore).
    @objc open var contentScrollView: UIScrollView? {
        didSet {
            oldValue?.panGestureRecognizer.removeTarget(self, action: #selector(handleContentPanGesture))
            contentScrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleContentPanGesture))
        }
    }

    /// When `presentationStyle` is `.automatic` (the default value) drawer is presented as a slideover in horizontally compact environments and as a popover otherwise. For horizontal presentation a slideover is always used. Set this property to a specific presentation style to enforce it in all environments.
    @objc open var presentationStyle: DrawerPresentationStyle = .automatic
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

    @objc open var presentationBackground: DrawerPresentationBackground = .black

    /// Use `passThroughView` to make underlying view interactable. This view can be set from presenting view controller to recieve all the touch events from drawer's presentation background.
    @objc open weak var passThroughView: UIView?

    /**
     Set `presentingGesture` before calling `present` to provide a gesture recognizer that resulted in the presentation of the drawer and to allow this presentation to be interactive.

     Only supported for a horizontal presentation direction.
     */
    @objc open var presentingGesture: UIPanGestureRecognizer? {
        didSet {
            if !presentationDirection.isHorizontal {
                presentingGesture = nil
            }
            if presentingGesture == oldValue {
                return
            }
            oldValue?.removeTarget(self, action: #selector(handlePresentingPan))
            presentingGesture?.addTarget(self, action: #selector(handlePresentingPan))
        }
    }

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
    @objc open var resizingBehavior: DrawerResizingBehavior = .none {
        didSet {
            if presentationDirection.isHorizontal && resizingBehavior == .dismissOrExpand {
                resizingBehavior = .dismiss
            }

            // If the drawer is already loaded, update the resizing handle when resizing behaviour is changed.
            if isViewLoaded {
               updateResizingHandleView()
            }
        }
    }

    /// Set `resizingHandleViewBackgroundColor` to customize background color of resizingHandleView if it is shown
    @objc open var resizingHandleViewBackgroundColor: UIColor = .clear {
        didSet {
            resizingHandleView?.backgroundColor = resizingHandleViewBackgroundColor
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
            if isExpanded {
                normalDrawerHeight = isResizing ? originalDrawerHeight : view.frame.height
                normalPreferredContentHeight = super.preferredContentSize.height
            }
            updatePreferredContentSize(isExpanded: isExpanded)

            updateResizingHandleViewAccessibility()
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
            delegate?.drawerControllerDidChangeExpandedState?(self)
        }
    }
    /**
     Set `adjustsHeightForKeyboard` to `true` to allow drawer to adjust its height when keyboard is shown or hidden, so that drawer's content is always visible.

     Supported only when drawer is presented as a slideover with the `.up` presentation direction.
     */
    @objc open var adjustsHeightForKeyboard: Bool = false

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
                        preferredContentSize.height += ResizingHandleView.height
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
            return CGSize(width: UIScreen.main.roundToDevicePixels(preferredContentSize.width), height: UIScreen.main.roundToDevicePixels(preferredContentSize.height))
        }
        set {
            var newValue = newValue
            if isExpanded && !isPreferredContentSizeBeingChangedInternally {
                normalPreferredContentHeight = newValue.height
                newValue.height = preferredContentSize.height
            }

            let needsContentViewFrameUpdate = presentingViewController != nil && preferredContentSize != newValue

            super.preferredContentSize = newValue
            updateContainerViewBottomConstraint()

            if needsContentViewFrameUpdate {
                (presentationController as? DrawerPresentationController)?.updateContentViewFrame(animated: true)
            }
        }
    }

    /// For `vertical` presentation shown when horizontal size is `.compact`, the content width will be the full width of the presenting window. If set to false, the `preferredContentSize.width` will be used for calculation in landscape mode.
    @objc open var shouldUseWindowFullWidthInLandscape: Bool = true

    /// Limits the full window width to its safe area for `vertical` presentation.
    @objc open var shouldRespectSafeAreaForWindowFullWidth: Bool = false

    // Override to provide the preferred size based on specifics of the concrete drawer subclass (see popup menu, for example)
    open var preferredContentWidth: CGFloat { return 0 }
    open var preferredContentHeight: CGFloat { return 0 }
    var tracksContentHeight: Bool {
        guard presentationController is UIPopoverPresentationController || presentationDirection.isVertical else {
            return false
        }
        if isResizing {
            return false
        }
        return super.preferredContentSize.height == 0 && preferredContentHeight == 0 && (contentController?.preferredContentSize.height ?? 0) == 0
    }

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

    @objc public weak var delegate: DrawerControllerDelegate?

    let presentationOrigin: CGFloat?
    let presentationDirection: DrawerPresentationDirection
    let preferredMaximumExpansionHeight: CGFloat

    var sourceObject: Any? {
        return sourceView ?? barButtonItem
    }

    /// Shadow is required if background is transparent
    var shadowOffset: CGFloat {
        return presentationBackground == .none ? Constants.shadowOffset : 0
    }

    private let sourceView: UIView?
    private let sourceRect: CGRect?
    private let barButtonItem: UIBarButtonItem?

    private var isPreferredContentSizeBeingChangedInternally: Bool = false
    private var normalDrawerHeight: CGFloat = 0
    private var normalPreferredContentHeight: CGFloat = -1

    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private var containerViewBottomConstraint: NSLayoutConstraint? {
        didSet {
            updateContainerViewBottomConstraint()
        }
    }

    private var containerViewCenterObservation: NSKeyValueObservation?

    private var useCustomBackgroundColor: Bool = false
    /// for iPad split mode, navigation bar has a different dark elevated color, and if it is a `.down` presentation style, match `Colors.NavigationBar.background` elevated color
    private var useNavigationBarBackgroundColor: Bool = false

    /**
     Initializes `DrawerController` to be presented as a popover from `sourceRect` in `sourceView` on iPad and as a slideover on iPhone/iPad.

     - Parameter sourceView: The view containing the anchor rectangle for the popover.
     - Parameter sourceRect: The rectangle in the specified view in which to anchor the popover.
     - Parameter presentationOrigin: The offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.
     - Parameter presentationDirection: The direction of slideover presentation.
     - Parameter preferredMaximumHeight: The maximum height to which the drawer is preferred to expand
     */
    @objc public init(sourceView: UIView, sourceRect: CGRect, presentationOrigin: CGFloat = -1, presentationDirection: DrawerPresentationDirection, preferredMaximumHeight: CGFloat = -1) {
        self.sourceView = sourceView
        self.sourceRect = sourceRect
        self.barButtonItem = nil
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection
        self.preferredMaximumExpansionHeight = preferredMaximumHeight

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    /**
     Initializes `DrawerController` to be presented as a popover from `barButtonItem` on iPad and as a slideover on iPhone/iPad.

     - Parameter barButtonItem: The bar button item on which to anchor the popover.
     - Parameter presentationOrigin: The offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and edge of the screen for other presentations.
     - Parameter presentationDirection: The direction of slideover presentation.
     */
    @objc public init(barButtonItem: UIBarButtonItem, presentationOrigin: CGFloat = -1, presentationDirection: DrawerPresentationDirection, preferredMaximumHeight: CGFloat = -1) {
        self.sourceView = nil
        self.sourceRect = nil
        self.barButtonItem = barButtonItem
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection
        self.preferredMaximumExpansionHeight = preferredMaximumHeight

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
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
        view.backgroundColor = backgroundColor
        view.layer.cornerCurve = .continuous
        view.isAccessibilityElement = false

        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        // Tracking container size by monitoring its center instead of bounds due to ordering of calls
        containerViewCenterObservation = containerView.observe(\.center) { [unowned self] _, _ in
            if self.tracksContentHeight {
                (self.presentationController as? DrawerPresentationController)?.updateContentViewFrame(animated: true)
                (self.presentationController as? UIPopoverPresentationController)?.preferredContentSizeDidChange(forChildContentContainer: self)
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Configure the resizing handle view according to resizing behaviour and disable the gesture recogniser(if any) till view actually appears
        updateResizingHandleView()
        resizingGestureRecognizer?.isEnabled = false

        // if DrawerController is shown in UIPopoverPresentationController then we want to show different darkElevated color
        if !useCustomBackgroundColor {
            if presentationController is UIPopoverPresentationController {
                backgroundColor = Colors.popoverBackground
            } else if useNavigationBarBackgroundColor {
                backgroundColor = Colors.NavigationBar.background
            } else {
                backgroundColor = Colors.drawerBackground
            }
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resizingGestureRecognizer?.isEnabled = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            resizingGestureRecognizer = nil
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

        // Dismiss the drawer if it has a custom origin, since its coordinates only make sense on a specific frame.
        // No need to dismiss drawers whose origin is fixed (up, down, sides) since they are presented the same for any frame,
        // with one exception handled in the willTransition(to: with:) method.
        if !isBeingPresented && presentationController is DrawerPresentationController && presentationOrigin != nil {
            presentingViewController?.dismiss(animated: false)
        }
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        // Vertical drawers change their presentation style in compact vs. regular split view on iPad, so they need to be dismissed.
        if !isBeingPresented && traitCollection.userInterfaceIdiom == .pad && presentationDirection.isVertical &&
            traitCollection.horizontalSizeClass != newCollection.horizontalSizeClass {
            presentingViewController?.dismiss(animated: false)
        }
    }

    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        updateContainerViewBottomConstraint()
        if presentingViewController != nil {
            (presentationController as? DrawerPresentationController)?.updateContentViewFrame(animated: true)
            (presentationController as? UIPopoverPresentationController)?.preferredContentSizeDidChange(forChildContentContainer: self)
        }
    }

    open override func accessibilityPerformEscape() -> Bool {
        return dismissPresentingViewController(animated: true)
    }

    // Change of presentation direction's orientation is not supported
    private func presentationDirection(for view: UIView) -> DrawerPresentationDirection {
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
            if traitCollection.userInterfaceIdiom == .phone {
                return .slideover
            } else if let window = sourceViewController.view?.window, window.traitCollection.horizontalSizeClass == .compact {
                return .slideover
            }
            return .popover
        } else {
            return .slideover
        }
    }

    private func updateContainerViewBottomConstraint() {
        containerViewBottomConstraint?.isActive = !tracksContentHeight
    }

    private func updatePreferredContentSize(isExpanded: Bool) {
        isPreferredContentSizeBeingChangedInternally = true
        if isExpanded {
            let screenHeight: CGFloat = UIScreen.main.bounds.height
            if preferredMaximumExpansionHeight != -1 &&
                preferredMaximumExpansionHeight < screenHeight &&
                preferredMaximumExpansionHeight >= originalDrawerHeight {
                // Preferred max expansion size is in range [originalDrawerHeight, screenHeight)
                preferredContentSize.height = preferredMaximumExpansionHeight
            } else {
                preferredContentSize.height = screenHeight
            }
        } else {
            preferredContentSize.height = normalPreferredContentHeight
        }
        isPreferredContentSizeBeingChangedInternally = false
    }

    // MARK: Interactive presentation

    private var interactiveTransition: UIPercentDrivenInteractiveTransition? {
        didSet {
            interactiveTransition?.completionCurve = DrawerTransitionAnimator.animationCurve
        }
    }

    @objc private func handlePresentingPan(gesture: UIPanGestureRecognizer) {
        guard let presentedView = presentationController?.presentedView else {
            return
        }

        var offset = gesture.translation(in: gesture.view).x
        if presentationDirection(for: view) == .fromTrailing {
            offset = -offset
        }
        let maxOffset = DrawerTransitionAnimator.sizeChange(forPresentedView: presentedView, presentationDirection: presentationDirection)

        let percent = max(0, min(offset / maxOffset, 1))

        switch gesture.state {
        case .began, .changed:
            interactiveTransition?.update(percent)
        case .ended:
            if percent < 0.5 {
                interactiveTransition?.cancel()
            } else {
                interactiveTransition?.finish()
            }
            interactiveTransition = nil
        case .cancelled:
            interactiveTransition?.cancel()
            interactiveTransition = nil
        default:
            break
        }
    }

    // MARK: Resizing

    private var canResize: Bool {
        return presentationController is DrawerPresentationController && resizingBehavior != .none
    }
    private var showsResizingHandle: Bool {
        return canResize && presentationDirection.isVertical
    }
    private var resizingHandleIsInteractive: Bool {
        return resizingBehavior == .dismissOrExpand || resizingBehavior == .expand
    }

    private var canResizeViaContentScrolling: Bool {
        return canResize && presentationDirection == .up
    }

    private var resizingHandleView: ResizingHandleView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let newView = resizingHandleView {
                initResizingHandleView()
                if presentationDirection == .down {
                    containerView.addArrangedSubview(newView)

                    // Force layout the containerView to avoid unwanted animation of view addition.
                    containerView.layoutIfNeeded()
                } else {
                    containerView.insertArrangedSubview(newView, at: 0)
                }
            }
        }
    }

    private var resizingGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            if let oldRecognizer = oldValue {
                oldRecognizer.view?.removeGestureRecognizer(oldRecognizer)
            }
            if let newRecognizer = resizingGestureRecognizer {
                newRecognizer.delegate = self
                if presentationDirection.isHorizontal {
                    presentationController?.containerView?.addGestureRecognizer(newRecognizer)
                } else {
                    view.addGestureRecognizer(newRecognizer)
                }
            }
        }
    }

    private var isResizing: Bool = false {
        didSet {
            updateContainerViewBottomConstraint()
        }
    }

    private var originalContentOffsetY: CGFloat?
    private var originalDrawerOffsetY: CGFloat = 0
    private var originalDrawerHeight: CGFloat = 0
    private var originalShowsContentScrollIndicator: Bool = true

    private func initResizingHandleView() {
        if resizingHandleIsInteractive {
            resizingHandleView?.isUserInteractionEnabled = true
            resizingHandleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResizingHandleViewTap)))
        }
        updateResizingHandleViewAccessibility()
    }

    private func updateResizingHandleView() {
        if canResize {
           if showsResizingHandle {
               if resizingHandleView == nil {
                   resizingHandleView = ResizingHandleView()
                   resizingHandleView?.backgroundColor = resizingHandleViewBackgroundColor
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
    }

    private func updateResizingHandleViewAccessibility() {
        resizingHandleView?.isAccessibilityElement = resizingHandleIsInteractive
        resizingHandleView?.accessibilityTraits = .button
        if isExpanded {
            resizingHandleView?.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Collapse".localized
            resizingHandleView?.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Collapse".localized
        } else {
            resizingHandleView?.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Expand".localized
            resizingHandleView?.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Expand".localized
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

        let mayResizeViaContentScrolling = canResizeViaContentScrolling && contentScrollView?.isDragging == true
        if resizingBehavior == .dismiss {
            if presentationDirection == .up && gesture.state == .changed && offset > 0 && !mayResizeViaContentScrolling {
                offset = offsetWithResistance(for: offset)
            } else {
                offset = min(offset, 0)
            }
        }

        // This resizingBehavior(expand) avoid the user to dismiss the drawer
        if resizingBehavior == .expand {
            // This is to avoid drawer to get dismissed when user drag the drawer from expanded state to normal state
            if isExpanded {
                offset = max(offset, -(originalDrawerHeight - normalDrawerHeight))
            }

            // This is to restrict dismiss behaviour of drawer
            if !isExpanded && offset < 0 && !mayResizeViaContentScrolling {
                offset = presentationDirection == .up ? offsetWithResistance(for: offset) : 0
            }
        }

        if mayResizeViaContentScrolling && offset < 0, let originalContentOffsetY = originalContentOffsetY {
            offset = min(offset + originalContentOffsetY, 0)
        }

        // Rounding to precision used for layout
        return UIScreen.main.roundToDevicePixels(offset)
    }

    private func offsetWithResistance(for offset: CGFloat) -> CGFloat {
        return Constants.resistanceCoefficient * offset
    }

    private func initOriginalContentOffsetYIfNeeded() {
        guard originalContentOffsetY == nil, let contentScrollView = contentScrollView else {
            return
        }
        // Remove over-scroll at the top so that scroll view does not get stuck in a weird state during drawer resizing
        contentScrollView.contentOffset.y = max(-contentScrollView.contentInset.top, contentScrollView.contentOffset.y)
        originalContentOffsetY = contentScrollView.contentOffset.y
    }

    /// To disimiss presentingViewController
    /// - Parameters:
    ///   - animated: dimiss should happen with animation or not
    ///   - isResizing: flag indicating wheter dismiss is being called due to user resizing the drawer, default is false
    /// - Returns: whether drawer got dismissed or not
    @discardableResult
    private func dismissPresentingViewController(animated: Bool, isResizing: Bool = false) -> Bool {
        if delegate?.drawerControllerShouldDismissDrawer?(self) ?? true {
            presentingViewController?.dismiss(animated: animated)
            return true
        } else if isResizing {
            guard let presentationController = presentationController as? DrawerPresentationController else {
                preconditionFailure("DrawerController cannot handle resizing without DrawerPresentationController")
            }
            presentationController.setExtraContentSize(0, updatingLayout: true, animated: animated)
        }
        return false
    }

    @objc private func handleResizingGesture(gesture: UIPanGestureRecognizer) {
        guard let presentationController = presentationController as? DrawerPresentationController else {
            preconditionFailure("DrawerController cannot handle resizing without DrawerPresentationController")
        }

        var offset = self.offset(forResizingGesture: gesture)

        switch gesture.state {
        case .began, .changed:
            if gesture.state == .began {
                isResizing = true
                presentationController.extraContentSizeEffectWhenCollapsing = isExpanded ? .resize : .move
                originalDrawerOffsetY = view.convert(view.bounds.origin, to: nil).y
                originalDrawerHeight = view.frame.height
                initOriginalContentOffsetYIfNeeded()
            }
            if isExpanded {
                let extraContentSizeEffect: DrawerPresentationController.ExtraContentSizeEffect = originalDrawerHeight + offset <= normalDrawerHeight ? .move : .resize
                if extraContentSizeEffect == .move {
                    offset += originalDrawerHeight - normalDrawerHeight
                }
                if presentationController.extraContentSizeEffectWhenCollapsing != extraContentSizeEffect {
                    presentationController.extraContentSizeEffectWhenCollapsing = extraContentSizeEffect
                    // When switching to .move, view has to pick up safe area insets and this requires it to be aligned with the screen edge and so offset has to be 0 at this point
                    presentationController.setExtraContentSize(extraContentSizeEffect == .move ? 0 : offset, updatingLayout: false)
                    updatePreferredContentSize(isExpanded: extraContentSizeEffect == .resize)
                }
            }
            presentationController.setExtraContentSize(offset)
        case .ended:
            if offset >= Constants.resizingThreshold {
                if isExpanded {
                    presentationController.setExtraContentSize(0, animated: true)
                } else {
                    presentationController.setExtraContentSize(0, updatingLayout: false)
                    isExpanded = true
                }
            } else if offset <= -Constants.resizingThreshold {
                if isExpanded {
                    if originalDrawerHeight + offset <= normalDrawerHeight - Constants.resizingThreshold {
                        dismissPresentingViewController(animated: true, isResizing: true)
                    } else {
                        presentationController.setExtraContentSize(0, updatingLayout: false)
                    }
                    isExpanded = false
                } else {
                    dismissPresentingViewController(animated: true, isResizing: true)
                }
            } else {
                presentationController.setExtraContentSize(0, animated: true)
            }
            isResizing = false
        case .cancelled:
            presentationController.setExtraContentSize(0, animated: true)
            isResizing = false
        default:
            break
        }
    }

    @objc private func handleContentPanGesture(gesture: UIPanGestureRecognizer) {
        guard let contentScrollView = contentScrollView else {
            preconditionFailure("DrawerController cannot handle content panning without contentScrollView")
        }
        if !canResizeViaContentScrolling {
            return
        }
        switch gesture.state {
        case .began, .changed:
            if gesture.state == .began {
                if let originalContentOffsetY = originalContentOffsetY {
                    // Reset offset to the initial value before UIScrollView's gesture processing
                    contentScrollView.contentOffset.y = originalContentOffsetY
                } else {
                    initOriginalContentOffsetYIfNeeded()
                }
                originalShowsContentScrollIndicator = contentScrollView.showsVerticalScrollIndicator
            }

            if contentScrollView.scrollLocationDescriptor != .excessivelyBeyondContent, let originalContentOffsetY = originalContentOffsetY {
                let drawerOffsetY = view.convert(view.bounds.origin, to: nil).y
                let drawerOffsetChange = drawerOffsetY - originalDrawerOffsetY
                let contentOffsetChange = -(gesture.translation(in: contentScrollView).y - drawerOffsetChange)
                contentScrollView.contentOffset.y = originalContentOffsetY + contentOffsetChange
            }

            let offsetFromZero = contentScrollView.contentOffset.y + contentScrollView.contentInset.top
            contentScrollView.showsVerticalScrollIndicator = originalShowsContentScrollIndicator && offsetFromZero != 0
        case .ended, .cancelled:
            contentScrollView.showsVerticalScrollIndicator = originalShowsContentScrollIndicator
            originalContentOffsetY = nil
        default:
            break
        }
    }

    @objc private func handleResizingHandleViewTap() {
        isExpanded = !isExpanded
    }
}

// MARK: - DrawerController: UIViewControllerTransitioningDelegate

extension DrawerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presentationStyle(for: source) == .slideover && UIView.areAnimationsEnabled {
            return DrawerTransitionAnimator(presenting: true, presentationDirection: presentationDirection(for: source.view), containerOffset: shadowOffset)
        }
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let controller = dismissed.presentationController as? DrawerPresentationController, UIView.areAnimationsEnabled {
            return DrawerTransitionAnimator(presenting: false, presentationDirection: controller.presentationDirection, containerOffset: shadowOffset)
        }
        return nil
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let gesture = presentingGesture, gesture.state == .began || gesture.state == .changed else {
            return nil
        }
        interactiveTransition = UIPercentDrivenInteractiveTransition()
        return interactiveTransition
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presentationStyle(for: source) {
        case .slideover:
            let direction = presentationDirection(for: source.view)

            useNavigationBarBackgroundColor = (direction.isVertical && source.traitCollection.userInterfaceLevel == .elevated)

            let drawerPresentationController = DrawerPresentationController(presentedViewController: presented,
                                                presentingViewController: presenting,
                                                source: source,
                                                presentationDirection: direction,
                                                adjustHeightForKeyboard: adjustsHeightForKeyboard)
            drawerPresentationController.drawerPresentationControllerDelegate = self
            return drawerPresentationController
        case .popover:
            let presentationController = UIPopoverPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.backgroundColor = backgroundColor
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
                preconditionFailure("A UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs.")
            }

            return presentationController
        }
    }
}

// MARK: - DrawerController: UIPopoverPresentationControllerDelegate

extension DrawerController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return dismissPresentingViewController(animated: true)
    }
}

// MARK: - DrawerController: UIGestureRecognizerDelegate

extension DrawerController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == resizingGestureRecognizer && otherGestureRecognizer == contentScrollView?.panGestureRecognizer
    }
}

// MARK: - DrawerController: DrawerPresentationDelegate

extension DrawerController: DrawerPresentationControllerDelegate {
    func drawerPresentationControllerDismissalRequested(_ presentationControler: DrawerPresentationController) {
        dismissPresentingViewController(animated: true)
    }
}
