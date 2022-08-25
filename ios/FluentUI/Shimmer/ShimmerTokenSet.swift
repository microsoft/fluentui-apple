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

/// Design token set for the `Shimmer` control.
public class ShimmerTokenSet: ControlTokenSet<ShimmerTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The alpha value of the center of the gradient in the animation if shimmer is revealing shimmer.
        /// The alpha value of the view other than the gradient if shimmer is concealing shimmer.
        case shimmerAlpha

        /// Tint color of the view if shimmer is revealing shimmer.
        /// Tint color of the middle of the gradient if shimmer is concealing shimmer.
        case tintColor

        /// Tint color of the view if shimmering without a cover.
        case viewTint

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

        /// Duration of a single shimmer animation
        case shimmerDuration

        /// Corner radius on each view.
        case cornerRadius

        /// Corner radius on each UILabel. Set to  0 to disable and use default `cornerRadius`.
        case labelCornerRadius

        /// Height of shimmering labels.
        case labelHeight

        /// Spacing between (if lines > 1).
        case labelSpacing
    }

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
                return .dynamicColor {
                    switch style() {
                    case .concealing:
                        return DynamicColor(light: theme.globalTokens.neutralColors[.white],
                                            dark: theme.globalTokens.neutralColors[.grey8])
                    case .revealing:
                        return DynamicColor(light: ColorValue(0xF1F1F1) /* gray50 */,
                                            lightHighContrast: ColorValue(0x919191) /* gray400 */,
                                            dark: theme.aliasTokens.backgroundColors[.surfaceQuaternary].dark,
                                            darkHighContrast: ColorValue(0x919191) /* gray400 */)
                    }
                }

            case .viewTint:
                return .dynamicColor {
                    return DynamicColor(light: ColorValue(0xF1F1F1) /* gray50 */,
                                            lightHighContrast: ColorValue(0x919191) /* gray400 */,
                                        dark: theme.aliasTokens.backgroundColors[.surfaceQuaternary].dark,
                                            darkHighContrast: ColorValue(0x919191) /* gray400 */)
                }

            case .darkGradient:
                return .dynamicColor {
                    return DynamicColor(light: theme.globalTokens.neutralColors[.black])
                }

            case .shimmerWidth:
                return .float { 180.0 }

            case .shimmerAngle:
                return .float { -(CGFloat.pi / 45.0) }

            case .shimmerSpeed:
                return .float { 350.0 }

            case .shimmerDelay:
                return .float { 0.4 }

            case .shimmerDuration:
                return .float { 3.0 }

            case .cornerRadius:
                return .float { theme.globalTokens.borderRadius[.medium] }

            case .labelCornerRadius:
                return .float { theme.globalTokens.borderRadius[.small] }

            case .labelHeight:
                return .float { 11.0 }

            case .labelSpacing:
                return .float { theme.aliasTokens.globalTokens.spacing[.small] }
            }
        }
    }

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer.
    var style: () -> MSFShimmerStyle
}
