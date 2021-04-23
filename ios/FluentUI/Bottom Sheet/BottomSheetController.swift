//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFBottomSheetControllerDelegate)
public protocol BottomSheetControllerDelegate: AnyObject {
    /// Called after the sheet fully expanded.
    @objc optional func bottomSheetControllerDidExpand(_ controller: BottomSheetController)

    /// Called after the sheet fully collapsed.
    @objc optional func bottomSheetControllerDidCollapse(_ controller: BottomSheetController)
}

@objc(MSFBottomSheetController)
public class BottomSheetController: UIViewController {

    /// Initializes the bottom sheet controller.
    /// - Parameter contentViewController: The view controller that's placed inside the bottom sheet.
    ///
    /// By default the root view of `contentViewController` will be sized automatically to fill the available area,
    /// respecting the provided `preferredExpandedHeightFraction` multiplier.
    /// Alternatively, the content can size itself by setting `respectsPreferredContentSize` to true and providing a `preferredContentSize`.
    @objc public init(with contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// A scroll view in `contentViewController`'s view hierarchy.
    /// Provide this to ensure the bottom sheet pan gesture recognizer coordinates with the scroll view to enable scrolling based on current bottom sheet position and content offset.
    @objc open var hostedScrollView: UIScrollView?

    /// Indicates if the bottom sheet is expandable.
    @objc open var isExpandable: Bool = true {
        didSet {
            if isExpandable != oldValue {
                resizingHandleView.isHidden = !isExpandable
                panGestureRecognizer.isEnabled = isExpandable
                move(to: .collapsed, animated: false)
            }
        }
    }

    /// Indicates if `preferredContentSize` of `contentViewController` should be respected.
    /// Regardless of the value, the expanded height is limited by the height of `BottomSheetController`'s root view.
    @objc open var respectsPreferredContentSize: Bool = false {
        didSet {
            if respectsPreferredContentSize != oldValue {
                updateBottomSheetHeightConstraints()
            }
        }
    }

    /// Fraction of the available area that the bottom sheet should take up in the expanded position.
    ///
    /// Ignored when `respectsPreferredContentSize` is set to `true`
    @objc open var expandedHeightFraction: CGFloat = 1.0 {
        didSet {
            if expandedHeightFraction != oldValue && !respectsPreferredContentSize {
                updateBottomSheetHeightConstraints()
            }
        }
    }

    /// Height of the top portion of the content view that should be visible when the bottom sheet is collapsed.
    @objc open var collapsedContentHeight: CGFloat = Constants.defaultCollapsedContentHeight

    /// The object that acts as the delegate of the bottom sheet.
    @objc open weak var delegate: BottomSheetControllerDelegate?

    // MARK: - View loading

    /// View hierarchy
    /// --BottomSheetPassthroughView (full overlay area)
    /// ----bottomSheetView (bottom sheet area only)
    /// ------bottomSheetContentView
    /// --------UIStackView
    /// ----------ResizingHandleView
    /// ----------contentView (root of contentViewController)
    public override func loadView() {
        view = BottomSheetPassthroughView()

        addChild(contentViewController)
        contentViewController.didMove(toParent: self)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetView)

        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetOffsetConstraint
        ])
        updateBottomSheetHeightConstraints()
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

        let stackView = UIStackView(arrangedSubviews: [resizingHandleView, contentView])
        stackView.spacing = 0.0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetContentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bottomSheetContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: bottomSheetContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: bottomSheetContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomSheetContentView.bottomAnchor, constant: -Constants.Spring.overflowHeight)
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

    // MARK: - Gesture handling

    @objc private func handleResizingHandleViewTap(_ sender: UITapGestureRecognizer) {
        if currentOffsetFromBottom != collapsedOffsetFromBottom {
            animate(to: .collapsed, velocity: 0)
            hostedScrollView?.setContentOffset(.zero, animated: true)
        } else {
            animate(to: .expanded, velocity: 0)
        }
    }

    private func updateResizingHandleViewAccessibility() {
        if currentOffsetFromBottom != collapsedOffsetFromBottom {
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Collapse".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Collapse".localized
        } else {
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Expand".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Expand".localized
        }
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            stopAnimationIfNeeded()
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
        let maxOffset = expandedOffsetFromBottom + Constants.maxRubberBandOffset
        let minOffset = collapsedOffsetFromBottom - Constants.maxRubberBandOffset

        var offsetDelta = translationDelta.y
        if currentOffsetFromBottom <= collapsedOffsetFromBottom || currentOffsetFromBottom >= expandedOffsetFromBottom {
            offsetDelta *= translationRubberBandFactor(for: currentOffsetFromBottom)
        }
        bottomSheetOffsetConstraint.constant = -min(max(currentOffsetFromBottom - offsetDelta, minOffset), maxOffset)
    }

    private func translationRubberBandFactor(for currentOffset: CGFloat) -> CGFloat {
        var offLimitsOffset: CGFloat = 0.0
        if currentOffset > expandedOffsetFromBottom {
            offLimitsOffset = min(currentOffset - expandedOffsetFromBottom, Constants.maxRubberBandOffset)
        } else if currentOffset < collapsedOffsetFromBottom {
            offLimitsOffset = min(collapsedOffsetFromBottom - currentOffset, Constants.maxRubberBandOffset)
        }

        return max(1.0 - offLimitsOffset / Constants.maxRubberBandOffset, Constants.minRubberBandScaleFactor)
    }

    // MARK: - Animations

    private func completePan(with velocity: CGFloat) {
        var targetState: BottomSheetExpansionState
        if abs(velocity) < Constants.directionOverrideVelocityThreshold {
            // Velocity too low, snap to the closest offset
            targetState =
                abs(collapsedOffsetFromBottom - currentOffsetFromBottom) < abs(expandedOffsetFromBottom - currentOffsetFromBottom)
                ? .collapsed
                : .expanded
        } else {
            // Velocity high enough, animate to the offset we're swiping towards
            targetState = velocity > 0 ? .collapsed : .expanded
        }
        move(to: targetState, velocity: velocity)
    }

    private func move(to targetExpansionState: BottomSheetExpansionState, animated: Bool = true, velocity: CGFloat = 0.0) {
        if animated {
            animate(to: targetExpansionState, velocity: velocity)
        } else {
            bottomSheetOffsetConstraint.constant = -(targetExpansionState == .expanded ? expandedOffsetFromBottom : collapsedOffsetFromBottom)
            handleCompletedStateChange(to: targetExpansionState)
        }
    }

    private func animate(to targetExpansionState: BottomSheetExpansionState, velocity: CGFloat = 0.0) {
        let targetOffsetFromBottom = targetExpansionState == .expanded ? expandedOffsetFromBottom : collapsedOffsetFromBottom
        let distanceToGo = abs(currentOffsetFromBottom - targetOffsetFromBottom)
        let springVelocity = min(abs(velocity / distanceToGo), Constants.Spring.maxInitialVelocity)
        let damping: CGFloat = abs(velocity) > Constants.Spring.flickVelocityThreshold
            ? Constants.Spring.oscillatingDampingRatio
            : Constants.Spring.defaultDampingRatio

        let springParams = UISpringTimingParameters(dampingRatio: damping, initialVelocity: CGVector(dx: 0.0, dy: springVelocity))
        translationAnimator = UIViewPropertyAnimator(duration: Constants.Spring.animationDuration, timingParameters: springParams)

        view.layoutIfNeeded()
        bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
        translationAnimator?.addAnimations {
            self.view.layoutIfNeeded()
        }

        translationAnimator?.addCompletion({ finalPosition in
            if finalPosition == .end {
                self.handleCompletedStateChange(to: targetExpansionState)
            }
        })
        translationAnimator?.startAnimation()
    }

    private func handleCompletedStateChange(to targetExpansionState: BottomSheetExpansionState) {
        switch targetExpansionState {
        case .expanded:
            self.delegate?.bottomSheetControllerDidExpand?(self)
        case .collapsed:
            self.delegate?.bottomSheetControllerDidCollapse?(self)
        }
        updateResizingHandleViewAccessibility()
    }

    private func stopAnimationIfNeeded() {
        guard let animator = translationAnimator else {
            return
        }

        if animator.isRunning {
            animator.stopAnimation(true)

            // The AutoLayout constant doesn't animate, so we need to set it to whatever it should be
            // based on the frame calculated during the interrupted animation
            let offsetFromBottom = view.frame.height - bottomSheetView.frame.origin.y
            bottomSheetOffsetConstraint.constant = -offsetFromBottom
        }
    }

    // MARK: - Height constraint utils

    private func updateBottomSheetHeightConstraints() {
        let newConstraints = generateBottomSheetHeightConstraints()

        NSLayoutConstraint.deactivate(bottomSheetHeightConstraints)
        NSLayoutConstraint.activate(newConstraints)

        bottomSheetHeightConstraints = newConstraints
    }

    private func generateBottomSheetHeightConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint]
        if respectsPreferredContentSize {
            // Convert child VC preferred height to a constraint + an upper bound constraint
            let preferredHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: contentViewController.preferredContentSize.height)
            preferredHeightConstraint.priority = .defaultLow

            let maxHeightConstraint = bottomSheetView.heightAnchor.constraint(
                lessThanOrEqualTo: view.heightAnchor,
                constant: Constants.Spring.overflowHeight - view.safeAreaInsets.top - Constants.minimumTopExpandedPadding)
            constraints = [preferredHeightConstraint, maxHeightConstraint]
        } else {
            // Fill view bounds, respecting the given height fraction
            constraints = [
                bottomSheetView.heightAnchor.constraint(
                    equalTo: view.heightAnchor,
                    multiplier: expandedHeightFraction,
                    constant: Constants.Spring.overflowHeight - view.safeAreaInsets.top - Constants.minimumTopExpandedPadding)]
        }
        return constraints
    }

    // The height doesn't change while panning. The sheet only gets pulled out from the off-screen area.
    private lazy var bottomSheetHeightConstraints: [NSLayoutConstraint] = generateBottomSheetHeightConstraints()

    private lazy var bottomSheetOffsetConstraint: NSLayoutConstraint =
        bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -collapsedOffsetFromBottom)

    private var contentViewController: UIViewController

    private var contentView: UIView { contentViewController.view }

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

    private var translationAnimator: UIViewPropertyAnimator?

    private var currentOffsetFromBottom: CGFloat {
        -bottomSheetOffsetConstraint.constant
    }

    private var collapsedOffsetFromBottom: CGFloat {
        collapsedContentHeight + (isExpandable ? ResizingHandleView.height : 0.0)
    }

    private var expandedOffsetFromBottom: CGFloat {
        return bottomSheetView.frame.height - Constants.Spring.overflowHeight
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
        guard let scrollView = hostedScrollView, let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        var shouldBegin = true
        let fullyExpanded = currentOffsetFromBottom >= expandedOffsetFromBottom

        if fullyExpanded {
            let scrolledToTop = scrollView.contentOffset.y <= 0
            let panningDown = panGesture.velocity(in: view).y > 0
            shouldBegin = scrolledToTop && panningDown
        }

        return shouldBegin
    }
}

enum BottomSheetExpansionState {
    case expanded
    case collapsed
}
