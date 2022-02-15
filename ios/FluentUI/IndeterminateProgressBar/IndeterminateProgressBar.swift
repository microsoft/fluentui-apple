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
public struct IndeterminateProgressBar: View, TokenizedControlInternal {
    /// Creates the Indeterminate Progress Bar.
    public init() {
        let state = MSFIndeterminateProgressBarStateImpl()
        self.state = state
        startPoint = Constants.Coordinates(isRTLLanguage).initialStartPoint
        endPoint = Constants.Coordinates(isRTLLanguage).initialEndPoint
    }

    public var body: some View {
        let height = tokens.height
        let gradientColor = Color(dynamicColor: tokens.gradientColor)
        let backgroundColor = Color(dynamicColor: tokens.backgroundColor)

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
            .resolveTokens(self)
    }

    var tokens: IndeterminateProgressBarTokens { state.tokens }
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

        withAnimation(Animation.linear(duration: Constants.animationDuration)
                                .repeatForever(autoreverses: false)) {
            startPoint = Constants.Coordinates(isRTLLanguage).finalStartPoint
            endPoint = Constants.Coordinates(isRTLLanguage).finalEndPoint
        }
    }

    private func stopAnimation() {
        withAnimation(Animation.linear(duration: 0)) {
            startPoint = Constants.Coordinates(isRTLLanguage).initialStartPoint
            endPoint = Constants.Coordinates(isRTLLanguage).initialEndPoint
        }
    }

    private struct Constants {
        static let animationDuration: Double = 1.75

        struct Coordinates {
            var isRTLLanguage: Bool
            var initialStartPoint: UnitPoint { isRTLLanguage ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5) }
            var initialEndPoint: UnitPoint { isRTLLanguage ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5) }
            var finalStartPoint: UnitPoint { isRTLLanguage ? UnitPoint(x: -1, y: 0.5) : UnitPoint(x: 1, y: 0.5) }
            var finalEndPoint: UnitPoint { isRTLLanguage ? UnitPoint(x: 0, y: 0.5) : UnitPoint(x: 2, y: 0.5) }

            init(_ isRTLLanguage: Bool = false) {
                self.isRTLLanguage = isRTLLanguage
            }
        }
    }
}

/// Properties available to customize the state of the Indeterminate Progress Bar
class MSFIndeterminateProgressBarStateImpl: NSObject,
                                            ObservableObject,
                                            ControlConfiguration,
                                            MSFIndeterminateProgressBarState {
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
    @Published var tokens: IndeterminateProgressBarTokens = .init()

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    @Published @objc public var overrideTokens: IndeterminateProgressBarTokens?
}
