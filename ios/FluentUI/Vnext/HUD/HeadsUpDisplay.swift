//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

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

/// Properties available to customize the state of the Heads-up Display state.
public protocol MSFHUDState {

    /// Label string presented by the Heads-up Display.
    var label: String? { get set }

    /// The action executed when the Heads up display is tapped.
    var tapAction: (() -> Void)? { get set }

    /// The `HUDType` enum value of the Heads-up Display.
    var type: HUDType { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: HeadsUpDisplayTokens? { get set }
}

/// View that represents the Heads-up Display.
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
                            return image
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

    /// UIKit wrapper that exposes the SwiftUI Heads-up Display implementation.
    /// - Parameters:
    ///   - type: The `HUDType` enum value of the Heads-up Display.
    ///   - isPresented: Binding boolean that controls whether the Heads-up Display is presented.
    ///   - label: Label string presented by the Heads-up Display.
    ///   - tapAction: Closure executed when the user taps on the Heads-up Display.
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
    @State var opacity: Double
    @State var presentationScaleFactor: CGFloat
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

    private struct Constants {
        static let presentationScaleFactorDefault: CGFloat = 1
        static let opacityPresented: Double = 1
        static let opacityDismissed: Double = 0
    }
}

/// UIKit wrapper that exposes the SwiftUI Heads-up display implementation
open class MSFHeadsUpDisplay: ControlHostingView {

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameters:
    ///   - type: The MSFHUDType value used by the Heads-up display.
    ///   - label: The label for the Heads up display.
    ///   - tapAction: The action executed when the Heads up display is tapped.
    public init(type: HUDType = .activity,
                label: String?,
                tapAction: (() -> Void)? = nil) {
        let hudView = HeadsUpDisplay(type: type,
                                     label: label,
                                     tapAction: tapAction)
        state = hudView.state
        super.init(AnyView(hudView))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Activity Indicator appearance.
    public var state: MSFHUDState
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
