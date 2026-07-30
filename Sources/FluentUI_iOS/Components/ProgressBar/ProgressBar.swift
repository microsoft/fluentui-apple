//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import UIKit

/// Properties available to customize the state of the Progress Bar.
@objc public protocol MSFProgressBarState {
    /// Defines whether the Progress Bar is animating or stopped.
    var isAnimating: Bool { get set }

    /// Defines whether the Progress Bar is visible when its animation stops.
    var hidesWhenStopped: Bool { get set }

    /// Determinate progress in the range 0.0...1.0. When `nil` (the default), the bar renders in
    /// its indeterminate (animated gradient) mode. When set, the bar renders a determinate fill
    /// representing the given fractional progress.
    var progress: NSNumber? { get set }
}

/// View that represents the Progress Bar control.
/// Use the ProgressView SwiftUI View (https://developer.apple.com/documentation/swiftui/progressview)
/// provided in the SwiftUI framework to render the default OS indeterminate spinner or a progress bar with a specific progress value.
public struct ProgressBar: View, TokenizedControlView {
    public typealias TokenSetKeyType = ProgressBarTokenSet.Tokens
    @ObservedObject public var tokenSet: ProgressBarTokenSet

    /// Creates the Progress Bar.
    public init() {
        let state = MSFProgressBarStateImpl()
        self.state = state
        self.tokenSet = ProgressBarTokenSet()
        startPoint = ProgressBarTokenSet.initialStartPoint(isRTLLanguage)
        endPoint = ProgressBarTokenSet.initialEndPoint(isRTLLanguage)
    }

    @ViewBuilder
    public var body: some View {
        let height = ProgressBarTokenSet.height

        if let progress = state.progress?.doubleValue {
            determinateBody(progress: progress, height: height)
        } else {
            indeterminateBody(height: height)
        }
    }

    private func indeterminateBody(height: Double) -> some View {
        tokenSet.update(fluentTheme)
        let backgroundColor = Color(tokenSet[.backgroundColor].uiColor)
        let gradientColor = Color(tokenSet[.gradientColor].uiColor)
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
            .ignoresSafeArea(.container, edges: .horizontal)
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

    private func determinateBody(progress: Double, height: Double) -> some View {
        tokenSet.update(fluentTheme)
        let backgroundColor = Color(tokenSet[.backgroundColor].uiColor)
        let fillColor = Color(tokenSet[.fillColor].uiColor)
        let clampedProgress = min(max(progress, 0.0), 1.0)
        let accessibilityLabel: String = state.accessibilityLabel ?? "Accessibility.ActivityIndicator.Animating.label".localized
        let accessibilityValue: String = "\(Int((clampedProgress * 100).rounded()))%"
#if DEBUG
        let accessibilityIdentifier: String = "Determinate Progress Bar at \(accessibilityValue)"
#endif

        return GeometryReader { proxy in
            Rectangle()
                .fill(fillColor)
                .frame(width: proxy.size.width * clampedProgress,
                       height: height,
                       alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .ignoresSafeArea(.container, edges: .horizontal)
        .frame(maxWidth: .infinity,
               minHeight: height,
               idealHeight: height,
               maxHeight: height,
               alignment: .center)
        .background(backgroundColor)
        .flipsForRightToLeftLayoutDirection(true)
        .animation(.linear(duration: ProgressBarTokenSet.determinateAnimationDuration), value: clampedProgress)
        .accessibilityElement()
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityValue(Text(accessibilityValue))
#if DEBUG
        .accessibilityIdentifier(accessibilityIdentifier)
#endif
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    @ObservedObject var state: MSFProgressBarStateImpl
    @State var startPoint: UnitPoint = .zero
    @State var endPoint: UnitPoint = .zero
    var isRTLLanguage: Bool {
        return layoutDirection == .rightToLeft
    }

    private func startAnimation() {
        stopAnimation()

        withAnimation(Animation.linear(duration: ProgressBarTokenSet.animationDuration)
                                .repeatForever(autoreverses: false)) {
            startPoint = ProgressBarTokenSet.finalStartPoint(isRTLLanguage)
            endPoint = ProgressBarTokenSet.finalEndPoint(isRTLLanguage)
        }
    }

    private func stopAnimation() {
        withAnimation(Animation.linear(duration: 0)) {
            startPoint = ProgressBarTokenSet.initialStartPoint(isRTLLanguage)
            endPoint = ProgressBarTokenSet.initialEndPoint(isRTLLanguage)
        }
    }
}

/// Properties available to customize the state of the Progress Bar
class MSFProgressBarStateImpl: ControlState, MSFProgressBarState {
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
    @Published var progress: NSNumber?
}
