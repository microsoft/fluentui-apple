//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `ShimmerLines`.
public protocol MSFShimmerLinesState {

    /// Determines whether the shimmer lines have a revealing shimmer or a concealing shimmer.
    var style: MSFShimmerStyle { get set }

    /// Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    var lineCount: Int { get set }

    /// The percent the first line (if 2+ lines) should fill the available horizontal space.
    var firstLineFillPercent: CGFloat? { get set }

    /// The percent the last line should fill the available horizontal space.
    var lastLineFillPercent: CGFloat? { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ShimmerTokens? { get set }
}

/// View that represents the ShimmerLines view
public struct ShimmerLinesViewSwiftUI: View, ConfigurableTokenizedControl {

    /// Initializes the SwiftUI View for Shimmer Lines.
    /// - Parameters:
    ///   - style: Determines whether the shimmer is a revealing shimmer or a concealing shimmer.
    ///   - lineCount: Number of lines that will shimmer in this view. Use 0 if the number of lines should fill the available space.
    ///   - firstLineFillPercent: The percent the first line (if 2+ lines) should fill the available horizontal space.
    ///   - lastLineFillPercent: The percent the last line should fill the available horizontal space.
    public init(style: MSFShimmerStyle,
                lineCount: Int,
                firstLineFillPercent: CGFloat,
                lastLineFillPercent: CGFloat) {
        let state = MSFShimmerLinesStateImpl(style: style,
                                             lineCount: lineCount)
        state.firstLineFillPercent = firstLineFillPercent
        state.lastLineFillPercent = lastLineFillPercent

        self.state = state
    }

    public var body: some View {
        ShimmerLinesShape(lineCount: state.lineCount,
                          firstLineFillPercent: state.firstLineFillPercent,
                          lastLineFillPercent: state.lastLineFillPercent,
                          lineHeight: tokens.labelHeight,
                          lineSpacing: tokens.labelSpacing,
                          frame: containerSize)
        .foregroundColor(Color.init(dynamicColor: tokens.viewTint))
        .shimmering(style: state.style,
                    shouldAddShimmeringCover: false,
                    usesTextHeightForLabels: false,
                    animationId: namespace,
                    isLabel: false)
        .frame(maxWidth: .infinity, maxHeight: state.lineCount == 0 ? .infinity : (CGFloat(state.lineCount - 1) * tokens.labelSpacing) + (CGFloat(state.lineCount) * tokens.labelHeight))
        .onSizeChange { newSize in
            containerSize = newSize
        }
    }

    public typealias TokenType = ShimmerTokens
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFShimmerLinesStateImpl
    let defaultTokens: ShimmerTokens = .init()
    var tokens: ShimmerTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
    }

    @Namespace private var namespace: Namespace.ID
    @State private var phase: CGFloat = 0
    @State private var containerSize: CGSize = CGSize()
}

/// Properties that can be used to customize the appearance of the `ShimmerLines`.
class MSFShimmerLinesStateImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFShimmerLinesState {
    @Published var style: MSFShimmerStyle
    @Published var lineCount: Int
    @Published var firstLineFillPercent: CGFloat?
    @Published var lastLineFillPercent: CGFloat?
    @Published var overrideTokens: ShimmerTokens?

    @objc init(style: MSFShimmerStyle,
               lineCount: Int) {
        self.style = style
        self.lineCount = lineCount

        super.init()
    }

    convenience init(style: MSFShimmerStyle,
                     lineCount: Int = 3,
                     firstLineFillPercent: CGFloat? = 0.94,
                     lastLineFillPercent: CGFloat? = 0.6) {
        self.init(style: style,
                  lineCount: lineCount)

        self.firstLineFillPercent = firstLineFillPercent
        self.lastLineFillPercent = lastLineFillPercent
    }
}
