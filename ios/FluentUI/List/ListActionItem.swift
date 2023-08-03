//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public enum ListActionItemSeparatorType {
    case inset
    case full
}

/// View that represents an action that is displayed in a List.
public struct ListActionItem: View {

    public init(primaryActionTitle: String,
                onPrimaryActionTapped: @escaping () -> Void,
                primaryActionType: ActionType = .regular) {
        self.primaryAction = Action(title: primaryActionTitle,
                                    actionType: primaryActionType,
                                    handler: onPrimaryActionTapped)
    }

    public init(primaryActionTitle: String,
                onPrimaryActionTapped: @escaping () -> Void,
                primaryActionType: ActionType = .regular,
                secondaryActionTitle: String,
                onSecondaryActionTapped: @escaping () -> Void,
                secondaryActionType: ActionType = .regular) {
        self.primaryAction = Action(title: primaryActionTitle,
                                    actionType: primaryActionType,
                                    handler: onPrimaryActionTapped)
        self.secondaryAction = Action(title: secondaryActionTitle,
                                      actionType: secondaryActionType,
                                      handler: onSecondaryActionTapped)
    }

    public var body: some View {
        tokenSet.update(fluentTheme)

        @ViewBuilder
        var primaryButton: some View {
            SwiftUI.Button(primaryAction.title) {
                primaryAction.handler()
            }
            .buttonStyle(ActionButtonStyle(actionType: primaryAction.actionType, tokenSet: tokenSet))
            .frame(maxWidth: .infinity, alignment: .center)
        }

        @ViewBuilder
        var secondaryButton: some View {
            if let secondaryAction {
                SwiftUI.Button(secondaryAction.title) {
                    secondaryAction.handler()
                }
                .buttonStyle(ActionButtonStyle(actionType: secondaryAction.actionType, tokenSet: tokenSet))
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }

        @ViewBuilder
        var separatorsStack: some View {
            VStack {
                if let topSeparatorType {
                    SeparatorRepresentable(orientation: .horizontal)
                        .frame(height: Separator.thickness)
                        .padding(edgeInsets(for: topSeparatorType))
                }
                Spacer()
                if let bottomSeparatorType {
                    SeparatorRepresentable(orientation: .horizontal)
                        .frame(height: Separator.thickness)
                        .padding(edgeInsets(for: bottomSeparatorType))
                }
            }
        }

        @ViewBuilder
        var buttons: some View {
            if secondaryAction != nil {
                HStack {
                    primaryButton
                        .padding(.leading, ListItemTokenSet.paddingLeading)
                        .padding(.trailing, ListItemTokenSet.horizontalSpacing)
                    SeparatorRepresentable(orientation: .horizontal)
                        .frame(width: Separator.thickness)
                    secondaryButton
                        .padding(.leading, ListItemTokenSet.horizontalSpacing)
                        .padding(.trailing, ListItemTokenSet.paddingTrailing)
                }
            } else {
                primaryButton
                    .padding(.leading, ListItemTokenSet.paddingLeading)
                    .padding(.trailing, ListItemTokenSet.paddingTrailing)
            }
        }

        @ViewBuilder
        var content: some View {
            if topSeparatorType != nil || bottomSeparatorType != nil {
                ZStack {
                    buttons
                    separatorsStack
                }
            } else {
                buttons
            }
        }

        return content
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .frame(minHeight: ListItemTokenSet.oneLineMinHeight)
    }

    var topSeparatorType: ListActionItemSeparatorType?
    var bottomSeparatorType: ListActionItemSeparatorType?
    var backgroundStyleType: ListItemBackgroundStyleType = .plain

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private let primaryAction: Action
    private var secondaryAction: Action?
    private let tokenSet: ListItemTokenSet = ListItemTokenSet(customViewSize: { .default })

    private struct Action {
        let title: String
        let actionType: ActionType
        let handler: () -> Void
    }

    private struct ActionButtonStyle: SwiftUI.ButtonStyle {
        let actionType: ActionType
        let tokenSet: ListItemTokenSet

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .font(Font(tokenSet[.titleFont].uiFont))
                .padding(.vertical, ListItemTokenSet.paddingVertical)
                .foregroundColor(configuration.isPressed ?
                                 Color(uiColor: actionType.highlightedTextColor(tokenSet: tokenSet))
                                 : Color(uiColor: actionType.textColor(tokenSet: tokenSet)))
        }
    }

    private func edgeInsets(for separatorType: ListActionItemSeparatorType) -> EdgeInsets {
        var edgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        switch separatorType {
        case .inset:
            edgeInsets.leading = ListItemTokenSet.horizontalSpacing
        case .full:
            break
        }
        return edgeInsets
    }
}

private struct SeparatorRepresentable: UIViewRepresentable {
    let orientation: SeparatorOrientation

    func makeUIView(context: Context) -> UIView {
        return Separator(orientation: orientation)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
