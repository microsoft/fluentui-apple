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

    /// Action to be dispatched by tapping on the `CardNudge`.
    @objc var messageButtonAction: CardNudgeButtonAction? { get set }
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
                    .foregroundColor(Color(tokenSet[.buttonBackgroundColor].uiColor))
                Image(uiImage: icon.renderingMode == .automatic ? icon.withRenderingMode(.alwaysTemplate) : icon)
                    .frame(width: CardNudgeTokenSet.iconSize, height: CardNudgeTokenSet.iconSize, alignment: .center)
                    .foregroundColor(Color(tokenSet[.buttonForegroundColor].uiColor))
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
                .foregroundColor(Color(tokenSet[.textColor].uiColor))
                .showsLargeContentViewer(text: state.title, image: state.mainIcon)
                .font(.init(tokenSet[.titleFont].uiFont))

            if hasSecondTextRow {
                HStack(spacing: CardNudgeTokenSet.accentPadding) {
                    if let accentIcon = state.accentIcon {
                        Image(uiImage: accentIcon)
                            .renderingMode(.template)
                            .frame(width: CardNudgeTokenSet.accentIconSize, height: CardNudgeTokenSet.accentIconSize)
                            .foregroundColor(Color(tokenSet[.accentColor].uiColor))
                    }
                    if let accent = state.accentText {
                        Text(accent)
                            .layoutPriority(1)
                            .lineLimit(1)
                            .foregroundColor(Color(tokenSet[.accentColor].uiColor))
                            .showsLargeContentViewer(text: accent, image: state.accentIcon)
                            .font(.init(tokenSet[.subtitleFont].uiFont))
                    }
                    if let subtitle = state.subtitle {
                        Text(subtitle)
                            .lineLimit(1)
                            .foregroundColor(Color(tokenSet[.subtitleTextColor].uiColor))
                            .showsLargeContentViewer(text: subtitle)
                            .font(.init(tokenSet[.subtitleFont].uiFont))
                    }
                }
            }
        }
    }

    @ViewBuilder
    var buttons: some View {
        HStack(spacing: CardNudgeTokenSet.buttonInnerPaddingHorizontal) {
            if let actionTitle = state.actionButtonTitle,
                      let action = state.actionButtonAction {
                SwiftUI.Button(actionTitle) {
                    action(state)
                }
                .lineLimit(1)
                .padding(.horizontal, CardNudgeTokenSet.buttonInnerPaddingHorizontal)
                .padding(.vertical, CardNudgeTokenSet.verticalPadding)
                .foregroundColor(Color(tokenSet[.buttonForegroundColor].uiColor))
                .font(.init(tokenSet[.titleFont].uiFont))
                .background(
                    RoundedRectangle(cornerRadius: tokenSet[.circleRadius].float)
                        .foregroundColor(Color(tokenSet[.buttonBackgroundColor].uiColor))
                )
                .showsLargeContentViewer(text: actionTitle)
                .hoverEffect()
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
                .padding(.vertical, CardNudgeTokenSet.verticalPadding)
                .accessibility(identifier: dismissLabel)
                .foregroundColor(Color(tokenSet[.subtitleTextColor].uiColor))
                .showsLargeContentViewer(text: dismissLabel, image: dismissImage)
                .hoverEffect()
            }
        }
    }

    @ViewBuilder
    var innerContents: some View {
        let messageAction = state.messageButtonAction
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
        .modifyIf(messageAction != nil) { view in
            view.accessibilityAddTraits(.isButton)
                .hoverEffect()
                .onTapGesture {
                    guard let messageAction else {
                        return
                    }
                    messageAction(state)
                }
        }
    }

    public var body: some View {
        tokenSet.update(fluentTheme)
#if DEBUG
        let accessibilityIdentifier: String = {
            var identifier: String = "Card Nudge with title \"\(state.title)\""

            var elements: [String] = []
            if let subtitle = state.subtitle {
                elements.append("subtitle \"\(subtitle)\"")
            }
            if let accentText = state.accentText {
                elements.append("accent text \"\(accentText)\"")
            }
            if state.mainIcon != nil {
                elements.append("an icon")
            }
            if state.accentIcon != nil {
                elements.append("an accent icon")
            }
            if let actionButtonTitle = state.actionButtonTitle {
                elements.append("an action button titled \"\(actionButtonTitle)\"")
            }
            if state.dismissButtonAction != nil {
                elements.append("a dismiss button")
            }

            if elements.count == 1 {
                identifier += " and \(elements[0])"
            } else if elements.count > 1 {
                for i in 0...elements.count - 2 {
                    identifier += ", \(elements[i])"
                }
                identifier += ", and \(elements[elements.count - 1])"
            }

            identifier += " in style \(state.style.rawValue)"

            return identifier
        }()
#endif
        return innerContents
            .background(
                RoundedRectangle(cornerRadius: tokenSet[.cornerRadius].float)
                    .strokeBorder(lineWidth: tokenSet[.outlineWidth].float)
                    .foregroundColor(Color(tokenSet[.outlineColor].uiColor))
                    .background(
                        Color(tokenSet[.backgroundColor].uiColor)
                            .cornerRadius(tokenSet[.cornerRadius].float)
                    )
#if DEBUG
                    .accessibilityIdentifier(accessibilityIdentifier)
#endif
            )
            .padding(.vertical, CardNudgeTokenSet.verticalPadding)
            .padding(.horizontal, CardNudgeTokenSet.horizontalPadding)
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

    /// Action to be dispatched by tapping on the `CardNudge`.
    @Published var messageButtonAction: CardNudgeButtonAction?

    /// Style to draw the control.
    @Published var style: MSFCardNudgeStyle

    @objc init(style: MSFCardNudgeStyle, title: String) {
        self.style = style
        self.title = title

        super.init()
    }
}
