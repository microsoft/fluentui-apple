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

    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: NotificationTokens? { get set }
}

/// View that represents the Notification.
public struct NotificationViewSwiftUI: View, ConfigurableTokenizedControl {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFNotificationStateImpl
    @Binding var isPresented: Bool
    @State private var bottomOffsetForDismissedState: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var maxWidth: CGFloat = 0
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
                messageButtonAction: (() -> Void)? = nil) {
        let state = MSFNotificationStateImpl(style: style, message: message)
        state.title = title
        state.image = image
        state.actionButtonTitle = actionButtonTitle
        state.actionButtonAction = actionButtonAction
        state.messageButtonAction = messageButtonAction
        self.state = state

        if let isPresented = isPresented {
            _isPresented = isPresented
        } else {
            _isPresented = .constant(true)
        }
    }

    public var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                Color.clear.background {
                    GeometryReader { geometryReader in
                        Color.clear.preference(key: WidthPreferenceKey.self, value: geometryReader.size.width)
                    }
                }
                .frame(height: 0)
                .onPreferenceChange(WidthPreferenceKey.self) { grWidth in
                    maxWidth = grWidth
                }
                let width: CGFloat = {
                    let isFullLength = state.style.isToast && horizontalSizeClass == .regular
                    return isFullLength ? maxWidth / 2 : maxWidth - (2 * tokens.presentationOffset)
                }()
                let cornerRadius = tokens.cornerRadius
                let ambientShadowOffsetY = tokens.ambientShadowOffsetY

                VStack {
//                    Spacer()
                    innerContents
                        .onTapGesture {
                            if let messageAction = state.messageButtonAction {
                                isPresented = false
                                messageAction()
                            }
                        }
                        .frame(width: width, alignment: .bottom)
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(Color(dynamicColor: tokens.outlineColor), lineWidth: tokens.outlineWidth)
                                .background(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .fill(Color(dynamicColor: tokens.backgroundColor))
                                )
                                .shadow(color: Color(dynamicColor: tokens.ambientShadowColor),
                                        radius: tokens.ambientShadowBlur,
                                        x: tokens.ambientShadowOffsetX,
                                        y: ambientShadowOffsetY)
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
                        .padding(.bottom, tokens.bottomPresentationPadding)
                        .onSizeChange { newSize in
                            bottomOffsetForDismissedState = newSize.height + (ambientShadowOffsetY / 2)
                            // Bottom offset is only updated when the notification isn't presented to account for the new notification height (if presented, offset doesn't need to be updated since it grows upward vertically)
                            if !isPresented {
                                bottomOffset = bottomOffsetForDismissedState
                            }
                        }
                        .frame(maxHeight: .infinity,
                               alignment: .bottom)
                        .offset(y: bottomOffset)
                }
            } else {
                // Fallback on earlier versions
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
            if let title = state.title {
                Text(title)
                    .font(.fluent(tokens.boldTextFont))
                    .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
            }
        }
    }

    @ViewBuilder
    private var messageLabel: some View {
        let messageFont = hasSecondTextRow ? tokens.footnoteTextFont : (state.style.isToast ? tokens.boldTextFont : tokens.regularTextFont)
        Text(state.message)
            .font(.fluent(messageFont))
            .foregroundColor(Color(dynamicColor: tokens.foregroundColor))
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
                     messageButtonAction: (() -> Void)? = nil) {
        self.init(style: style, message: message)

        self.title = title
        self.image = image
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.messageButtonAction = messageButtonAction
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
