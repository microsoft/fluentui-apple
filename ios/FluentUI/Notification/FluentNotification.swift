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

    /// Bool to control if the Notification has a dismiss action by default.
    var showDefaultDismissActionButton: Bool { get set }

    /// Action to be dispatched by tapping on the toast/bar notification.
    var messageButtonAction: (() -> Void)? { get set }

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: NotificationTokens? { get set }

    /// Defines whether the notification shows from the bottom of the presenting view or the top.
    var showFromBottom: Bool { get set }
}

/// View that represents the Notification.
public struct FluentNotification: View, ConfigurableTokenizedControl {
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
    ///   - trailingImageAccessibilityLabel: Optional localized accessibility label for the trailing image.
    ///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
    ///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
    ///   - showDefaultDismissActionButton: Bool to control if the Notification has a dismiss action by default.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    ///   - showFromBottom: Defines whether the notification shows from the bottom of the presenting view or the top.
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
                showDefaultDismissActionButton: Bool? = nil,
                messageButtonAction: (() -> Void)? = nil,
                showFromBottom: Bool = true) {
        let state = MSFNotificationStateImpl(style: style,
                                             message: message,
                                             attributedMessage: attributedMessage,
                                             title: title,
                                             attributedTitle: attributedTitle,
                                             image: image,
                                             trailingImage: trailingImage,
                                             trailingImageAccessibilityLabel: trailingImageAccessibilityLabel,
                                             actionButtonTitle: actionButtonTitle,
                                             actionButtonAction: actionButtonAction,
                                             showDefaultDismissActionButton: showDefaultDismissActionButton,
                                             messageButtonAction: messageButtonAction,
                                             showFromBottom: true)
        self.state = state
        self.shouldSelfPresent = shouldSelfPresent
        self.isFlexibleWidthToast = isFlexibleWidthToast && style.isToast

        if let isPresented = isPresented {
            _isPresented = isPresented
        } else {
            _isPresented = .constant(true)
        }

        if _isPresented.wrappedValue == true {
            _opacity = .init(initialValue: 1)
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
                        .foregroundColor(Color(dynamicColor: tokens.imageColor))
                        .padding(.vertical, tokens.verticalPadding)
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
                        .accessibilityLabel(attributedTitle.string)
                } else if let title = state.title {
                    Text(title)
                        .font(.fluent(tokens.boldTextFont))
                        .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
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
                    .accessibilityLabel(attributedMessage.string)
            } else if let message = state.message {
                let messageFont = tokens.regularTextFont
                Text(message)
                    .font(.fluent(messageFont))
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
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
            .padding(.vertical, tokens.verticalPadding)
        }

        @ViewBuilder
        var button: some View {
            let shouldHaveDefaultAction = state.showDefaultDismissActionButton && shouldSelfPresent
            if let buttonAction = state.actionButtonAction ?? (shouldHaveDefaultAction ? dismissAnimated : nil) {
                let foregroundColor = tokens.foregroundColor
                if let actionTitle = state.actionButtonTitle, !actionTitle.isEmpty {
                    SwiftUI.Button(actionTitle) {
                        isPresented = false
                        buttonAction()
                    }
                    .lineLimit(1)
                    .foregroundColor(Color(dynamicColor: foregroundColor))
                    .font(.fluent(tokens.boldTextFont))
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
                .frame(minHeight: tokens.minimumHeight)
            } else {
                let horizontalSpacing = tokens.horizontalSpacing
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
                .frame(minHeight: tokens.minimumHeight)
                .padding(.horizontal, tokens.horizontalPadding)
                .clipped()
            }
        }

        @ViewBuilder
        var notification: some View {
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
                    // Get total horizontal padding by doubling the offset
                    let horizontalPadding = 2 * tokens.presentationOffset
                    let calculatedNotificationWidth: CGFloat = {
                        let isHalfLength = state.style.isToast && horizontalSizeClass == .regular
                        return isHalfLength ? proposedWidth / 2 : proposedWidth - horizontalPadding
                    }()
                    let showFromBottom = state.showFromBottom

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
                        .padding(showFromBottom ? .bottom : .top, tokens.bottomPresentationPadding)
                        .onSizeChange { newSize in
                            bottomOffsetForDismissedState = newSize.height
                            // Bottom offset is only updated when the notification
                            // isn't presented to account for the new notification
                            // height (if presented, offset doesn't need to be
                            // updated since it grows upward vertically)
                            if !isPresented {
                                bottomOffset = bottomOffsetForDismissedState
                            }
                        }
                        .offset(y: showFromBottom ? bottomOffset : -bottomOffset)
                        .frame(width: proposedWidth, height: proposedSize.height, alignment: showFromBottom ? .bottom : .top)
                        .opacity(opacity)
                }
            }
        }

        return presentableNotification
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFNotificationStateImpl
    let defaultTokens: NotificationTokens = .init()
    var tokens: NotificationTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
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
            opacity = 1
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: tokens.style.animationDurationForHide)) {
            bottomOffset = bottomOffsetForDismissedState
            opacity = 0
        }
    }

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?
    @Binding private var isPresented: Bool
    @State private var bottomOffsetForDismissedState: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var innerContentsSize: CGSize = CGSize()
    @State private var attributedMessageSize: CGSize = CGSize()
    @State private var attributedTitleSize: CGSize = CGSize()
    @State private var opacity: CGFloat = 0

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

class MSFNotificationStateImpl: NSObject, ControlConfiguration, MSFNotificationState {
    @Published public var message: String?
    @Published public var attributedMessage: NSAttributedString?
    @Published public var title: String?
    @Published public var attributedTitle: NSAttributedString?
    @Published public var image: UIImage?
    @Published public var trailingImage: UIImage?
    @Published public var trailingImageAccessibilityLabel: String?
    @Published public var showDefaultDismissActionButton: Bool
    @Published public var showFromBottom: Bool = true

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

    @objc convenience init(style: MSFNotificationStyle) {
        self.init(style: style,
                  message: nil,
                  attributedMessage: nil,
                  title: nil,
                  attributedTitle: nil,
                  image: nil,
                  trailingImage: nil,
                  trailingImageAccessibilityLabel: nil,
                  actionButtonTitle: nil,
                  actionButtonAction: nil,
                  showDefaultDismissActionButton: nil,
                  messageButtonAction: nil,
                  showFromBottom: true)
    }

    init(style: MSFNotificationStyle,
         message: String? = nil,
         attributedMessage: NSAttributedString? = nil,
         title: String? = nil,
         attributedTitle: NSAttributedString? = nil,
         image: UIImage? = nil,
         trailingImage: UIImage? = nil,
         trailingImageAccessibilityLabel: String? = nil,
         actionButtonTitle: String? = nil,
         actionButtonAction: (() -> Void)? = nil,
         showDefaultDismissActionButton: Bool? = nil,
         messageButtonAction: (() -> Void)? = nil,
         showFromBottom: Bool = true) {
        self.style = style
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
        self.showFromBottom = showFromBottom
        self.showDefaultDismissActionButton = showDefaultDismissActionButton ?? style.isToast

        super.init()
    }
}
