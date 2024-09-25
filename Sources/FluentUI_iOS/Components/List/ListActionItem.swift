//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public typealias ListActionItemSeparatorType = TableViewCell.SeparatorType
public typealias ListActionItemActionType = ActionsCell.ActionType

/// View that represents an action that is displayed in a List.
public struct ListActionItem: View {

    // MARK: Initializer

    /// Creates a ListActionItem view
    /// - Parameters:
    ///   - title: The title of the action
    ///   - onTapped: The logic to execute when the item is tapped
    ///   - actionType: A type that defines how the action is communicated
    public init(title: String,
                onTapped: @escaping () -> Void,
                actionType: ListActionItemActionType = .regular) {
        self.primaryAction = Action(title: title,
                                    actionType: actionType,
                                    handler: onTapped)
    }

    /// Creates a ListActionItem view
    /// - Parameters:
    ///   - primaryActionTitle: The title of the action that is primary in the row
    ///   - onPrimaryActionTapped: The logic to execute when the primary action is tapped
    ///   - primaryActionType: A type that defines how the primary action is communicated
    ///   - secondaryActionTitle: The title of the action that is secondary in the row
    ///   - onSecondaryActionTapped: The logic to execute when the secondary action is tapped
    ///   - secondaryActionType: A type that defines how the secondary action is communicated
    public init(primaryActionTitle: String,
                onPrimaryActionTapped: @escaping () -> Void,
                primaryActionType: ListActionItemActionType = .regular,
                secondaryActionTitle: String,
                onSecondaryActionTapped: @escaping () -> Void,
                secondaryActionType: ListActionItemActionType = .regular) {
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
            .accessibilityIdentifier(AccessibilityIdentifiers.primaryActionButton)
        }

        @ViewBuilder
        var secondaryButton: some View {
            if let secondaryAction {
                SwiftUI.Button(secondaryAction.title) {
                    secondaryAction.handler()
                }
                .buttonStyle(ActionButtonStyle(actionType: secondaryAction.actionType, tokenSet: tokenSet))
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier(AccessibilityIdentifiers.secondaryActionButton)
            }
        }

        @ViewBuilder
        var separatorsStack: some View {
            VStack {
                if topSeparatorType != .none {
                    SeparatorRepresentable(orientation: .horizontal)
                        .frame(height: Separator.thickness)
                        .padding(edgeInsets(for: topSeparatorType))
                }
                Spacer()
                if bottomSeparatorType != .none {
                    SeparatorRepresentable(orientation: .horizontal)
                        .frame(height: Separator.thickness)
                        .padding(edgeInsets(for: bottomSeparatorType))
                }
            }
            .accessibilityHidden(true)
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
        var backgroundView: some View {
            if let backgroundColor = backgroundStyleType.defaultColor(tokenSet: tokenSet) {
                Color(backgroundColor)
            } else {
                EmptyView()
            }
        }

        @ViewBuilder
        var content: some View {
            if topSeparatorType != .none || bottomSeparatorType != .none {
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
            .background(backgroundView)
    }

    /// The type of separator on the top edge
    var topSeparatorType: ListActionItemSeparatorType = .none
    /// The type of separator on the bottom edge
    var bottomSeparatorType: ListActionItemSeparatorType = .none
    /// The background styling to match the type of `List` it is displayed in
    var backgroundStyleType: ListItemBackgroundStyleType = .plain

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private let primaryAction: Action
    private var secondaryAction: Action?
    /// The token set, which uses customViewSize as default as the control does not use those token values
    private let tokenSet: ListItemTokenSet = ListItemTokenSet(customViewSize: { .default })

    private struct Action {
        let title: String
        let actionType: ListActionItemActionType
        let handler: () -> Void
    }

    private struct ActionButtonStyle: SwiftUI.ButtonStyle {
        let actionType: ListActionItemActionType
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

    private struct SeparatorRepresentable: UIViewRepresentable {
        let orientation: SeparatorOrientation

        func makeUIView(context: Context) -> UIView {
            return Separator(orientation: orientation)
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }

    private func edgeInsets(for separatorType: ListActionItemSeparatorType) -> EdgeInsets {
        var edgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        switch separatorType {
        case .inset:
            edgeInsets.leading = ListItemTokenSet.horizontalSpacing
        case .full, .none:
            break
        }
        return edgeInsets
    }
}

// MARK: Constants

private struct AccessibilityIdentifiers {
    static let primaryActionButton: String = "ListActionItemPrimaryButton"
    static let secondaryActionButton: String = "ListActionItemSecondaryButton"
}
