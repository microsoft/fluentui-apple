//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState: NSObjectProtocol {
    /// Style to draw the control.
    var style: MSFNotificationStyle { get }

    /// Text for the main title area of the control. If there is a title, the message becomes subtext.
    var message: String { get set }

    /// Optional text to draw above the message area.
    var title: String? { get set }

    /// Optional icon to draw at the leading edge of the control.
    var image: UIImage? { get set }

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    var actionButtonTitle: String? { get set }

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    var actionButtonAction: (() -> Void)? { get set }

    /// Action to be dispatched by tapping on the toast/bar notification.
    var messageButtonAction: (() -> Void)? { get set }

    /// Action to be dispatched when dismissing toast/bar notification.
    var dismissAction: (() -> Void)? { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: NotificationTokens? { get set }
}

/// View that represents the Notification.
public struct NotificationViewSwiftUI: View, ConfigurableTokenizedControl {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @ObservedObject var state: MSFNotificationStateImpl
    @Binding var isPresented: Bool
    @State private var height: CGFloat = 0
    @State private var yOffsetFromBottom: CGFloat = 0
    let defaultTokens: NotificationTokens = .init()
    var tokens: NotificationTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
    }
    public func overrideTokens(_ tokens: NotificationTokens?) -> NotificationViewSwiftUI {
        state.overrideTokens = tokens
        return self
    }

    public init(style: MSFNotificationStyle,
                message: String,
                isPresented: Binding<Bool>? = nil,
                title: String = "",
                image: UIImage? = nil,
                actionButtonTitle: String = "",
                actionButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil,
                dismissAction: (() -> Void)? = nil) {
        let state = MSFNotificationStateImpl(style: style, message: message)
        state.title = title
        state.image = image
        state.actionButtonTitle = actionButtonTitle
        state.actionButtonAction = actionButtonAction
        state.messageButtonAction = messageButtonAction
        state.dismissAction = dismissAction
        self.state = state

        if let isPresented = isPresented {
            _isPresented = isPresented
        } else {
            _isPresented = .constant(true)
        }
    }

    private var hasImage: Bool {
        state.style.isToast && state.image != nil
    }

    private var hasSecondTextRow: Bool {
        state.style.isToast && state.title != ""
    }

    private var hasCenteredText: Bool {
        !state.style.isToast && state.actionButtonAction == nil
    }

    private func presentAnimated() {
        withAnimation(.spring(response: tokens.style.animationDurationForShow, dampingFraction: tokens.style.animationDampingRatio, blendDuration: 0)) {
            yOffsetFromBottom = 0
        }
    }

    private func dismissAnimated() {
        withAnimation(.spring(response: tokens.style.animationDurationForHide, dampingFraction: tokens.style.animationDampingRatio, blendDuration: 0)) {
            yOffsetFromBottom = height + tokens.bottomPresentationPadding + (tokens.ambientShadowOffsetY / 2)
        }
    }

    @ViewBuilder
    var image: some View {
        if state.style.isToast {
            if let image = state.image {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .frame(width: image.size.width, height: image.size.height, alignment: .center)
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
                    .padding(.vertical, tokens.verticalPadding)
                    .padding(.leading, tokens.horizontalPadding)
            }
        }
    }

    @ViewBuilder
    var titleLabel: some View {
        if state.style.isToast && hasSecondTextRow {
            if let title = state.title {
                Text(title)
                    .font(.fluent(tokens.boldTextFont))
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
            }
        }
    }

    @ViewBuilder
    var messageLabel: some View {
        let messageFont = hasSecondTextRow ? tokens.footnoteTextFont : (state.style.isToast ? tokens.boldTextFont : tokens.regularTextFont)
        Text(state.message)
            .font(.fluent(messageFont))
            .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
    }

    @ViewBuilder
    var textContainer: some View {
        VStack(alignment: .leading) {
            if hasSecondTextRow {
                titleLabel
            }
            messageLabel
        }
        .padding(.horizontal, !hasImage ? tokens.horizontalPadding : 0)
        .padding(.vertical, hasSecondTextRow ? tokens.verticalPadding : tokens.verticalPaddingForOneLine)
    }

    @ViewBuilder
    var button: some View {
        if let buttonAction = state.actionButtonAction, let actionTitle = state.actionButtonTitle, let dismissAction = state.dismissAction {
            if actionTitle.isEmpty {
                SwiftUI.Button(action: {
                    isPresented = false
                    dismissAction()
                    buttonAction()
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, tokens.horizontalPadding)
                .padding(.vertical, tokens.verticalPadding)
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
            } else {
                SwiftUI.Button(actionTitle) {
                    isPresented = false
                    dismissAction()
                    buttonAction()
                }
                .lineLimit(1)
                .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
                .padding(.horizontal, tokens.horizontalPadding)
                .padding(.vertical, tokens.verticalPadding)
                .font(.fluent(tokens.boldTextFont))
            }
        }
    }

    @ViewBuilder
    var innerContents: some View {
        if hasCenteredText {
            textContainer
        } else {
            HStack(spacing: tokens.horizontalSpacing) {
                image
                textContainer
                Spacer(minLength: tokens.horizontalPadding)
                button
                    .layoutPriority(1)
            }
            .frame(minHeight: tokens.minimumHeight)
        }
    }

    public var body: some View {
        if let viewControllerWidth = viewControllerHolder?.view.frame.width {
            innerContents
                .alignmentGuide(VerticalAlignment.bottom) { (viewDimensions) -> CGFloat in
                    DispatchQueue.main.async {
                        height = viewDimensions.height
                        if isPresented == true {
                            yOffsetFromBottom = 0
                        } else {
                            yOffsetFromBottom = height + tokens.bottomPresentationPadding + (tokens.ambientShadowOffsetY / 2)
                        }
                    }
                    return viewDimensions[VerticalAlignment.bottom]
                }
                .onTapGesture {
                    if let messageAction = state.messageButtonAction, let dismissAction = state.dismissAction {
                        isPresented = false
                        dismissAction()
                        messageAction()
                    }
                }
                .frame(width: state.style.isToast && horizontalSizeClass == .regular ? viewControllerWidth / 2 : viewControllerWidth - (2 * tokens.presentationOffset), alignment: .bottom)
                .background(
                    RoundedRectangle(cornerRadius: tokens.cornerRadius)
                        .strokeBorder(Color(dynamicColor: tokens.outlineColor), lineWidth: tokens.outlineWidth)
                        .background(
                            RoundedRectangle(cornerRadius: tokens.cornerRadius)
                                .fill(Color(dynamicColor: tokens.backgroundColor))
                        )
                        .shadow(color: Color(dynamicColor: tokens.ambientShadowColor),
                                radius: tokens.ambientShadowBlur,
                                x: tokens.ambientShadowOffsetX,
                                y: tokens.ambientShadowOffsetY)
                        .shadow(color: Color(dynamicColor: tokens.perimeterShadowColor),
                                radius: tokens.perimeterShadowBlur,
                                x: tokens.perimeterShadowOffsetX,
                                y: tokens.perimeterShadowOffsetY)
                )
                .onChange(of: isPresented, perform: { present in
                    if present {
                        presentAnimated()
                    } else {
                        dismissAnimated()
                    }
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, tokens.bottomPresentationPadding)
                .offset(y: yOffsetFromBottom)
        }
    }
}

class MSFNotificationStateImpl: NSObject, ControlConfiguration, MSFNotificationState {
    @Published public var message: String
    @Published public var title: String?
    @Published public var image: UIImage?

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published public var actionButtonTitle: String?

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published public var actionButtonAction: (() -> Void)?

    /// Action to be dispatched by tapping on the toast/bar notification.
    @Published public var messageButtonAction: (() -> Void)?

    /// Action to be dispatched when dismissing toast/bar notification.
    @Published public var dismissAction: (() -> Void)?

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    @Published var overrideTokens: NotificationTokens?

    /// Style to draw the control.
    @Published public var style: MSFNotificationStyle

    @objc init(style: MSFNotificationStyle, message: String) {
        self.style = style
        self.message = message

        super.init()
    }

    convenience init(style: MSFNotificationStyle,
                     message: String,
                     title: String? = nil,
                     image: UIImage? = nil,
                     actionButtonTitle: String? = nil,
                     actionButtonAction: (() -> Void)? = nil,
                     messageButtonAction: (() -> Void)? = nil,
                     dismissAction: (() -> Void)? = nil) {
        self.init(style: style, message: message)

        self.title = title
        self.image = image
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
        self.dismissAction = dismissAction
    }
}
