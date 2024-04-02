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

    /// Defines whether the notification shows from the bottom of the presenting view or the top.
    var showFromBottom: Bool { get set }

    /// An optional linear gradient to use as the background of the notification.
    ///
    /// If this property is nil, then this notification will use the background color defined by its design tokens.
    var backgroundGradient: LinearGradientInfo? { get set }
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
                                             showFromBottom: showFromBottom)
        self.state = state
        self.shouldSelfPresent = shouldSelfPresent
        self.isFlexibleWidthToast = isFlexibleWidthToast && style.isToast

        self.tokenSet = NotificationTokenSet(style: { state.style })

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
        tokenSet.update(fluentTheme)
        @ViewBuilder
        var image: some View {
            if state.style.isToast {
                if let image = state.image {
                    let imageSize = image.size
                    Image(uiImage: image.renderingMode == .automatic ? image.withRenderingMode(.alwaysTemplate) : image)
                        .frame(width: imageSize.width,
                               height: imageSize.height,
                               alignment: .center)
                        .foregroundColor(Color(tokenSet[.imageColor].uiColor))
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
                        .font(.init(tokenSet[.boldTextFont].uiFont))
                        .foregroundColor(Color(tokenSet[.foregroundColor].uiColor))
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
                Text(message)
                    .font(.init(tokenSet[.regularTextFont].uiFont))
                    .foregroundColor(Color(tokenSet[.foregroundColor].uiColor))
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
            .padding(.vertical, NotificationTokenSet.verticalPadding)
        }

        @ViewBuilder
        var button: some View {
            let shouldHaveDefaultAction = state.showDefaultDismissActionButton && shouldSelfPresent
            if let buttonAction = state.actionButtonAction ?? (shouldHaveDefaultAction ? dismissAnimated : nil) {
                let foregroundColor = tokenSet[.foregroundColor].uiColor
                if let actionTitle = state.actionButtonTitle, !actionTitle.isEmpty {
                    SwiftUI.Button(actionTitle) {
                        isPresented = false
                        buttonAction()
                    }
                    .lineLimit(1)
                    .foregroundColor(Color(foregroundColor))
                    .font(.init(tokenSet[.boldTextFont].uiFont))
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
                    .foregroundColor(Color(foregroundColor))
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
                            Spacer(minLength: 0)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .modifyIf(messageButtonAction != nil, { messageButton in
                        messageButton.accessibilityAddTraits(.isButton)
                            .hoverEffect()
                    })
                    button
#if os(visionOS)
                        .buttonStyle(.borderless)
#endif // os(visionOS)
                        .layoutPriority(1)
                }
                .onSizeChange { newSize in
                    innerContentsSize = newSize
                }
                .frame(minHeight: tokenSet[.minimumHeight].float)
                .padding(.horizontal, NotificationTokenSet.horizontalPadding)
                .clipped()
            }
        }

        @ViewBuilder
        var backgroundFill: some View {
            if let backgroundGradient = state.backgroundGradient {
                GeometryReader { g in
                    // The gradient needs to be rendered square, then scaled to fit the containing view.
                    // Otherwise SwiftUI will crop the gradient view, which is not what we want!
                    LinearGradient(gradientInfo: backgroundGradient)
                        .frame(width: g.size.width, height: g.size.width)
                        .scaleEffect(x: 1.0, y: g.size.height / g.size.width, anchor: .top)
                }
            } else {
                Color(tokenSet[.backgroundColor].uiColor)
            }
        }

        @ViewBuilder
        var notification: some View {
            let shadowInfo = tokenSet[.shadow].shadowInfo
            innerContents
                .background(
                    RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                        .border(width: tokenSet[.outlineWidth].float,
                                edges: state.showFromBottom ? [.top] : [.bottom],
                                color: Color(tokenSet[.outlineColor].uiColor)).foregroundColor(.clear)
                        .background(
                            backgroundFill
                                .clipShape(RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float))
                        )
                        .applyFluentShadow(shadowInfo: shadowInfo)
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
                    let showFromBottom = state.showFromBottom

                    notification
                        .frame(idealWidth: isFlexibleWidthToast ? innerContentsSize.width - horizontalPadding : calculatedNotificationWidth,
                               maxWidth: isFlexibleWidthToast ? proposedWidth : calculatedNotificationWidth, alignment: .center)
                        .onChange_iOS17(of: isPresented) { newPresent in
                            if newPresent {
                                presentAnimated()
                            } else {
                                dismissAnimated()
                            }
                        }
                        .padding(.bottom, tokenSet[.bottomPresentationPadding].float)
                        .onSizeChange { newSize in
                            bottomOffsetForDismissedState = newSize.height + (tokenSet[.shadow].shadowInfo.yKey / 2)
                            // Bottom offset is only updated when the notification isn't presented to account for the new notification height (if presented, offset doesn't need to be updated since it grows upward vertically)
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
            opacity = 1
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: state.style.animationDurationForHide)) {
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

class MSFNotificationStateImpl: ControlState, MSFNotificationState {
    @Published var message: String?
    @Published var attributedMessage: NSAttributedString?
    @Published var title: String?
    @Published var attributedTitle: NSAttributedString?
    @Published var image: UIImage?
    @Published var trailingImage: UIImage?
    @Published var trailingImageAccessibilityLabel: String?
    @Published var showDefaultDismissActionButton: Bool
    @Published var showFromBottom: Bool
    @Published var backgroundGradient: LinearGradientInfo?

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published var actionButtonTitle: String?

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published var actionButtonAction: (() -> Void)?

    /// Action to be dispatched by tapping on the toast/bar notification.
    @Published var messageButtonAction: (() -> Void)?

    /// Style to draw the control.
    @Published var style: MSFNotificationStyle

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
