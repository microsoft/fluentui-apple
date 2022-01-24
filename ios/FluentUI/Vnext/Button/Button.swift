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

    /// Custom design token set for this button, to use in place of the control's default Fluent tokens.
    var overrideTokens: ButtonTokens? { get set }
}

/// View that represents the button.
public struct FluentButton: View, TokenizedControlInternal {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFButtonStateImpl
    var tokens: ButtonTokens { state.tokens }

    /// Creates a FluentButton.
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
    }

    public var body: some View {
        Button(action: state.action, label: {})
            .buttonStyle(FluentButtonStyle(state: state, tokens: tokens))
            .modifyIf(state.disabled != nil, { button in
                button.disabled(state.disabled!)
            })
            .frame(maxWidth: .infinity)
            .resolveTokens(self)
            .resolveTokenModifier(self, value: state.size)
            .resolveTokenModifier(self, value: state.style)
    }
}

class MSFButtonStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFButtonState {
    var action: () -> Void
    @Published var image: UIImage?
    @Published var disabled: Bool?
    @Published var text: String?
    @Published var size: MSFButtonSize
    @Published var style: MSFButtonStyle

    @Published var overrideTokens: ButtonTokens?
    @Published var tokens: ButtonTokens
    var defaultTokens: ButtonTokens { .init(style: self.style, size: self.size) }

    var isDisabled: Bool {
        get {
            return disabled ?? false
        }
        set {
            disabled = newValue
        }
    }

    init(style: MSFButtonStyle,
         size: MSFButtonSize,
         action: @escaping () -> Void) {
        self.size = size
        self.style = style
        self.action = action
        self.tokens = ButtonTokens(style: style, size: size)
        super.init()
    }
}

/// Body of the button adjusted for pressed or rest state
struct FluentButtonBody: View {
    @Environment(\.isEnabled) var isEnabled: Bool
    @ObservedObject var state: MSFButtonStateImpl
    var tokens: ButtonTokens
    let isPressed: Bool

    var body: some View {
        let isDisabled = !isEnabled
        let isFloatingStyle = tokens.style.isFloatingStyle
        let shouldUsePressedShadow = isDisabled || isPressed
        let iconColor: DynamicColor
        let textColor: DynamicColor
        let borderColor: DynamicColor
        let backgroundColor: DynamicColor
        if isDisabled {
            iconColor = tokens.iconColor.disabled
            textColor = tokens.textColor.disabled
            borderColor = tokens.borderColor.disabled
            backgroundColor = tokens.backgroundColor.disabled
        } else if isPressed {
            iconColor = tokens.iconColor.pressed
            textColor = tokens.textColor.pressed
            borderColor = tokens.borderColor.pressed
            backgroundColor = tokens.backgroundColor.pressed
        } else {
            iconColor = tokens.iconColor.rest
            textColor = tokens.textColor.rest
            borderColor = tokens.borderColor.rest
            backgroundColor = tokens.backgroundColor.rest
        }

        @ViewBuilder
        var buttonContent: some View {
            HStack(spacing: tokens.interspace) {
                if let image = state.image {
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(Color(dynamicColor: iconColor))
                        .frame(width: tokens.iconSize, height: tokens.iconSize, alignment: .center)
                }
                if let text = state.text {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.fluent(tokens.textFont, shouldScale: !isFloatingStyle))
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
            .foregroundColor(Color(dynamicColor: textColor))
        }

        @ViewBuilder
        var buttonBackground: some View {
            if tokens.borderSize > 0 {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: tokens.borderRadius)
                        .strokeBorder(lineWidth: tokens.borderSize, antialiased: false)
                        .foregroundColor(Color(dynamicColor: borderColor))
                        .contentShape(Rectangle()))
            } else {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: tokens.borderRadius)
                        .fill(Color(dynamicColor: backgroundColor)))
            }
        }

        let shadowInfo = shouldUsePressedShadow ? tokens.pressedShadow : tokens.restShadow

        @ViewBuilder
        var button: some View {
            if isFloatingStyle {
                buttonBackground
                    .clipShape(Capsule())
                    .shadow(color: Color(dynamicColor: shadowInfo.colorOne),
                            radius: shadowInfo.blurOne,
                            x: shadowInfo.xOne,
                            y: shadowInfo.yOne)
                    .shadow(color: Color(dynamicColor: shadowInfo.colorTwo),
                            radius: shadowInfo.blurTwo,
                            x: shadowInfo.xTwo,
                            y: shadowInfo.yTwo)
                    .contentShape(Capsule())
            } else {
                buttonBackground
                    .contentShape(RoundedRectangle(cornerRadius: tokens.borderRadius))
            }
        }

        return button
            .pointerInteraction(isEnabled)
    }
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
struct FluentButtonStyle: ButtonStyle {
    @ObservedObject var state: MSFButtonStateImpl
    var tokens: ButtonTokens

    func makeBody(configuration: Self.Configuration) -> some View {
        FluentButtonBody(state: state,
                         tokens: tokens,
                         isPressed: configuration.isPressed)
    }
}
