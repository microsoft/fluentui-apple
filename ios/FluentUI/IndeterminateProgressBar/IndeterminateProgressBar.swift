//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Indeterminate Progress Bar implementation
@objc open class MSFIndeterminateProgressBar: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Indeterminate Progress Bar.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the Indeterminate Progress Bar appearance.
    @objc open var state: MSFIndeterminateProgressBarState {
        return self.indeterminateProgressBarView.state
    }

    /// Creates a new MSFIndeterminateProgressBar instance.
    @objc public override convenience init() {
        self.init(theme: nil)
    }

    /// Creates a new MSFIndeterminateProgressBar instance.
    /// - Parameters:
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Indeterminate Progress Bar
    @objc public init(theme: FluentUIStyle? = nil) {
        super.init()

        indeterminateProgressBarView = IndeterminateProgressBar()
        hostingController = FluentUIHostingController(rootView: AnyView(indeterminateProgressBarView
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { indeterminateProgressBarView in
                                                                                indeterminateProgressBarView.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: FluentUIHostingController!

    private var indeterminateProgressBarView: IndeterminateProgressBar!
}

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
public struct IndeterminateProgressBar: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFIndeterminateProgressBarTokens
    @ObservedObject var state: MSFIndeterminateProgressBarStateImpl
    @State var startPoint: UnitPoint = Constants.initialStartPoint
    @State var endPoint: UnitPoint = Constants.initialEndPoint

    /// Creates the Indeterminate Progress Bar.
    public init() {
        let state = MSFIndeterminateProgressBarStateImpl()
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let height = tokens.height
        let gradientColor = Color(tokens.gradientColor)
        let backgroundColor = Color(tokens.backgroundColor)

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
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    private func startAnimation() {
        stopAnimation()

        withAnimation(Animation.linear(duration: Constants.animationDuration)
                                .repeatForever(autoreverses: false)) {
            startPoint = Constants.finalStartPoint
            endPoint = Constants.finalEndPoint
        }
    }

    private func stopAnimation() {
        withAnimation(Animation.linear(duration: 0)) {
            startPoint = Constants.initialStartPoint
            endPoint = Constants.initialEndPoint
        }
    }

    private struct Constants {
        static let animationDuration: Double = 1.75
        static let isRTLLanguage = Locale.current.isRightToLeftLayoutDirection()
        static let initialStartPoint: UnitPoint = { isRTLLanguage ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: -1, y: 0.5) }()
        static let initialEndPoint: UnitPoint = { isRTLLanguage ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: 0, y: 0.5) }()
        static let finalStartPoint: UnitPoint = { isRTLLanguage ? UnitPoint(x: -1, y: 0.5) : UnitPoint(x: 1, y: 0.5) }()
        static let finalEndPoint: UnitPoint = { isRTLLanguage ? UnitPoint(x: 0, y: 0.5) : UnitPoint(x: 2, y: 0.5) }()
    }
}

/// Properties available to customize the state of the Indeterminate Progress Bar
class MSFIndeterminateProgressBarStateImpl: NSObject, ObservableObject, MSFIndeterminateProgressBarState {
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true

    let tokens: MSFIndeterminateProgressBarTokens

    override init() {
        self.tokens = MSFIndeterminateProgressBarTokens()
    }
}
