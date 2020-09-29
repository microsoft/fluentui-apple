//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Indeterminate progress bar. Since iOS's UIprogressView is always determinate, this is created for handling indeterminate scenarios.
@objc(MSFIndeterminateProgressBarView)
open class IndeterminateProgressBarView: UIView, ActivityViewAnimating {

    /// The progress bar view should be hidden when animation stops if set to true. The default value is true.
    @objc open var hidesWhenStopped: Bool = true

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: frame.height)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: Constants.progressBarHeight)
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = Constants.progressBarHeight
        autoresizingMask = .flexibleWidth
        clipsToBounds = true
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        trackLayer.removeFromSuperlayer()
        trackLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height)
        layer.addSublayer(trackLayer)

        addGradientLayer()
        stopAnimating()
        animationGroup = addAnimation()
        startAnimating()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateColors()
    }

    @objc open func startAnimating() {
        guard !isAnimating else {
            return
        }
        isAnimating = true

        isHidden = false
        gradientLayer.add(animationGroup, forKey: Constants.animationKey)
    }

    @objc open func stopAnimating() {
        guard isAnimating else {
            return
        }
        isAnimating = false

        if hidesWhenStopped {
            isHidden = true
        }
        gradientLayer.removeAnimation(forKey: Constants.animationKey)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                updateColors()
            }
        }
    }

    private func addGradientLayer() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.height)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
    }

    private func addAnimation() -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()

        let position = CABasicAnimation(keyPath: "position.x")
        position.fromValue = -frame.width / 2
        position.toValue = frame.width * 1.5

        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.keyTimes = Constants.opacityKeyFrame
        opacity.values = Constants.opacityValues
        opacity.isRemovedOnCompletion = false
        opacity.fillMode = CAMediaTimingFillMode.forwards

        groupAnimation.animations = [opacity, position]
        groupAnimation.repeatCount = .infinity
        groupAnimation.duration = Constants.animationDuration
        groupAnimation.timingFunction = Constants.animationTimingFunction
        return groupAnimation
    }

    private func updateColors() {
        if let window = window {
            let appColor = Colors.primary(for: window)
            let edgeColor = appColor.withAlphaComponent(0).cgColor
            let centerColor = appColor.cgColor

            gradientLayer.colors = [edgeColor, centerColor, edgeColor]
            trackLayer.backgroundColor = Colors.Progress.trackTint.cgColor
        }
    }

    private struct Constants {
        static let animationDuration: TimeInterval = 2.5
        static let animationKey: String = "progressAnimation"
        static let animationTimingFunction = CAMediaTimingFunction(controlPoints: 0.28, 0.08, 0.72, 0.92)
        static let opacityKeyFrame: [NSNumber] = [0, 0.375, 0.625, 1]
        static let opacityValues: [NSNumber] = [0.0, 1.0, 1.0, 0.0]
        static let progressBarHeight: CGFloat = 2
    }

    /// progressbar's track
    private var trackLayer = CALayer()

    /// gradient layer that slides across the track
    private var gradientLayer = CAGradientLayer()

    /// The grouped animations that will be applied to the gradient layer
    private var animationGroup = CAAnimationGroup()

    // Don't modify this directly. Instead, call `startAnimating` and `stopAnimating`
    @objc(isAnimating) public private(set) var isAnimating: Bool = false
}
