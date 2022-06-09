//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Shimmer style can be either concealing or revealing
/// The style affects the default shimmer alpha value and the default shimmer tint color
@objc public enum MSFShimmerStyle: Int, CaseIterable {
    /// Concealing shimmer: the gradient conceals parts of the subviews as it moves leaving most parts of the subviews unblocked.
    case concealing

    /// Revealing shimmer: the gradient reveals parts of the subviews as it moves leaving most parts of the subview blocked.
    case revealing
}

/// Design token set for the `Shimmer` control.
open class ShimmerTokens: ControlTokens {
    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer
    public internal(set) var style: MSFShimmerStyle = .revealing

    // MARK: - Design Tokens

    /// The alpha value of the center of the gradient in the animation if shimmer is revealing shimmer
    /// The alpha value of the view other than the gradient if shimmer is concealing shimmer
    open var shimmerAlpha: CGFloat {
        switch style {
        case .concealing:
            return 0
        case .revealing:
            return 0.4
        }
    }

    /// Tint color of the view if shimmer is revealing shimmer
    /// Tint color of the middle of the gradient if shimmer is concealing shimmer
    open var tintColor: DynamicColor {
        switch style {
        case .concealing:
            return DynamicColor(light: globalTokens.neutralColors[.white],
                                dark: globalTokens.neutralColors[.grey8])
        case .revealing:
            return tint
        }
    }

    open var darkGradient: ColorValue {
        return globalTokens.neutralColors[.black]
    }

    open var tint: DynamicColor {
        return DynamicColor(light: ColorValue(0xF1F1F1) /* gray50 */,
                            lightHighContrast: ColorValue(0x919191) /* gray400 */,
                            dark: aliasTokens.backgroundColors[.surfaceQuaternary].dark,
                            darkHighContrast: ColorValue(0x919191) /* gray400 */)
    }

    /// the width of the gradient in the animation
    open var shimmerWidth: CGFloat { 180.0 }

    /// Angle of the direction of the gradient, in radian. 0 means horizontal, Pi/2 means vertical.
    open var shimmerAngle: CGFloat { -(CGFloat.pi / 45.0) }

    /// Speed of the animation, in point/seconds.
    open var shimmerSpeed: CGFloat { 350.0 }

    /// Delay between the end of a shimmering animation and the beginning of the next one.
    open var shimmerDelay: TimeInterval { 0.4 }

    /// Corner radius on each view.
    open var cornerRadius: CGFloat { globalTokens.borderRadius[.medium] }

    /// Corner radius on each UILabel. Set to  0 to disable and use default `cornerRadius`.
    open var labelCornerRadius: CGFloat { globalTokens.borderRadius[.small] }

    /// True to enable shimmers to auto-adjust to font height for a UILabel -- this will more accurately reflect the text in the label rect rather than using the bounding box.
    open var usesTextHeightForLabels: Bool { false }

    /// If greater than 0, a fixed height to use for all UILabels. This will take precedence over `usesTextHeightForLabels`. Set to less than 0 to disable.
    open var labelHeight: CGFloat { 11.0 }

    /// Determines whether we shimmer the top level subviews, or the leaf nodes of the view heirarchy
    open var shimmersLeafViews: Bool { false }
}

// This custom tokens class is used to override only the three ShimmerTokens values
// that we want to expose publicly to consumers of the Shimmer.
open class CustomShimmerTokens: ShimmerTokens {
    @available(*, unavailable)
    required public init() {
        preconditionFailure("init() has not been implemented")
    }

    public init (shimmersLeafViews: Bool?,
                 usesTextHeightForLabels: Bool?,
                 labelHeight: CGFloat?) {
        if let shimmersLeafViews = shimmersLeafViews {
            shimmersLeafViewsOverride = shimmersLeafViews
        }

        if let usesTextHeightForLabels = usesTextHeightForLabels {
            usesTextHeightForLabelsOverride = usesTextHeightForLabels
        }

        if let labelHeight = labelHeight {
            labelHeightOverride = labelHeight
        }

        super.init()
    }

    public override var shimmersLeafViews: Bool {
        self.shimmersLeafViewsOverride ?? super.shimmersLeafViews
    }

    public override var usesTextHeightForLabels: Bool {
        self.usesTextHeightForLabelsOverride ?? super.usesTextHeightForLabels
    }

    public override var labelHeight: CGFloat {
        self.labelHeightOverride ?? super.labelHeight
    }

    var shimmersLeafViewsOverride: Bool?
    var usesTextHeightForLabelsOverride: Bool?
    var labelHeightOverride: CGFloat?
}
