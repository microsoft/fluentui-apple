//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

class MSCardTransitionAnimator: NSObject {
    struct Constants {
        static let animationDuration: TimeInterval = 0.15
        static let presentationInScale: CGFloat = 0.65
        static let presentationOutScale: CGFloat = 0.9
        static let presentationAnchorMax = CGPoint(x: 0.85, y: 0.8)
        static let presentationAnchorDistanceMax = CGPoint(x: 200, y: 90)
        static let presentationAnchorDistanceMin = CGPoint(x: 50, y: 40)
    }

    private let presenting: Bool
    private let scaledView: UIView
    private var sourceView: UIView?
    private var sourceRect: CGRect?

    init(presenting: Bool, scaledView: UIView, sourceView: UIView?, sourceRect: CGRect?) {
        self.presenting = presenting
        self.scaledView = scaledView
        self.sourceView = sourceView
        self.sourceRect = sourceRect

        super.init()
    }

    /// Compute the anchor point for the transition so that the view appears to come from the right direction
    private func anchorPointForTransition(fromScaledView scaledView: UIView, containerView: UIView) -> CGPoint {
        guard let sourceView = sourceView, let sourceRect = sourceRect else {
            return CGPoint(x: 0.5, y: 0.5)
        }

        let rect = sourceView.convert(sourceRect, to: containerView)
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )
        let distance = CGPoint(
            x: abs(scaledView.center.x - center.x),
            y: abs(scaledView.center.y - center.y)
        )

        var anchorX: CGFloat
        if distance.x < Constants.presentationAnchorDistanceMin.x {
            // Min distance between center and sourceRect not reached
            anchorX = 0.5
        } else {
            anchorX = Constants.presentationAnchorMax.x * min(distance.x / (Constants.presentationAnchorDistanceMax.x - Constants.presentationAnchorDistanceMin.x), 1)
        }

        var anchorY: CGFloat
        if distance.y < Constants.presentationAnchorDistanceMin.y {
            // Min distance between center and sourceRect not reached
            anchorY = 0.5
        } else {
            anchorY = Constants.presentationAnchorMax.y * min(distance.x / (Constants.presentationAnchorDistanceMax.y - Constants.presentationAnchorDistanceMin.y), 1)
        }

        if scaledView.center.x > center.x {
            anchorX = 1 - anchorX
        }
        if scaledView.center.y > center.y {
            anchorY = 1 - anchorY
        }

        return CGPoint(x: anchorX, y: anchorY)
    }

    private func present(withTransitionContext transitionContext: UIViewControllerContextTransitioning, completion: @escaping (Bool) -> Void) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView

        // Animation start state
        presentedView.frame = containerView.bounds
        presentedView.alpha = 0
        presentedView.layoutIfNeeded()

        let scaledViewFrame = scaledView.frame
        scaledView.layer.anchorPoint = anchorPointForTransition(fromScaledView: scaledView, containerView: containerView)
        scaledView.transform = CGAffineTransform(scaleX: Constants.presentationInScale, y: Constants.presentationInScale)

        // Start animation
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            // Animation end state
            self.scaledView.transform = CGAffineTransform.identity
            presentedView.alpha = 1
        }, completion: { finished in
            completion(finished)
            // Reset frame because anchor point changes
            self.scaledView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.scaledView.frame = scaledViewFrame
        })
    }

    private func dismiss(withTransitionContext transitionContext: UIViewControllerContextTransitioning, completion: @escaping (Bool) -> Void) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView

        // Animation start state
        let scaledViewFrame = scaledView.frame
        scaledView.layer.anchorPoint = anchorPointForTransition(fromScaledView: scaledView, containerView: containerView)
        scaledView.frame = scaledViewFrame

        // Start animation
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            // Animation end state
            self.scaledView.transform = CGAffineTransform(scaleX: Constants.presentationOutScale, y: Constants.presentationOutScale)
            presentedView.alpha = 0
        }, completion: completion)
    }
}

// MARK: - MSCardTransitionAnimator: UIViewControllerAnimatedTransitioning

extension MSCardTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            present(withTransitionContext: transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        } else {
            dismiss(withTransitionContext: transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
