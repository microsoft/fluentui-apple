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
            return DynamicColor(light: ColorValue(0xF1F1F1) /* gray50 */,
                                lightHighContrast: ColorValue(0x919191) /* gray400 */,
                                dark: aliasTokens.backgroundColors[.surfaceQuaternary].dark,
                                darkHighContrast: ColorValue(0x919191) /* gray400 */)
        }
    }

    ///  Color of the darkest part of the shimmer's gradient.
    open var darkGradient: ColorValue {
        return globalTokens.neutralColors[.black]
    }

    /// The width of the gradient in the animation.
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

    /// Height of shimmering labels.
    open var labelHeight: CGFloat { 11.0 }

    /// Spacing between (if lines > 1).
    open var labelSpacing: CGFloat { aliasTokens.globalTokens.spacing[.small] }

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer
    public internal(set) var style: MSFShimmerStyle = .revealing
}
