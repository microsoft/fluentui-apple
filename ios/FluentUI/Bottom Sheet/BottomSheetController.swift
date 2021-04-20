//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFBottomSheeControllerDelegate)
public protocol BottomSheetControllerDelegate: AnyObject {
    /// Called after the sheet fully expanded.
    @objc optional func bottomSheetControllerDidExpand(_ controller: BottomSheetController)

    /// Called after the sheet fully collapsed.
    @objc optional func bottomSheetControllerDidCollapse(_ controller: BottomSheetController)
}

@objc(MSFBottomSheetController)
public class BottomSheetController: UIViewController {

    open var contentViewController: UIViewController? {
        didSet {
            if let oldViewController = oldValue {
                oldViewController.willMove(toParent: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
            }

            if let newViewController = contentViewController {
                addChild(newViewController)
                contentContainer.addSubview(newViewController.view)
                newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                newViewController.didMove(toParent: self)

                NSLayoutConstraint.activate([
                    newViewController.view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
                    newViewController.view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                    newViewController.view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
                    newViewController.view.topAnchor.constraint(equalTo: contentContainer.topAnchor)
                ])
                updateBottomSheetHeightConstraints()
            }
        }
    }

    open var hostedScrollView: UIScrollView?

    open var isExpandable: Bool = true {
        didSet {
            if isExpandable != oldValue {
                if isExpandable {
                    resizingHandleView.isHidden = false
                    panGestureRecognizer.isEnabled = true
                } else {
                    resizingHandleView.isHidden = true
                    panGestureRecognizer.isEnabled = false
                }
                move(to: collapsedOffsetFromBottom, animated: false)
            }
        }
    }

    open var respectsPreferredContentSize: Bool = false {
        didSet {
            if respectsPreferredContentSize != oldValue {
                updateBottomSheetHeightConstraints()
            }
        }
    }

    open var preferredExpandedHeightFraction: CGFloat = 1.0 {
        didSet {
            if preferredExpandedHeightFraction != oldValue && !respectsPreferredContentSize {
                updateBottomSheetHeightConstraints()
            }
        }
    }

    open var collapsedContentHeight: CGFloat = Constants.defaultCollapsedContentHeight

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

    private lazy var contentContainer: UIView = {
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        return contentContainer
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
        let bottomSheet = UIView()
        bottomSheet.backgroundColor = Colors.NavigationBar.background
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.layer.cornerRadius = Constants.cornerRadius
        bottomSheet.layer.cornerCurve = .continuous
        bottomSheet.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomSheet.layer.shadowColor = Constants.Shadow.color
        bottomSheet.layer.shadowOpacity = Constants.Shadow.opacity
        bottomSheet.layer.shadowOffset = Constants.Shadow.offset
        bottomSheet.layer.shadowRadius = Constants.Shadow.radius

        let shadowLayer = CAShapeLayer()

        shadowLayer.path = UIBezierPath(roundedRect: view.bounds,
                                      cornerRadius: view.layer.cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.fillColor = view.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 5.0
        view.layer.insertSublayer(shadowLayer, at: 0)

        let stackView = UIStackView(arrangedSubviews: [resizingHandleView, contentContainer])
        stackView.spacing = 0.0
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        bottomSheet.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bottomSheet.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomSheet.bottomAnchor, constant: -Constants.bottomOverflowHeight)
        ])

