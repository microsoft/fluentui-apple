//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Activity Indicator implementation
@objc open class MSFActivityIndicator: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Activity Indicator.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the Activity Indicator appearance.
    @objc open var state: MSFActivityIndicatorState {
        return self.activityIndicatorView.state
    }

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameter size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    @objc public convenience init(size: MSFActivityIndicatorSize = .medium) {
        self.init(size: size,
                  theme: nil)
    }

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameters:
    ///   - size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Activity Indicator.
    @objc public init(size: MSFActivityIndicatorSize = .medium,
                      theme: FluentUIStyle? = nil) {
        super.init()

        activityIndicatorView = ActivityIndicator(size: size)
        hostingController = UIHostingController(rootView: AnyView(activityIndicatorView
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { activityIndicatorView in
                                                                        activityIndicatorView.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var activityIndicatorView: ActivityIndicator!
}

/// Properties available to customize the state of the activity indicator state
@objc public protocol MSFActivityIndicatorState {

    /// Sets the accessibility label for the Activity Indicator.
    var accessibilityLabel: String? { get set }

    /// Sets the color of the Activity Indicator.
    var color: UIColor? { get set }

    /// Defines whether the Activity Indicator is animating or stopped.
    var isAnimating: Bool { get set }

    /// Defines whether the Activity Indicator is visible when its animation stops.
    var hidesWhenStopped: Bool { get set }

    /// The MSFActivityIndicatorSize value used by the Activity Indicator.
    var size: MSFActivityIndicatorSize { get set }
}

/// View that represents the activity indicator
public struct ActivityIndicator: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFActivityIndicatorTokens
    @ObservedObject var state: MSFActivityIndicatorStateImpl
    @State var rotationAngle: Double = 0.0

    /// Creates the ActivityIndicator.
    /// - Parameter size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    public init(size: MSFActivityIndicatorSize) {
        let state = MSFActivityIndicatorStateImpl(size: size)
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let size = tokens.activityIndicatorSize
        activityIndicatorContent
            .frame(width: size,
                   height: size,
                   alignment: .center)
    }

    @ViewBuilder
    public var activityIndicatorContent: some View {
        if state.isAnimating {
            animatedSemiRing
        } else if state.hidesWhenStopped {
            // Clear circle instead of EmptyView() to ensure the frame size
            // remains the same even when invisible.
            Circle()
                .foregroundColor(.clear)
        } else {
            semiRing
        }
    }

    @ViewBuilder
    private var animatedSemiRing: some View {
        semiRing
            .rotationEffect(Angle(degrees: rotationAngle))
            .onAppear {
                rotationAngle = initialAnimationRotationAngle

                withAnimation(Animation.linear(duration: animationDuration)
                                .repeatForever(autoreverses: false)) {
                    rotationAngle = finalAnimationRotationAngle
                }
            }
    }

    @ViewBuilder
    private var semiRing: some View {
        let color = Color(state.color ?? tokens.defaultColor)
        let accessibilityLabel: String = {
            if let overriddenAccessibilityLabel = state.accessibilityLabel {
                return overriddenAccessibilityLabel
            }

            return state.isAnimating ?
                "Accessibility.ActivityIndicator.Animating.label".localized
                :
                "Accessibility.ActivityIndicator.Stopped.label".localized
        }()

        Circle()
            .trim(from: semiRingStartFraction,
                  to: semiRingEndFraction)
            .stroke(style: StrokeStyle(lineWidth: tokens.thickness,
                                       lineCap: .round))
            .foregroundColor(color)
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: .isImage)
            .accessibility(label: Text(accessibilityLabel))
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    private let animationDuration: Double = 0.75
    private let semiRingStartFraction: CGFloat = 0.0
    private let semiRingEndFraction: CGFloat = 0.75
    private let initialAnimationRotationAngle: Double = 0.0
    private let finalAnimationRotationAngle: Double = 360.0
}

/// Properties available to customize the state of the activity indicator
class MSFActivityIndicatorStateImpl: NSObject, ObservableObject, MSFActivityIndicatorState {
    @Published var color: UIColor?
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true

    let tokens: MSFActivityIndicatorTokens

    var size: MSFActivityIndicatorSize {
        get {
            return tokens.size
        }

        set {
            tokens.size = newValue
        }
    }

    init(size: MSFActivityIndicatorSize) {
        self.tokens = MSFActivityIndicatorTokens(size: size)
    }
}
