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
    @objc public init(headerContentView: UIView? = nil, expandedContentView: UIView, shouldShowDimmingView: Bool = true) {
        self.headerContentView = headerContentView
        self.expandedContentView = expandedContentView
        self.shouldShowDimmingView = shouldShowDimmingView
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
                if isViewLoaded && !isHidden {
                    move(to: .collapsed, animated: false)
                    delegate?.bottomSheetControllerCollapsedHeightInSafeAreaDidChange?(self)
                }
            }
        }
    }

    /// Indicates if the bottom sheet is hidden.
    ///
    /// Changes to this property are animated. A new value is reflected in the getter only after the animation completes.
    @objc open var isHidden: Bool {
        get {
            return currentExpansionState == .hidden
        }
        set {
            setIsHidden(newValue)
        }
    }

    /// Preferred height of `expandedContentView`.
    ///
    /// The default value is 0, which results in a full screen sheet expansion.
    @objc open var preferredExpandedContentHeight: CGFloat = 0 {
        didSet {
            if isViewLoaded {
                updateSheetSizingConstraints()
                move(to: currentExpansionState, animated: false)
            }
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
    @objc open var collapsedContentHeight: CGFloat = Constants.defaultCollapsedContentHeight {
        didSet {
            if isViewLoaded && currentExpansionState == .collapsed {
                move(to: .collapsed, animated: false)
                delegate?.bottomSheetControllerCollapsedHeightInSafeAreaDidChange?(self)
            }
        }
    }

    /// Current height of the portion of a collapsed sheet that's in the safe area.
    @objc public var collapsedHeightInSafeArea: CGFloat {
        return offset(for: .collapsed)
    }

    /// A layout guide that covers the on-screen portion of the sheet view.
    @objc public let sheetLayoutGuide = UILayoutGuide()

    /// The object that acts as the delegate of the bottom sheet.
    @objc open weak var delegate: BottomSheetControllerDelegate?

    /// Height of the resizing handle
    @objc public static var resizingHandleHeight: CGFloat {
        return ResizingHandleView.height
    }

    // MARK: - Parametrized setters

    /// Sets the `isExpanded` property with a completion handler.
    /// - Parameters:
    ///   - isExpanded: The new value.
    ///   - animated: Indicates if the change should be animated. The default value is `true`.
    ///   - completion: Closure to be called when the state change completes.
    @objc public func setIsExpanded(_ isExpanded: Bool, animated: Bool = true, completion: ((_ isFinished: Bool) -> Void)? = nil) {
        guard isExpanded != self.isExpanded else {
            return
        }

        if !isHidden && isExpandable {
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
    }

    /// Changes the `isHidden` state with a completion handler.
    /// - Parameters:
    ///   - isHidden: The new value.
    ///   - animated: Indicates if the change should be animated. The default value is `true`.
    ///   - completion: Closure to be called when the state change completes.
    @objc public func setIsHidden(_ isHidden: Bool, animated: Bool = true, completion: ((_ isFinished: Bool) -> Void)? = nil) {
        let targetState: BottomSheetExpansionState = isHidden ? .hidden : .collapsed
        if isViewLoaded {
            move(to: targetState, animated: animated) { finalPosition in
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

            move(to: initialState, animated: false)
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
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutGuide(sheetLayoutGuide)

        if shouldShowDimmingView {
            view.addSubview(dimmingView)
            NSLayoutConstraint.activate([
                dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

        view.addSubview(bottomSheetView)
        bottomSheetView.isHidden = isHidden

        let overflowView = UIView()
        overflowView.translatesAutoresizingMaskIntoConstraints = false
        overflowView.backgroundColor = Colors.NavigationBar.background
        view.addSubview(overflowView)

        view.addLayoutGuide(maxSheetHeightLayoutGuide)
        view.addLayoutGuide(preferredExpandedContentLayoutGuide)

        let preferredExpandedContentTopConstraint = preferredExpandedContentLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -preferredExpandedContentHeight)

        NSLayoutConstraint.activate([
            maxSheetHeightLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maxSheetHeightLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            maxSheetHeightLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maxSheetHeightLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.minimumTopExpandedPadding),
            preferredExpandedContentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preferredExpandedContentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preferredExpandedContentLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            preferredExpandedContentTopConstraint,
            preferredExpandedContentHeightConstraint,
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.heightAnchor.constraint(lessThanOrEqualTo: maxSheetHeightLayoutGuide.heightAnchor),
            overflowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overflowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overflowView.heightAnchor.constraint(equalToConstant: Constants.Spring.overflowHeight),
            overflowView.topAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            bottomSheetOffsetConstraint
        ])

        NSLayoutConstraint.activate(makeLayoutGuideConstraints())

        self.preferredExpandedContentGuideTopConstraint = preferredExpandedContentTopConstraint

        updateSheetSizingConstraints()
        updateResizingHandleViewAccessibility()
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
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false

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
        if needsOffsetUpdate {
            needsOffsetUpdate = false
            move(to: currentExpansionState, animated: false, velocity: 0.0)
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if size.height != view.frame.height {
            needsOffsetUpdate = true
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateResizingHandleViewAccessibility()
        updateExpandedContentAlpha()
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
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Collapse".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Collapse".localized
        } else {
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Expand".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Expand".localized
        }
    }

    private func updateExpandedContentAlpha() {
        let transitionLength = Constants.expandedContentAlphaTransitionLength
        let currentOffset = currentOffsetFromBottom
        let collapsedOffset = offset(for: .collapsed)

        var targetAlpha: CGFloat = 1.0
        if currentOffset <= collapsedOffset {
            targetAlpha = 0.0
        } else if currentOffset > collapsedOffset && currentOffset < collapsedOffset + transitionLength {
            targetAlpha = abs(currentOffset - collapsedOffset) / transitionLength
        }
        expandedContentView.alpha = targetAlpha
    }

    private func updateDimmingViewAlpha() {
        guard shouldShowDimmingView else {
            return
        }

        let currentOffset = currentOffsetFromBottom
        let collapsedOffset = offset(for: .collapsed)
        let expandedOffset = offset(for: .expanded)

        var targetAlpha: CGFloat = 0.0
        if currentOffset > expandedOffset {
            targetAlpha = 1.0
        } else if currentOffset < collapsedOffset {
            targetAlpha = 0.0
        } else {
            targetAlpha = abs(currentOffset - collapsedOffset) / (expandedOffset - collapsedOffset)
        }
        dimmingView.alpha = targetAlpha
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            completeAnimationsIfNeeded()
            fallthrough
        case .changed:
            translateSheet(by: sender.translation(in: view))
            sender.setTranslation(.zero, in: view)
            updateExpandedContentAlpha()
            updateDimmingViewAlpha()
        case .ended, .cancelled, .failed:
            completePan(with: sender.velocity(in: view).y)
        default:
            break
        }
    }

    private func translateSheet(by translationDelta: CGPoint) {
        let expandedOffset = offset(for: .expanded)
        let collapsedOffset = offset(for: .collapsed)
        let maxOffset = expandedOffset + Constants.maxRubberBandOffset
        let minOffset = collapsedOffset - Constants.maxRubberBandOffset

        var offsetDelta = translationDelta.y
        if currentOffsetFromBottom <= collapsedOffset || currentOffsetFromBottom >= expandedOffset {
            offsetDelta *= translationRubberBandFactor(for: currentOffsetFromBottom)
        }
        bottomSheetOffsetConstraint.constant = -min(max(currentOffsetFromBottom - offsetDelta, minOffset), maxOffset)
    }

    private func translationRubberBandFactor(for currentOffset: CGFloat) -> CGFloat {
        var offLimitsOffset: CGFloat = 0.0
        let expandedOffset = offset(for: .expanded)
        let collapsedOffset = offset(for: .collapsed)

        if currentOffset > expandedOffset {
            offLimitsOffset = min(currentOffset - expandedOffset, Constants.maxRubberBandOffset)
        } else if currentOffset < collapsedOffset {
            offLimitsOffset = min(collapsedOffset - currentOffset, Constants.maxRubberBandOffset)
        }

        return max(1.0 - offLimitsOffset / Constants.maxRubberBandOffset, Constants.minRubberBandScaleFactor)
    }

    // MARK: - Animations

    private func completePan(with velocity: CGFloat) {
        var targetState: BottomSheetExpansionState
        if abs(velocity) < Constants.directionOverrideVelocityThreshold {
            // Velocity too low, snap to the closest offset
            targetState =
                abs(offset(for: .collapsed) - currentOffsetFromBottom) < abs(offset(for: .expanded) - currentOffsetFromBottom)
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
                      completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        completeAnimationsIfNeeded()
        let targetOffsetFromBottom = offset(for: targetExpansionState)

        if currentOffsetFromBottom != targetOffsetFromBottom {
            let animator = stateChangeAnimator(to: targetExpansionState, velocity: velocity)
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
        }
    }

    private func stateChangeAnimator(to targetExpansionState: BottomSheetExpansionState,
                                     velocity: CGFloat = 0.0,
                                     interaction: BottomSheetInteraction = .noUserAction,
                                     shouldNotifyDelegate: Bool = true) -> UIViewPropertyAnimator {
        let targetOffsetFromBottom = offset(for: targetExpansionState)
        let distanceToGo = abs(currentOffsetFromBottom - targetOffsetFromBottom)
        let springVelocity = min(abs(velocity / distanceToGo), Constants.Spring.maxInitialVelocity)
        let damping: CGFloat = abs(velocity) > Constants.Spring.flickVelocityThreshold
            ? Constants.Spring.oscillatingDampingRatio
            : Constants.Spring.defaultDampingRatio

        let springParams = UISpringTimingParameters(dampingRatio: damping, initialVelocity: CGVector(dx: 0.0, dy: springVelocity))
        let translationAnimator = UIViewPropertyAnimator(duration: Constants.Spring.animationDuration, timingParameters: springParams)

        // Disable dragging while hiding the sheet
        if targetExpansionState == .hidden {
            panGestureRecognizer.isEnabled = false
        }

        view.layoutIfNeeded()

        // Animation might be reversed, so we need to remember the original state
        let originalBottomSheetHiddenState = bottomSheetView.isHidden
        let originalBottomOffsetConstant = bottomSheetOffsetConstraint.constant

        bottomSheetView.isHidden = false
        bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
        translationAnimator.addAnimations { [weak self] in
            self?.view.layoutIfNeeded()
        }

        let targetRelatedViewAlpha = targetExpansionState.relatedViewAlpha
        if expandedContentView.alpha != targetRelatedViewAlpha {
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
            strongSelf.panGestureRecognizer.isEnabled = strongSelf.isExpandable

            if finalPosition == .end {
                strongSelf.handleCompletedStateChange(to: targetExpansionState, interaction: interaction, shouldNotifyDelegate: shouldNotifyDelegate)
            } else if finalPosition == .start {
                strongSelf.bottomSheetView.isHidden = originalBottomSheetHiddenState
                strongSelf.bottomSheetOffsetConstraint.constant = originalBottomOffsetConstant
            } else {
                // The constraint constant doesn't animate, so we need to set it to whatever it should be
                // based on the frame calculated during the interrupted animation
                let offsetFromBottom = strongSelf.view.frame.height - strongSelf.bottomSheetView.frame.origin.y - strongSelf.view.safeAreaInsets.bottom
                strongSelf.bottomSheetOffsetConstraint.constant = -offsetFromBottom
            }
        })
        translationAnimator.pauseAnimation()
        return translationAnimator
    }

    private func offset(for expansionState: BottomSheetExpansionState) -> CGFloat {
        var offset: CGFloat

        switch expansionState {
        case .collapsed:
            offset = collapsedContentHeight + (isExpandable ? ResizingHandleView.height : 0.0)
        case .expanded:
            offset = bottomSheetView.frame.height - view.safeAreaInsets.bottom
        case .hidden:
            offset = -view.safeAreaInsets.bottom
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

        if targetExpansionState == .hidden {
            bottomSheetView.isHidden = true
        }

        updateResizingHandleViewAccessibility()
        updateExpandedContentAlpha()
    }

    private func completeAnimationsIfNeeded(skipToEnd: Bool = false) {
        if let currentAnimator = currentStateChangeAnimator, currentAnimator.isRunning {
            let endPosition: UIViewAnimatingPosition = currentAnimator.isReversed ? .start : .end
            currentAnimator.stopAnimation(false)
            currentAnimator.finishAnimation(at: skipToEnd ? endPosition : .current)
            currentStateChangeAnimator = nil
        }
    }

    private func updateSheetSizingConstraints() {
        if preferredExpandedContentHeight > 0 {
            fullScreenSheetConstraint.isActive = false

            // Apply the new preferred height to the static layout guide
            preferredExpandedContentGuideTopConstraint?.constant = -preferredExpandedContentHeight

            // Activate constraint which ties expandedContentView height to the layout guide height
            preferredExpandedContentHeightConstraint.isActive = true

        } else {
            // Tie the sheet size to maxSheetHeightLayoutGuide.heightAnchor to make it full screen
            preferredExpandedContentHeightConstraint.isActive = false
            fullScreenSheetConstraint.isActive = true
        }
    }

    private func makeLayoutGuideConstraints() -> [NSLayoutConstraint] {
        let requiredConstraints = [
            sheetLayoutGuide.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            sheetLayoutGuide.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            sheetLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetLayoutGuide.topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ]

        // BottomSheetView will go off-screen when it's hidden, so this constraint is not always required.
        let breakableConstraint = sheetLayoutGuide.topAnchor.constraint(equalTo: bottomSheetView.topAnchor)
        breakableConstraint.priority = .defaultHigh

        return requiredConstraints + [breakableConstraint]
    }

    private lazy var preferredExpandedContentHeightConstraint: NSLayoutConstraint = {
        let constraint = expandedContentView.heightAnchor.constraint(equalTo: preferredExpandedContentLayoutGuide.heightAnchor)
        constraint.priority = .defaultHigh // Lower than required so Auto Layout can enforce max sheet height
        return constraint
    }()

    private lazy var fullScreenSheetConstraint: NSLayoutConstraint = {
        let constraint = bottomSheetView.heightAnchor.constraint(equalTo: maxSheetHeightLayoutGuide.heightAnchor)
        constraint.priority = .defaultHigh // Lower than required so Auto Layout can enforce max sheet height
        return constraint
    }()

    private lazy var maxSheetHeightLayoutGuide: UILayoutGuide = UILayoutGuide()

    private lazy var preferredExpandedContentLayoutGuide: UILayoutGuide = UILayoutGuide()

    private var preferredExpandedContentGuideTopConstraint: NSLayoutConstraint?

    private lazy var bottomSheetOffsetConstraint: NSLayoutConstraint =
        bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset(for: currentExpansionState))

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

    private var currentStateChangeAnimator: UIViewPropertyAnimator?

    private var needsOffsetUpdate: Bool = false

    private var currentExpansionState: BottomSheetExpansionState = .collapsed

    private var currentOffsetFromBottom: CGFloat {
        -bottomSheetOffsetConstraint.constant
    }

    private let shouldShowDimmingView: Bool

    private struct Constants {
        // Maximum offset beyond the normal bounds with additional resistance
        static let maxRubberBandOffset: CGFloat = 20.0
        static let minRubberBandScaleFactor: CGFloat = 0.05

        // Swipes over this velocity ignore proximity to the collapsed / expanded offset and fly towards
        // the offset that makes sense given the swipe direction
        static let directionOverrideVelocityThreshold: CGFloat = 150

        // Minimum padding from top when the sheet is fully expanded
        static let minimumTopExpandedPadding: CGFloat = 25.0
        static let defaultCollapsedContentHeight: CGFloat = 75

        static let cornerRadius: CGFloat = 14

        static let expandedContentAlphaTransitionLength: CGFloat = 30

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
        let fullyExpanded = currentOffsetFromBottom >= offset(for: .expanded)

        if fullyExpanded {
            let scrolledToTop = scrollView.contentOffset.y <= 0
            let panningDown = panGesture.velocity(in: view).y > 0
            let panInHostedScrollView = scrollView.frame.contains(panGesture.location(in: scrollView.superview))
            shouldBegin = (scrolledToTop && panningDown) || !panInHostedScrollView
        }
        return shouldBegin
    }
}
