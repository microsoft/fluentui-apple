//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
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

    /// Action to be dispatched by the dismiss button on the trailing edge of the control.
    var defaultDimissButtonAction: (() -> Void)? { get set }

    /// Action to be dispatched by tapping on the toast/bar notification.
    var messageButtonAction: (() -> Void)? { get set }

    /// The callback to execute when the notification is dismissed.
    var onDismiss: (() -> Void)? { get set }

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
    ///   - defaultDimissButtonAction: Action to be dispatched by the dismiss button of the trailing edge of the control.
    ///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
    ///   - showFromBottom: Defines whether the notification shows from the bottom of the presenting view or the top.
    ///   - verticalOffset: How much to vertically offset the notification from its default position.
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
                defaultDimissButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil,
                showFromBottom: Bool = true,
                verticalOffset: CGFloat = 0.0) {
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
                                             defaultDimissButtonAction: defaultDimissButtonAction,
                                             messageButtonAction: messageButtonAction,
                                             showFromBottom: showFromBottom,
                                             verticalOffset: verticalOffset)
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
                        .foregroundColor(tokenSet[.imageColor].color)
                }
            }
        }

        @ViewBuilder
        var titleLabel: some View {
            if state.style.isToast && hasSecondTextRow {
                if let attributedTitle = state.attributedTitle {
                    Text(AttributedString(attributedTitle))
                        .fixedSize(horizontal: false, vertical: true)
                } else if let title = state.title {
                    Text(title)
                        .font(.init(tokenSet[.boldTextFont].uiFont))
                }
            }
        }

        @ViewBuilder
        var messageLabel: some View {
            if let attributedMessage = state.attributedMessage {
                Text(AttributedString(attributedMessage))
                    .fixedSize(horizontal: false, vertical: true)
            } else if let message = state.message {
                Text(message)
                    .font(.init(tokenSet[.regularTextFont].uiFont))
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

        /// The `actionButton` will be shown iff a `state.actionButtonAction` is set and there is a custom title or trailing image.
        /// If the `state.actionButtonAction` is set but there is no custom title or trailing image, the action will be attached to
        /// the `dismissButton`.
        @ViewBuilder
        var actionButton: some View {
            if let buttonAction = state.actionButtonAction {
                if let actionTitle = state.actionButtonTitle, !actionTitle.isEmpty {
                    SwiftUI.Button(actionTitle) {
                        isPresented = false
                        buttonAction()
                    }
                    .lineLimit(1)
                    .font(.init(tokenSet[.boldTextFont].uiFont))
                    .hoverEffect()
                } else if let trailingImage = state.trailingImage {
                    SwiftUI.Button(action: {
                        isPresented = false
                        buttonAction()
                    }, label: {
                        Image(uiImage: trailingImage)
                            .accessibilityLabel(state.trailingImageAccessibilityLabel ?? "")
                    })
                    .hoverEffect()
                }
            }
        }

        @ViewBuilder
        var dismissButton: some View {
            if let dismissAction = dismissButtonAction {
                HStack {
                    SwiftUI.Button(action: {
                        isPresented = false
                        dismissAction()
                    }, label: {
                        Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                            .accessibilityLabel("Accessibility.Dismiss.Label".localized)
                    })
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
                    actionButton
#if os(visionOS)
                        .buttonStyle(.borderless)
#endif // os(visionOS)
                        .layoutPriority(1)

                    if dismissButtonAction != nil {
                        Spacer()
                        dismissButton
#if os(visionOS)
                        .buttonStyle(.borderless)
#endif // os(visionOS)
                        .layoutPriority(1)
                    }
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
                tokenSet[.backgroundColor].color
            }
        }

        @ViewBuilder
        var notification: some View {
            let shadowInfo = tokenSet[.shadow].shadowInfo
            innerContents
                .foregroundStyle(tokenSet[.foregroundColor].color)
                .background(
                    RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                        .border(width: tokenSet[.outlineWidth].float,
                                edges: state.showFromBottom ? [.top] : [.bottom],
                                color: tokenSet[.outlineColor].color).foregroundColor(.clear)
                        .background(
                            backgroundFill
                                .clipShape(RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float))
                        )
                        .applyFluentShadow(shadowInfo: shadowInfo)
                )
#if os(visionOS)
                .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float))
#endif // os(visionOS)
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
            .onDisappear {
                state.onDismiss?()
            }
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFNotificationStateImpl

    /// The `dismissButtonAction` will be non-nil for the following cases:
    /// - The `state.actionButtonAction` is set but there is no custom title or trailing image. The `actionButtonAction`
    /// will be attached to the button.
    /// - The`showDefaultDismissActionButton` is `true` and the `state.defaultDismissButtonAction` is set
    /// - The`showDefaultDismissActionButton`is `true` and `shouldSelfPresent` is `true`
    private var dismissButtonAction: (() -> Void)? {
        // Determine if we should use the custom action button’s action.
        let shouldUseActionButtonAction =
            state.actionButtonAction != nil
            && (state.actionButtonTitle == nil || (state.actionButtonTitle?.isEmpty ?? true))
            && state.trailingImage == nil

        var dismissAction: (() -> Void)?

        if shouldUseActionButtonAction {
            dismissAction = state.actionButtonAction
        } else if state.showDefaultDismissActionButton {
            if let defaultAction = state.defaultDimissButtonAction {
                dismissAction = defaultAction
            } else if shouldSelfPresent {
                dismissAction = dismissAnimated
            }
        }
        return dismissAction
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
        withAnimation(.spring(response: state.style.animationDurationForShow / 2.0,
                              dampingFraction: state.style.animationDampingRatio,
                              blendDuration: 0)) {
            bottomOffset = -state.verticalOffset
            opacity = 1
        }
    }

    private func dismissAnimated() {
        withAnimation(.linear(duration: state.style.animationDurationForHide / 2.0)) {
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
    @Published var defaultDimissButtonAction: (() -> Void)?
    @Published var showFromBottom: Bool
    @Published var backgroundGradient: LinearGradientInfo?
    @Published var verticalOffset: CGFloat
    @Published var onDismiss: (() -> Void)?

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
                  showFromBottom: true,
                  verticalOffset: 0.0)
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
         defaultDimissButtonAction: (() -> Void)? = nil,
         messageButtonAction: (() -> Void)? = nil,
         showFromBottom: Bool = true,
         verticalOffset: CGFloat) {
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
        self.defaultDimissButtonAction = defaultDimissButtonAction
        self.verticalOffset = verticalOffset

        super.init()
    }
}
