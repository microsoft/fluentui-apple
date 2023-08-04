//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class ListActionItemDemoControllerSwiftUI: UIHostingController<ListActionItemDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ListActionItemDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ListActionItemDemoView())
    }
}

struct ListActionItemDemoView: View {
    @State var showingAlert: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared
    @State var showSecondaryAction: Bool = false
    @State var primaryActionTitle: String = "Search"
    @State var secondaryActionTitle: String = "Cancel"
    @State var primaryActionType: ListActionItemActionType = .regular
    @State var secondaryActionType: ListActionItemActionType = .destructive
    @State var topSeparatorType: ListActionItemSeparatorType = .none
    @State var bottomSeparatorType: ListActionItemSeparatorType = .inset
    @State var backgroundStyleType: ListItemBackgroundStyleType = .grouped

    public var body: some View {

        @ViewBuilder
        var textFields: some View {
            TextField("Primary Action Title", text: $primaryActionTitle)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("primaryActionTitleTextField")
            if showSecondaryAction {
                TextField("Secondary Action Title", text: $secondaryActionTitle)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("secondaryActionTitleTextField")
            }
        }

        @ViewBuilder
        var pickers: some View {
            let actionTypePickerOptions = Group {
                Text(".regular").tag(ListActionItemActionType.regular)
                Text(".destructive").tag(ListActionItemActionType.destructive)
                Text(".communication").tag(ListActionItemActionType.communication)
            }

            Picker("Primary Action Type", selection: $primaryActionType) {
                actionTypePickerOptions
            }
            if showSecondaryAction {
                Picker("Secondary Action Type", selection: $secondaryActionType) {
                    actionTypePickerOptions
                }
            }

            let separatorTypePickerOptions = Group {
                Text(".none").tag(ListActionItemSeparatorType.none)
                Text(".inset").tag(ListActionItemSeparatorType.inset)
                Text(".full").tag(ListActionItemSeparatorType.full)
            }

            Picker("Top Separator Type", selection: $topSeparatorType) {
                separatorTypePickerOptions
            }

            Picker("Bottom Separator Type", selection: $bottomSeparatorType) {
                separatorTypePickerOptions
            }
        }

        @ViewBuilder
        var content: some View {
            List {
                Section {
                    if showSecondaryAction {
                        ListActionItem(primaryActionTitle: primaryActionTitle,
                                       onPrimaryActionTapped: {
                            showingAlert.toggle()
                        },
                                       primaryActionType: primaryActionType,
                                       secondaryActionTitle: secondaryActionTitle,
                                       onSecondaryActionTapped: {
                            showingAlert.toggle()
                        },
                                       secondaryActionType: secondaryActionType)
                        .topSeparatorType(topSeparatorType)
                        .bottomSeparatorType(bottomSeparatorType)
                        .backgroundStyleType(backgroundStyleType)
                    } else {
                        ListActionItem(title: primaryActionTitle,
                                       onTapped: {
                            showingAlert.toggle()
                        },
                                       actionType: primaryActionType)
                        .topSeparatorType(topSeparatorType)
                        .bottomSeparatorType(bottomSeparatorType)
                        .backgroundStyleType(backgroundStyleType)
                    }

                } header: {
                    Text("ListActionItem")
                }
                .alert("Action tapped", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                        .accessibilityIdentifier("DismissAlertButton")
                }

                Section {
                    FluentUIDemoToggle(titleKey: "Show secondary action", isOn: $showSecondaryAction)
                        .accessibilityIdentifier("showSecondaryActionSwitch")
                    textFields
                    pickers
                } header: {
                    Text("Settings")
                }
            }
            .fluentTheme(fluentTheme)
            .listStyle(.insetGrouped)
        }

        return content
    }
}
