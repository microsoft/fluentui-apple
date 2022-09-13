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

    public typealias TokenSetKeyType = CardNudgeTokenSet.Tokens
    @ObservedObject public var tokenSet: CardNudgeTokenSet

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFCardNudgeStateImpl

    @ViewBuilder
    var icon: some View {
        if let icon = state.mainIcon {
            ZStack {
                RoundedRectangle(cornerRadius: tokenSet[.circleRadius].float)
                    .frame(width: CardNudgeTokenSet.circleSize, height: CardNudgeTokenSet.circleSize)
                    .foregroundColor(Color(dynamicColor: tokenSet[.buttonBackgroundColor].dynamicColor))
                Image(uiImage: icon)
                    .renderingMode(.template)
                    .frame(width: CardNudgeTokenSet.iconSize, height: CardNudgeTokenSet.iconSize, alignment: .center)
                    .foregroundColor(Color(dynamicColor: tokenSet[.accentColor].dynamicColor))
            }
            .padding(.trailing, CardNudgeTokenSet.horizontalPadding)
            .showsLargeContentViewer(text: state.title, image: state.mainIcon)
        }
    }

    private var hasSecondTextRow: Bool {
        state.accentIcon != nil || state.accentText != nil || state.subtitle != nil
    }

    @ViewBuilder
    var textContainer: some View {
        VStack(alignment: .leading, spacing: CardNudgeTokenSet.interTextVerticalPadding) {
            Text(state.title)
                .lineLimit(1)
                .foregroundColor(Color(dynamicColor: tokenSet[.textColor].dynamicColor))
                .showsLargeContentViewer(text: state.title, image: state.mainIcon)

            if hasSecondTextRow {
                HStack(spacing: CardNudgeTokenSet.accentPadding) {
                    if let accentIcon = state.accentIcon {
                        Image(uiImage: accentIcon)
                            .renderingMode(.template)
                            .frame(width: CardNudgeTokenSet.accentIconSize, height: CardNudgeTokenSet.accentIconSize)
                            .foregroundColor(Color(dynamicColor: tokenSet[.accentColor].dynamicColor))
                    }
                    if let accent = state.accentText {
                        Text(accent)
                            .layoutPriority(1)
                            .lineLimit(1)
                            .foregroundColor(Color(dynamicColor: tokenSet[.accentColor].dynamicColor))
                            .showsLargeContentViewer(text: accent, image: state.accentIcon)
                    }
                    if let subtitle = state.subtitle {
                        Text(subtitle)
                            .lineLimit(1)
                            .foregroundColor(Color(dynamicColor: tokenSet[.subtitleTextColor].dynamicColor))
                            .showsLargeContentViewer(text: subtitle)
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
                .padding(.horizontal, CardNudgeTokenSet.buttonInnerPaddingHorizontal)
                .padding(.vertical, CardNudgeTokenSet.verticalPadding)
                .foregroundColor(Color(dynamicColor: tokenSet[.accentColor].dynamicColor))
                .background(
                    RoundedRectangle(cornerRadius: tokenSet[.circleRadius].float)
                        .foregroundColor(Color(dynamicColor: tokenSet[.buttonBackgroundColor].dynamicColor))
                )
                .showsLargeContentViewer(text: actionTitle)
            }
            if let dismissAction = state.dismissButtonAction {
                let dismissImage = UIImage.staticImageNamed("dismiss-20x20")
                let dismissLabel = "Accessibility.Dismiss.Label".localized
                SwiftUI.Button(action: {
                    dismissAction(state)
                }, label: {
                    if let image = dismissImage {
                        Image(uiImage: image)
                    }
                })
                .padding(.horizontal, CardNudgeTokenSet.buttonInnerPaddingHorizontal)
                .padding(.vertical, CardNudgeTokenSet.verticalPadding)
                .accessibility(identifier: dismissLabel)
                .foregroundColor(Color(dynamicColor: tokenSet[.textColor].dynamicColor))
                .showsLargeContentViewer(text: dismissLabel, image: dismissImage)
            }
        }
    }

    @ViewBuilder
    var innerContents: some View {
        HStack(spacing: 0) {
            icon
            textContainer
            Spacer(minLength: CardNudgeTokenSet.accentPadding)
            buttons
                .layoutPriority(1)
        }
        .padding(.vertical, CardNudgeTokenSet.mainContentVerticalPadding)
        .padding(.horizontal, CardNudgeTokenSet.horizontalPadding)
        .frame(minHeight: CardNudgeTokenSet.minimumHeight)
    }

    public var body: some View {
        innerContents
            .background(
                RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                    .strokeBorder(lineWidth: tokenSet[.outlineWidth].float)
                    .foregroundColor(Color(dynamicColor: tokenSet[.outlineColor].dynamicColor))
                    .background(
                        Color(dynamicColor: tokenSet[.backgroundColor].dynamicColor)
                            .cornerRadius(tokenSet[.cornerRadius].float)
                    )
            )
            .padding(.vertical, CardNudgeTokenSet.verticalPadding)
            .padding(.horizontal, CardNudgeTokenSet.horizontalPadding)
            .fluentTokens(tokenSet, fluentTheme)
    }

    public init(style: MSFCardNudgeStyle, title: String) {
        let state = MSFCardNudgeStateImpl(style: style, title: title)
        self.state = state
        self.tokenSet = CardNudgeTokenSet(style: { state.style })
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
