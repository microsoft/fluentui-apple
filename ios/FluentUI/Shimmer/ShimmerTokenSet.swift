//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Shimmer style can be either concealing or revealing.
/// The style affects the default shimmer alpha value and the default shimmer tint color.
@objc public enum MSFShimmerStyle: Int, CaseIterable {
    /// Concealing shimmer: the gradient conceals parts of the subviews as it moves leaving most parts of the subviews unblocked.
    case concealing

    /// Revealing shimmer: the gradient reveals parts of the subviews as it moves leaving most parts of the subview blocked.
    case revealing
}

public enum ShimmerToken: Int, TokenSetKey {
    /// The alpha value of the center of the gradient in the animation if shimmer is revealing shimmer.
    /// The alpha value of the view other than the gradient if shimmer is concealing shimmer.
    case shimmerAlpha

    /// Tint color of the view if shimmer is revealing shimmer.
    /// Tint color of the middle of the gradient if shimmer is concealing shimmer.
    case tintColor

    ///  Color of the darkest part of the shimmer's gradient.
    case darkGradient

    /// The width of the gradient in the animation.
    case shimmerWidth

    /// Angle of the direction of the gradient, in radian. 0 means horizontal, Pi/2 means vertical.
    case shimmerAngle

    /// Speed of the animation, in point/seconds.
    case shimmerSpeed

    /// Delay between the end of a shimmering animation and the beginning of the next one.
    case shimmerDelay

    /// Corner radius on each view.
    case cornerRadius

    /// Corner radius on each UILabel. Set to  0 to disable and use default `cornerRadius`.
    case labelCornerRadius

    /// Height of shimmering labels.
    case labelHeight

    /// Spacing between (if lines > 1).
    case labelSpacing
}

/// Design token set for the `Shimmer` control.
public class ShimmerTokenSet: ControlTokenSet<ShimmerToken> {
    init(style: @escaping () -> MSFShimmerStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .shimmerAlpha:
                return .float {
                    switch style() {
                    case .concealing:
                        return 0
                    case .revealing:
                        return 0.4
                    }
                }

            case .tintColor:
                return .uiColor {
                    switch style() {
                    case .concealing:
                        return theme.color(.stencil2)
                    case .revealing:
                        return theme.color(.stencil1)
                    }
                }

            case .darkGradient:
                return .uiColor { theme.color(.foregroundDarkStatic) }

            case .shimmerWidth:
                return .float { 180.0 }

            case .shimmerAngle:
                return .float { -(CGFloat.pi / 45.0) }

            case .shimmerSpeed:
                return .float { 350.0 }

            case .shimmerDelay:
                return .float { 0.4 }

            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius40) }

            case .labelCornerRadius:
                return .float { GlobalTokens.corner(.radius20) }

            case .labelHeight:
                return .float { 11.0 }

            case .labelSpacing:
                return .float { GlobalTokens.spacing(.size120) }
            }
        }
    }

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer.
    var style: () -> MSFShimmerStyle
}
