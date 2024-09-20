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
        startPoint = IndeterminateProgressBarTokenSet.initialStartPoint(isRTLLanguage)
        endPoint = IndeterminateProgressBarTokenSet.initialEndPoint(isRTLLanguage)
    }

    public var body: some View {
        tokenSet.update(fluentTheme)
        let height = IndeterminateProgressBarTokenSet.height
        let gradientColor = Color(tokenSet[.gradientColor].uiColor)
        let backgroundColor = Color(tokenSet[.backgroundColor].uiColor)
        let accessibilityLabel: String = {
            if let overriddenAccessibilityLabel = state.accessibilityLabel {
                return overriddenAccessibilityLabel
            }

            return state.isAnimating ?
                "Accessibility.ActivityIndicator.Animating.label".localized
                :
                "Accessibility.ActivityIndicator.Stopped.label".localized
        }()
#if DEBUG
        let accessibilityIdentifier: String = "Indeterminate Progress Bar that is \(state.isAnimating ? "in progress" : "progress halted")"
#endif

        return Rectangle()
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
#if DEBUG
            .accessibilityIdentifier(accessibilityIdentifier)
#endif
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

        withAnimation(Animation.linear(duration: IndeterminateProgressBarTokenSet.animationDuration)
                                .repeatForever(autoreverses: false)) {
            startPoint = IndeterminateProgressBarTokenSet.finalStartPoint(isRTLLanguage)
            endPoint = IndeterminateProgressBarTokenSet.finalEndPoint(isRTLLanguage)
        }
    }

    private func stopAnimation() {
        withAnimation(Animation.linear(duration: 0)) {
            startPoint = IndeterminateProgressBarTokenSet.initialStartPoint(isRTLLanguage)
            endPoint = IndeterminateProgressBarTokenSet.initialEndPoint(isRTLLanguage)
        }
    }
}

/// Properties available to customize the state of the Indeterminate Progress Bar
class MSFIndeterminateProgressBarStateImpl: ControlState,
                                            MSFIndeterminateProgressBarState {
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
}
