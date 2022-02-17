//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFBottomSheetControllerDelegate)
public protocol BottomSheetControllerDelegate: AnyObject {

    /// Called after a transition to a new expansion state completes.
    ///
    /// External changes to`isExpanded` or `isHidden` will not trigger this callback.
    /// - Parameters:
    ///   - bottomSheetController: The caller object.
    ///   - expansionState: The expansion state that the sheet moved to.
    ///   - interaction: The user interaction that caused the state change.
    @objc optional func bottomSheetController(_ bottomSheetController: BottomSheetController,
                                              didMoveTo expansionState: BottomSheetExpansionState,
                                              interaction: BottomSheetInteraction)

    /// Called when `collapsedHeightInSafeArea` changes.
    @objc optional func bottomSheetControllerCollapsedHeightInSafeAreaDidChange(_ bottomSheetController: BottomSheetController)
}

/// Interactions that can trigger a state change.
@objc public enum BottomSheetInteraction: Int {
    case noUserAction // No user action, used for events not triggered by users
    case swipe // Swipe on the sheet view
    case resizingHandleTap // Tap on the sheet resizing handle
    case dimmingViewTap // Tap on the dimming view
}

/// Defines the position the sheet is currently in
@objc public enum BottomSheetExpansionState: Int {
    case expanded // Sheet is fully expanded
    case collapsed // Sheet is collapsed
    case hidden // Sheet is hidden (fully off-screen)
    case transitioning // Sheet is between states, only used during user interaction / animation

    // Target alpha of related views like the sheet content or dimming view.
    var relatedViewAlpha: CGFloat { self == .expanded ? 1.0 : 0.0 }
}

@objc(MSFBottomSheetController)
public class BottomSheetController: UIViewController {

