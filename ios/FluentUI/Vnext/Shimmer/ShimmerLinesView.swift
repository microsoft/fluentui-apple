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
}

/// View that represents the ShimmerLines view.
public struct ShimmerLinesView: View, TokenizedControlView {
    public typealias TokenSetKeyType = ShimmerTokenSet.Tokens
    @ObservedObject public var tokenSet: ShimmerTokenSet

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
        self.tokenSet = ShimmerTokenSet(style: { state.style })
    }

    public var body: some View {
        ShimmerLinesShape(lineCount: state.lineCount,
                          firstLineFillPercent: state.firstLineFillPercent,
                          lastLineFillPercent: state.lastLineFillPercent,
                          lineHeight: tokenSet[.labelHeight].float,
                          lineSpacing: tokenSet[.labelSpacing].float,
                          frame: containerSize)
        .foregroundColor(Color.init(dynamicColor: tokenSet[.viewTint].dynamicColor))
        .shimmering(style: state.style,
                    shouldAddShimmeringCover: false,
                    usesTextHeightForLabels: false,
                    animationId: namespace,
                    isLabel: false)
        .frame(maxWidth: .infinity, maxHeight: state.lineCount == 0 ? .infinity : (CGFloat(state.lineCount - 1) * tokenSet[.labelSpacing].float) + (CGFloat(state.lineCount) * tokenSet[.labelHeight].float))
        .onSizeChange { newSize in
            containerSize = newSize
        }
        .accessibilityLabel("Accessibility.Shimmer.Loading".localized)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFShimmerLinesStateImpl
    @Namespace private var namespace: Namespace.ID
    @State private var phase: CGFloat = 0
    @State private var containerSize: CGSize = CGSize()
}

/// Properties that can be used to customize the appearance of the `ShimmerLines`.
class MSFShimmerLinesStateImpl: ControlState, MSFShimmerLinesState {
    @Published var style: MSFShimmerStyle
    @Published var lineCount: Int
    @Published var firstLineFillPercent: CGFloat?
    @Published var lastLineFillPercent: CGFloat?

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
