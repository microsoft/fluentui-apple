//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState: NSObjectProtocol {
    /// Style to draw the control.
    var style: MSFNotificationStyle { get }

    /// Optional text for the main title area of the control. If there is a title, the message becomes subtext.
    var message: String? { get set }

    /// Optional attributed text for the main title area of the control. If there is a title, the message becomes subtext.
    var attributedMessage: NSAttributedString? { get set }

    /// Optional text to draw above the message area.
    var title: String? { get set }

    /// Optional attributed text to draw above the message area.
    var attributedTitle: NSAttributedString? { get set }

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

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: NotificationTokens? { get set }
}

/// View that represents the Notification.
public struct FluentNotification: View, ConfigurableTokenizedControl {
    /// Creates the FluentNotification
    /// - Parameters:
    ///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
    ///   - shouldSelfPresent: Whether the notification should  present itself (SwiftUI environment) or externally (UIKit environment)
    ///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - attributedMessage: Optional attributed text for the main title area of the control. If there is a title, the message becomes subtext. If set, it will override the message parameter.
    ///   - isPresented: Controls whether the Notification is being presented.
    ///   - title: Optional text to draw above the message area.
    ///   - attributedTitle: Optional attributed text to draw above the message area. If set, it will override the title parameter.
    ///   - image: Optional icon to draw at the leading edge of the control.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    public init(style: MSFNotificationStyle,
                shouldSelfPresent: Bool = true,
                message: String? = nil,
                attributedMessage: NSAttributedString? = nil,
                isPresented: Binding<Bool>? = nil,
                title: String? = nil,
                attributedTitle: NSAttributedString? = nil,
                image: UIImage? = nil,
                actionButtonTitle: String? = nil,
                actionButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil) {
        let state = MSFNotificationStateImpl(style: style)
        state.message = message
        state.attributedMessage = attributedMessage
        state.title = title
        state.attributedTitle = attributedTitle
        state.image = image
        state.actionButtonTitle = actionButtonTitle
        state.actionButtonAction = actionButtonAction
        state.messageButtonAction = messageButtonAction
        self.state = state
        self.shouldSelfPresent = shouldSelfPresent

        if let isPresented = isPresented {
            _isPresented = isPresented
        } else {
            _isPresented = .constant(true)
        }
    }

    public var body: some View {
        if !shouldSelfPresent {
            notification
        } else {
            GeometryReader { proxy in
                let proposedSize = proxy.size
                let proposedWidth = proposedSize.width
                let calculatedNotificationWidth: CGFloat = {
                    let isHalfLength = state.style.isToast && horizontalSizeClass == .regular
                    return isHalfLength ? proposedWidth / 2 : proposedWidth - (2 * tokens.presentationOffset)
                }()

                notification
                    .frame(width: calculatedNotificationWidth, alignment: .center)
                    .onChange(of: isPresented, perform: { present in
                        if present {
                            presentAnimated()
                        } else {
                            dismissAnimated()
                        }
                    })
                    .padding(.bottom, tokens.bottomPresentationPadding)
                    .onSizeChange { newSize in
                        bottomOffsetForDismissedState = newSize.height + (tokens.ambientShadowOffsetY / 2)
                        // Bottom offset is only updated when the notification isn't presented to account for the new notification height (if presented, offset doesn't need to be updated since it grows upward vertically)
                        if !isPresented {
                            bottomOffset = bottomOffsetForDismissedState
                        }
                    }
                    .offset(y: bottomOffset)
                    .frame(width: proposedWidth, height: proposedSize.height, alignment: .bottom)
            }
        }
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFNotificationStateImpl
    let defaultTokens: NotificationTokens = .init()
    var tokens: NotificationTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
    }

    @ViewBuilder
    private var notification: some View {
        innerContents
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
            .onTapGesture {
                if let messageAction = state.messageButtonAction {
                    isPresented = false
                    messageAction()
                }
            }
    }

    @ViewBuilder
    private var image: some View {
        if state.style.isToast {
            if let image = state.image {
                let imageSize = image.size
                Image(uiImage: image)
                    .renderingMode(.template)
                    .frame(width: imageSize.width,
                           height: imageSize.height,
                           alignment: .center)
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
                    .padding(.vertical, tokens.verticalPadding)
                    .padding(.leading, tokens.horizontalPadding)
            }
        }
    }

    @ViewBuilder
    private var titleLabel: some View {
        if state.style.isToast && hasSecondTextRow {
            if let attributedTitle = state.attributedTitle {
                AttributedText(attributedTitle)
                    .fixedSize(horizontal: false, vertical: true)
            } else if let title = state.title {
                Text(title)
                    .font(.fluent(tokens.boldTextFont))
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
            }
        }
    }

    @ViewBuilder
    private var messageLabel: some View {
        if let attributedMessage = state.attributedMessage {
            AttributedText(attributedMessage)
                .fixedSize(horizontal: false, vertical: true)
        } else if let message = state.message {
            let messageFont = hasSecondTextRow ? tokens.footnoteTextFont : (state.style.isToast ? tokens.boldTextFont : tokens.regularTextFont)
            Text(message)
                .font(.fluent(messageFont))
                .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
        }
    }

    @ViewBuilder
    private var textContainer: some View {
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
    private var button: some View {
        if let buttonAction = state.actionButtonAction, let actionTitle = state.actionButtonTitle {
            let foregroundColor = tokens.foregroundColor
            let horizontalPadding = tokens.horizontalPadding
            let verticalPadding = tokens.verticalPadding

            if actionTitle.isEmpty {
                SwiftUI.Button(action: {
                    isPresented = false
                    buttonAction()
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(dynamicColor: foregroundColor))
            } else {
                SwiftUI.Button(actionTitle) {
                    isPresented = false
                    buttonAction()
                }
                .lineLimit(1)
                .foregroundColor(Color(dynamicColor: foregroundColor))
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .font(.fluent(tokens.boldTextFont))
            }
        }
    }

    @ViewBuilder
    private var innerContents: some View {
        if hasCenteredText {
            HStack {
                Spacer()
                textContainer
                Spacer()
            }
            .frame(minHeight: tokens.minimumHeight)
        } else {
            HStack(spacing: tokens.horizontalSpacing) {
                image
                textContainer
                Spacer(minLength: tokens.horizontalPadding)
                button
                    .layoutPriority(1)
            }
            .frame(minHeight: tokens.minimumHeight)
            .clipped()
        }
    }

    private var hasImage: Bool {
        state.style.isToast && state.image != nil
    }

    private var hasSecondTextRow: Bool {
        guard state.attributedTitle != nil || state.title != nil else {
            return false
        }

        return state.style.isToast
    }

    private var hasCenteredText: Bool {
        !state.style.isToast && state.actionButtonAction == nil
    }

    private func presentAnimated() {
        withAnimation(.spring(response: tokens.style.animationDurationForShow,
                              dampingFraction: tokens.style.animationDampingRatio,
                              blendDuration: 0)) {
            bottomOffset = 0
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: tokens.style.animationDurationForHide)) {
            bottomOffset = bottomOffsetForDismissedState
        }
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Binding private var isPresented: Bool
    @State private var bottomOffsetForDismissedState: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0

    // When true, the notification view will take up all proposed space
    // and automatically position itself within it.
    // isPresented only works when shouldSelfPresent is true.
    //
    // When false, the view will have a fitting, flexible width and self-sized height.
    // In this mode the notification should be positioned and presented externally.
    private let shouldSelfPresent: Bool
}

class MSFNotificationStateImpl: NSObject, ControlConfiguration, MSFNotificationState {
    @Published public var message: String?
    @Published public var attributedMessage: NSAttributedString?
    @Published public var title: String?
    @Published public var attributedTitle: NSAttributedString?
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

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    @Published var overrideTokens: NotificationTokens?

    /// Style to draw the control.
    @Published public var style: MSFNotificationStyle

    @objc init(style: MSFNotificationStyle) {
        self.style = style

        super.init()
    }

    convenience init(style: MSFNotificationStyle,
                     message: String? = nil,
                     attributedMessage: NSAttributedString? = nil,
                     title: String? = nil,
                     attributedTitle: NSAttributedString? = nil,
                     image: UIImage? = nil,
                     actionButtonTitle: String? = nil,
                     actionButtonAction: (() -> Void)? = nil,
                     messageButtonAction: (() -> Void)? = nil) {
        self.init(style: style)

        self.message = message
        self.attributedMessage = attributedMessage
        self.title = title
        self.attributedTitle = attributedTitle
        self.image = image
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
    }
}
