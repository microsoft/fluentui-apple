//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Shimmer style can be either concealing or revealing
/// The style affects the default shimmer alpha value and the default shimmer tint color
@objc(MSFShimmerViewStyle)
public enum ShimmerStyle: Int, CaseIterable {
    /// Concealing shimmer: the gradient conceals parts of the subviews as it moves leaving most parts of the subviews unblocked.
    case concealing

    /// Revealing shimmer: the gradient reveals parts of the subviews as it moves leaving most parts of the subview blocked.
    case revealing

    var defaultAlphaValue: CGFloat {
        switch self {
        case .concealing:
            return 0
        case .revealing:
            return 0.4
        }
    }

    var defaultTintColor: UIColor {
        switch self {
        case .concealing:
            return Colors.Shimmer.gradientCenter
        case .revealing:
            return Colors.Shimmer.tint
        }
    }
}

@available(*, deprecated, renamed: "ShimmerView")
public typealias MSShimmerView = ShimmerView

/// View that converts the subviews of a container view into a loading state with the "shimmering" effect
@objc(MSFShimmerView)
open class ShimmerView: UIView {

    @available(*, deprecated, message: "Use individual properties instead")
    @objc open var shimmerAppearance = ShimmerAppearance() {
        didSet {
            shimmerAlpha = shimmerAppearance.alpha
            shimmerWidth = shimmerAppearance.width
            shimmerAngle = shimmerAppearance.angle
            shimmerSpeed = shimmerAppearance.speed
            shimmerDelay = shimmerAppearance.delay

            setNeedsLayout()
        }
    }

