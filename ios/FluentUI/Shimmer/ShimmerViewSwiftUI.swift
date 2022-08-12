//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Shimmer`.
@objc public protocol MSFShimmerState {

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer.
    var style: MSFShimmerStyle { get set }

    /// Determines whether the view itself is shimmered or an added cover on top is shimmered
    var shouldAddShimmeringCover: Bool { get set }

    /// Whether to use the height of the view (if the view is a label), else default to token value.
    var usesTextHeightForLabels: Bool { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ShimmerTokens? { get set }
}

/// View Modifier that adds a "shimmering" effect to any view
public struct ShimmerViewSwiftUI: ViewModifier, ConfigurableTokenizedControl {

    public func body(content: Content) -> some View {
        let distance = (contentSize.width + tokens.shimmerWidth) / cos(tokens.shimmerAngle)
        let duration = CFTimeInterval(distance / tokens.shimmerSpeed) + tokens.shimmerDelay
        content
            .onSizeChange { newSize in
                contentSize = newSize
            }
            .modifier(AnimatedMask(tokens: tokens,
                                   state: state,
                                   isLabel: isLabel,
                                   phase: phase,
                                  contentSize: contentSize)
                .animation(Animation.linear(duration: duration)
                    .delay(tokens.shimmerDelay)
                    .repeatForever(autoreverses: false)
            ))
            .onAppear {
                if !UIAccessibility.isReduceMotionEnabled {
                    phase = .init(1.0 + (tokens.shimmerWidth / contentSize.width))
                }
            }
            /// RTL languages require shimmer in the respective direction
            .flipsForRightToLeftLayoutDirection(true)
            .matchedGeometryEffect(id: UUID(), in: self.animationId)
    }

    /// An animatable modifier to interpolate between `phase` values.
    struct AnimatedMask: AnimatableModifier {
        var tokens: ShimmerTokens
        var state: MSFShimmerState
        var isLabel: Bool
        var phase: CGFloat
        var contentSize: CGSize

        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        func body(content: Content) -> some View {
            let gradientMask = GradientMask(tokens: tokens,
                                            state: state,
                                            contentSize: contentSize,
                                            phase: phase)

            if state.shouldAddShimmeringCover {
                ZStack {
                    content
                    HStack {
                        RoundedRectangle(cornerRadius: isLabel && tokens.labelCornerRadius >= 0 ? tokens.labelCornerRadius : tokens.cornerRadius)
                            .foregroundColor(Color.init(dynamicColor: tokens.tintColor))
                            .frame(width: contentSize.width,
                                   height: !isLabel || state.usesTextHeightForLabels ? contentSize.height : tokens.labelHeight)
                            .mask(gradientMask)
                    }
                }
            } else {
                content
                    .mask(gradientMask)
            }
        }
    }

    /// A slanted, animatable gradient between light (transparent) and dark (opaque) parts of shimmer  to use as mask.
    /// The `phase` parameter shifts the gradient, moving the shimmer band.
    struct GradientMask: View {
        var tokens: ShimmerTokens
        var state: MSFShimmerState
        var contentSize: CGSize
        var phase: CGFloat

        var body: some View {
            let light = Color.white.opacity(self.tokens.shimmerAlpha)
            let dark = Color(colorValue: self.tokens.darkGradient)

            let widthPercentage = tokens.shimmerWidth / contentSize.width
            LinearGradient(gradient: Gradient(stops: [
                .init(color: state.style == .concealing ? light : dark, location: phase - widthPercentage),
                .init(color: state.style == .concealing ? dark : light, location: phase - widthPercentage / 2.0),
                .init(color: state.style == .concealing ? light : dark, location: phase)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        }
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFShimmerStateImpl
    let defaultTokens: ShimmerTokens = .init()
    var tokens: ShimmerTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
    }

    /// When displaying one or more shimmers, this ID will synchronize the animations
    let animationId: Namespace.ID
    /// Determines whether content to shimmer is a label.
    let isLabel: Bool

    @State private var phase: CGFloat = 0
    @State private var contentSize: CGSize = CGSize()
}

class MSFShimmerStateImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFShimmerState {
    @Published var style: MSFShimmerStyle
    @Published var shouldAddShimmeringCover: Bool = true
    @Published var usesTextHeightForLabels: Bool = false
    @Published var overrideTokens: ShimmerTokens?

    init(style: MSFShimmerStyle) {
        self.style = style
        super.init()
    }

    convenience init(style: MSFShimmerStyle,
                     shouldAddShimmeringCover: Bool = true,
                     usesTextHeightForLabels: Bool = false) {
        self.init(style: style)
        self.shouldAddShimmeringCover = shouldAddShimmeringCover
        self.usesTextHeightForLabels = usesTextHeightForLabels
    }
}
