//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties available to customize the state of the button
@objc public class MSFButtonState: NSObject, ObservableObject {
    @objc @Published public var image: UIImage?
    @objc @Published public var isDisabled: Bool = false
    @objc @Published public var text: String?
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
struct MSFButtonViewButtonStyle: ButtonStyle {
    var targetButton: MSFButtonView

    func makeBody(configuration: Self.Configuration) -> some View {
        let tokens = targetButton.tokens
        let state = targetButton.state
        let isDisabled = state.isDisabled
        let isPressed = configuration.isPressed
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
                    .font(Font(tokens.textFont))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: tokens.textMinimumHeight)
                }
        }
        .padding(tokens.padding)
        .modifyIf(state.text?.isEmpty == false, { view in
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
        .modifyIf(tokens.style.isFloatingStyle, { view in
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

/// View that represents the button
public struct MSFButtonView: View {
    var action: () -> Void
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonState

    public init(action: @escaping () -> Void,
                style: MSFButtonStyle,
                size: MSFButtonSize) {
        self.action = action
        self.state = MSFButtonState()
        self.tokens = MSFButtonTokens(style: style, size: size)
    }

    public var body: some View {
        Button(action: action, label: {})
            .buttonStyle(MSFButtonViewButtonStyle(targetButton: self))
            .disabled(state.isDisabled)
            .frame(maxWidth: .infinity)
            .onAppear {
                // When environment values are available through the view hierarchy:
                //  - If we get a non-default theme through the environment values,
                //    we use to override the theme from this view and its hierarchy.
                //  - Otherwise we just refresh the tokens to reflect the theme
                //    associated with the window that this View belongs to.
                if theme == ThemeKey.defaultValue {
                    self.tokens.updateForCurrentTheme()
                } else {
                    self.tokens.theme = theme
                }
            }
    }
}

/// UIKit wrapper that exposes the SwiftUI Button implementation
@objc open class MSFButton: NSObject, FluentUIWindowProvider {

    @objc open var action: ((_ sender: MSFButton) -> Void)?

    @objc open var state: MSFButtonState {
        return self.buttonView.state
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc public convenience init(style: MSFButtonStyle = .secondary,
                                  size: MSFButtonSize = .large,
                                  action: ((_ sender: MSFButton) -> Void)?) {
        self.init(style: style,
                  size: size,
                  action: action,
                  theme: nil)
    }

    @objc public init(style: MSFButtonStyle = .secondary,
                      size: MSFButtonSize = .large,
                      action: ((_ sender: MSFButton) -> Void)?,
                      theme: FluentUIStyle? = nil) {
        super.init()
        initialize(style: style,
                   size: size,
                   action: action,
                   theme: theme)
    }

    private func initialize(style: MSFButtonStyle = .secondary,
                            size: MSFButtonSize = .large,
                            action: ((_ sender: MSFButton) -> Void)?,
                            theme: FluentUIStyle? = nil) {
        self.action = action
        buttonView = MSFButtonView(action: {
            self.action?(self)
        },
        style: style,
        size: size)

        hostingController = UIHostingController(rootView: AnyView(buttonView.modifyIf(theme != nil, { buttonView in
            buttonView.usingTheme(theme!)
        })))
        buttonView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var buttonView: MSFButtonView!
}
