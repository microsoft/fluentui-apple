//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Properties available to customize the state of the Indeterminate Progress Bar.
@objc public protocol MSFIndeterminateProgressBarState {
    /// Defines whether the Indeterminate Progress Bar is animating or stopped.
    var isAnimating: Bool { get set }

    /// Defines whether the Indeterminate Progress Bar is visible when its animation stops.
    var hidesWhenStopped: Bool { get set }
}

/// View that represents the Indeterminate Progress Bar control.
/// Use the ProgressView SwiftUI View (https://developer.apple.com/documentation/swiftui/progressview)
/// provided in the SwiftUI framework to render the default OS indeterminate spinner or a progress bar with a specific progress value.
public struct IndeterminateProgressBar: View, TokenizedControlView {
    public typealias TokenSetKeyType = IndeterminateProgressBarTokenSet.Tokens
    @ObservedObject public var tokenSet: IndeterminateProgressBarTokenSet

    /// Creates the Indeterminate Progress Bar.
    public init() {
        let state = MSFIndeterminateProgressBarStateImpl()
        self.state = state
        self.tokenSet = IndeterminateProgressBarTokenSet()
        startPoint = Self.initialStartPoint(isRTLLanguage)
        endPoint = Self.initialEndPoint(isRTLLanguage)
    }

    public var body: some View {
        let height = Self.height
        let gradientColor = Color(dynamicColor: tokenSet[.gradientColor].dynamicColor)
        let backgroundColor = Color(dynamicColor: tokenSet[.backgroundColor].dynamicColor)
        let accessibilityLabel: String = {
            if let overriddenAccessibilityLabel = state.accessibilityLabel {
                return overriddenAccessibilityLabel
            }

            return state.isAnimating ?
                "Accessibility.ActivityIndicator.Animating.label".localized
                :
                "Accessibility.ActivityIndicator.Stopped.label".localized
        }()

        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [backgroundColor, gradientColor, backgroundColor]),
                                 startPoint: startPoint,
                                 endPoint: endPoint))
            .frame(maxWidth: .infinity,
                   minHeight: height,
                   idealHeight: height,
                   maxHeight: height,
                   alignment: .center)
            .background(backgroundColor)
            .accessibilityLabel(Text(accessibilityLabel))
            .accessibilityAddTraits(.updatesFrequently)
            .modifyIf(state.isAnimating, { view in
                view
                    .onAppear {
                        startAnimation()
                    }
            })
            .modifyIf(!state.isAnimating) { view in
                view
                    .onAppear {
                       stopAnimation()
                    }
            }
            .modifyIf(!state.isAnimating && state.hidesWhenStopped, { view in
                view.hidden()
            })
            .fluentTokens(tokenSet, fluentTheme)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFIndeterminateProgressBarStateImpl
    @State var startPoint: UnitPoint = .zero
    @State var endPoint: UnitPoint = .zero
    var isRTLLanguage: Bool {
        return layoutDirection == .rightToLeft
    }

    private func startAnimation() {
        stopAnimation()

        withAnimation(Animation.linear(duration: Self.animationDuration)
                                .repeatForever(autoreverses: false)) {
            startPoint = Self.finalStartPoint(isRTLLanguage)
            endPoint = Self.finalEndPoint(isRTLLanguage)
        }
    }

    private func stopAnimation() {
        withAnimation(Animation.linear(duration: 0)) {
            startPoint = Self.initialStartPoint(isRTLLanguage)
            endPoint = Self.initialEndPoint(isRTLLanguage)
        }
    }

    // MARK: Constants

    private static let animationDuration: Double = 1.75
    private static let height: Double = 2.0

    private static func initialStartPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5)
    }

    private static func initialEndPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5)
    }

    private static func finalStartPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: -1, y: 0.5) : UnitPoint(x: 1, y: 0.5)
    }

    private static func finalEndPoint(_ isRTLLanguage: Bool) -> UnitPoint {
        return isRTLLanguage ? UnitPoint(x: 0, y: 0.5) : UnitPoint(x: 2, y: 0.5)
    }
}

/// Properties available to customize the state of the Indeterminate Progress Bar
class MSFIndeterminateProgressBarStateImpl: ControlState,
                                            MSFIndeterminateProgressBarState {
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
}
