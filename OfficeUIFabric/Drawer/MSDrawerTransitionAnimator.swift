//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerTransitionAnimator

class MSDrawerTransitionAnimator: NSObject {
    private struct Constants {
        static let animationDurationMin: TimeInterval = 0.15
        static let animationDurationMax: TimeInterval = 0.25
        static let animationSpeed: CGFloat = 1300   // pixels per second
    }

    static func animationDuration(forSizeChange change: CGFloat) -> TimeInterval {
        let duration = TimeInterval(abs(change) / Constants.animationSpeed)
        return max(Constants.animationDurationMin, min(duration, Constants.animationDurationMax))
    }

    let presenting: Bool
    let presentationDirection: MSDrawerPresentationDirection

    init(presenting: Bool, presentationDirection: MSDrawerPresentationDirection) {
        self.presenting = presenting
        self.presentationDirection = presentationDirection
        super.init()
    }

    private func presentWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning, completion: @escaping ((Bool) -> Void)) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let contentView = presentedView.superview!

        presentedView.frame = presentedViewRectDismissed(forContentSize: contentView.bounds.size)
        let animationDuration = MSDrawerTransitionAnimator.animationDuration(forSizeChange: presentedView.height)
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            presentedView.frame = self.presentedViewRectPresented(forContentSize: presentedView.frame.size)
        }, completion: completion)
    }

    private func dismissWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning, completion: @escaping ((Bool) -> Void)) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

        let animationDuration = MSDrawerTransitionAnimator.animationDuration(forSizeChange: presentedView.height)
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            presentedView.frame = self.presentedViewRectDismissed(forContentSize: presentedView.frame.size)
        }, completion: completion)
    }

    private func presentedViewRectDismissed(forContentSize contentSize: CGSize) -> CGRect {
        var rect = presentedViewRectPresented(forContentSize: contentSize)
        switch presentationDirection {
        case .down:
            rect.origin.y = -contentSize.height
        case .up:
            rect.origin.y = contentSize.height
        }
        return rect
    }

    private func presentedViewRectPresented(forContentSize contentSize: CGSize) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
    }
}

// MARK: - MSDrawerTransitionAnimator: UIViewControllerAnimatedTransitioning

extension MSDrawerTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // Cannot provide a value here since it's dynamically calculated from the change of a size, which is not available here.
        // As a consequence, animations running along are not supported.
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            presentWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        } else {
            dismissWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
