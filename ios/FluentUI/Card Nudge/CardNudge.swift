//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Type of callback for both action and dismiss buttons.
public typealias CardNudgeButtonAction = ((_ state: MSFCardNudgeState) -> Void)

/// Properties that can be used to customize the appearance of the `CardNudge`.
@objc public protocol MSFCardNudgeState: NSObjectProtocol {
    /// Style to draw the control.
    @objc var style: MSFCardNudgeStyle { get set }

    /// Text for the main title area of the control.
    @objc var title: String { get set }

    /// Optional subtext to draw below the main title area.
    @objc var subtitle: String? { get set }

    /// Optional icon to draw at the leading edge of the control.
    @objc var mainIcon: UIImage? { get set }

    /// Optional accented text to draw below the main title area.
    @objc var accentText: String? { get set }

    /// Optional small icon to draw at the leading edge of `accentText`.
    @objc var accentIcon: UIImage? { get set }

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @objc var actionButtonTitle: String? { get set }

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @objc var actionButtonAction: CardNudgeButtonAction? { get set }

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    @objc var dismissButtonAction: CardNudgeButtonAction? { get set }
}

/// View that represents the CardNudge.
public struct CardNudge: View, TokenizedControlView {
    public typealias TokenType = CardNudgeTokens

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFCardNudgeStateImpl
    @ObservedObject var tokenResolver: TokenResolver<CardNudge> = .init()

    @ViewBuilder
    var icon: some View {
        if let icon = state.mainIcon {
            ZStack {
                RoundedRectangle(cornerRadius: tokenResolver.value(\.circleRadius))
                    .frame(width: tokenResolver.value(\.circleSize), height: tokenResolver.value(\.circleSize))
                    .foregroundColor(Color(dynamicColor: tokenResolver.value(\.buttonBackgroundColor)))
                Image(uiImage: icon)
                    .renderingMode(.template)
                    .frame(width: tokenResolver.value(\.iconSize), height: tokenResolver.value(\.iconSize), alignment: .center)
                    .foregroundColor(Color(dynamicColor: tokenResolver.value(\.accentColor)))
            }
            .padding(.trailing, tokenResolver.value(\.horizontalPadding))
        }
    }

    private var hasSecondTextRow: Bool {
        state.accentIcon != nil || state.accentText != nil || state.subtitle != nil
    }

    @ViewBuilder
    var textContainer: some View {
        VStack(alignment: .leading, spacing: tokenResolver.value(\.interTextVerticalPadding)) {
            Text(state.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(Color(dynamicColor: tokenResolver.value(\.textColor)))

            if hasSecondTextRow {
                HStack(spacing: tokenResolver.value(\.accentPadding)) {
                    if let accentIcon = state.accentIcon {
                        Image(uiImage: accentIcon)
                            .renderingMode(.template)
                            .frame(width: tokenResolver.value(\.accentIconSize), height: tokenResolver.value(\.accentIconSize))
                            .foregroundColor(Color(dynamicColor: tokenResolver.value(\.accentColor)))
                    }
                    if let accent = state.accentText {
                        Text(accent)
                            .font(.subheadline)
                            .layoutPriority(1)
                            .lineLimit(1)
                            .foregroundColor(Color(dynamicColor: tokenResolver.value(\.accentColor)))
                    }
                    if let subtitle = state.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(Color(dynamicColor: tokenResolver.value(\.subtitleTextColor)))
                    }
                }
            }
        }
    }

    @ViewBuilder
    var buttons: some View {
        HStack(spacing: 0) {
            if let actionTitle = state.actionButtonTitle,
                      let action = state.actionButtonAction {
                SwiftUI.Button(actionTitle) {
                    action(state)
                }
                .lineLimit(1)
                .padding(.horizontal, tokenResolver.value(\.buttonInnerPaddingHorizontal))
                .padding(.vertical, tokenResolver.value(\.verticalPadding))
                .foregroundColor(Color(dynamicColor: tokenResolver.value(\.accentColor)))
                .background(
                    RoundedRectangle(cornerRadius: tokenResolver.value(\.circleRadius))
                        .foregroundColor(Color(dynamicColor: tokenResolver.value(\.buttonBackgroundColor)))
                )
            }
            if let dismissAction = state.dismissButtonAction {
                SwiftUI.Button(action: {
                    dismissAction(state)
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, tokenResolver.value(\.buttonInnerPaddingHorizontal))
                .padding(.vertical, tokenResolver.value(\.verticalPadding))
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(dynamicColor: tokenResolver.value(\.textColor)))
            }
        }
    }

    @ViewBuilder
    var innerContents: some View {
        HStack(spacing: 0) {
            icon
            textContainer
            Spacer(minLength: tokenResolver.value(\.accentPadding))
            buttons
                .layoutPriority(1)
        }
        .padding(.vertical, tokenResolver.value(\.mainContentVerticalPadding))
        .padding(.horizontal, tokenResolver.value(\.horizontalPadding))
        .frame(minHeight: tokenResolver.value(\.minimumHeight))
    }

    public var body: some View {
        innerContents
            .background(
                RoundedRectangle(cornerRadius: tokenResolver.value(\.cornerRadius))
                    .strokeBorder(lineWidth: tokenResolver.value(\.outlineWidth))
                    .foregroundColor(Color(dynamicColor: tokenResolver.value(\.outlineColor)))
                    .background(
                        Color(dynamicColor: tokenResolver.value(\.backgroundColor))
                            .cornerRadius(tokenResolver.value(\.cornerRadius))
                    )
            )
            .padding(.vertical, tokenResolver.value(\.verticalPadding))
            .padding(.horizontal, tokenResolver.value(\.horizontalPadding))
            .fluentTokens(tokenResolver, fluentTheme) { tokens in
                tokens.style = state.style
            }
    }

    public init(style: MSFCardNudgeStyle, title: String) {
        let state = MSFCardNudgeStateImpl(style: style, title: title)
        self.state = state
    }
}

class MSFCardNudgeStateImpl: ControlState, MSFCardNudgeState {
    @Published var title: String
    @Published var subtitle: String?
    @Published var mainIcon: UIImage?
    @Published var accentIcon: UIImage?
    @Published var accentText: String?

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published var actionButtonTitle: String?

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published var actionButtonAction: CardNudgeButtonAction?

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    @Published var dismissButtonAction: CardNudgeButtonAction?

    /// Style to draw the control.
    @Published var style: MSFCardNudgeStyle

    @objc init(style: MSFCardNudgeStyle, title: String) {
        self.style = style
        self.title = title

        super.init()
    }
}