    /// Initializes the bottom sheet controller
    /// - Parameters:
    ///   - headerContentView: Top part of the sheet content that is visible in both collapsed and expanded state.
    ///   - expandedContentView: Sheet content below the header which is only visible when the sheet is expanded.
    ///   - shouldShowDimmingView: Indicates if the main content is dimmed when the sheet is expanded.
    @objc public init(headerContentView: UIView? = nil,
                      expandedContentView: UIView,
                      shouldShowDimmingView: Bool = true,
                      usesIntegratedPresentation: Bool = false) {
        self.headerContentView = headerContentView
        self.expandedContentView = expandedContentView
        self.shouldShowDimmingView = shouldShowDimmingView
        self.usesIntegratedPresentation = usesIntegratedPresentation
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Top part of the sheet content that is visible in both collapsed and expanded state.
    @objc public let headerContentView: UIView?

    /// Sheet content below the header which is only visible when the sheet is expanded.
    @objc public let expandedContentView: UIView

    /// A scroll view in `expandedContentView`'s view hierarchy.
    /// Provide this to ensure the bottom sheet pan gesture recognizer coordinates with the scroll view to enable scrolling based on current bottom sheet position and content offset.
    @objc open var hostedScrollView: UIScrollView?

    /// Indicates if the bottom sheet is expandable.
    @objc open var isExpandable: Bool = true {
        didSet {
            if isExpandable != oldValue {
                resizingHandleView.isHidden = !isExpandable
                panGestureRecognizer.isEnabled = isExpandable
                if isViewLoaded {
                    move(to: .collapsed, animated: false)
                    recalculateSheetFrame()
                }
            }
        }
    }

    /// Indicates if the bottom sheet view is hidden.
    ///
    /// Changes to this property are animated. When hiding, new value is reflected after the animation completes.
    @objc open var isHidden: Bool {
        get {
            return bottomSheetView.isHidden
        }
        set {
            setIsHidden(newValue)
        }
    }

    /// Indicates if the sheet height is flexible.
    ///
    /// When set to `false`, the sheet height is static and always corresponds to the height of the maximum expansion state.
    /// Interacting with the sheet will only vertically translate it, moving it partially on/off-screen.
    ///
    /// When set to `true`, moving the sheet beyond the `.collapsed` state will resize it.
    ///
    /// Use flexible height if you have views attached to the bottom of `expandedContentView` that should always be visible.
    @objc open var isFlexibleHeight: Bool = false {
        didSet {
            guard isViewLoaded else {
                return
            }
            recalculateSheetFrame()
        }
    }

    /// Height of `headerContentView`.
    ///
    /// Setting this is required when the `headerContentView` is non-nil.
    @objc open var headerContentHeight: CGFloat = 0 {
        didSet {
            guard headerContentHeight != oldValue && isViewLoaded else {
                return
            }
            completeAnimationsIfNeeded(skipToEnd: true)
            headerContentViewHeightConstraint?.constant = headerContentHeight
        }
    }

    /// Preferred height of `expandedContentView`.
    ///
    /// The default value is 0, which results in a full screen sheet expansion.
    @objc open var preferredExpandedContentHeight: CGFloat = 0 {
        didSet {
            guard preferredExpandedContentHeight != oldValue && isViewLoaded else {
                return
            }
            completeAnimationsIfNeeded(skipToEnd: true)
            recalculateSheetFrame()
        }
    }

    /// A string to optionally customize the accessibility label of the bottom sheet handle.
    /// The message should convey the "Expand" action and will be used when the bottom sheet is collapsed.
    @objc public var handleExpandCustomAccessibilityLabel: String? {
        didSet {
            updateResizingHandleViewAccessibility()
        }
    }

    /// A string to optionally customize the accessibility label of the bottom sheet handle.
    /// The message should convey the "Collapse" action and will be used when the bottom sheet is expanded.
    @objc public var handleCollapseCustomAccessibilityLabel: String? {
        didSet {
            updateResizingHandleViewAccessibility()
        }
    }

    /// Indicates if the bottom sheet is expanded.
    ///
    /// Changes to this property are animated. A new value is reflected in the getter only after the animation completes.
    @objc open var isExpanded: Bool {
        get {
            return currentExpansionState == .expanded
        }
        set {
            setIsExpanded(newValue)
        }
    }

    /// Height of the top portion of the content view that should be visible when the bottom sheet is collapsed.
    ///
    /// When set to 0, `headerContentHeight` will be used.
    @objc open var collapsedContentHeight: CGFloat = 0 {
        didSet {
            guard collapsedContentHeight != oldValue && isViewLoaded else {
                return
            }
            completeAnimationsIfNeeded(skipToEnd: true)
            recalculateSheetFrame()
        }
    }

    /// Indicates if the content should be hidden when the sheet is collapsed
    @objc open var shouldHideCollapsedContent: Bool = true {
        didSet {
            guard shouldHideCollapsedContent != oldValue && isViewLoaded else {
                return
            }
            recalculateSheetFrame()
        }
    }

    /// Indicates if the sheet should always fill the available width. The default value is true.
    @objc open var shouldAlwaysFillWidth: Bool = true {
        didSet {
            guard shouldAlwaysFillWidth != oldValue && isViewLoaded else {
                return
            }
            recalculateSheetFrame()
        }
    }

    /// Current height of the portion of a collapsed sheet that's in the safe area.
    @objc public private(set) var collapsedHeightInSafeArea: CGFloat = 0 {
        didSet {
            guard collapsedHeightInSafeArea != oldValue else {
                return
            }
            delegate?.bottomSheetControllerCollapsedHeightInSafeAreaDidChange?(self)
        }
    }

    /// A layout guide that covers the on-screen portion of the sheet view.
    @objc public let sheetLayoutGuide = UILayoutGuide()

    /// The object that acts as the delegate of the bottom sheet.
    @objc open weak var delegate: BottomSheetControllerDelegate?

    /// Height of the resizing handle
    @objc public static var resizingHandleHeight: CGFloat {
        return ResizingHandleView.height
    }

    // MARK: - Integrated presentation

    public func addBottomSheetView(to hostView: UIView) {
        precondition(usesIntegratedPresentation, "addBottomSheetView should only be used when integrated presentation is enabled")

        self.hostView = hostView
        hostView.addSubview(view)

        recalculateSheetFrame()
        NSLayoutConstraint.activate(makeLayoutGuideConstraints())
    }

    public func removeBottomSheetFromHostView() {
        precondition(usesIntegratedPresentation, "removeBottomSheetFromHostView should only be used when integrated presentation is enabled")

        view.removeFromSuperview()
        hostView = nil
    }

    public let usesIntegratedPresentation: Bool

    // MARK: - Parametrized setters

    /// Sets the `isExpanded` property with a completion handler.
    /// - Parameters:
    ///   - isExpanded: The new value.
    ///   - animated: Indicates if the change should be animated. The default value is `true`.
    ///   - completion: Closure to be called when the state change completes.
    @objc public func setIsExpanded(_ isExpanded: Bool, animated: Bool = true, completion: ((_ isFinished: Bool) -> Void)? = nil) {
        guard isExpanded != self.isExpanded, !isHiddenOrHiding, isExpandable else {
            return
        }

        let targetExpansionState: BottomSheetExpansionState = isExpanded ? .expanded : .collapsed
        if isViewLoaded {
            move(to: targetExpansionState, animated: animated, shouldNotifyDelegate: false) { finalPosition in
                completion?(finalPosition == .end)
            }
        } else {
            currentExpansionState = targetExpansionState
            completion?(true)
        }
    }

    /// Changes the `isHidden` state with a completion handler.
    /// - Parameters:
    ///   - isHidden: The new value.
    ///   - animated: Indicates if the change should be animated. The default value is `true`.
    ///   - completion: Closure to be called when the state change completes.
    @objc public func setIsHidden(_ isHidden: Bool, animated: Bool = true, completion: ((_ isFinished: Bool) -> Void)? = nil) {
        let targetState: BottomSheetExpansionState = isHidden ? .hidden : .collapsed
        if isViewLoaded {
            move(to: targetState, animated: animated, allowUnhiding: true) { finalPosition in
                completion?(finalPosition == .end)
            }
        } else {
            currentExpansionState = targetState
            completion?(true)
        }
    }

    /// Initiates an interactive `isHidden` state change driven by the returned `UIViewPropertyAnimator`.
    ///
    /// The returned animator comes preloaded with all the animations required to reach the target `isHidden` state.
    ///
    /// You can modify the `fractionComplete` property of the animator to interactively drive the animation in the paused state.
    /// You can also change the `isReversed` property to swap the start and target `isHidden` states.
    ///
    /// When you are done driving the animation interactively, you must call `startAnimation` on the animator to let the animation resume
    /// from the current value of `fractionComplete`.
    /// - Parameters:
    ///   - isHidden: The target state.
    ///   - completion: Closure to be called when the state change completes.
    /// - Returns: A `UIViewPropertyAnimator`. The associated animations start in a paused state.
    @objc public func prepareInteractiveIsHiddenChange(_ isHidden: Bool, completion: ((_ finalPosition: UIViewAnimatingPosition) -> Void)? = nil) -> UIViewPropertyAnimator? {
        guard isViewLoaded else {
            return nil
        }

        completeAnimationsIfNeeded(skipToEnd: true)

        var animator: UIViewPropertyAnimator?
        if isHidden != self.isHidden {
            let initialState: BottomSheetExpansionState = isHidden ? .collapsed : .hidden
            let targetState: BottomSheetExpansionState = isHidden ? .hidden : .collapsed

            move(to: initialState, animated: false, allowUnhiding: true)
            animator = stateChangeAnimator(to: targetState)

            currentStateChangeAnimator = animator
            animator?.addCompletion { [weak self] finalPosition in
                self?.currentStateChangeAnimator = nil
                completion?(finalPosition)
            }
        }

        return animator
    }

    // MARK: - View loading

    // View hierarchy
    // self.view - BottomSheetPassthroughView (full overlay area)
    // |--dimmingView (spans self.view)
    // |--bottomSheetView (sheet shadow)
    // |  |--UIStackView (round corner mask)
    // |  |  |--resizingHandleView
    // |  |  |--headerContentView
    // |  |  |--expandedContentView
    // |--overflowView
    public override func loadView() {
        var constraints = [NSLayoutConstraint]()

        if usesIntegratedPresentation {
            view = bottomSheetView
        } else {
            view = BottomSheetPassthroughView()
            view.translatesAutoresizingMaskIntoConstraints = false

            hostView = view
            view.addSubview(bottomSheetView)
            constraints.append(contentsOf: makeLayoutGuideConstraints())
        }

        view.addLayoutGuide(sheetLayoutGuide)

        bottomSheetView.isHidden = currentExpansionState == .hidden

        // The non-zero frame here ensures the layout engine won't complain if it tries to calculate
        // sheet content layout before view.bounds is set to a non-zero rect.
        // We will set the sheet frame to a more meaningful rect after the first layout pass.
        bottomSheetView.frame = CGRect(x: 0, y: 0, width: Constants.minSheetWidth, height: expandedSheetHeight)

        let overflowView = UIView()
        overflowView.translatesAutoresizingMaskIntoConstraints = false
        overflowView.backgroundColor = Colors.NavigationBar.background
        bottomSheetView.addSubview(overflowView)

        if let headerContentView = headerContentView {
            let heightConstraint = headerContentView.heightAnchor.constraint(equalToConstant: headerContentHeight)
            constraints.append(heightConstraint)
            headerContentViewHeightConstraint = heightConstraint
        }

        constraints.append(contentsOf: [
            overflowView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            overflowView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            overflowView.heightAnchor.constraint(equalToConstant: Constants.Spring.overflowHeight),
            overflowView.topAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])

        NSLayoutConstraint.activate(constraints)
    }

    private lazy var dimmingView: DimmingView = {
        var dimmingView = DimmingView(type: .black)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.alpha = 0.0

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        dimmingView.addGestureRecognizer(tapGesture)
        return dimmingView
    }()

    private lazy var resizingHandleView: ResizingHandleView = {
        let resizingHandleView = ResizingHandleView()
        resizingHandleView.isAccessibilityElement = true
        resizingHandleView.accessibilityTraits = .button
        resizingHandleView.isUserInteractionEnabled = true
        resizingHandleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResizingHandleViewTap)))
        return resizingHandleView
    }()

    private lazy var bottomSheetView: UIView = {
        let bottomSheetContentView = UIView()
        bottomSheetContentView.translatesAutoresizingMaskIntoConstraints = false

        bottomSheetContentView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self

        let stackView = UIStackView(arrangedSubviews: [resizingHandleView])
        stackView.spacing = 0.0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if let headerView = headerContentView {
            stackView.addArrangedSubview(headerView)
        }

        stackView.addArrangedSubview(expandedContentView)
        bottomSheetContentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bottomSheetContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: bottomSheetContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: bottomSheetContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomSheetContentView.bottomAnchor)
        ])

        return makeBottomSheetByEmbedding(contentView: bottomSheetContentView)
    }()

    private func makeBottomSheetByEmbedding(contentView: UIView) -> UIView {
        let bottomSheetView = UIView()

        // We need to have the shadow on a parent of the view that does the corner masking.
        // Otherwise the view will mask its own shadow.
        bottomSheetView.layer.shadowColor = Constants.Shadow.color
        bottomSheetView.layer.shadowOffset = Constants.Shadow.offset
        bottomSheetView.layer.shadowOpacity = Constants.Shadow.opacity
        bottomSheetView.layer.shadowRadius = Constants.Shadow.radius

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.NavigationBar.background
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.cornerCurve = .continuous
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.clipsToBounds = true

        bottomSheetView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])

        return bottomSheetView
    }

    public override func viewDidLayoutSubviews() {
        guard hostView == view else {
            return
        }

        recalculateSheetFrame()
    }

    public override func viewSafeAreaInsetsDidChange() {
        recalculateSheetFrame()
    }

    public func recalculateSheetFrame() {
        guard let hostView = hostView else {
            return
        }

        // In the transitioning state a pan gesture or an animator temporarily owns the sheet frame updates,
        // so to avoid interfering we won't update the frame here.
        if currentExpansionState != .transitioning {
            let newFrame = sheetFrame(offset: offset(for: currentExpansionState))
            if newFrame != bottomSheetView.frame {
                bottomSheetView.frame = newFrame
                updateSheetLayoutGuideTopConstraint()
                updateExpandedContentAlpha()
                updateDimmingViewAlpha()
            }
        }
        collapsedHeightInSafeArea = hostView.safeAreaLayoutGuide.layoutFrame.maxY - offset(for: .collapsed)
    }

    public func hostViewBoundsDidChange() {
        recalculateSheetFrame()
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if size.height != view.frame.height && currentExpansionState == .transitioning {
            // The view is resizing and we can't guarantee the animation target frame is valid anymore.
            // Completing the animation ensures the sheet will be correctly positioned on the next layout pass
            completeAnimationsIfNeeded(skipToEnd: true)

            if panGestureRecognizer.state != .possible {
                panGestureRecognizer.state = .cancelled
            }
        }
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        completeAnimationsIfNeeded(skipToEnd: true)
    }

    // MARK: - Gesture handling

    @objc private func handleDimmingViewTap(_ sender: UITapGestureRecognizer) {
        move(to: .collapsed, interaction: .dimmingViewTap)
    }

    @objc private func handleResizingHandleViewTap(_ sender: UITapGestureRecognizer) {
        move(to: isExpanded ? .collapsed : .expanded, interaction: .resizingHandleTap)
    }

    private func updateResizingHandleViewAccessibility() {
        if currentExpansionState == .expanded {
            resizingHandleView.accessibilityLabel = handleCollapseCustomAccessibilityLabel ?? "Accessibility.Drawer.ResizingHandle.Label.Collapse".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Collapse".localized
        } else {
            resizingHandleView.accessibilityLabel = handleExpandCustomAccessibilityLabel ?? "Accessibility.Drawer.ResizingHandle.Label.Expand".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Expand".localized
        }
    }

    private func updateExpandedContentAlpha() {
        let transitionLength = Constants.expandedContentAlphaTransitionLength
        let currentOffset = currentSheetVerticalOffset
        let collapsedOffset = offset(for: .collapsed)

        var targetAlpha: CGFloat = 1.0
        if shouldHideCollapsedContent {
            if currentOffset >= collapsedOffset {
                targetAlpha = 0.0
            } else if currentOffset < collapsedOffset && currentOffset > collapsedOffset - transitionLength {
                targetAlpha = abs(currentOffset - collapsedOffset) / transitionLength
            }
        }
        expandedContentView.alpha = targetAlpha
    }

    private func updateDimmingViewAlpha() {
        guard shouldShowDimmingView else {
            return
        }

        var targetAlpha: CGFloat = 0.0
        if isExpandable {
            let currentOffset = currentSheetVerticalOffset
            let collapsedOffset = offset(for: .collapsed)
            let expandedOffset = offset(for: .expanded)

            if currentOffset <= expandedOffset {
                targetAlpha = 1.0
            } else if currentOffset >= collapsedOffset {
                targetAlpha = 0.0
            } else {
                targetAlpha = abs(currentOffset - collapsedOffset) / (collapsedOffset - expandedOffset)
            }
        }

        dimmingView.alpha = targetAlpha
        ensureDimmingViewPresentIfNeeded()
    }

    private func ensureDimmingViewPresentIfNeeded() {
        if dimmingView.alpha == 0.0 || !shouldShowDimmingView {
            dimmingView.removeFromSuperview()
        } else if let hostView = hostView, dimmingView.superview != hostView {
            hostView.insertSubview(dimmingView, belowSubview: bottomSheetView)
            NSLayoutConstraint.activate([
                dimmingView.leadingAnchor.constraint(equalTo: hostView.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: hostView.trailingAnchor),
                dimmingView.topAnchor.constraint(equalTo: hostView.topAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: hostView.bottomAnchor)
            ])
        }
    }

    private func updateSheetLayoutGuideTopConstraint() {
        guard let sheetLayoutGuideTopConstraint = sheetLayoutGuideTopConstraint else {
            return
        }

        if sheetLayoutGuideTopConstraint.constant != currentSheetVerticalOffset {
            sheetLayoutGuideTopConstraint.constant = currentSheetVerticalOffset
        }
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            completeAnimationsIfNeeded()
            currentExpansionState = .transitioning
            fallthrough
        case .changed:
            translateSheet(by: sender.translation(in: view))
            sender.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            completePan(with: sender.velocity(in: view).y)
        default:
            break
        }
    }

    private func translateSheet(by translationDelta: CGPoint) {
        let expandedOffset = offset(for: .expanded)
        let collapsedOffset = offset(for: .collapsed)
        let minOffset = expandedOffset - Constants.maxRubberBandOffset
        let maxOffset = collapsedOffset + Constants.maxRubberBandOffset

        var offsetDelta = translationDelta.y
        if currentSheetVerticalOffset >= collapsedOffset || currentSheetVerticalOffset <= expandedOffset {
            offsetDelta *= translationRubberBandFactor(for: currentSheetVerticalOffset)
        }

        let targetOffset = min(max(bottomSheetView.frame.origin.y + offsetDelta, minOffset), maxOffset)
        bottomSheetView.frame = sheetFrame(offset: targetOffset)

        updateSheetLayoutGuideTopConstraint()
        updateExpandedContentAlpha()
        updateDimmingViewAlpha()
    }

    // Source of truth for the sheet frame at a given offset from the top of the host view bounds.
    // The output is only meaningful once view.bounds is non-zero i.e. a layout pass has occured.
    private func sheetFrame(offset: CGFloat) -> CGRect {
        let hostViewBounds = hostView?.bounds ?? .zero
        let availableWidth: CGFloat = hostViewBounds.width
        let sheetWidth = shouldAlwaysFillWidth ? availableWidth : min(Constants.maxSheetWidth, availableWidth)
        let sheetHeight: CGFloat

        if isFlexibleHeight {
            let minSheetHeight = collapsedSheetHeight
            sheetHeight = max(minSheetHeight, hostViewBounds.maxY - offset)
        } else {
            sheetHeight = expandedSheetHeight
        }

        return CGRect(origin: CGPoint(x: (hostViewBounds.width - sheetWidth) / 2, y: offset),
                      size: CGSize(width: sheetWidth, height: sheetHeight))
    }

    private func translationRubberBandFactor(for currentOffset: CGFloat) -> CGFloat {
        let offLimitsOffset: CGFloat
        let expandedOffset = offset(for: .expanded)
        let collapsedOffset = offset(for: .collapsed)

        if currentOffset < expandedOffset {
            offLimitsOffset = min(expandedOffset - currentOffset, Constants.maxRubberBandOffset)
        } else if currentOffset > collapsedOffset {
            offLimitsOffset = min(currentOffset - collapsedOffset, Constants.maxRubberBandOffset)
        } else {
            offLimitsOffset = 0.0
        }

        return max(1.0 - offLimitsOffset / Constants.maxRubberBandOffset, Constants.minRubberBandScaleFactor)
    }

    // MARK: - Animations

    private func completePan(with velocity: CGFloat) {
        var targetState: BottomSheetExpansionState
        if abs(velocity) < Constants.directionOverrideVelocityThreshold {
            // Velocity too low, snap to the closest offset
            targetState =
                abs(offset(for: .collapsed) - currentSheetVerticalOffset) < abs(offset(for: .expanded) - currentSheetVerticalOffset)
                ? .collapsed
                : .expanded
        } else {
            // Velocity high enough, animate to the offset we're swiping towards
            targetState = velocity > 0 ? .collapsed : .expanded
        }
        move(to: targetState, velocity: velocity, interaction: .swipe)
    }

    private func move(to targetExpansionState: BottomSheetExpansionState,
                      animated: Bool = true,
                      velocity: CGFloat = 0.0,
                      interaction: BottomSheetInteraction = .noUserAction,
                      shouldNotifyDelegate: Bool = true,
                      allowUnhiding: Bool = false,
                      completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        guard targetExpansionState == .hidden || !isHiddenOrHiding || allowUnhiding else {
            return
        }

        completeAnimationsIfNeeded()

        if currentSheetVerticalOffset != offset(for: targetExpansionState) {
            let animator = stateChangeAnimator(to: targetExpansionState,
                                               velocity: velocity,
                                               interaction: interaction,
                                               shouldNotifyDelegate: shouldNotifyDelegate)
            animator.addCompletion({ finalPosition in
                completion?(finalPosition)
            })

            if animated {
                currentStateChangeAnimator = animator
                animator.addCompletion { [weak self] _ in
                    self?.currentStateChangeAnimator = nil
                }
                animator.startAnimation()
            } else {
                animator.stopAnimation(false)
                animator.finishAnimation(at: .end)
            }
        } else {
            handleCompletedStateChange(to: targetExpansionState, interaction: interaction, shouldNotifyDelegate: shouldNotifyDelegate)
        }
    }

    private func stateChangeAnimator(to targetExpansionState: BottomSheetExpansionState,
                                     velocity: CGFloat = 0.0,
                                     interaction: BottomSheetInteraction = .noUserAction,
                                     shouldNotifyDelegate: Bool = true) -> UIViewPropertyAnimator {
        let targetVerticalOffset = offset(for: targetExpansionState)
        let distanceToGo = abs(currentSheetVerticalOffset - targetVerticalOffset)
        let springVelocity = min(abs(velocity / distanceToGo), Constants.Spring.maxInitialVelocity)
        let damping: CGFloat = abs(velocity) > Constants.Spring.flickVelocityThreshold
            ? Constants.Spring.oscillatingDampingRatio
            : Constants.Spring.defaultDampingRatio

        let springParams = UISpringTimingParameters(dampingRatio: damping,
                                                    initialVelocity: CGVector(dx: springVelocity, dy: springVelocity))
        let translationAnimator = UIViewPropertyAnimator(duration: Constants.Spring.animationDuration, timingParameters: springParams)

        self.targetExpansionState = targetExpansionState

        // Disable dragging while hiding the sheet
        if targetExpansionState == .hidden {
            panGestureRecognizer.isEnabled = false
        }

        // Animation might be reversed, so we need to remember the original state
        let originalExpansionState = currentExpansionState

        bottomSheetView.isHidden = false
        translationAnimator.addAnimations { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomSheetView.frame = strongSelf.sheetFrame(offset: targetVerticalOffset)
            strongSelf.sheetLayoutGuideTopConstraint?.constant = targetVerticalOffset
            strongSelf.view.layoutIfNeeded()
        }

        let targetRelatedViewAlpha = targetExpansionState.relatedViewAlpha
        if shouldHideCollapsedContent && expandedContentView.alpha != targetRelatedViewAlpha {
            translationAnimator.addAnimations {
                self.expandedContentView.alpha = targetRelatedViewAlpha
            }
        }

        if shouldShowDimmingView && dimmingView.alpha != targetRelatedViewAlpha {
            translationAnimator.addAnimations {
                self.dimmingView.alpha = targetRelatedViewAlpha
            }
        }

        translationAnimator.addCompletion({ [weak self] finalPosition in
            guard let strongSelf = self else {
                return
            }
            strongSelf.targetExpansionState = nil
            strongSelf.panGestureRecognizer.isEnabled = strongSelf.isExpandable
            strongSelf.handleCompletedStateChange(to: finalPosition == .start ? originalExpansionState : targetExpansionState,
                                                  interaction: interaction,
                                                  shouldNotifyDelegate: shouldNotifyDelegate && finalPosition != .current)
        })

        hostView?.layoutIfNeeded()
        currentExpansionState = .transitioning
        return translationAnimator
    }

    // Vertical offset of bottomSheetView.origin for the given expansion state
    //
    // Note: Since .transitioning state doesn't have a well defined offset, this function will
    // only return the current sheet offset in that case.
    private func offset(for expansionState: BottomSheetExpansionState) -> CGFloat {
        guard let hostView = hostView else {
            return 0
        }

        let offset: CGFloat

        switch expansionState {
        case .collapsed:
            offset = hostView.frame.maxY - collapsedSheetHeight
        case .expanded:
            offset = hostView.frame.maxY - expandedSheetHeight
        case .hidden:
            offset = hostView.frame.maxY
        case .transitioning:
            offset = bottomSheetView.frame.minY
        }

        return offset
    }

    private func handleCompletedStateChange(to targetExpansionState: BottomSheetExpansionState,
                                            interaction: BottomSheetInteraction = .noUserAction,
                                            shouldNotifyDelegate: Bool = true) {
        currentExpansionState = targetExpansionState
        if shouldNotifyDelegate {
            self.delegate?.bottomSheetController?(self, didMoveTo: targetExpansionState, interaction: interaction)
        }

        if targetExpansionState == .collapsed {
            hostedScrollView?.setContentOffset(.zero, animated: true)
        }

        bottomSheetView.isHidden = targetExpansionState == .hidden

        // UIKit doesn't properly handle interrupted constraint animations, so we need to
        // detect and fix a possible desync here
        updateSheetLayoutGuideTopConstraint()

        ensureDimmingViewPresentIfNeeded()
    }

    private func completeAnimationsIfNeeded(skipToEnd: Bool = false) {
        if let currentAnimator = currentStateChangeAnimator, currentAnimator.isRunning {
            let endPosition: UIViewAnimatingPosition = currentAnimator.isReversed ? .start : .end
            currentAnimator.stopAnimation(false)
            currentAnimator.finishAnimation(at: skipToEnd ? endPosition : .current)
            currentStateChangeAnimator = nil
        }
    }

    private func makeLayoutGuideConstraints() -> [NSLayoutConstraint] {
        guard let hostView = hostView else {
            return []
        }

        let requiredConstraints = [
            sheetLayoutGuide.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            sheetLayoutGuide.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            sheetLayoutGuide.bottomAnchor.constraint(equalTo: hostView.bottomAnchor),
            sheetLayoutGuide.topAnchor.constraint(lessThanOrEqualTo: hostView.bottomAnchor)
        ]

        // This constraint is used to align the top of the layout guide with the top of the bottomSheetView.
        // BottomSheetView will go off-screen when it's hidden, so this constraint is not always required.
        let breakableTopConstraint = sheetLayoutGuide.topAnchor.constraint(equalTo: hostView.topAnchor)
        breakableTopConstraint.priority = .defaultHigh

        self.sheetLayoutGuideTopConstraint = breakableTopConstraint
        return requiredConstraints + [breakableTopConstraint]
    }

    private var sheetLayoutGuideTopConstraint: NSLayoutConstraint?

    // Height of the sheet in the fully expanded state
    private var expandedSheetHeight: CGFloat {
        guard isExpandable, let hostView = hostView else {
            return collapsedSheetHeight
        }

        let height: CGFloat
        let maxHeight = hostView.frame.height - hostView.safeAreaInsets.top - Constants.minimumTopExpandedPadding

        if preferredExpandedContentHeight == 0 {
            height = maxHeight
        } else {
            let idealHeight = currentResizingHandleHeight + headerContentHeight + preferredExpandedContentHeight + hostView.safeAreaInsets.bottom
            height = min(maxHeight, idealHeight)
        }

        // One case when the lower bound is required is when view.frame is .zero (like before the initial layout pass)
        // This gives the sheet some space to layout in so the layout engine doesn't complain.
        return max(collapsedSheetHeight, height)
    }

    // Height of the sheet in collapsed state
    private var collapsedSheetHeight: CGFloat {
        let visibleContentHeight = (collapsedContentHeight > 0) ? collapsedContentHeight : headerContentHeight
        return currentResizingHandleHeight + visibleContentHeight + (hostView?.safeAreaInsets.bottom ?? 0)
    }

    private var currentResizingHandleHeight: CGFloat {
        (isExpandable ? ResizingHandleView.height : 0.0)
    }

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

    private var headerContentViewHeightConstraint: NSLayoutConstraint?

    private var currentStateChangeAnimator: UIViewPropertyAnimator?

    private var currentExpansionState: BottomSheetExpansionState = .collapsed {
        didSet {
            updateResizingHandleViewAccessibility()
        }
    }

    private var targetExpansionState: BottomSheetExpansionState?

    private var isHiddenOrHiding: Bool { isHidden || targetExpansionState == .hidden }

    private var currentSheetVerticalOffset: CGFloat {
        bottomSheetView.frame.minY
    }

    private let shouldShowDimmingView: Bool

    private var hostView: UIView?

    private struct Constants {
        // Maximum offset beyond the normal bounds with additional resistance
        static let maxRubberBandOffset: CGFloat = 20.0
        static let minRubberBandScaleFactor: CGFloat = 0.05

        // Swipes over this velocity ignore proximity to the collapsed / expanded offset and fly towards
        // the offset that makes sense given the swipe direction
        static let directionOverrideVelocityThreshold: CGFloat = 150

        // Minimum padding from top when the sheet is fully expanded
        static let minimumTopExpandedPadding: CGFloat = 25.0

        static let cornerRadius: CGFloat = 14

        static let expandedContentAlphaTransitionLength: CGFloat = 30

        static let maxSheetWidth: CGFloat = 610
        static let minSheetWidth: CGFloat = 300

        struct Spring {
            // Spring used in slow swipes - no oscillation
            static let defaultDampingRatio: CGFloat = 1.0

            // Spring used in fast swipes - slight oscillation
            static let oscillatingDampingRatio: CGFloat = 0.8

            // Swipes over this velocity get slight spring oscillation
            static let flickVelocityThreshold: CGFloat = 800

            static let maxInitialVelocity: CGFloat = 40.0
            static let animationDuration: TimeInterval = 0.4

            // Off-screen overflow that can be partially revealed during spring oscillation or rubber banding (dragging the sheet beyond limits)
            static let overflowHeight: CGFloat = 50.0
        }

        struct Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.14
            static let radius: CGFloat = 8
            static let offset: CGSize = CGSize(width: 0, height: 4)
        }
    }
}

extension BottomSheetController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == hostedScrollView?.panGestureRecognizer
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = hostedScrollView,
              let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        var shouldBegin = true
        let fullyExpanded = currentSheetVerticalOffset <= offset(for: .expanded)

        if fullyExpanded {
            let scrolledToTop = scrollView.contentOffset.y <= 0
            let panningDown = panGesture.velocity(in: view).y > 0
            let panInHostedScrollView = scrollView.frame.contains(panGesture.location(in: scrollView.superview))
            shouldBegin = (scrolledToTop && panningDown) || !panInHostedScrollView
        }
        return shouldBegin
    }
}
