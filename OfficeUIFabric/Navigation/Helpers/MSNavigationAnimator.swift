//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSNavigationAnimator

/// Implements a custom navigation animation for `MSNavigationController`.
/// Animates view controllers, navigation bar, toolbar and a background views.
/// This custom animation is needed because the native animation only animates view controllers.
/// This class attemps to match the native animation as much as possible.
class MSNavigationAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    /// Represents the transition of a view's frame.
    struct ViewFrameTransition {
        /// The view to animate
        let view: UIView

        /// The initial frame
        let fromFrame: CGRect

        /// The final frame
        let toFrame: CGRect

        /// The original super view.
        /// At the end of the animation the view will be returned to this super view.
        let originalSuperview: UIView?

        /// The original frame.
        /// If the animation is cancelled, the view is returned to this frame.
        let originalFrame: CGRect?

        /// The original index of `view` in the array `originalSuperview.superviews`.
        /// Used to restore the view at the same position.
        let originalIndex: Int?

        /// Whether this is a temporary view.
        /// If true, the view will be removed from the view hierarchy at the end of the animation.
        let isTemporary: Bool

        /// A custom animation block executed during the animation
        var customAnimation : (() -> Void)?
    }

    private typealias ViewFrameTransitionGroups = (group1: [ViewFrameTransition], group2: [ViewFrameTransition])

    var operation: UINavigationController.Operation = .none

    weak var navigationController: UINavigationController?

    var isInteractiveTransition: Bool = false

    var tintColor: UIColor = .black

    private var transitionDuration: TimeInterval {
        return self.operation == .push ? 0.45 : 0.40
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        var frameTransitions: ViewFrameTransitionGroups = (group1: [ViewFrameTransition](), group2: [ViewFrameTransition]())

        createBackgroundTransitions(transitionContext, frameTransitions: &frameTransitions)
        createNavigationControllerTransitions(transitionContext, frameTransitions: &frameTransitions)
        createViewControllerTransitions(transitionContext, frameTransitions: &frameTransitions)

        guard !frameTransitions.0.isEmpty || !frameTransitions.1.isEmpty else {
            transitionContext.completeTransition(true)
            return
        }

        let containerView = transitionContext.containerView

        let transitions = frameTransitions.group1 + frameTransitions.group2

        transitions.forEach {
            containerView.addSubview($0.view)
            $0.view.frame = $0.fromFrame
        }
        // Bring navigation bar upfront if it has a shadow (displayed outside of navigation bar's bounds)
        if let navigationBar = navigationController?.navigationBar, navigationBar.shadowImage == nil {
            navigationBar.superview?.bringSubviewToFront(navigationBar)
        }

        let timingFunction = self.isInteractiveTransition ?
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) :
            CAMediaTimingFunction(controlPoints: 0, 0.5, 0.2, 1) // Custom EaseOut function that is very close to the native one.

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)

        UIView.animate(withDuration: self.transitionDuration,
                       animations: { transitions.forEach { $0.view.frame = $0.toFrame; $0.customAnimation?() } },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        transitions.forEach {
                            if $0.isTemporary {
                                $0.view.removeFromSuperview()
                            } else if let origSuperview = $0.originalSuperview, let superview = $0.view.superview, superview != origSuperview {
                                $0.view.frame = transitionContext.transitionWasCancelled ? $0.originalFrame ?? $0.view.frame : origSuperview.convert($0.view.frame, from: superview)
                                if let index = $0.originalIndex {
                                    origSuperview.insertSubview($0.view, at: index)
                                } else {
                                    origSuperview.addSubview($0.view)
                                }
                            }
                        }
                        if transitionContext.transitionWasCancelled, let fromVC = transitionContext.viewController(forKey: .from) {
                            (self.navigationController as? MSNavigationController)?.updateNavigationBar(using: fromVC)
                        }
        })

        CATransaction.commit()
    }

    /// Creates a transition for two background views that are placed under the "to" and "from" view controllers, and the navigation controller's subviews.
    /// The background that appears on top has a shadow that fades out during the transition.
    private func createBackgroundTransitions(_ transitionContext: UIViewControllerContextTransitioning, frameTransitions : inout ViewFrameTransitionGroups) {
        let fromBgView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: 1.0, height: 1.0)))
        fromBgView.backgroundColor = tintColor

        let toBgView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: 1.0, height: 1.0)))
        toBgView.backgroundColor = tintColor

        let topView = operation == .push ? toBgView : fromBgView
        topView.clipsToBounds = false
        let shadowSubview = UIView(frame: CGRect(x: topView.bounds.origin.x, y: topView.bounds.origin.y, width: 5, height: topView.bounds.size.height))
        shadowSubview.backgroundColor = topView.backgroundColor
        shadowSubview.autoresizingMask = [.flexibleHeight]
        shadowSubview.layer.shadowColor = UIColor.black.cgColor
        shadowSubview.layer.shadowOffset = CGSize(width: -5, height: 0)
        shadowSubview.layer.shadowPath = CGPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 5, height: UIScreen.main.bounds.size.height)), transform: nil)
        shadowSubview.layer.shadowOpacity = 0.32
        topView.addSubview(shadowSubview)

        let bottomView = self.operation == .push ? fromBgView : toBgView
        bottomView.layer.zPosition = -1

        let customAnimation : (() -> Void) = {
            shadowSubview.alpha = 0.0
        }

        let frame = transitionContext.containerView.convert(UIScreen.main.bounds, from: UIScreen.main.coordinateSpace)

        self.createTransition(view: fromBgView, frame: frame, isTemporaryView: true, isToView: false, customAnimation: customAnimation, frameTransitions: &frameTransitions)
        self.createTransition(view: toBgView, frame: frame, isTemporaryView: true, isToView: true, frameTransitions: &frameTransitions)
    }

    /// Creates the transitions for the "to" and "from" view controllers.
    private func createViewControllerTransitions(_ transitionContext: UIViewControllerContextTransitioning, frameTransitions : inout ViewFrameTransitionGroups) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let oldViewFrame = transitionContext.initialFrame(for: fromVC)
        let newViewFrame = transitionContext.finalFrame(for: toVC)

        self.createTransition(view: fromVC.view, frame: oldViewFrame, isTemporaryView: false, isToView: false, frameTransitions: &frameTransitions)
        self.createTransition(view: toVC.view, frame: newViewFrame, isTemporaryView: false, isToView: true, frameTransitions: &frameTransitions)
    }

    /// Creates the transitions for the Navigation Controller which must be an instance of `MSNavigationController`.
    /// All subviews including Navigation Bar and Toolbar are animated.
    private func createNavigationControllerTransitions(_ transitionContext: UIViewControllerContextTransitioning, frameTransitions : inout ViewFrameTransitionGroups) {
        guard let navigationController = self.navigationController as? MSNavigationController else {
            return
        }

        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let oldView = navigationController.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        let finalFrame = navigationController.view.convert(navigationController.view.bounds, to: transitionContext.containerView)
        self.createTransition(view: oldView, frame: finalFrame, isTemporaryView: true, isToView: false, frameTransitions: &frameTransitions)

        navigationController.updateNavigationBar(using: toVC)

        for subview in navigationController.view.subviews {
            guard subview != transitionContext.containerView, !transitionContext.containerView.isDescendant(of: subview) else {
                continue
            }
            let finalFrame = subview.convert(subview.bounds, to: transitionContext.containerView)
            self.createTransition(view: subview, frame: finalFrame, isTemporaryView: false, isToView: true, frameTransitions: &frameTransitions)
        }
    }

    /// Helper method for creating a transition for one view.
    /// - Parameter view: The view to animate.
    /// - Parameter frame: The normal frame of the view.
    /// - Parameter isTemporary: Whether this is a temporary view that exists only during the animation.
    /// - Parameter isToView: Whether this view represents the destination view (the view that is being navigated to).
    /// - Parameter customAnimation: An optional closure executed in the animation block.
    private func createTransition(view: UIView, frame: CGRect, isTemporaryView: Bool, isToView: Bool, customAnimation: (() -> Void)? = nil, frameTransitions : inout ViewFrameTransitionGroups) {
        let isPush = self.operation == .push
        let isOnTop = isToView == isPush

        let origSuperview = view.superview
        let origIndex = view.superview?.subviews.firstIndex(of: view)
        let origFrame = view.frame

        let leftFrame = CGRect(x: isOnTop ? frame.origin.x : frame.size.width * -0.3,
                               y: frame.origin.y,
                               width: frame.size.width,
                               height: frame.height)

        let rightFrame = CGRect(x: isOnTop ? frame.size.width : frame.origin.x,
                                y: frame.origin.y,
                                width: frame.size.width,
                                height: frame.height)

        let transition = ViewFrameTransition(view: view,
                                             fromFrame: isPush ? rightFrame : leftFrame,
                                             toFrame: isPush ? leftFrame : rightFrame,
                                             originalSuperview: origSuperview,
                                             originalFrame: origFrame,
                                             originalIndex: origIndex,
                                             isTemporary: isTemporaryView,
                                             customAnimation: customAnimation)

        if isOnTop {
            frameTransitions.group2.append(transition)
        } else {
            frameTransitions.group1.append(transition)
        }
    }
}
