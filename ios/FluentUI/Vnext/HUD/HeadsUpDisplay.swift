//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Defines the content type of the Heads-up display.
/// The `.activity` value will make the HUD display an Activity Indicator.
/// The `.success` and `.failure` values will make the HUD display its default images for the cases.
/// The `.custom` value allows a UIImage to be passed as a parameter for the HUD to display.
public enum HUDType: Equatable, Hashable {
    case activity
    case custom(image: UIImage)
    case failure
    case success

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .custom(let image):
            hasher.combine(image)
        case .activity, .success, .failure:
                break
        }
    }
}

/// Properties available to customize the state of the Heads-up display state.
public protocol MSFHUDState {

    /// Label string presented by the Heads-up display.
    var label: String? { get set }

    /// The action executed when the Heads-up display is tapped.
    var tapAction: (() -> Void)? { get set }

    /// The `HUDType` enum value of the Heads-up display.
    var type: HUDType { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: HeadsUpDisplayTokens? { get set }
}

/// View that represents the Heads-up display.
public struct HeadsUpDisplay: View, ConfigurableTokenizedControl {
    public var body: some View {
        let label = state.label ?? ""
        let type = state.type
        let foregroundColor = Color(dynamicColor: tokens.foregroundColor)
        let verticalPadding = tokens.verticalPadding
        let horizontalPadding = tokens.horizontalPadding

        HStack(alignment: .center) {
            VStack {
                switch type {
                case .activity:
                    ActivityIndicator(size: .xLarge)
                        .isAnimating(true)
                        .color(UIColor(dynamicColor: tokens.foregroundColor))
                case .custom, .failure, .success:
                    let image: UIImage = {
                        switch type {
                        case.activity:
                            preconditionFailure("HUDType.activity does not have an associated image.")
                        case .custom(let image):
                            return image.withRenderingMode(.alwaysTemplate)
                        case .failure:
                            return UIImage.staticImageNamed("dismiss-36x36")!
                        case.success:
                            return UIImage.staticImageNamed("checkmark-36x36")!
                        }
                    }()

                    Image(uiImage: image)
                        .foregroundColor(foregroundColor)
                }

                if !label.isEmpty {
                    Spacer()
                        .frame(height: verticalPadding)
                    Text(label)
                        .foregroundColor(foregroundColor)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(EdgeInsets(top: verticalPadding,
                            leading: horizontalPadding,
                            bottom: verticalPadding,
                            trailing: horizontalPadding))
        .squareShaped(minSize: tokens.minSize,
                      maxSize: tokens.maxSize)
        .background(Rectangle()
                        .fill(Color(dynamicColor: tokens.backgroundColor))
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .center)
                        .cornerRadius(tokens.cornerRadius)
        )
        .contentShape(Rectangle())
        .onChange(of: isPresented, perform: { present in
            if present {
                presentAnimated()
            } else {
                dismissAnimated()
            }
        })
        .onAnimationComplete(for: presentationScaleFactor) {
            resetScaleFactor()
        }
        .opacity(opacity)
        .scaleEffect(presentationScaleFactor)
        .onTapGesture {
            state.tapAction?()
        }
    }

    /// Initializes the SwiftUI View for the Heads-up display.
    /// - Parameters:
    ///   - type: The `HUDType` enum value of the Heads-up display.
    ///   - isPresented: Binding boolean that controls whether the Heads-up display is presented.
    ///   - label: Label string presented by the Heads-up display.
    ///   - tapAction: Closure executed when the user taps on the Heads-up display.
    public init(type: HUDType,
                isPresented: Binding<Bool>? = nil,
                label: String? = nil,
                tapAction: (() -> Void)? = nil) {
        let stateImpl = MSFHUDStateImpl(type: type)
        stateImpl.label = label
        stateImpl.tapAction = tapAction
        state = stateImpl

        if let isPresented = isPresented {
            _isPresented = isPresented
            opacity = Constants.opacityDismissed
            presentationScaleFactor = HUD.Constants.showAnimationScale
        } else {
            _isPresented = .constant(true)
            opacity = Constants.opacityPresented
            presentationScaleFactor = Constants.presentationScaleFactorDefault
        }
    }

    let defaultTokens: HeadsUpDisplayTokens = .init()
    var tokens: HeadsUpDisplayTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Binding var isPresented: Bool
    @ObservedObject var state: MSFHUDStateImpl

    private func resetScaleFactor() {
        guard presentationScaleFactor != Constants.presentationScaleFactorDefault else {
            return
        }

        presentationScaleFactor = HUD.Constants.showAnimationScale
    }

    private func presentAnimated() {
        withAnimation(.linear(duration: HUD.Constants.showAnimationDuration)) {
            opacity = Constants.opacityPresented
            presentationScaleFactor = Constants.presentationScaleFactorDefault
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: HUD.Constants.hideAnimationDuration)) {
            opacity = Constants.opacityDismissed
            presentationScaleFactor = HUD.Constants.hideAnimationScale
        }
    }

    @State private var opacity: Double
    @State private var presentationScaleFactor: CGFloat

    private struct Constants {
        static let presentationScaleFactorDefault: CGFloat = 1
        static let opacityPresented: Double = 1.0
        static let opacityDismissed: Double = 0.0
    }
}

/// Properties available to customize the state of the HUD
class MSFHUDStateImpl: NSObject,
                       ObservableObject,
                       Identifiable,
                       ControlConfiguration,
                       MSFHUDState {
    @Published var label: String?
    @Published var overrideTokens: HeadsUpDisplayTokens?
    var tapAction: (() -> Void)?
    @Published var type: HUDType

    init(type: HUDType) {
        self.type = type
        super.init()
    }
}
