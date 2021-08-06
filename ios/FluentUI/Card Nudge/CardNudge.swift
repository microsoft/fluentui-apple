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
    @objc var style: MSFCardNudgeStyle { get }

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
public struct CardNudge: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFCardNudgeTokens
    @ObservedObject var state: MSFCardNudgeStateImpl

    @ViewBuilder
    var icon: some View {
        if let icon = state.mainIcon {
            ZStack {
                Circle()
                    .frame(width: tokens.circleSize, height: tokens.circleSize)
                    .foregroundColor(Color(tokens.buttonBackgroundColor))
                Image(uiImage: icon)
                    .renderingMode(.template)
                    .frame(width: tokens.iconSize, height: tokens.iconSize, alignment: .center)
                    .foregroundColor(Color(tokens.accentColor))
            }
            .padding(.trailing, tokens.horizontalPadding)
        }
    }

    private var hasSecondTextRow: Bool {
        state.accentIcon != nil || state.accentText != nil || state.subtitle != nil
    }

    @ViewBuilder
    var textContainer: some View {
        VStack(alignment: .leading, spacing: tokens.interTextVerticalPadding) {
            Text(state.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(Color(tokens.textColor))

            if hasSecondTextRow {
                HStack(spacing: tokens.accentPadding) {
                    if let accentIcon = state.accentIcon {
                        Image(uiImage: accentIcon)
                            .renderingMode(.template)
                            .frame(width: tokens.accentIconSize, height: tokens.accentIconSize)
                            .foregroundColor(Color(tokens.accentColor))
                    }
                    if let accent = state.accentText {
                        Text(accent)
                            .font(.subheadline)
                            .layoutPriority(1)
                            .lineLimit(1)
                            .foregroundColor(Color(tokens.accentColor))
                    }
                    if let subtitle = state.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(Color(tokens.subtitleTextColor))
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
                .padding(.horizontal, tokens.buttonInnerPaddingHorizontal)
                .padding(.vertical, tokens.verticalPadding)
                .foregroundColor(Color(tokens.accentColor))
                .background(
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(Color(tokens.buttonBackgroundColor))
                )
            }
            if let dismissAction = state.dismissButtonAction {
                SwiftUI.Button(action: {
                    dismissAction(state)
                }, label: {
                    Image("dismiss-20x20", bundle: FluentUIFramework.resourceBundle)
                })
                .padding(.horizontal, tokens.buttonInnerPaddingHorizontal)
                .padding(.vertical, tokens.verticalPadding)
                .accessibility(identifier: "Accessibility.Dismiss.Label")
                .foregroundColor(Color(tokens.textColor))
            }
        }
    }

    @ViewBuilder
    var innerContents: some View {
        HStack(spacing: 0) {
            icon
            textContainer
            Spacer(minLength: tokens.accentPadding)
            buttons
                .layoutPriority(1)
        }
        .padding(.vertical, tokens.mainContentVerticalPadding)
        .padding(.horizontal, tokens.horizontalPadding)
        .frame(minHeight: tokens.minimumHeight)
    }

    public var body: some View {
        innerContents
            .background(
                RoundedRectangle(cornerRadius: tokens.cornerRadius)
                    .strokeBorder(Color(tokens.outlineColor), lineWidth: tokens.outlineWidth)
                    .background(
                        RoundedRectangle(cornerRadius: tokens.cornerRadius)
                            .fill(Color(tokens.backgroundColor))
                    )
            )
            .padding(.vertical, tokens.verticalPadding)
            .padding(.horizontal, tokens.horizontalPadding)
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    init(style: MSFCardNudgeStyle, title: String) {
        let state = MSFCardNudgeStateImpl(style: style, title: title)
        self.state = state
        self.tokens = state.tokens
    }
}

class MSFCardNudgeStateImpl: NSObject, ObservableObject, Identifiable, MSFCardNudgeState {
    @Published @objc public private(set) var style: MSFCardNudgeStyle

    @Published @objc public var title: String
    @Published @objc public var subtitle: String?
    @Published @objc public var mainIcon: UIImage?
    @Published @objc public var accentIcon: UIImage?
    @Published @objc public var accentText: String?

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published @objc public var actionButtonTitle: String?

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    @Published @objc public var actionButtonAction: CardNudgeButtonAction?

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    @Published @objc public var dismissButtonAction: CardNudgeButtonAction?

    let tokens: MSFCardNudgeTokens

    @objc init(style: MSFCardNudgeStyle, title: String) {
        self.style = style
        self.title = title
        self.tokens = MSFCardNudgeTokens(style: style)

        super.init()
    }

    @objc convenience init(style: MSFCardNudgeStyle,
                           title: String,
                           subtitle: String? = nil,
                           mainIcon: UIImage? = nil,
                           accentText: String? = nil,
                           actionButtonTitle: String? = nil,
                           actionButtonAction: CardNudgeButtonAction? = nil,
                           dismissButtonAction: CardNudgeButtonAction? = nil) {
        self.init(style: style, title: title)

        self.subtitle = subtitle
        self.mainIcon = mainIcon
        self.accentText = accentText
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.dismissButtonAction = dismissButtonAction
    }
}

#if DEBUG
struct CardNudge_Previews: PreviewProvider {
    @ViewBuilder
    static var cards: some View {
        VStack(spacing: 0) {
            CardNudge(style: .standard, title: "Title")
                .mainIcon(UIImage(systemName: "newspaper"))
                .accentText("Accent")
                .accentIcon(UIImage(named: "ic_fluent_presence_blocked_12_regular", in: FluentUIFramework.resourceBundle, with: nil))
                .subtitle("Subtitle")
                .actionButtonTitle("Action")
                .actionButtonAction({ _ in
                })
                .dismissButtonAction({ _ in
                })

            CardNudge(style: .standard, title: "Title")
                .mainIcon(UIImage(systemName: "newspaper"))
                .accentText("Accent")
                .accentIcon(UIImage(named: "ic_fluent_presence_blocked_12_regular", in: FluentUIFramework.resourceBundle, with: nil))
                .subtitle("Subtitle")
                .dismissButtonAction({ _ in
                })
            CardNudge(style: .outline, title: "Title")
            CardNudge(style: .outline, title: "Title")
                .dismissButtonAction({ _ in
                })
            CardNudge(style: .outline, title: "Title")
                .mainIcon(UIImage(systemName: "newspaper"))
                .accentText("Accent")
                .accentIcon(UIImage(named: "ic_fluent_presence_blocked_12_regular", in: FluentUIFramework.resourceBundle, with: nil))
                .subtitle("Subtitle")
                .actionButtonTitle("Action")
                .actionButtonAction({ _ in
                })
        }
    }

    static var previews: some View {
        Group {
            cards.preferredColorScheme(.light)
            cards.preferredColorScheme(.dark)
        }
        .environment(\.sizeCategory, .large)
    }
}
#endif
