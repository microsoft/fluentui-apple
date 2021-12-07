//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState {
    /// Style to draw the control.
    var style: MSFNotificationStyle { get }

    /// Optional text to draw above the message area.
    var title: String? { get set }

    /// Text for the main title area of the control. If there is a title, the message becomes subtext.
    var message: String { get set }

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
}

/// View that represents the Notification.
public struct NotificationViewSwiftUI: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.swiftUIInsets) private var safeAreaInsets: EdgeInsets
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFNotificationTokens
    @ObservedObject var state: MSFNotificationStateImpl

    public init(style: MSFNotificationStyle,
                title: String = "",
                message: String,
                image: UIImage? = nil,
                actionButtonTitle: String = "",
                actionButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil,
                dismissAction: @escaping (() -> Void)) {
        let state = MSFNotificationStateImpl(style: style,
                                             title: title,
                                             message: message,
                                             image: image,
                                             actionButtonTitle: actionButtonTitle,
                                             actionButtonAction: actionButtonAction,
                                             messageButtonAction: messageButtonAction)
        self.state = state
        self.tokens = state.tokens
        self.dismissAction = dismissAction
    }

    public var dismissAction: (() -> Void)

    private var hasImage: Bool {
        state.style.isToast && state.image != nil
    }

    private var hasSecondTextRow: Bool {
        state.style.isToast && state.title != ""
    }

    private var hasCenteredText: Bool {
        !state.style.isToast && state.actionButtonAction == nil
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
        if let action = state.actionButtonAction, let actionTitle = state.actionButtonTitle {
            if actionTitle.isEmpty {
                SwiftUI.Button(action: {
                    dismissAction()
                    action()
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, tokens.horizontalPadding)
                .padding(.vertical, tokens.verticalPadding)
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(tokens.foregroundColor))
            } else {
                if let action = state.actionButtonAction {
                    SwiftUI.Button(actionTitle) {
                        dismissAction()
                        action()
                    }
                    .lineLimit(1)
                    .foregroundColor(Color(tokens.foregroundColor))
                    .padding(.horizontal, tokens.horizontalPadding)
                    .padding(.vertical, tokens.verticalPadding)
                    .font(Font(tokens.boldTextFont))
                }
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
        if let windowWidth = UIApplication.shared.keyWindow?.bounds.width {
            let width = windowWidth - safeAreaInsets.leading - safeAreaInsets.trailing
            innerContents
                .onTapGesture {
                    if let action = state.messageButtonAction {
                        dismissAction()
                        action()
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
                        .shadow(color: Color(tokens.ambientShadowColor), radius: tokens.ambientShadowBlur, x: tokens.ambientShadowOffsetX, y: tokens.ambientShadowOffsetY)
                        .shadow(color: Color(tokens.perimeterShadowColor), radius: tokens.perimeterShadowBlur, x: tokens.perimeterShadowOffsetX, y: tokens.perimeterShadowOffsetY)
                )
                .designTokens(tokens,
                              from: theme,
                              with: windowProvider)
        }
    }
}

class MSFNotificationStateImpl: NSObject, ObservableObject, MSFNotificationState {
    @Published public var style: MSFNotificationStyle
    @Published public var title: String?
    @Published public var message: String
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

    let tokens: MSFNotificationTokens

    init(style: MSFNotificationStyle,
         message: String) {
        self.style = style
        self.message = message
        self.tokens = MSFNotificationTokens(style: style)
        super.init()
    }

    convenience init(style: MSFNotificationStyle,
                     title: String,
                     message: String,
                     image: UIImage?,
                     actionButtonTitle: String,
                     actionButtonAction: (() -> Void)?,
                     messageButtonAction: (() -> Void)?) {
        self.init(style: style,
                  message: message)

        self.title = title
        self.image = image
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
    }
}
