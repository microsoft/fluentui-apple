//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Type of callback for both action and dismiss buttons.
public typealias CardNudgeViewButtonAction = ((_ state: CardNudgeViewState) -> Void)

/// A class that contains properties to specify the contents of a `PersonaButton`.
@objc(MSFCardNudgeViewState)
public class CardNudgeViewState: NSObject, ObservableObject, Identifiable {
    @Published @objc public private(set) var style: CardNudgeViewStyle

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
    @Published @objc public var actionButtonAction: CardNudgeViewButtonAction?

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    @Published @objc public var dismissButtonAction: CardNudgeViewButtonAction?

    /// Parent window of the `PersonaButton`.
    ///
    /// Used to derive the color theme for the control.
    var hostingWindow: UIWindow? {
        didSet {
            tokens.window = hostingWindow
        }
    }

    let tokens: CardNudgeTokens

    @objc init(style: CardNudgeViewStyle, title: String) {
        self.style = style
        self.title = title
        self.tokens = CardNudgeTokens(style: style)

        super.init()
    }

    @objc convenience init(style: CardNudgeViewStyle,
                           title: String,
                           subtitle: String? = nil,
                           mainIcon: UIImage? = nil,
                           accentText: String? = nil,
                           actionButtonTitle: String? = nil,
                           actionButtonAction: CardNudgeViewButtonAction? = nil,
                           dismissButtonAction: CardNudgeViewButtonAction? = nil) {
        self.init(style: style, title: title)

        self.subtitle = subtitle
        self.mainIcon = mainIcon
        self.accentText = accentText
        self.actionButtonTitle = actionButtonTitle
        self.actionButtonAction = actionButtonAction
        self.dismissButtonAction = dismissButtonAction
    }
}

public struct CardNudgeView: View {
    @ObservedObject var tokens: CardNudgeTokens
    @ObservedObject var state: CardNudgeViewState

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
            .padding(.trailing, tokens.innerPadding)
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
                .padding(.vertical, tokens.buttonInnerPaddingVertical)
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
                .padding(.vertical, tokens.buttonInnerPaddingVertical)
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
            Spacer(minLength: 0)
            buttons
                .layoutPriority(1)
        }
        .padding(.vertical, tokens.mainContentVerticalPadding)
        .padding(.horizontal, tokens.innerPadding)
        .frame(minHeight: tokens.minimumHeight)
    }

    public var body: some View {
        innerContents
            .background(
                RoundedRectangle(cornerRadius: tokens.cornerRadius)
                    .strokeBorder(Color(tokens.backgroundBorderColor), lineWidth: 1.0)
                    .background(
                        RoundedRectangle(cornerRadius: tokens.cornerRadius)
                            .fill(Color(tokens.backgroundColor))
                    )
            )
            .padding(.vertical, tokens.outerVerticalPadding)
            .padding(.horizontal, tokens.outerHorizontalPadding)
    }

    init(_ state: CardNudgeViewState) {
        self.state = state
        self.tokens = state.tokens
    }
}
