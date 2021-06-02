//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFBottomSheetControllerDelegate)
public protocol BottomSheetControllerDelegate: AnyObject {

    /// Called after the sheet moved to a new expansion state
    @objc optional func bottomSheetControllerDidMove(to expansionState: BottomSheetExpansionState)
}

/// Defines the position the sheet is currently in
@objc public enum BottomSheetExpansionState: Int {
    case expanded // Sheet is fully expanded
    case collapsed // Sheet is collapsed
    case hidden // Sheet is hidden (fully off-screen)
}

@objc(MSFBottomSheetController)
public class BottomSheetController: UIViewController {

    /// Initializes the bottom sheet controller
    /// - Parameters:
    ///   - headerContentView: Top part of the sheet content that is visible in both collapsed and expanded state.
    ///   - expandedContentView: Sheet content below the header which is only visible when the sheet is expanded.
    @objc public init(headerContentView: UIView? = nil, expandedContentView: UIView) {
        self.headerContentView = headerContentView
        self.expandedContentView = expandedContentView
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
                }
            }
        }
    }

    /// Indicates if the bottom sheet is hidden.
    ///
    /// Changes to this property are animated.
    @objc open var isHidden: Bool {
        get {
            return currentExpansionState == .hidden
        }
        set {
            if newValue != isHidden {
                if isViewLoaded {
                    if newValue {
                        panGestureRecognizer.isEnabled = false
                        move(to: .hidden) { _ in
                            self.bottomSheetView.isHidden = true
                        }
                    } else {
                        bottomSheetView.isHidden = false
                        move(to: .collapsed) { _ in
                            self.panGestureRecognizer.isEnabled = self.isExpandable
                        }
                    }
                } else {
                    // This ensures the view eventually loads at the correct offset
                    currentExpansionState = newValue ? .hidden : .collapsed
                }
            }
        }
    }

    /// Fraction of the available area that the bottom sheet should take up in the expanded position.
    @objc open var expandedHeightFraction: CGFloat = 1.0 {
        didSet {
            if expandedHeightFraction != oldValue {
                updateBottomSheetHeightConstraint()
            }
        }
    }

    /// Height of the top portion of the content view that should be visible when the bottom sheet is collapsed.
    @objc open var collapsedContentHeight: CGFloat = Constants.defaultCollapsedContentHeight {
        didSet {
            if isViewLoaded && currentExpansionState == .collapsed {
                move(to: .collapsed, animated: false)
            }
        }
    }

    /// The object that acts as the delegate of the bottom sheet.
    @objc open weak var delegate: BottomSheetControllerDelegate?

    // MARK: - View loading

    // View hierarchy
    // self.view - BottomSheetPassthroughView (full overlay area)
    // |--bottomSheetView (shadow)
    // |  |--UIStackView (round corner mask)
    // |  |  |--resizingHandleView
    // |  |  |--headerContentView
    // |  |  |--expandedContentView
    // |--overflowView
    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetView)
        bottomSheetView.isHidden = isHidden

        let overflowView = UIView()
        overflowView.translatesAutoresizingMaskIntoConstraints = false
        overflowView.backgroundColor = Colors.NavigationBar.background
        view.addSubview(overflowView)

        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overflowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overflowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overflowView.heightAnchor.constraint(equalToConstant: Constants.Spring.overflowHeight),
            overflowView.topAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            bottomSheetOffsetConstraint
        ])
        updateBottomSheetHeightConstraint()
        updateResizingHandleViewAccessibility()
    }

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

    @objc private func handleResizingHandleViewTap(_ sender: UITapGestureRecognizer) {
        if currentOffsetFromBottom != offset(for: .collapsed) {
            move(to: .collapsed, velocity: 0)
        } else {
            move(to: .expanded, velocity: 0)
        }
    }

    private func updateResizingHandleViewAccessibility() {
        if currentOffsetFromBottom != offset(for: .collapsed) {
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

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            stopAnimationIfNeeded()
            fallthrough
        case .changed:
            translateSheet(by: sender.translation(in: view))
            sender.setTranslation(.zero, in: view)
            updateExpandedContentAlpha()
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
        move(to: targetState, velocity: velocity)
    }

    private func move(to targetExpansionState: BottomSheetExpansionState, animated: Bool = true, velocity: CGFloat = 0.0, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let targetOffsetFromBottom = offset(for: targetExpansionState)
        currentExpansionState = targetExpansionState

        if currentOffsetFromBottom != targetOffsetFromBottom {
            if animated {
                let targetOffsetFromBottom = offset(for: targetExpansionState)
                let distanceToGo = abs(currentOffsetFromBottom - targetOffsetFromBottom)
                let springVelocity = min(abs(velocity / distanceToGo), Constants.Spring.maxInitialVelocity)
                let damping: CGFloat = abs(velocity) > Constants.Spring.flickVelocityThreshold
                    ? Constants.Spring.oscillatingDampingRatio
                    : Constants.Spring.defaultDampingRatio

                let springParams = UISpringTimingParameters(dampingRatio: damping, initialVelocity: CGVector(dx: 0.0, dy: springVelocity))

                stopAnimationIfNeeded()
                let translationAnimator = UIViewPropertyAnimator(duration: Constants.Spring.animationDuration, timingParameters: springParams)
                self.translationAnimator = translationAnimator

                view.layoutIfNeeded()
                bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
                translationAnimator.addAnimations { [weak self] in
                    self?.view.layoutIfNeeded()
                }

                let targetExpandedContentOpacity: CGFloat = targetExpansionState == .expanded ? 1.0 : 0.0
                if expandedContentView.alpha != targetExpandedContentOpacity {
                    translationAnimator.addAnimations { [weak self] in
                        self?.expandedContentView.alpha = targetExpandedContentOpacity
                    }
                }

                translationAnimator.addCompletion({ [weak self] finalPosition in
                    if finalPosition == .end {
                        self?.handleCompletedStateChange(to: targetExpansionState)
                    }
                    completion?(finalPosition)
                })
                translationAnimator.startAnimation()
            } else {
                bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
                handleCompletedStateChange(to: targetExpansionState)
            }
        }
    }

    private func offset(for expansionState: BottomSheetExpansionState) -> CGFloat {
        var offset: CGFloat

        switch expansionState {
        case .collapsed:
            offset = collapsedContentHeight + (isExpandable ? ResizingHandleView.height : 0.0)
        case .expanded:
            offset = bottomSheetView.frame.height - view.safeAreaInsets.bottom
        case .hidden:
            offset = Constants.hiddenOffScreenOffset
        }

        return offset
    }

    private func handleCompletedStateChange(to targetExpansionState: BottomSheetExpansionState) {
        self.delegate?.bottomSheetControllerDidMove?(to: targetExpansionState)

        if targetExpansionState == .collapsed {
            hostedScrollView?.setContentOffset(.zero, animated: true)
        }

        updateResizingHandleViewAccessibility()
        updateExpandedContentAlpha()
    }

    private func stopAnimationIfNeeded() {
        guard let animator = translationAnimator, animator.isRunning else {
            return
        }
        animator.stopAnimation(true)

        // The AutoLayout constant doesn't animate, so we need to set it to whatever it should be
        // based on the frame calculated during the interrupted animation
        let offsetFromBottom = view.frame.height - bottomSheetView.frame.origin.y - view.safeAreaInsets.bottom
        bottomSheetOffsetConstraint.constant = -offsetFromBottom
    }

    // MARK: - Height constraint utils

    private func updateBottomSheetHeightConstraint() {
        let newConstraint = generateBottomSheetHeightConstraint()

        bottomSheetHeightConstraint.isActive = false
        newConstraint.isActive = true

        bottomSheetHeightConstraint = newConstraint
    }

    private func generateBottomSheetHeightConstraint() -> NSLayoutConstraint {
        // Fill view bounds, respecting the given height fraction
        let constraint = bottomSheetView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: expandedHeightFraction,
            constant: view.safeAreaInsets.top - Constants.minimumTopExpandedPadding)
        return constraint
    }

    // The height doesn't change while panning. The sheet only gets pulled out from the off-screen area.
    private lazy var bottomSheetHeightConstraint: NSLayoutConstraint = generateBottomSheetHeightConstraint()

    private lazy var bottomSheetOffsetConstraint: NSLayoutConstraint =
        bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset(for: currentExpansionState))

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

    private var translationAnimator: UIViewPropertyAnimator?

    private var needsOffsetUpdate: Bool = false

    private var currentExpansionState: BottomSheetExpansionState = .collapsed

    private var currentOffsetFromBottom: CGFloat {
        -bottomSheetOffsetConstraint.constant
    }

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

        static let hiddenOffScreenOffset: CGFloat = -50

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
