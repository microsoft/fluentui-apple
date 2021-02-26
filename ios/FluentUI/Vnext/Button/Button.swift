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
                }
        }
        .padding(tokens.padding)
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

        self.hostingController = UIHostingController(rootView: theme != nil ? AnyView(buttonView.usingTheme(theme!)) : AnyView(buttonView))
        buttonView.tokens.windowProvider = self
        self.view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var buttonView: MSFButtonView!
}
