//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// View that converts the subviews of a container view into a loading state with the "shimmering" effect
@objc(MSFShimmerView)
open class ShimmerView: UIView, TokenizedControlInternal {

    /// Optional synchronizer to sync multiple shimmer views
    @objc open weak var animationSynchronizer: AnimationSynchronizerProtocol?

    open override var intrinsicContentSize: CGSize { return bounds.size }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updateViewCoverLayers()

        let viewToCover = containerView ?? self

        shimmeringLayer.frame = CGRect(x: -viewToCover.frame.width,
                                       y: 0.0,
                                       width: viewToCover.bounds.width + 2 * viewToCover.frame.width,
                                       height: viewToCover.frame.height)

        updateShimmeringLayer()
        updateShimmeringAnimation()
    }

    /// Create a shimmer view
    /// - Parameter containerView: view to convert layout into a shimmer -- each of containerView's first-level subviews will be mirrored
    /// - Parameter excludedViews: subviews of `containerView` to exclude from shimmer
    /// - Parameter animationSynchronizer: optional synchronizer to sync multiple shimmer views
    /// - Parameter shimmerStyle: determines whether the shimmer is a revealing shimmer or a concealing shimmer
    /// - Parameter shimmersLeafViews: True to enable shimmers to auto-adjust to font height for a UILabel -- this will more accurately reflect the text in the label rect rather than using the bounding box.
    /// - Parameter usesTextHeightForLabels: Determines whether we shimmer the top level subviews, or the leaf nodes of the view hierarchy. If false, we use default height of 11.0
    @objc public init(containerView: UIView? = nil,
                      excludedViews: [UIView] = [],
                      animationSynchronizer: AnimationSynchronizerProtocol? = nil,
                      shimmerStyle: MSFShimmerStyle = .revealing,
                      shimmersLeafViews: Bool = false,
                      usesTextHeightForLabels: Bool = false) {
        self.style = shimmerStyle

        let tokens = ShimmerTokens()
        tokens.style = style
        self.tokens = tokens

        self.containerView = containerView
        self.excludedViews = excludedViews
        self.animationSynchronizer = animationSynchronizer
        self.shimmersLeafViews = shimmersLeafViews
        self.usesTextHeightForLabels = usesTextHeightForLabels
        super.init(frame: CGRect(origin: .zero, size: containerView?.bounds.size ?? .zero))

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncAnimation),
                                               name: UIAccessibility.reduceMotionStatusDidChangeNotification,
                                               object: nil)
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Manaully sync with the synchronizer
    @objc public func syncAnimation() {
        updateShimmeringAnimation()
    }

    public var tokens: ShimmerTokens = .init()

    // MARK: - TokenizedControl
    public typealias TokenType = ShimmerTokens
    public func overrideTokens(_ tokens: ShimmerTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    /// Style to draw the control.
    public var style: MSFShimmerStyle {
        didSet {
            tokens.style = style
        }
    }

    /// Update the frame of each layer covering views in the containerView
    func updateViewCoverLayers() {
        let viewToCover = containerView ?? self

        viewCoverLayers.forEach { $0.removeFromSuperlayer() }

        let subviews: Set<UIView> = {
            if shimmersLeafViews {
                var leaves = [UIView]()
                searchLeaves(in: viewToCover, output: &leaves)
                return Set(leaves).subtracting(Set(excludedViews))
            } else {
                return Set(viewToCover.subviews).subtracting(Set(excludedViews))
            }
        }()

        viewCoverLayers = subviews.filter({ !$0.isHidden && !($0 is ShimmerView) }).map { subview in
            let coverLayer = CALayer()

            let shouldApplyLabelCornerRadius = subview is UILabel && tokens.labelCornerRadius >= 0
            coverLayer.cornerRadius = shouldApplyLabelCornerRadius ? tokens.labelCornerRadius : tokens.cornerRadius
            coverLayer.backgroundColor = UIColor(dynamicColor: tokens.tintColor).cgColor

            var coverFrame = viewToCover.convert(subview.bounds, from: subview)
            if let label = subview as? UILabel {
                let viewLabelHeight: CGFloat? = {
                    if usesTextHeightForLabels {
                        return label.font.deviceLineHeight
                    } else {
                        return tokens.labelHeight
                    }
                }()

                if let viewLabelHeight = viewLabelHeight {
                    let delta = coverFrame.height - viewLabelHeight
                    coverFrame.size.height = viewLabelHeight
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
        let light = UIColor.white.withAlphaComponent(tokens.shimmerAlpha).cgColor
        let dark = UIColor(colorValue: tokens.darkGradient).cgColor
        shimmeringLayer.colors = self.style == .concealing ? [light, dark, light] : [dark, light, dark]

        let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5 - tan(tokens.shimmerAngle * (isRTL ? -1 : 1)))
        if isRTL {
            shimmeringLayer.startPoint = endPoint
            shimmeringLayer.endPoint = startPoint
        } else {
            shimmeringLayer.startPoint = startPoint
            shimmeringLayer.endPoint = endPoint
        }

        let widthPercentage = Float(tokens.shimmerWidth / shimmeringLayer.frame.width)
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
        shimmeringLayer.removeAnimation(forKey: "shimmering")

        // For usability/accessibility reasons, the animation is not added if the user
        // has the "reduce motion" enabled on the device.
        guard !UIAccessibility.isReduceMotionEnabled else {
            return
        }

        if let animationSynchronizer = animationSynchronizer, animationSynchronizer.referenceLayer == nil {
            animationSynchronizer.referenceLayer = shimmeringLayer
        }

        let animation = CABasicAnimation(keyPath: "locations")

        let widthPercentage = Float(tokens.shimmerWidth / shimmeringLayer.frame.width)

        let fromLocationStart = NSNumber(value: 0.0)
        let fromLocationMiddle = NSNumber(value: widthPercentage / 2.0)
        let fromLocationEnd = NSNumber(value: widthPercentage)

        let toLocationStart = NSNumber(value: 1.0 - widthPercentage)
        let toLocationMiddle = NSNumber(value: 1.0 - (widthPercentage / 2.0))
        let toLocationEnd = NSNumber(value: 1.0)

        // Do not flip values from / to for RTL. These are already relative to the layout direction.
        animation.fromValue = [fromLocationStart, fromLocationMiddle, fromLocationEnd]
        animation.toValue = [toLocationStart, toLocationMiddle, toLocationEnd]

        let distance = (frame.width + tokens.shimmerWidth) / cos(tokens.shimmerAngle)
        animation.duration = CFTimeInterval(distance / tokens.shimmerSpeed)
        animation.fillMode = .forwards

        // Add animation (use a group to add a delay between animations)
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = animation.duration + tokens.shimmerDelay
        animationGroup.repeatCount = .infinity
        animationGroup.timeOffset = animationSynchronizer?.timeOffset(for: shimmeringLayer) ?? 0
        shimmeringLayer.add(animationGroup, forKey: "shimmering")
    }

    var defaultTokens: ShimmerTokens = .init()
    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ShimmerTokens? {
        didSet {
            tokens = resolvedTokens
        }
    }

    /// Layers covering the subviews of the container
    var viewCoverLayers = [CALayer]()

    /// Layer that slides to provide the "shimmer" effect
    var shimmeringLayer = CAGradientLayer()

    private func searchLeaves(in view: UIView, output: inout [UIView]) {
        for v in view.subviews {
            if v.subviews.isEmpty && v != self {
                output.append(v)
            } else if !v.isHidden {
                searchLeaves(in: v, output: &output)
            }
        }
    }

    private var shimmersLeafViews: Bool
    private var usesTextHeightForLabels: Bool
    private var excludedViews: [UIView]
    private weak var containerView: UIView?
}
