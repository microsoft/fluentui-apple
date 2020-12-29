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
public class MSFButtonTokens: ObservableObject {
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

    var style: MSFButtonVnextStyle!
    var size: MSFButtonVnextSize!

    public init(style: MSFButtonVnextStyle,
                size: MSFButtonVnextSize) {
        self.style = style
        self.size = size
        self.themeAware = true

        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        var appearanceProxy: ApperanceProxyType

        switch style {
        case .primary:
            appearanceProxy = StylesheetManager.S.PrimaryButtonTokens
        case .secondary:
            appearanceProxy = StylesheetManager.S.SecondaryButtonTokens
        case .ghost:
            appearanceProxy = StylesheetManager.S.GhostButtonTokens
        case .none:
            appearanceProxy = StylesheetManager.S.MSFButtonTokens
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
        case .large, .none:
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
                }
        }
        .padding(tokens.padding)
        .foregroundColor(Color(isDisabled ? tokens.disabledTitleColor :
                                (isPressed ? tokens.highlightedTitleColor : tokens.titleColor)))
        .background((tokens.borderSize > 0) ?
                        AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                            .strokeBorder(lineWidth: tokens.borderSize, antialiased: false)
                            .foregroundColor(Color(isDisabled ? tokens.disabledBorderColor :
                                                    (isPressed ? tokens.highlightedBorderColor : tokens.borderColor))))
                                    :
                        AnyView(RoundedRectangle(cornerRadius: tokens.borderRadius)
                            .fill(Color(isDisabled ? tokens.disabledBackgroundColor :
                                            (isPressed ? tokens.highlightedBackgroundColor : tokens.backgroundColor)))))
    }
}

/// View that represents the button
public struct MSFButtonView: View {
    var action: () -> Void
    @ObservedObject var tokens: MSFButtonTokens
    @ObservedObject var state: MSFButtonVnextState

    public init(action: @escaping () -> Void,
                style: MSFButtonVnextStyle,
                size: MSFButtonVnextSize) {
        self.action = action
        self.tokens = MSFButtonTokens(style: style, size: size)
        self.state = MSFButtonVnextState()
    }

    public var body: some View {
        Button(action: action, label: {})
            .buttonStyle(MSFButtonViewButtonStyle(targetButton: self))
            .disabled(state.isDisabled)
            .fixedSize()
    }
}

@objc(MSFButtonVnext)
/// UIKit wrapper that exposes the SwiftUI Button implementation
open class MSFButtonVnext: NSObject {

    private var hostingController: UIHostingController<MSFButtonView>

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFButtonVnextState {
        return self.hostingController.rootView.state
    }

    @objc public init(style: MSFButtonVnextStyle = .secondary,
                      size: MSFButtonVnextSize = .large,
                      action: @escaping () -> Void) {
        self.hostingController = UIHostingController(rootView: MSFButtonView(action: action,
                                                                             style: style,
                                                                             size: size))
        super.init()
        self.view.backgroundColor = UIColor.clear
    }
}
