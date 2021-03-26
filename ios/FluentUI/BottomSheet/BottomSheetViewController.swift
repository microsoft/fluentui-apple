//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

enum BottomSheetViewState {
    case expand
    case collapse
}

@objc(MSFBottomSheetViewControllerDelegate)
public protocol BottomSheetViewControllerDelegate: AnyObject {
    /// Called when drawer is being expanded.
    @objc optional func bottomSheetViewControllerDidExpand(_ controller: BottomSheetViewController)

    /// Called when drawer is being collapsed.
    @objc optional func bottomSheetViewControllerDidCollapse(_ controller: BottomSheetViewController)
}

public class BottomSheetViewController: UIViewController {
    @objc public weak var delegate: BottomSheetViewControllerDelegate?
    /// bottom sheet's view height in collapsed mode.
    @objc public var collapsedHeight: CGFloat = Constants.collapsedHeight {
        didSet {
            updateHeight()
        }
    }

    private var animator: UIViewPropertyAnimator?
    private var contentViewController: UIViewController
    private var currentState: BottomSheetViewState = .collapse
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private lazy var dimmingView: DimmingView = {
        let view = DimmingView(type: .black)
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan))
        return recognizer
    }()

    private lazy var resizingHandleView: ResizingHandleView = {
        let resizingHandleView = ResizingHandleView()
        resizingHandleView.isAccessibilityElement = true
        resizingHandleView.accessibilityTraits = .button
        resizingHandleView.isUserInteractionEnabled = true
        resizingHandleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResizingHandleViewTap)))
        return resizingHandleView
    }()

    @objc public init(with contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

// MARK: Lifecycle methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.NavigationBar.background

        view.layer.shadowColor = Constants.Shadow.color
        view.layer.shadowOpacity = Constants.Shadow.opacity
        view.layer.shadowRadius = Constants.Shadow.radius
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(resizingHandleView)
        containerView.addArrangedSubview(contentViewController.view)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        updateResizingHandleViewAccessibility()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if animator?.state == .active {
            // panning started, don't update the height
            return
        }
        updateHeight()
    }

// MARK: private helpers
    private func updateHeight() {
        // update the view layout for collapsed mode
        if currentState == .collapse {
            if let window = self.view.window {
                view.frame = targetCollapseFrame(with: window)
                view.layoutIfNeeded()
            }
        }
    }

    private func targetCollapseFrame(with window: UIWindow) -> CGRect {
        let windowFrame = window.frame
        let adjustedCollapseHeight = collapsedHeight + window.safeAreaInsets.bottom
        return CGRect(x: 0, y: (windowFrame.height - adjustedCollapseHeight), width: windowFrame.width, height: adjustedCollapseHeight)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        removeDimmingView()
        super.viewDidDisappear(animated)
    }

// MARK: animator setup
    private func setupAnimator() {
        if let window = self.view.window {
            let targetFrame: CGRect
            var windowFrame = window.frame
            let futureDimmingViewAlpha: CGFloat
            switch currentState {
            case .collapse:
                windowFrame.size.height -= window.safeAreaInsets.top
                windowFrame.origin.y = window.safeAreaInsets.top
                targetFrame = windowFrame
                setupDimmingView()
                futureDimmingViewAlpha = 1
            case .expand:
                targetFrame = targetCollapseFrame(with: window)
                futureDimmingViewAlpha = 0
            }

            animator = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .linear, animations: { [weak self] in
                self?.view.frame = targetFrame
                self?.dimmingView.alpha = futureDimmingViewAlpha
            })
        }
    }

    private func addAnimatorCompletion(to futureState: BottomSheetViewState, completion: (() -> Void)? = nil) {
        animator?.addCompletion { [weak self] _ in
            if let currentBottomSheetViewController = self {
                currentBottomSheetViewController.panGestureRecognizer.isEnabled = true
                currentBottomSheetViewController.currentState = futureState
                currentBottomSheetViewController.view.layoutIfNeeded()

                // when the bottomsheet drawer is expanded, we don't want the UIViews behind the sheet to be accessible.
                currentBottomSheetViewController.view.accessibilityViewIsModal = futureState == .expand
                currentBottomSheetViewController.updateResizingHandleViewAccessibility()
                UIAccessibility.post(notification: .layoutChanged, argument: currentBottomSheetViewController.resizingHandleView)

                completion?()
                if futureState == .expand {
                    currentBottomSheetViewController.delegate?.bottomSheetViewControllerDidExpand?(currentBottomSheetViewController)
                } else {
                    currentBottomSheetViewController.removeDimmingView()
                    currentBottomSheetViewController.delegate?.bottomSheetViewControllerDidCollapse?(currentBottomSheetViewController)
                }
            }
        }
    }

