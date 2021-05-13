//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties available to customize the state of the activity indicator state
@objc public protocol MSFActivityIndicatorState {
    var accessibilityLabel: String? { get set }
    var color: UIColor? { get set }
    var isAnimating: Bool { get set }
    var hidesWhenStopped: Bool { get set }
}

/// Properties available to customize the state of the activity indicator
class MSFActivityIndicatorStateImpl: NSObject, ObservableObject, MSFActivityIndicatorState {
    @Published var color: UIColor?
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
}

/// View that represents the activity indicator
public struct ActivityIndicator: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFActivityIndicatorTokens
    @ObservedObject var state: MSFActivityIndicatorStateImpl
    @State var rotationAngle: Double = 0.0

    public init(size: MSFActivityIndicatorSize) {
        self.tokens = MSFActivityIndicatorTokens(size: size)
        self.state = MSFActivityIndicatorStateImpl()
    }

    public var body: some View {
        if state.isAnimating {
            animatedSemiRing
        } else if state.hidesWhenStopped {
            EmptyView()
        } else {
            semiRing
        }
    }

    public func setSize(size: MSFActivityIndicatorSize) {
        tokens.size = size
    }

    var animatedSemiRing: some View {
        return semiRing
            .rotationEffect(Angle(degrees: rotationAngle))
            .onAppear {
                rotationAngle = 0.0

                withAnimation(animation) {
                    rotationAngle = 360.0
                }
            }
    }

    var semiRing: some View {
        let size = tokens.activityIndicatorSize
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

        return Circle()
            .trim(from: 0, to: 0.75)
            .stroke(style: StrokeStyle(lineWidth: tokens.thickness, lineCap: .round))
            .foregroundColor(color)
            .frame(width: size, height: size, alignment: .center)
            .accessibilityElement(children: .ignore)
            .accessibility(addTraits: .isImage)
            .accessibility(label: Text(accessibilityLabel))
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    private let animationDuration: Double = 0.75

    var animation: Animation {
        Animation
            .linear(duration: animationDuration)
            .repeatForever(autoreverses: false)
    }
}

/// UIKit wrapper that exposes the SwiftUI activity indicator implementation
@objc open class MSFActivityIndicator: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFActivityIndicatorState {
        return self.activityIndicatorView.state
    }

    @objc open func setSize(size: MSFActivityIndicatorSize) {
        self.activityIndicatorView.setSize(size: size)
    }

    @objc public convenience init(size: MSFActivityIndicatorSize = .medium) {
        self.init(size: size,
                  theme: nil)
    }

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
