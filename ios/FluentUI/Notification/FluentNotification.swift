//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState: NSObjectProtocol {
    /// Style to draw the control.
    var style: MSFNotificationStyle { get set }

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

    /// Optional icon to display in the action button if no button title is provided.
    /// If the trailingImage is set, the trailingImageAccessibilityLabel should also be set.
    var trailingImage: UIImage? { get set }

    /// Optional localized accessibility label for the trailing image.
    var trailingImageAccessibilityLabel: String? { get set }

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
public struct FluentNotification: View, TokenizedControlView {
    public typealias TokenSetKeyType = NotificationTokenSet.Tokens
    @ObservedObject public var tokenSet: NotificationTokenSet

    /// Creates the FluentNotification
    /// - Parameters:
    ///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
    ///   - shouldSelfPresent: Whether the notification should  present itself (SwiftUI environment) or externally (UIKit environment).
    ///   - isFlexibleWidthToast: Whether the width of the toast is set based  on the width of the screen or on its contents.
    ///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
    ///   - attributedMessage: Optional attributed text for the main title area of the control. If there is a title, the message becomes subtext. If set, it will override the message parameter.
    ///   - isPresented: Controls whether the Notification is being presented.
    ///   - title: Optional text to draw above the message area.
    ///   - attributedTitle: Optional attributed text to draw above the message area. If set, it will override the title parameter.
    ///   - image: Optional icon to draw at the leading edge of the control.
    ///   - trailingImage: Optional icon to show in the action button if no button title is provided.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    public init(style: MSFNotificationStyle,
                shouldSelfPresent: Bool = true,
                isFlexibleWidthToast: Bool = false,
                message: String? = nil,
                attributedMessage: NSAttributedString? = nil,
                isPresented: Binding<Bool>? = nil,
                title: String? = nil,
                attributedTitle: NSAttributedString? = nil,
                image: UIImage? = nil,
                trailingImage: UIImage? = nil,
                trailingImageAccessibilityLabel: String? = nil,
                actionButtonTitle: String? = nil,
                actionButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil) {
        let state = MSFNotificationStateImpl(style: style)
        state.message = message
        state.attributedMessage = attributedMessage
        state.title = title
        state.attributedTitle = attributedTitle
        state.image = image
        state.trailingImage = trailingImage
        state.trailingImageAccessibilityLabel = trailingImageAccessibilityLabel
        state.actionButtonTitle = actionButtonTitle
        state.actionButtonAction = actionButtonAction
        state.messageButtonAction = messageButtonAction
        self.state = state
        self.shouldSelfPresent = shouldSelfPresent
        self.isFlexibleWidthToast = isFlexibleWidthToast && style.isToast

        self.tokenSet = NotificationTokenSet(style: { state.style })

        if let isPresented = isPresented {
            _isPresented = isPresented
        } else {
            _isPresented = .constant(true)
        }
    }

    public var body: some View {
        @ViewBuilder
        var image: some View {
            if state.style.isToast {
                if let image = state.image {
                    let imageSize = image.size
                    Image(uiImage: image)
                        .renderingMode(.template)
                        .frame(width: imageSize.width,
                               height: imageSize.height,
                               alignment: .center)
                        .foregroundColor(Color(dynamicColor: tokenSet[.imageColor].dynamicColor))
                }
            }
        }

        @ViewBuilder
        var titleLabel: some View {
            if state.style.isToast && hasSecondTextRow {
                if let attributedTitle = state.attributedTitle {
                    AttributedText(attributedTitle, attributedTitleSize.width)
                        .fixedSize(horizontal: isFlexibleWidthToast, vertical: true)
                        .onSizeChange { newSize in
                            attributedTitleSize = newSize
                        }
                } else if let title = state.title {
                    Text(title)
                        .font(.fluent(tokenSet[.boldTextFont].fontInfo))
                        .foregroundColor(Color(dynamicColor: tokenSet[.foregroundColor].dynamicColor))
                }
            }
        }

        @ViewBuilder
        var messageLabel: some View {
            if let attributedMessage = state.attributedMessage {
                AttributedText(attributedMessage, attributedMessageSize.width)
                    .fixedSize(horizontal: isFlexibleWidthToast, vertical: true)
                    .onSizeChange { newSize in
                        attributedMessageSize = newSize
                    }
            } else if let message = state.message {
                let messageFont = hasSecondTextRow ? tokenSet[.footnoteTextFont].fontInfo : (state.style.isToast ? tokenSet[.boldTextFont].fontInfo : tokenSet[.regularTextFont].fontInfo)
                Text(message)
                    .font(.fluent(messageFont))
                    .foregroundColor(Color(dynamicColor: tokenSet[.foregroundColor].dynamicColor))
            }
        }

        @ViewBuilder
        var textContainer: some View {
            VStack(alignment: .leading) {
                if hasSecondTextRow {
                    titleLabel
                }
                messageLabel
            }
            .padding(.vertical, hasSecondTextRow ? tokenSet[.verticalPadding].float : tokenSet[.verticalPaddingForOneLine].float)
        }

        @ViewBuilder
        var button: some View {
            if let buttonAction = state.actionButtonAction {
                let foregroundColor = tokenSet[.foregroundColor].dynamicColor
                if let actionTitle = state.actionButtonTitle, !actionTitle.isEmpty {
                    SwiftUI.Button(actionTitle) {
                        isPresented = false
                        buttonAction()
                    }
                    .lineLimit(1)
                    .foregroundColor(Color(dynamicColor: foregroundColor))
                    .font(.fluent(tokenSet[.boldTextFont].fontInfo))
                    .hoverEffect()
                } else {
                    SwiftUI.Button(action: {
                        isPresented = false
                        buttonAction()
                    }, label: {
                        if let trailingImage = state.trailingImage {
                            Image(uiImage: trailingImage)
                                .accessibilityLabel(state.trailingImageAccessibilityLabel ?? "")
                        } else {
                            Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                                .accessibilityLabel("Accessibility.Dismiss.Label".localized)
                        }
                    })
                    .foregroundColor(Color(dynamicColor: foregroundColor))
                    .hoverEffect()
                }
            }
        }

        let messageButtonAction = state.messageButtonAction
        @ViewBuilder
        var innerContents: some View {
            if hasCenteredText {
                HStack {
                    Spacer()
                    textContainer
                    Spacer()
                }
                .frame(minHeight: tokenSet[.minimumHeight].float)
            } else {
                let horizontalSpacing = tokenSet[.horizontalSpacing].float
                HStack(spacing: isFlexibleWidthToast ? horizontalSpacing : 0) {
                    HStack(spacing: horizontalSpacing) {
                        image
                        textContainer
                        if !isFlexibleWidthToast {
                            Spacer(minLength: horizontalSpacing)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .modifyIf(messageButtonAction != nil, { messageButton in
                        messageButton.accessibilityAddTraits(.isButton)
                            .hoverEffect()
                    })
                    button
                        .layoutPriority(1)
                }
                .onSizeChange { newSize in
                    innerContentsSize = newSize
                }
                .frame(minHeight: tokenSet[.minimumHeight].float)
                .padding(.horizontal, tokenSet[.horizontalPadding].float)
                .clipped()
            }
        }

        @ViewBuilder
        var notification: some View {
            innerContents
                .background(
                    RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                        .strokeBorder(Color(dynamicColor: tokenSet[.outlineColor].dynamicColor), lineWidth: tokenSet[.outlineWidth].float)
                        .background(
                            RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                                .fill(Color(dynamicColor: tokenSet[.backgroundColor].dynamicColor))
                        )
                        .shadow(color: Color(dynamicColor: tokenSet[.ambientShadowColor].dynamicColor),
                                radius: tokenSet[.ambientShadowBlur].float,
                                x: tokenSet[.ambientShadowOffsetX].float,
                                y: tokenSet[.ambientShadowOffsetY].float)
                        .shadow(color: Color(dynamicColor: tokenSet[.perimeterShadowColor].dynamicColor),
                                radius: tokenSet[.perimeterShadowBlur].float,
                                x: tokenSet[.perimeterShadowOffsetX].float,
                                y: tokenSet[.perimeterShadowOffsetY].float)
                )
                .onTapGesture {
                    if let messageAction = messageButtonAction {
                        isPresented = false
                        messageAction()
                    }
                }
        }

        @ViewBuilder
        var presentableNotification: some View {
            if !shouldSelfPresent {
                notification
            } else {
                GeometryReader { proxy in
                    let proposedSize = proxy.size
                    let proposedWidth = proposedSize.width
                    let horizontalPadding = 2 * tokenSet[.presentationOffset].float
                    let calculatedNotificationWidth: CGFloat = {
                        let isHalfLength = state.style.isToast && horizontalSizeClass == .regular
                        return isHalfLength ? proposedWidth / 2 : proposedWidth - horizontalPadding
                    }()

                    notification
                        .frame(idealWidth: isFlexibleWidthToast ? innerContentsSize.width - horizontalPadding : calculatedNotificationWidth,
                               maxWidth: isFlexibleWidthToast ? proposedWidth : calculatedNotificationWidth, alignment: .center)
                        .onChange(of: isPresented, perform: { present in
                            if present {
                                presentAnimated()
                            } else {
                                dismissAnimated()
                            }
                        })
                        .padding(.bottom, tokenSet[.bottomPresentationPadding].float)
                        .onSizeChange { newSize in
                            bottomOffsetForDismissedState = newSize.height + (tokenSet[.ambientShadowOffsetY].float / 2)
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

        return presentableNotification
            .fluentTokens(tokenSet, fluentTheme)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFNotificationStateImpl

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
        withAnimation(.spring(response: state.style.animationDurationForShow,
                              dampingFraction: state.style.animationDampingRatio,
                              blendDuration: 0)) {
            bottomOffset = 0
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: state.style.animationDurationForHide)) {
            bottomOffset = bottomOffsetForDismissedState
        }
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Binding private var isPresented: Bool
    @State private var bottomOffsetForDismissedState: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var innerContentsSize: CGSize = CGSize()
    @State private var attributedMessageSize: CGSize = CGSize()
    @State private var attributedTitleSize: CGSize = CGSize()

    // When true, the notification view will take up all proposed space
    // and automatically position itself within it.
    // isPresented only works when shouldSelfPresent is true.
    //
    // When false, the view will have a fitting, flexible width and self-sized height.
    // In this mode the notification should be positioned and presented externally.
    private let shouldSelfPresent: Bool

    // When true, the notification will fit the size of its contents.
    // When false, the notification will be fixed based on the size of the screen.
    private let isFlexibleWidthToast: Bool
}

class MSFNotificationStateImpl: ControlState, MSFNotificationState {
    @Published public var message: String?
    @Published public var attributedMessage: NSAttributedString?
    @Published public var title: String?
    @Published public var attributedTitle: NSAttributedString?
    @Published public var image: UIImage?
    @Published public var trailingImage: UIImage?
    @Published public var trailingImageAccessibilityLabel: String?

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
                     trailingImage: UIImage? = nil,
                     trailingImageAccessibilityLabel: String? = nil,
                     actionButtonTitle: String? = nil,
                     actionButtonAction: (() -> Void)? = nil,
                     messageButtonAction: (() -> Void)? = nil) {
        self.init(style: style)

        self.message = message
        self.attributedMessage = attributedMessage
        self.title = title
        self.attributedTitle = attributedTitle
        self.image = image
        self.trailingImage = trailingImage
        self.trailingImageAccessibilityLabel = trailingImageAccessibilityLabel
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
    }
}