        return bottomSheet
    }()

    private lazy var bottomSheetHeightConstraints = generateBottomSheetHeightConstraints()

    private lazy var bottomSheetOffsetConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -collapsedOffsetFromBottom)

    private var currentOffsetFromBottom: CGFloat {
        -bottomSheetOffsetConstraint.constant
    }

    private var collapsedOffsetFromBottom: CGFloat {
        collapsedContentHeight + (isExpandable ? ResizingHandleView.height : 0.0)
    }

    private var translationAnimator: UIViewPropertyAnimator?

    override public func loadView() {
        view = PassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bottomSheetView)
        bottomSheetView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self

        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetOffsetConstraint
        ])
    }

    @objc private func handleResizingHandleViewTap(_ sender: UITapGestureRecognizer) {
        if currentOffsetFromBottom != collapsedOffsetFromBottom {
            animate(to: collapsedOffsetFromBottom, velocity: 0)
        } else {
            animate(to: expandedOffsetFromBottom, velocity: 0)
        }
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch (sender.state) {
        case .began:
            stopAnimationIfNeeded()
        case .changed:
            let translation = sender.translation(in: view)
            let maxOffset = expandedOffsetFromBottom + Constants.maxRubberBandOffset
            let minOffset = collapsedOffsetFromBottom - Constants.maxRubberBandOffset

            if currentOffsetFromBottom > collapsedOffsetFromBottom && currentOffsetFromBottom < expandedOffsetFromBottom {
                bottomSheetOffsetConstraint.constant = -clamp(currentOffsetFromBottom - translation.y, minOffset, maxOffset)
            } else {
                // TODO: Only apply rubber band in the correct direction
                // We're in the rubber band territory. Let's clamp the translation to something sensible so we don't jump right to the edge before the scale can kick in.
                let clampedTranslation = clamp(translation.y, -5, 5)
                bottomSheetOffsetConstraint.constant = -clamp(currentOffsetFromBottom - (clampedTranslation * translationScaleFactor), minOffset, maxOffset)
            }
            sender.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            completePan(with: sender.velocity(in: view).y)
        default:
            break
        }
    }

    private func updateBottomSheetHeightConstraints() {
        NSLayoutConstraint.deactivate(bottomSheetHeightConstraints)
        let newConstraints = generateBottomSheetHeightConstraints()
        NSLayoutConstraint.activate(newConstraints)
        bottomSheetHeightConstraints = newConstraints
        view.setNeedsLayout()
    }

    private func generateBottomSheetHeightConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint]
        if respectsPreferredContentSize, let contentVC = contentViewController {
            let size = contentVC.preferredContentSize

            let preferredHeightConstraint = contentContainer.heightAnchor.constraint(equalToConstant: size.height)
            preferredHeightConstraint.priority = .defaultLow

            let maxHeightConstraint = bottomSheetView.heightAnchor.constraint(
                lessThanOrEqualTo: view.heightAnchor,
                constant: Constants.bottomOverflowHeight - view.safeAreaInsets.top - Constants.minimumTopExpandedPadding)
            constraints = [preferredHeightConstraint, maxHeightConstraint]
        } else {
            constraints = [
                bottomSheetView.heightAnchor.constraint(
                    equalTo: view.heightAnchor,
                    multiplier: preferredExpandedHeightFraction,
                    constant: Constants.bottomOverflowHeight - view.safeAreaInsets.top - Constants.minimumTopExpandedPadding)]
        }
        return constraints
    }



    private func completePan(with velocity: CGFloat) {
        if abs(velocity) < 150 {
            // Velocity too low, snap to the closest offset
            if abs(collapsedOffsetFromBottom - currentOffsetFromBottom) < abs(expandedOffsetFromBottom - currentOffsetFromBottom) {
                move(to: collapsedOffsetFromBottom, velocity: velocity)
            } else {
                move(to: expandedOffsetFromBottom, velocity: velocity)
            }
        } else {
            // Velocity high enough, animate to the offset we're swiping towards
            if velocity > 0 {
                move(to: collapsedOffsetFromBottom, velocity: velocity)
            } else {
                move(to: expandedOffsetFromBottom, velocity: velocity)
            }
        }
    }

    private func move(to targetOffsetFromBottom: CGFloat, animated: Bool = true, velocity: CGFloat = 0.0) {
        if animated {
            animate(to: targetOffsetFromBottom, velocity: velocity)
        } else {
            bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
            view.setNeedsLayout()
        }
    }

    private func animate(to targetOffsetFromBottom: CGFloat, velocity: CGFloat = 0.0) {
        let distanceToGo = abs(currentOffsetFromBottom - targetOffsetFromBottom)
        let springVelocity = min(abs(velocity / distanceToGo), Constants.maxInitialSpringVelocity)
        let damping: CGFloat = velocity > Constants.flickVelocityThreshold ? 0.8 : 1.0

        let springParams = UISpringTimingParameters(dampingRatio: damping, initialVelocity: CGVector(dx: 0.0, dy: springVelocity))
        translationAnimator = UIViewPropertyAnimator(duration: 0.4, timingParameters: springParams)

        view.layoutIfNeeded()
        bottomSheetOffsetConstraint.constant = -targetOffsetFromBottom
        translationAnimator?.addAnimations {
            self.view.layoutIfNeeded()
        }
        translationAnimator?.startAnimation()
    }

    private func stopAnimationIfNeeded() {
        guard let animator = translationAnimator else {
            return
        }

        if animator.isRunning {
            animator.stopAnimation(true)

            // The AutoLayout constant doesn't animate, so we need to set it to where it should be
            // based on the frame calculated during the interrupted animation
            let offsetFromBottom = view.frame.height - bottomSheetView.frame.origin.y
            bottomSheetOffsetConstraint.constant = -offsetFromBottom
        }
    }

    var expandedOffsetFromBottom: CGFloat {
        return bottomSheetView.frame.height - Constants.bottomOverflowHeight
    }

    var translationScaleFactor: CGFloat {
        let offsetFromBottom = currentOffsetFromBottom


        var offLimitsOffset: CGFloat = 0.0
        if offsetFromBottom > expandedOffsetFromBottom {
            offLimitsOffset = min(offsetFromBottom - expandedOffsetFromBottom, Constants.maxRubberBandOffset)
        } else if offsetFromBottom < collapsedOffsetFromBottom {
            offLimitsOffset = min(collapsedOffsetFromBottom - offsetFromBottom, Constants.maxRubberBandOffset)
        }

        let scaleFactor: CGFloat = 1.0 - offLimitsOffset / Constants.maxRubberBandOffset

        return scaleFactor * scaleFactor
    }

    private struct Constants {
        static let cornerRadius: CGFloat = 14
        static let maxRubberBandOffset: CGFloat = 20.0
        static let maxInitialSpringVelocity: CGFloat = 40.0
        static let flickVelocityThreshold: CGFloat = 2500
        static let bottomOverflowHeight: CGFloat = 50.0
        static let minimumTopExpandedPadding: CGFloat = 25.0

        static let defaultCollapsedContentHeight: CGFloat = 75

        struct Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.14
            static let radius: CGFloat = 8
            static let offset: CGSize = CGSize(width: 0, height: 4)
        }
    }

    private func clamp<T>(_ n: T, _ minimum: T, _ maximum: T) -> T where T : Comparable {
        return min(max(n, minimum), maximum)
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
        if scrollView.bounds.contains(panGesture.location(in: scrollView)) {
            let scrolledToTop = scrollView.contentOffset.y <= 0
            let panningDown = panGesture.velocity(in: view).y > 0
            let fullyExpanded = currentOffsetFromBottom >= expandedOffsetFromBottom

            if fullyExpanded && (!scrolledToTop || (scrolledToTop && !panningDown)) {
                shouldBegin = false
            }
        }
        return shouldBegin
    }
}

private class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
