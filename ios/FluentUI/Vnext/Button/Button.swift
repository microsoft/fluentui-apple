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
public struct FluentButton: View, TokenizedControlView {
    public typealias TokenSetKeyType = ButtonTokenSet.Tokens
    @ObservedObject public var tokenSet: ButtonTokenSet

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
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
        self.tokenSet = ButtonTokenSet(style: { state.style },
                                       size: { state.size })
    }

    public var body: some View {
        Button(action: state.action) {
            if let image = state.image {
                Image(uiImage: image)
            }
            if let text = state.text {
                Text(text)
            }
        }
        .buttonStyle(FluentButtonStyle(state: state,
                                       tokenSet: tokenSet))
        .disabled(state.disabled ?? false)
        .frame(maxWidth: .infinity)
        .modifyIf(state.style.isFloatingStyle, { button in
            button.showsLargeContentViewer()
        })
        .fluentTokens(tokenSet, fluentTheme)
    }
}

class MSFButtonStateImpl: ControlState, MSFButtonState {
    var action: () -> Void
    @Published var image: UIImage?
    @Published var disabled: Bool?
    @Published var isFocused: Bool = false
    @Published var text: String?
    @Published var size: MSFButtonSize
    @Published var style: MSFButtonStyle

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

        super.init()
    }
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
struct FluentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    @ObservedObject var state: MSFButtonStateImpl
    @ObservedObject var tokenSet: ButtonTokenSet
    @State var isPressed: Bool = false

    func makeBody(configuration: Self.Configuration) -> some View {
        isPressed = configuration.isPressed
        return body
    }

    var body: some View {
        let isDisabled = !isEnabled
        let isFocused = state.isFocused
        let isFloatingStyle = state.style.isFloatingStyle
        let shouldUsePressedShadow = isDisabled || isPressed
        let verticalPadding = tokenSet[.minVerticalPadding].float
        let horizontalPadding = tokenSet[.horizontalPadding].float
        let iconColor: DynamicColor
        let textColor: DynamicColor
        let borderColor: DynamicColor
        let backgroundColor: DynamicColor
        if isDisabled {
            iconColor = tokenSet[.iconColorDisabled].dynamicColor
            textColor = tokenSet[.textColorDisabled].dynamicColor
            borderColor = tokenSet[.borderColorDisabled].dynamicColor
            backgroundColor = tokenSet[.backgroundColorDisabled].dynamicColor
        } else if isPressed || isFocused {
            iconColor = tokenSet[.iconColorPressed].dynamicColor
            textColor = tokenSet[.textColorPressed].dynamicColor
            borderColor = tokenSet[.borderColorPressed].dynamicColor
            backgroundColor = tokenSet[.backgroundColorPressed].dynamicColor
        } else {
            iconColor = tokenSet[.iconColor].dynamicColor
            textColor = tokenSet[.textColor].dynamicColor
            borderColor = tokenSet[.borderColor].dynamicColor
            backgroundColor = tokenSet[.backgroundColor].dynamicColor
        }

        @ViewBuilder
        var buttonContent: some View {
            HStack(spacing: tokenSet[.interspace].float) {
                if let image = state.image {
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(Color(dynamicColor: iconColor))
                        .frame(width: tokenSet[.iconSize].float, height: tokenSet[.iconSize].float, alignment: .center)
                }
                if let text = state.text {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.fluent(tokenSet[.textFont].fontInfo, shouldScale: !isFloatingStyle))
                        .modifyIf(isFloatingStyle, { view in
                            view.frame(minHeight: tokenSet[.textMinimumHeight].float)
                        })
                }
            }
            .padding(EdgeInsets(top: verticalPadding,
                                leading: horizontalPadding,
                                bottom: verticalPadding,
                                trailing: horizontalPadding))
            .modifyIf(isFloatingStyle && !(state.text?.isEmpty ?? true), { view in
                view.padding(.horizontal, tokenSet[.textAdditionalHorizontalPadding].float )
            })
            .frame(maxWidth: .infinity, minHeight: tokenSet[.minHeight].float, maxHeight: .infinity)
            .foregroundColor(Color(dynamicColor: textColor))
        }

        @ViewBuilder
        var buttonBackground: some View {
            if tokenSet[.borderSize].float > 0 {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: tokenSet[.borderRadius].float)
                        .strokeBorder(lineWidth: tokenSet[.borderSize].float, antialiased: false)
                        .foregroundColor(Color(dynamicColor: borderColor))
                        .contentShape(Rectangle()))
            } else {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: tokenSet[.borderRadius].float)
                        .fill(Color(dynamicColor: backgroundColor)))
            }
        }

        let shadowInfo = shouldUsePressedShadow ? tokenSet[.pressedShadow].shadowInfo : tokenSet[.restShadow].shadowInfo

        @ViewBuilder
        var button: some View {
            if isFloatingStyle {
                buttonBackground
                    .clipShape(Capsule())
                    .applyShadow(shadowInfo: shadowInfo)
                    .contentShape(Capsule())
            } else {
                buttonBackground
                    .contentShape(RoundedRectangle(cornerRadius: tokenSet[.borderRadius].float))
            }
        }

        return button
            .pointerInteraction(isEnabled)
    }

}
