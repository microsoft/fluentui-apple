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

    /// Time it takes until notification auto-dismisses
    var delayTime: TimeInterval { get set }

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
}

/// View that represents the Notification.
public struct NotificationViewSwiftUI: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFNotificationTokens
    @ObservedObject var state: MSFNotificationStateImpl

    public init(style: MSFNotificationStyle,
                message: String,
                delayTime: TimeInterval) {
        let state = MSFNotificationStateImpl(style: style, message: message, delayTime: delayTime)
        self.state = state
        self.tokens = state.tokens
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

    private var safeAreaInsets: UIEdgeInsets {
        windowProvider?.window?.safeAreaInsets ?? UIEdgeInsets()
    }

    @ViewBuilder
    var image: some View {
        if state.style.isToast {
            if let image = state.image {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .frame(width: image.size.width, height: image.size.height, alignment: .center)
                    .foregroundColor(Color(tokens.foregroundColor))
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
                    .font(Font(tokens.boldTextFont))
                    .foregroundColor(Color(tokens.foregroundColor))
            }
        }
    }

    @ViewBuilder
    var messageLabel: some View {
        let messageFont = hasSecondTextRow ? Font(tokens.footnoteTextFont) : (state.style.isToast ? Font(tokens.boldTextFont) : Font(tokens.regularTextFont))
        Text(state.message)
            .font(messageFont)
            .foregroundColor(Color(tokens.foregroundColor))
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
                    dismissAction()
                    buttonAction()
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, tokens.horizontalPadding)
                .padding(.vertical, tokens.verticalPadding)
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(tokens.foregroundColor))
            } else {
                SwiftUI.Button(actionTitle) {
                    dismissAction()
                    buttonAction()
                }
                .lineLimit(1)
                .foregroundColor(Color(tokens.foregroundColor))
                .padding(.horizontal, tokens.horizontalPadding)
                .padding(.vertical, tokens.verticalPadding)
                .font(Font(tokens.boldTextFont))
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
        // Note: we are using viewController's width because GeometryReader relies on the bounds of the hosting controller which cannot be set accurately at this point
        if let windowWidth = windowProvider?.window?.bounds.width {
            let width = windowWidth - safeAreaInsets.left - safeAreaInsets.right
            innerContents
                .onTapGesture {
                    if let messageAction = state.messageButtonAction, let dismissAction = state.dismissAction {
                        dismissAction()
                        messageAction()
                    }
                }
                .frame(width: state.style.isToast && horizontalSizeClass == .regular ? width / 2 : width - (2 * tokens.presentationOffset))
                .background(
                    RoundedRectangle(cornerRadius: tokens.cornerRadius)
                        .strokeBorder(Color(tokens.outlineColor), lineWidth: tokens.outlineWidth)
                        .background(
                            RoundedRectangle(cornerRadius: tokens.cornerRadius)
                                .fill(Color(tokens.backgroundColor))
                        )
                        .shadow(color: Color(tokens.ambientShadowColor),
                                radius: tokens.ambientShadowBlur,
                                x: tokens.ambientShadowOffsetX,
                                y: tokens.ambientShadowOffsetY)
                        .shadow(color: Color(tokens.perimeterShadowColor),
                                radius: tokens.perimeterShadowBlur,
                                x: tokens.perimeterShadowOffsetX,
                                y: tokens.perimeterShadowOffsetY)
                )
                .designTokens(tokens,
                              from: theme,
                              with: windowProvider)
        }
    }
}

class MSFNotificationStateImpl: NSObject, ObservableObject, Identifiable, MSFNotificationState {
    @Published public var style: MSFNotificationStyle
    @Published public var message: String
    @Published public var delayTime: TimeInterval
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

    let tokens: MSFNotificationTokens

    init(style: MSFNotificationStyle, message: String, delayTime: TimeInterval) {
        self.style = style
        self.message = message
        self.delayTime = delayTime
        self.tokens = MSFNotificationTokens(style: style)
        super.init()
    }

    convenience init(style: MSFNotificationStyle,
                     message: String,
                     delayTime: TimeInterval,
                     title: String? = nil,
                     image: UIImage? = nil,
                     actionButtonTitle: String? = nil,
                     actionButtonAction: (() -> Void)? = nil,
                     messageButtonAction: (() -> Void)? = nil,
                     dismissAction: (() -> Void)? = nil) {
        self.init(style: style, message: message, delayTime: delayTime)

        self.title = title
        self.image = image
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
        self.dismissAction = dismissAction
    }
}
