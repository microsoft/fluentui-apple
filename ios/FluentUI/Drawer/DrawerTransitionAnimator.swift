//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DrawerTransitionAnimator

class DrawerTransitionAnimator: NSObject {
    private struct Constants {
        static let animationDurationMin: TimeInterval = 0.15
        static let animationDurationMax: TimeInterval = 0.25
        static let animationSpeed: CGFloat = 1300   // pixels per second
        static let animationCurve: UIView.AnimationOptions = .curveEaseOut
        static let animationCurveInteractive: UIView.AnimationOptions = .curveLinear
    }

    static let animationCurve: UIView.AnimationCurve = .easeOut

    static func animationDuration(forSizeChange change: CGFloat) -> TimeInterval {
        let duration = TimeInterval(abs(change) / Constants.animationSpeed)
        return max(Constants.animationDurationMin, min(duration, Constants.animationDurationMax))
    }

    static func sizeChange(forPresentedView presentedView: UIView, presentationDirection: DrawerPresentationDirection) -> CGFloat {
        return presentationDirection.isVertical ? presentedView.frame.height : presentedView.frame.width
    }

    let presenting: Bool
    let presentationDirection: DrawerPresentationDirection
    let containerOffset: CGFloat

    init(presenting: Bool, presentationDirection: DrawerPresentationDirection, containerOffset: CGFloat) {
        self.presenting = presenting
        self.presentationDirection = presentationDirection
        self.containerOffset = containerOffset
        super.init()
    }

    private func presentWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning,
                                              completion: @escaping ((Bool) -> Void)) {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to),
              let contentView = presentedView.superview else {
                  completion(true)
                  return
              }

        presentedView.frame = presentedViewRectDismissed(forContentSize: contentView.bounds.size)
        let sizeChange = Self.sizeChange(forPresentedView: presentedView, presentationDirection: presentationDirection)
        let animationDuration = DrawerTransitionAnimator.animationDuration(forSizeChange: sizeChange)
        let options: UIView.AnimationOptions = [
            .beginFromCurrentState,
            transitionContext.isInteractive ? Constants.animationCurveInteractive : Constants.animationCurve
        ]

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: options,
                       animations: {
            presentedView.frame = self.presentedViewRectPresented(forContentSize: contentView.bounds.size)
        },
                       completion: completion)
    }

    private func dismissWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning,
                                              completion: @escaping ((Bool) -> Void)) {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let contentView = presentedView.superview else {
                  completion(true)
                  return
              }

        presentedView.frame = currentRect(for: presentedView)
        let sizeChange = Self.sizeChange(forPresentedView: presentedView, presentationDirection: presentationDirection)
        let animationDuration = DrawerTransitionAnimator.animationDuration(forSizeChange: sizeChange)

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: [.beginFromCurrentState, Constants.animationCurve],
                       animations: {
            presentedView.frame = self.presentedViewRectDismissed(forContentSize: contentView.frame.size)
        },
                       completion: completion)
    }

    private func presentedViewRectDismissed(forContentSize contentSize: CGSize) -> CGRect {
        var rect = presentedViewRectPresented(forContentSize: contentSize)
        switch presentationDirection {
        case .down:
            rect.origin.y = -(contentSize.height - containerOffset)
        case .up:
            rect.origin.y = (contentSize.height - containerOffset)
        case .fromLeading:
            rect.origin.x = -(contentSize.width - containerOffset)
        case .fromTrailing:
            rect.origin.x = (contentSize.width - containerOffset)
        }
        return rect
    }

	private func currentRect(for presentedView: UIView) -> CGRect {
        return presentedView.frame.inset(by: DrawerShadowView.shadowOffsetForPresentedView(with: self.presentationDirection, offset: self.containerOffset))
    }

    private func presentedViewRectPresented(forContentSize contentSize: CGSize) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height).inset(by: DrawerShadowView.shadowOffsetForPresentedView(with: self.presentationDirection, offset: self.containerOffset))
    }
}

// MARK: - DrawerTransitionAnimator: UIViewControllerAnimatedTransitioning

extension DrawerTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // Cannot provide a value here since it's dynamically calculated from the change of a size, which is not available here.
        // As a consequence, animations running along are not supported.
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            presentWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        } else {
            dismissWithTransitionContext(transitionContext) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}
