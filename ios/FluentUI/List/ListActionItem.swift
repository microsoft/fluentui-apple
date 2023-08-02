//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

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
            .frame(maxWidth: .infinity)
        }

        @ViewBuilder
        var secondaryButton: some View {
            if let secondaryAction {
                SwiftUI.Button(secondaryAction.title) {
                    secondaryAction.handler()
                }
                .buttonStyle(ActionButtonStyle(actionType: secondaryAction.actionType, tokenSet: tokenSet))
                .frame(maxWidth: .infinity)
            }
        }

        @ViewBuilder
        var verticalSeparator: some View {
            Color.black
                .frame(width: 1)
        }

        @ViewBuilder
        var content: some View {
            if secondaryAction != nil {
                HStack {
                    primaryButton
                    Rectangle()
                        .frame(width: SeparatorTokenSet.thickness)
                        .foregroundColor(Color(Separator.separatorDefaultColor(fluentTheme: fluentTheme)))
                    secondaryButton
                }
                .listRowInsets(EdgeInsets())
            } else {
                primaryButton
                    .listRowInsets(EdgeInsets())
            }
        }

        return content
    }

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
                .foregroundColor(configuration.isPressed ?
                                 Color(uiColor: actionType.highlightedTextColor(tokenSet: tokenSet))
                                 : Color(uiColor: actionType.textColor(tokenSet: tokenSet)))
        }
    }
}


private struct SeparatorRepresentable: UIViewRepresentable {
    let orientation: SeparatorOrientation
    
    func makeUIView(context: Context) -> UIView {
        return Separator(orientation: orientation)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