    /// The alpha value of the center of the gradient in the animation if shimmer is revealing shimmer
    /// The alpha value of the view other than the gradient if shimmer is concealing shimmer
    @objc open var shimmerAlpha: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }

    /// the width of the gradient in the animation
    @objc open var shimmerWidth: CGFloat = defaultWidth {
        didSet {
            setNeedsLayout()
        }
    }

    /// Angle of the direction of the gradient, in radian. 0 means horizontal, Pi/2 means vertical.
    @objc open var shimmerAngle: CGFloat = defaultAngle {
        didSet {
            setNeedsLayout()
        }
    }

    /// Speed of the animation, in point/seconds.
    @objc open var shimmerSpeed: CGFloat = defaultSpeed {
        didSet {
            setNeedsLayout()
        }
    }

    /// Delay between the end of a shimmering animation and the beginning of the next one.
    @objc open var shimmerDelay: TimeInterval = defaultDelay {
        didSet {
            setNeedsLayout()
        }
    }

    @available(*, deprecated, message: "Use individual properties instead")
    @objc open var appearance = ShimmerViewAppearance() {
        didSet {
            viewTintColor = appearance.tintColor
            cornerRadius = appearance.cornerRadius
            labelCornerRadius = appearance.labelCornerRadius
            usesTextHeightForLabels = appearance.usesTextHeightForLabels
            labelHeight = appearance.labelHeight

            setNeedsLayout()
        }
    }

    /// Tint color of the view if shimmer is revealing shimmer
    /// Tint color of the middle of the gradient if shimmer is concealing shimmer
    @objc open var viewTintColor: UIColor = Colors.Shimmer.tint {
        didSet {
            setNeedsLayout()
        }
    }

    /// Corner radius on each view.
    @objc open var cornerRadius: CGFloat = defaultCornerRadius {
        didSet {
            setNeedsLayout()
        }
    }

    /// Corner radius on each UILabel. Set to  0 to disable and use default `cornerRadius`.
    @objc open var labelCornerRadius: CGFloat = defaultLabelCornerRadius {
        didSet {
            setNeedsLayout()
        }
    }

    /// True to enable shimmers to auto-adjust to font height for a UILabel -- this will more accurately reflect the text in the label rect rather than using the bounding box.
    /// `labelHeight` will take precendence over this property.
    @objc open var usesTextHeightForLabels: Bool = defaultUsesTextHeightForLabels {
        didSet {
            setNeedsLayout()
        }
    }

    /// If greater than 0, a fixed height to use for all UILabels. This will take precedence over `usesTextHeightForLabels`. Set to less than 0 to disable.
    @objc open var labelHeight: CGFloat = defaultLabelHeight {
        didSet {
            setNeedsLayout()
        }
    }

    /// Determines whether we shimmer the top level subviews, or the leaf nodes of the view heirarchy
    @objc open var shimmersLeafViews: Bool = defaultShimmersLeafViews {
        didSet {
            setNeedsLayout()
        }
    }

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer
    @objc open var shimmerStyle: ShimmerStyle {
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
                      animationSynchronizer: AnimationSynchronizerProtocol? = nil,
                      shimmerStyle: ShimmerStyle = .revealing) {
        self.containerView = containerView
        self.excludedViews = excludedViews
        self.animationSynchronizer = animationSynchronizer
        self.shimmerStyle = shimmerStyle
        self.viewTintColor = shimmerStyle.defaultTintColor
        self.shimmerAlpha = shimmerStyle.defaultAlphaValue
        super.init(frame: CGRect(origin: .zero, size: containerView?.bounds.size ?? .zero))

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncAnimation),
                                               name: UIAccessibility.reduceMotionStatusDidChangeNotification,
                                               object: nil)
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

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

    /// Manaully sync with the synchronizer
    @objc open func syncAnimation() {
        updateShimmeringAnimation()
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

            let shouldApplyLabelCornerRadius = subview is UILabel && labelCornerRadius >= 0
            coverLayer.cornerRadius = shouldApplyLabelCornerRadius ? labelCornerRadius : cornerRadius
            coverLayer.backgroundColor = viewTintColor.cgColor

            var coverFrame = viewToCover.convert(subview.bounds, from: subview)
            if let label = subview as? UILabel {
                let viewLabelHeight: CGFloat? = {
                    if labelHeight >= 0 {
                        return labelHeight
                    } else if usesTextHeightForLabels {
                        return label.font.deviceLineHeight
                    }
                    return nil
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
        let light = UIColor.white.withAlphaComponent(shimmerAlpha).cgColor
        let dark = Colors.Shimmer.darkGradient.cgColor
        shimmeringLayer.colors = shimmerStyle == .concealing ? [light, dark, light] : [dark, light, dark]

        let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5 - tan(shimmerAngle * (isRTL ? -1 : 1)))
        if isRTL {
            shimmeringLayer.startPoint = endPoint
            shimmeringLayer.endPoint = startPoint
        } else {
            shimmeringLayer.startPoint = startPoint
            shimmeringLayer.endPoint = endPoint
        }

        let widthPercentage = Float(shimmerWidth / shimmeringLayer.frame.width)
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

        let widthPercentage = Float(shimmerWidth / shimmeringLayer.frame.width)

        let fromLocationStart = NSNumber(value: 0.0)
        let fromLocationMiddle = NSNumber(value: widthPercentage / 2.0)
        let fromLocationEnd = NSNumber(value: widthPercentage)

        let toLocationStart = NSNumber(value: 1.0 - widthPercentage)
        let toLocationMiddle = NSNumber(value: 1.0 - (widthPercentage / 2.0))
        let toLocationEnd = NSNumber(value: 1.0)

        // Do not flip values from / to for RTL. These are already relative to the layout direction.
        animation.fromValue = [fromLocationStart, fromLocationMiddle, fromLocationEnd]
        animation.toValue = [toLocationStart, toLocationMiddle, toLocationEnd]

        let distance = (frame.width + shimmerWidth) / cos(shimmerAngle)
        animation.duration = CFTimeInterval(distance / shimmerSpeed)
        animation.fillMode = .forwards

        // Add animation (use a group to add a delay between animations)
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = animation.duration + shimmerDelay
        animationGroup.repeatCount = .infinity
        animationGroup.timeOffset = animationSynchronizer?.timeOffset(for: shimmeringLayer) ?? 0
        shimmeringLayer.add(animationGroup, forKey: "shimmering")
    }

    private func searchLeaves(in view: UIView, output: inout [UIView]) {
        for v in view.subviews {
            if v.subviews.isEmpty && v != self {
                output.append(v)
            } else if !v.isHidden {
                searchLeaves(in: v, output: &output)
            }
        }
    }

    private static let defaultWidth: CGFloat = 180
    private static let defaultAngle: CGFloat = -(CGFloat.pi / 45.0)
    private static let defaultSpeed: CGFloat = 350
    private static let defaultDelay: TimeInterval = 0.4
    private static let defaultCornerRadius: CGFloat = 4.0
    private static let defaultLabelCornerRadius: CGFloat = 2.0
    private static let defaultUsesTextHeightForLabels: Bool = false
    private static let defaultLabelHeight: CGFloat = 11

    private static let defaultShimmersLeafViews: Bool = false
}

public extension Colors {
    struct Shimmer {
        public static var darkGradient: UIColor = .black
        public static var gradientCenter = UIColor(light: .white, dark: gray950)
        public static var tint = UIColor(light: surfaceTertiary, lightHighContrast: Colors.Palette.gray400.color, dark: surfaceQuaternary, darkHighContrast: Colors.Palette.gray400.color)
    }
}
