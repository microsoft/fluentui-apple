//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Properties available to customize the configuration of the Activity Indicator configuration
@objc public protocol MSFActivityIndicatorConfiguration {

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

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ActivityIndicatorTokens? { get set }
}

/// View that represents the Activity Indicator.
public struct ActivityIndicator: View, ConfigurableTokenizedControl {

    /// Creates the ActivityIndicator.
    /// - Parameter size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    public init(size: MSFActivityIndicatorSize) {
        let configuration = MSFActivityIndicatorConfigurationImpl(size: size)
        self.configuration = configuration
    }

    public var body: some View {
        let side = tokens.side
        let color: Color = {
            guard let configurationUIColor = configuration.color else {
                return Color(dynamicColor: tokens.defaultColor)
            }

            return Color(configurationUIColor)
        }()
        let accessibilityLabel: String = {
            if let overriddenAccessibilityLabel = configuration.accessibilityLabel {
                return overriddenAccessibilityLabel
            }

            return configuration.isAnimating ?
                "Accessibility.ActivityIndicator.Animating.label".localized
                :
                "Accessibility.ActivityIndicator.Stopped.label".localized
        }()

        SemiRing(color: color,
                 thickness: tokens.thickness,
                 accessibilityLabel: accessibilityLabel)
            .modifyIf(configuration.isAnimating, { animatedView in
                animatedView
                    .rotationEffect(.degrees(rotationAngle), anchor: .center)
                    .onAppear {
                        startAnimation()
                    }
            })
            .modifyIf(!configuration.isAnimating) { staticView in
                staticView
                    .onAppear {
                       stopAnimation()
                    }
            }
            .modifyIf(!configuration.isAnimating && configuration.hidesWhenStopped, { view in
                view.hidden()
            })
            .frame(width: side,
                   height: side,
                   alignment: .center)
    }

    let defaultTokens: ActivityIndicatorTokens = .init()
    var tokens: ActivityIndicatorTokens {
        let tokens = resolvedTokens
        tokens.size = configuration.size
        return tokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var configuration: MSFActivityIndicatorConfigurationImpl
    @State var rotationAngle: Double = 0.0

    private struct SemiRing: View {
        var color: Color
        var thickness: CGFloat
        var accessibilityLabel: String

        public var body: some View {
            Circle()
                .trim(from: semiRingStartFraction,
                      to: semiRingEndFraction)
                .stroke(style: StrokeStyle(lineWidth: thickness,
                                           lineCap: .round))
                .foregroundColor(color)
                .accessibilityElement(children: .ignore)
                .accessibility(addTraits: .isImage)
                .accessibility(label: Text(accessibilityLabel))
        }

        private let semiRingStartFraction: CGFloat = 0.0
        private let semiRingEndFraction: CGFloat = 0.75
    }

    private func startAnimation() {
        stopAnimation()
        rotationAngle = initialAnimationRotationAngle

        withAnimation(Animation.linear(duration: animationDuration)
                                .repeatForever(autoreverses: false)) {
            rotationAngle = finalAnimationRotationAngle
        }
    }

    private func stopAnimation() {
        rotationAngle = finalAnimationRotationAngle

        withAnimation(Animation.linear(duration: 0)) {
            rotationAngle = initialAnimationRotationAngle
        }
    }

    private let animationDuration: Double = 0.75
    private let initialAnimationRotationAngle: Double = 0.0
    private let finalAnimationRotationAngle: Double = 360.0
}

/// Properties available to customize the configuration of the Activity Indicator
class MSFActivityIndicatorConfigurationImpl: NSObject, ObservableObject, ControlConfiguration, MSFActivityIndicatorConfiguration {
    @Published var overrideTokens: ActivityIndicatorTokens?

    @Published var color: UIColor?
    @Published var isAnimating: Bool = false
    @Published var hidesWhenStopped: Bool = true
    @Published var size: MSFActivityIndicatorSize

    init(size: MSFActivityIndicatorSize) {
        self.size = size
        super.init()
    }
}
