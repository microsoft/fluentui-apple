//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerTransitionAnimator

class MSDrawerTransitionAnimator: NSObject {
    private struct Constants {
        static let animationDuration: TimeInterval = 0.2
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
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            presentedView.frame = self.presentedViewRectPresented(forContentSize: presentedView.frame.size)
        }, completion: completion)
    }

    private func dismissWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning, completion: @escaping ((Bool) -> Void)) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
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
        return Constants.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            presentWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        }
        else {
            dismissWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
