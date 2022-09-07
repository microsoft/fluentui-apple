//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Shimmer`.
@objc public protocol MSFShimmerState {

    /// Determines whether the shimmer is a revealing shimmer or a concealing shimmer.
    var style: MSFShimmerStyle { get set }

    /// Determines whether the view itself is shimmered or an added cover on top is shimmered.
    var shouldAddShimmeringCover: Bool { get set }

    /// Whether to use the height of the view (if the view is a label), else default to token value.
    var usesTextHeightForLabels: Bool { get set }

    /// Sets the accessibility label for the Shimmer.
    var accessibilityLabel: String? { get set }
}

/// View Modifier that adds a "shimmering" effect to any view.
public struct ShimmerView: ViewModifier, TokenizedControlView {
    public typealias TokenSetKeyType = ShimmerTokenSet.Tokens
    @ObservedObject public var tokenSet: ShimmerTokenSet

    public func body(content: Content) -> some View {
        let accessibilityLabel: String = {
            guard let overriddenAccessibilityLabel = state.accessibilityLabel else {
                return "Accessibility.Shimmer.Loading".localized
            }

            return overriddenAccessibilityLabel
        }()

        content
            .modifyIf(isShimmering, { view in
                view
                    .modifier(AnimatedMask(tokenSet: tokenSet,
                                           state: state,
                                           isLabel: isLabel,
                                           phase: phase,
                                           contentSize: contentSize)
                        .animation(Animation.linear(duration: tokenSet[.shimmerDuration].float)
                            .delay(tokenSet[.shimmerDelay].float)
                            .repeatForever(autoreverses: false)
                        ))
                    .onSizeChange { newSize in
                        contentSize = newSize
                    }
                    .onAppear {
                        if !UIAccessibility.isReduceMotionEnabled {
                            phase = .init(1.0 + (tokenSet[.shimmerWidth].float / contentSize.width))
                        }
                    }
                    /// RTL languages require shimmer in the respective direction.
                    .flipsForRightToLeftLayoutDirection(true)
                    .matchedGeometryEffect(id: UUID(), in: self.animationId)
                    .accessibilityElement()
                    .accessibilityLabel(accessibilityLabel)
            })
    }

    /// An animatable modifier to interpolate between `phase` values.
    struct AnimatedMask: AnimatableModifier {
        var tokenSet: ShimmerTokenSet
        var state: MSFShimmerState
        var isLabel: Bool
        var phase: CGFloat
        var contentSize: CGSize

        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        func body(content: Content) -> some View {
            let gradientMask = GradientMask(tokenSet: tokenSet,
                                            state: state,
                                            contentSize: contentSize,
                                            phase: phase)

            if state.shouldAddShimmeringCover {
                ZStack {
                    content
                    HStack {
                        RoundedRectangle(cornerRadius: isLabel && tokenSet[.labelCornerRadius].float >= 0 ? tokenSet[.labelCornerRadius].float : tokenSet[.cornerRadius].float)
                            .foregroundColor(Color.init(dynamicColor: tokenSet[.tintColor].dynamicColor))
                            .frame(width: contentSize.width,
                                   height: !isLabel || state.usesTextHeightForLabels ? contentSize.height : tokenSet[.labelHeight].float)
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
        var tokenSet: ShimmerTokenSet
        var state: MSFShimmerState
        var contentSize: CGSize
        var phase: CGFloat

        var body: some View {
            let light = Color.white.opacity(self.tokenSet[.shimmerAlpha].float)
            let dark = Color(colorValue: self.tokenSet[.darkGradient].dynamicColor.light)

            let widthPercentage = tokenSet[.shimmerWidth].float / contentSize.width
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

    /// When displaying one or more shimmers, this ID will synchronize the animations.
    let animationId: Namespace.ID
    /// Determines whether content to shimmer is a label.
    let isLabel: Bool
    /// Whether the shimmering effect is active.
    let isShimmering: Bool

    @State private var phase: CGFloat = 0
    @State private var contentSize: CGSize = CGSize()
}

class MSFShimmerStateImpl: ControlState, MSFShimmerState {
    @Published var style: MSFShimmerStyle
    @Published var shouldAddShimmeringCover: Bool = true
    @Published var usesTextHeightForLabels: Bool = false

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
