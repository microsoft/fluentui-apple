//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(MSFButtonVnextStyle)
/// Pre-defined styles of the button
public enum MSFButtonVnextStyle: Int, CaseIterable {
    case primary
    case secondary
    case ghost
}

@objc(MSFButtonVnextSize)
/// Pre-defined sizes of the button
public enum MSFButtonVnextSize: Int, CaseIterable {
    case small
    case medium
    case large
}

@objc(MSFButtonVnextState)
/// Properties available to customize the state of the button
public class MSFButtonVnextState: NSObject, ObservableObject {
    @objc @Published public var image: UIImage?
    @objc @Published public var isDisabled: Bool = false
    @objc @Published public var text: String?
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
public class MSFButtonTokens: MSFTokensBase, ObservableObject {
    @Published public var borderRadius: CGFloat!
    @Published public var borderSize: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var interspace: CGFloat!
    @Published public var padding: CGFloat!
    @Published public var textFont: UIFont!

    @Published public var titleColor: UIColor!
    @Published public var borderColor: UIColor!
    @Published public var backgroundColor: UIColor!
    @Published public var iconColor: UIColor!

    @Published public var highlightedTitleColor: UIColor!
    @Published public var highlightedBorderColor: UIColor!
    @Published public var highlightedBackgroundColor: UIColor!
    @Published public var highlightedIconColor: UIColor!

    @Published public var disabledTitleColor: UIColor!
    @Published public var disabledBorderColor: UIColor!
    @Published public var disabledBackgroundColor: UIColor!
    @Published public var disabledIconColor: UIColor!

    var style: MSFButtonVnextStyle
    var size: MSFButtonVnextSize

    public init(style: MSFButtonVnextStyle,
                size: MSFButtonVnextSize) {
        self.style = style
        self.size = size

        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .primary:
            appearanceProxy = currentTheme.PrimaryButtonTokens
        case .secondary:
            appearanceProxy = currentTheme.SecondaryButtonTokens
        case .ghost:
            appearanceProxy = currentTheme.GhostButtonTokens
        }

        titleColor = appearanceProxy.textColor.rest
        borderColor = appearanceProxy.borderColor.rest
        backgroundColor = appearanceProxy.backgroundColor.rest
        iconColor = appearanceProxy.iconColor.rest

        highlightedTitleColor = appearanceProxy.textColor.pressed
        highlightedBorderColor = appearanceProxy.borderColor.pressed
        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed
        highlightedIconColor = appearanceProxy.iconColor.pressed

        disabledTitleColor = appearanceProxy.textColor.disabled
        disabledBorderColor = appearanceProxy.borderColor.disabled
        disabledBackgroundColor = appearanceProxy.backgroundColor.disabled
        disabledIconColor = appearanceProxy.iconColor.disabled

        switch size {
        case .large:
            borderRadius = appearanceProxy.borderRadius.large
            borderSize = appearanceProxy.borderSize.large
            iconSize = appearanceProxy.iconSize.large
            interspace = appearanceProxy.interspace.large
            padding = appearanceProxy.padding.large
            textFont = appearanceProxy.textFont.large
        case .medium:
            borderRadius = appearanceProxy.borderRadius.medium
            borderSize = appearanceProxy.borderSize.medium
            iconSize = appearanceProxy.iconSize.medium
            interspace = appearanceProxy.interspace.medium
            padding = appearanceProxy.padding.medium
            textFont = appearanceProxy.textFont.medium
        case .small:
            borderRadius = appearanceProxy.borderRadius.small
            borderSize = appearanceProxy.borderSize.small
            iconSize = appearanceProxy.iconSize.small
            interspace = appearanceProxy.interspace.small
            padding = appearanceProxy.padding.small
            textFont = appearanceProxy.textFont.small
        }
    }
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
public struct MSFButtonViewButtonStyle: ButtonStyle {
    var targetButton: MSFButtonView

    public func makeBody(configuration: Self.Configuration) -> some View {
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
    @ObservedObject var state: MSFButtonVnextState

    public init(action: @escaping () -> Void,
                style: MSFButtonVnextStyle,
                size: MSFButtonVnextSize) {
        self.action = action
        self.state = MSFButtonVnextState()
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

@objc(MSFButtonVnext)
/// UIKit wrapper that exposes the SwiftUI Button implementation
open class MSFButtonVnext: NSObject, FluentUIWindowProvider {

    private var hostingController: UIHostingController<AnyView>!

    private var buttonView: MSFButtonView!

    @objc open var action: ((_ sender: MSFButtonVnext) -> Void)?

    @objc open var state: MSFButtonVnextState {
        return self.buttonView.state
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    public var window: UIWindow? {
        return self.view.window
    }

    @objc public convenience init(style: MSFButtonVnextStyle = .secondary,
                                  size: MSFButtonVnextSize = .large,
                                  action: ((_ sender: MSFButtonVnext) -> Void)?) {
        self.init(style: style,
                  size: size,
                  action: action,
                  theme: nil)
    }

    @objc public init(style: MSFButtonVnextStyle = .secondary,
                      size: MSFButtonVnextSize = .large,
                      action: ((_ sender: MSFButtonVnext) -> Void)?,
                      theme: FluentUIStyle? = nil) {
        super.init()
        initialize(style: style,
                   size: size,
                   action: action,
                   theme: theme)
    }

    private func initialize(style: MSFButtonVnextStyle = .secondary,
                            size: MSFButtonVnextSize = .large,
                            action: ((_ sender: MSFButtonVnext) -> Void)?,
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
}