// MARK: pan gesture utilities

    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let positionInSuperview = gesture.translation(in: view.superview)

        switch gesture.state {
        case .began:
            panningStart()
        case .changed:
            panningProgress(in: positionInSuperview.y)
        case .ended:
            let velocity = gesture.velocity(in: view)
            panningStop(in: positionInSuperview.y, velocity: velocity.y)
        default:
           break
        }
    }

    private func panningStart() {
        if animator?.isRunning ?? false {
           return
        }

        setupAnimator()
    }

    private func panningStop(in verticalPos: CGFloat, velocity: CGFloat) {
        panGestureRecognizer.isEnabled = false

        let windowHeight = view.window?.frame.height ?? 0
        let shouldReverse: Bool
        let futureState: BottomSheetViewState
        switch currentState {
        case .expand:
            if verticalPos >= windowHeight / 2 || velocity > Constants.velocityThreshold {
                shouldReverse = false
                futureState = .collapse
            } else {
                shouldReverse = true
                futureState = .expand
            }
        case .collapse:
            if verticalPos <= -windowHeight / 2 || velocity <= -1 * Constants.velocityThreshold {
                shouldReverse = false
                futureState = .expand
            } else {
                shouldReverse = true
                futureState = .collapse
            }
        }

        animator?.isReversed = shouldReverse
        addAnimatorCompletion(to: futureState, completion: nil)
        animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }

    private func panningProgress(in verticalPos: CGFloat) {
        if animator?.isRunning ?? false {
           return
        }

        let windowHeight = view.window?.frame.height ?? 0
        var progress = -1 * verticalPos / (windowHeight - collapsedHeight)

        if currentState == .expand {
            progress *= -1
        }

        animator?.fractionComplete = progress
    }

// MARK: Resize Handle utilities

    @objc private func handleResizingHandleViewTap(gesture: UITapGestureRecognizer) {
        if animator?.isRunning ?? false {
            return
        }

        if gesture.state == .recognized {
            let futureState: BottomSheetViewState
            switch currentState {
            case .collapse:
                futureState = .expand
            case .expand:
                futureState = .collapse
            }

            setupAnimator()
            addAnimatorCompletion(to: futureState)
            animator?.startAnimation()
        }
    }

    private func updateResizingHandleViewAccessibility() {
        if currentState == .expand {
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Collapse".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Collapse".localized
        } else {
            resizingHandleView.accessibilityLabel = "Accessibility.Drawer.ResizingHandle.Label.Expand".localized
            resizingHandleView.accessibilityHint = "Accessibility.Drawer.ResizingHandle.Hint.Expand".localized
        }
    }

// MARK: Dimming View utilities
    private func setupDimmingView() {
        if let rootView = view.superview {
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            rootView.insertSubview(dimmingView, belowSubview: view)
            NSLayoutConstraint.activate([
                dimmingView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
                dimmingView.topAnchor.constraint(equalTo: rootView.topAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
            ])
            dimmingView.alpha = 0
        }
    }

    private func removeDimmingView() {
        dimmingView.removeFromSuperview()
    }

    private struct Constants {
        static let animationDuration: TimeInterval = 0.25
        static let collapsedHeight: CGFloat = ResizingHandleView.height + 48
        static let velocityThreshold: CGFloat = 250
        static let cornerRadius: CGFloat = 14

        struct Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.05
            static let radius: CGFloat = 4
        }
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = (otherGestureRecognizer as? UIPanGestureRecognizer)?.view as? UIScrollView, scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) || (scrollView.contentOffset.y <= 0) {
            // If scroll view has reached the bottom or top bring the bottom sheet pan in action too.
            return true
        } else {
            return false
        }
    }
}
