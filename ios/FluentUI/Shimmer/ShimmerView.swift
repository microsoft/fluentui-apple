//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "ShimmerView")
public typealias MSShimmerView = ShimmerView

/// View that converts the subviews of a container view into a loading state with the "shimmering" effect
@objc(MSFShimmerView)
open class ShimmerView: UIView {
    /// Appearance of the shimmer itself (the animation appearance)
    @objc open var shimmerAppearance = ShimmerAppearance() {
        didSet {
            setNeedsLayout()
        }
    }

    /// Properties related to the apperance of the shimmer view itself
    @objc open var appearance = ShimmerViewAppearance() {
        didSet {
            setNeedsLayout()
        }
    }

    /// Optional synchronizer to sync multiple shimmer views
    @objc open weak var animationSynchronizer: AnimationSynchronizerProtocol?

    open override var intrinsicContentSize: CGSize { return bounds.size }

    /// Layers covering the subviews of the container
    var viewCoverLayers = [CALayer]()

    /// Layer that slides to provide the "shimmer" effect
    var shimmeringLayer = CAGradientLayer()

    private weak var containerView: UIView?
    private var excludedViews: [UIView]

    /// Create a shimmer view
    /// - Parameter containerView: view to convert layout into a shimmer -- each of containerView's first-level subviews will be mirrored
    /// - Parameter excludedViews: subviews of `containerView` to exclude from shimmer
    /// - Parameter animationSynchronizer: optional synchronizer to sync multiple shimmer views
    @objc public init(containerView: UIView? = nil,
                      excludedViews: [UIView] = [],
                      animationSynchronizer: AnimationSynchronizerProtocol? = nil) {
        self.containerView = containerView
        self.excludedViews = excludedViews
        self.animationSynchronizer = animationSynchronizer
        super.init(frame: CGRect(origin: .zero, size: containerView?.bounds.size ?? .zero))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updateViewCoverLayers()

        guard let containerView = containerView else {
            return
        }

        shimmeringLayer.frame = CGRect(x: -containerView.frame.width,
                                       y: 0.0,
                                       width: containerView.bounds.width + 2 * containerView.frame.width,
                                       height: containerView.frame.height)

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    /// Manaully sync with the synchronizer
    @objc open func syncAnimation() {
        updateShimmeringAnimation()
    }

    /// Update the frame of each layer covering views in the containerView
    func updateViewCoverLayers() {
        guard let containerView = containerView else {
            return
        }

        viewCoverLayers.forEach { $0.removeFromSuperlayer() }

        let subviews = Set(containerView.subviews).subtracting(Set(excludedViews))

        viewCoverLayers = subviews.filter({ !$0.isHidden && !($0 is ShimmerView) }).map { subview in
            let coverLayer = CALayer()

            let shouldApplyLabelCornerRadius = subview is UILabel && appearance.labelCornerRadius >= 0
            coverLayer.cornerRadius = shouldApplyLabelCornerRadius ? appearance.labelCornerRadius : appearance.cornerRadius
            coverLayer.backgroundColor = appearance.tintColor.cgColor

            var coverFrame = subview.frame
            if let label = subview as? UILabel {
                let labelHeight: CGFloat? = {
                    if appearance.labelHeight >= 0 {
                        return appearance.labelHeight
                    } else if appearance.usesTextHeightForLabels {
                        return label.font.deviceLineHeight
                    }
                    return nil
                }()

                if let labelHeight = labelHeight {
                    let delta = coverFrame.height - labelHeight
                    coverFrame.size.height = labelHeight
                    coverFrame.origin.y += delta / 2
                }
            }
            coverLayer.frame = coverFrame

            return coverLayer
        }

        viewCoverLayers.forEach { layer.addSublayer($0) }
    }

    /// Update the gradient layer that animates to provide the shimmer effect (also updates the animation)
    func updateShimmeringLayer() {
        let light = UIColor.white.withAlphaComponent(shimmerAppearance.alpha).cgColor
        let dark = UIColor.black.cgColor
        let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft

        shimmeringLayer.colors = [dark, light, dark]

        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5 - tan(shimmerAppearance.angle * (isRTL ? -1 : 1)))
        if isRTL {
            shimmeringLayer.startPoint = endPoint
            shimmeringLayer.endPoint = startPoint
        } else {
            shimmeringLayer.startPoint = startPoint
            shimmeringLayer.endPoint = endPoint
        }

        let widthPercentage = Float(shimmerAppearance.width / shimmeringLayer.frame.width)
        let locationStart = NSNumber(value: 0.5 - widthPercentage / 2)
        let locationMiddle = NSNumber(value: 0.5)
        let locationEnd = NSNumber(value: 0.5 + widthPercentage / 2)

        let locations = [locationStart, locationMiddle, locationEnd]
        shimmeringLayer.locations = isRTL ? locations.reversed() : locations

        layer.mask = shimmeringLayer

        updateShimmeringAnimation()
    }

    /// Update the shimmer animation
    func updateShimmeringAnimation() {
        if let animationSynchronizer = animationSynchronizer, animationSynchronizer.referenceLayer == nil {
            animationSynchronizer.referenceLayer = shimmeringLayer
        }

        shimmeringLayer.removeAnimation(forKey: "shimmering")

        let animation = CABasicAnimation(keyPath: "locations")

        let widthPercentage = Float(shimmerAppearance.width / shimmeringLayer.frame.width)

        let fromLocationStart = NSNumber(value: 0.0)
        let fromLocationMiddle = NSNumber(value: widthPercentage / 2.0)
        let fromLocationEnd = NSNumber(value: widthPercentage)

        let toLocationStart = NSNumber(value: 1.0 - widthPercentage)
        let toLocationMiddle = NSNumber(value: 1.0 - (widthPercentage / 2.0))
        let toLocationEnd = NSNumber(value: 1.0)

        // Do not flip values from / to for RTL. These are already relative to the layout direction.
        animation.fromValue = [fromLocationStart, fromLocationMiddle, fromLocationEnd]
        animation.toValue = [toLocationStart, toLocationMiddle, toLocationEnd]

        let distance = (frame.width + shimmerAppearance.width) / cos(shimmerAppearance.angle)
        animation.duration = CFTimeInterval(distance / shimmerAppearance.speed)
        animation.fillMode = .forwards

        // Add animation (use a group to add a delay between animations)
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = animation.duration + shimmerAppearance.delay
        animationGroup.repeatCount = .infinity
        animationGroup.timeOffset = animationSynchronizer?.timeOffset(for: shimmeringLayer) ?? 0
        shimmeringLayer.add(animationGroup, forKey: "shimmering")
    }
}
