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
public struct FluentButton: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl

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
        self.tokens = state.tokens
    }

    public var body: some View {
        Button(action: state.action, label: {})
            .buttonStyle(FluentButtonStyle(tokens: tokens,
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
struct FluentButtonBody: View {
    @Environment(\.isEnabled) var isEnabled: Bool
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl
    let isPressed: Bool

    var body: some View {
        let isDisabled = !isEnabled
        let isFloatingStyle = tokens.style.isFloatingStyle
        let shouldUsePressedShadow = isDisabled || isPressed
        let iconColor: UIColor
        let titleColor: UIColor
        let borderColor: UIColor
        let backgroundColor: UIColor
        if isDisabled {
            iconColor = tokens.disabledIconColor
            titleColor = tokens.disabledTitleColor
            borderColor = tokens.disabledBorderColor
            backgroundColor = tokens.disabledBackgroundColor
        } else if isPressed {
            iconColor = tokens.highlightedIconColor
            titleColor = tokens.highlightedTitleColor
            borderColor = tokens.highlightedBorderColor
            backgroundColor = tokens.highlightedBackgroundColor
        } else {
            iconColor = tokens.iconColor
            titleColor = tokens.titleColor
            borderColor = tokens.borderColor
            backgroundColor = tokens.backgroundColor
        }

        @ViewBuilder
        var buttonContent: some View {
            HStack(spacing: tokens.interspace) {
                if let image = state.image {
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(Color(iconColor))
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
            .foregroundColor(Color(titleColor))
        }

        @ViewBuilder
        var buttonBackground: some View {
            if tokens.borderSize > 0 {
                buttonContent.background(
                    AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                                .strokeBorder(lineWidth: tokens.borderSize, antialiased: false)
                                .foregroundColor(Color(borderColor))
                                .contentShape(Rectangle())))
            } else {
                buttonContent.background(
                    AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                                .fill(Color(backgroundColor))))
            }
        }

        let shadow1Color: Color
        let shadow1Blur: CGFloat
        let shadow1DepthX: CGFloat
        let shadow1DepthY: CGFloat
        let shadow2Color: Color
        let shadow2Blur: CGFloat
        let shadow2DepthX: CGFloat
        let shadow2DepthY: CGFloat
        if shouldUsePressedShadow {
            shadow1Color = tokens.pressedShadow1Color
            shadow1Blur = tokens.pressedShadow1Blur
            shadow1DepthX = tokens.pressedShadow1DepthX
            shadow1DepthY = tokens.pressedShadow1DepthY
            shadow2Color = tokens.pressedShadow2Color
            shadow2Blur = tokens.pressedShadow2Blur
            shadow2DepthX = tokens.pressedShadow2DepthX
            shadow2DepthY = tokens.pressedShadow2DepthY
        } else {
            shadow1Color = tokens.restShadow1Color
            shadow1Blur = tokens.restShadow1Blur
            shadow1DepthX = tokens.restShadow1DepthX
            shadow1DepthY = tokens.restShadow1DepthY
            shadow2Color = tokens.restShadow2Color
            shadow2Blur = tokens.restShadow2Blur
            shadow2DepthX = tokens.restShadow2DepthX
            shadow2DepthY = tokens.restShadow2DepthY
        }

        @ViewBuilder
        var button: some View {
            if isFloatingStyle {
                buttonBackground
                    .clipShape(Capsule())
                    .shadow(color: shadow1Color,
                            radius: shadow1Blur,
                            x: shadow1DepthX,
                            y: shadow1DepthY)
                    .shadow(color: shadow2Color,
                            radius: shadow2Blur,
                            x: shadow2DepthX,
                            y: shadow2DepthY)
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
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonStateImpl

    func makeBody(configuration: Self.Configuration) -> some View {
        FluentButtonBody(tokens: tokens,
                         state: state,
                         isPressed: configuration.isPressed)
    }
}
