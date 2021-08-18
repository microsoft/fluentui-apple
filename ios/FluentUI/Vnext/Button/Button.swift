//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Properties that can be used to customize the appearance of the Button.
@objc public protocol MSFButtonState {

    /// The string representing the accessibility label of the button.
    var accessibilityLabel: String? { get set }

    /// Defines the icon image of the button.
    var image: UIImage? { get set }

    /// Controls whether the button is available for user interaction, renders the control accordingly.
    var isDisabled: Bool { get set }

    /// Text used as the label of the button.
    var text: String? { get set }

    /// Defines the size of the button.
    var size: MSFButtonSize { get set }

    /// Defines the style of the button.
    var style: MSFButtonStyle { get set }
}

/// View that represents the button.
public struct MSFButtonView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl

    /// Creates a MSFButtonView.
    /// - Parameters:
    ///   - style: The MSFButtonStyle used by the button.
    ///   - size: The MSFButtonSize value used by the button.
    ///   - image: The image used as the leading icon of the button.
    ///   - text: The text used in the button label.
    ///   - action: Closure that handles the button tap event.
    public init(style: MSFButtonStyle,
                size: MSFButtonSize,
                image: UIImage? = nil,
                text: String? = nil,
                action: @escaping () -> Void) {
        let state = MSFButtonStateImpl(style: style,
                                       size: size,
                                       action: action)
        state.text = text
        state.image = image
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        Button(action: state.action, label: {})
            .buttonStyle(MSFButtonViewButtonStyle(tokens: tokens,
                                                  state: state))
            .modifyIf(state.disabled != nil, { button in
                button.disabled(state.disabled!)
            })
            .frame(maxWidth: .infinity)
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }
}

class MSFButtonStateImpl: NSObject, ObservableObject, MSFButtonState {
    var action: () -> Void
    @Published var image: UIImage?
    @Published var disabled: Bool?
    @Published var text: String?

    var isDisabled: Bool {
        get {
            return disabled ?? false
        }
        set {
            disabled = newValue
        }
    }

    var size: MSFButtonSize {
        get {
            return tokens.size
        }
        set {
            tokens.size = newValue
        }
    }

    var style: MSFButtonStyle {
        get {
            return tokens.style
        }
        set {
            tokens.style = newValue
        }
    }

    var tokens: MSFButtonTokens

    init(style: MSFButtonStyle,
         size: MSFButtonSize,
         action: @escaping () -> Void) {
        self.tokens = MSFButtonTokens(style: style,
                                      size: size)
        self.action = action
        super.init()
    }
}

/// Body of the button adjusted for pressed or rest state
struct MSFButtonViewBody: View {
    @Environment(\.isEnabled) var isEnabled: Bool
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl
    let isPressed: Bool

    var body: some View {
        let isDisabled = !isEnabled
        let isFloatingStyle = tokens.style.isFloatingStyle
        let shouldUsePressedShadow = isDisabled || isPressed

        return HStack(spacing: tokens.interspace) {
            if let image = state.image {
                Image(uiImage: image)
                    .resizable()
                    .foregroundColor(Color(isDisabled ? tokens.disabledIconColor :
                                            (isPressed ? tokens.highlightedIconColor : tokens.iconColor)))
                    .frame(width: tokens.iconSize, height: tokens.iconSize, alignment: .center)
                }

            if let text = state.text {
                Text(text)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .scalableFont(font: tokens.textFont,
                                  shouldScale: !isFloatingStyle)
                    .modifyIf(isFloatingStyle, { view in
                        view.frame(minHeight: tokens.textMinimumHeight)
                    })
                }
        }
        .padding(tokens.padding)
        .modifyIf(isFloatingStyle && !(state.text?.isEmpty ?? true), { view in
            view.padding(.horizontal, tokens.textAdditionalHorizontalPadding )
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color(isDisabled ? tokens.disabledTitleColor :
                                (isPressed ? tokens.highlightedTitleColor : tokens.titleColor)))
        .background((tokens.borderSize > 0) ?
                        AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                                    .strokeBorder(lineWidth: tokens.borderSize, antialiased: false)
                                    .foregroundColor(Color(isDisabled ? tokens.disabledBorderColor :
                                                            (isPressed ? tokens.highlightedBorderColor : tokens.borderColor)))
                                    .contentShape(Rectangle()))
                                    :
                        AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                                    .fill(Color(isDisabled ? tokens.disabledBackgroundColor :
                                                    (isPressed ? tokens.highlightedBackgroundColor : tokens.backgroundColor)))))
        .modifyIf(isFloatingStyle, { view in
            view.clipShape(Capsule())
                .shadow(color: shouldUsePressedShadow ? tokens.pressedShadow1Color : tokens.restShadow1Color,
                        radius: shouldUsePressedShadow ? tokens.pressedShadow1Blur : tokens.restShadow1Blur,
                        x: shouldUsePressedShadow ? tokens.pressedShadow1DepthX : tokens.restShadow1DepthX,
                        y: shouldUsePressedShadow ? tokens.pressedShadow1DepthY : tokens.restShadow1DepthY)
                .shadow(color: shouldUsePressedShadow ? tokens.pressedShadow2Color : tokens.restShadow2Color,
                        radius: shouldUsePressedShadow ? tokens.pressedShadow2Blur : tokens.restShadow2Blur,
                        x: shouldUsePressedShadow ? tokens.pressedShadow2DepthX : tokens.restShadow2DepthX,
                        y: shouldUsePressedShadow ? tokens.pressedShadow2DepthY : tokens.restShadow2DepthY)
        })
    }
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
struct MSFButtonViewButtonStyle: ButtonStyle {
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl

    func makeBody(configuration: Self.Configuration) -> some View {
        MSFButtonViewBody(tokens: tokens,
                          state: state,
                          isPressed: configuration.isPressed)
    }
}
