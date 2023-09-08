//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class ListItemDemoControllerSwiftUI: UIHostingController<ListItemDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ListItemDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ListItemDemoView())
    }
}

struct ListItemDemoView: View {
    @State var showingAlert: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared
    let accessoryTypes: [ListItemAccessoryType] = [.none, .checkmark, .detailButton, .disclosureIndicator]

    @State var title: String = "Contoso Survey"
    @State var subtitle: String = "Research Notes"
    @State var footer: String = "22 views"
    @State var showSubtitle: Bool = false
    @State var showFooter: Bool = false
    @State var showLeadingContent: Bool = true
    @State var showTrailingContent: Bool = true
    @State var isDisabled: Bool = false
    @State var accessoryType: ListItemAccessoryType = .none
    @State var leadingContentSize: ListItemLeadingContentSize = .default
    @State var backgroundStyle: ListItemBackgroundStyleType = .grouped
    @State var titleLineLimit: Int = 1
    @State var subtitleLineLimit: Int = 1
    @State var footerLineLimit: Int = 1
    @State var trailingContentFocusableElementCount: Int = 0
    @State var trailingContentToggleEnabled: Bool = true

    public var body: some View {

        @ViewBuilder
        var textFields: some View {
            TextField("Title", text: $title)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("titleTextField")
            TextField("Subtitle", text: $subtitle)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("subtitleTextField")
            TextField("Footer", text: $footer)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("footerTextField")
        }

        @ViewBuilder
        var toggles: some View {
            FluentUIDemoToggle(titleKey: "Show subtitle", isOn: $showSubtitle)
                .accessibilityIdentifier("subtitleSwitch")
            FluentUIDemoToggle(titleKey: "Show footer", isOn: $showFooter)
                .accessibilityIdentifier("footerSwitch")
            FluentUIDemoToggle(titleKey: "Show leading content", isOn: $showLeadingContent)
                .accessibilityIdentifier("leadingContentSwitch")
            FluentUIDemoToggle(titleKey: "Show trailing content", isOn: $showTrailingContent)
                .accessibilityIdentifier("trailingContentSwitch")
            FluentUIDemoToggle(titleKey: "Disabled", isOn: $isDisabled)
        }

        @ViewBuilder
        var pickers: some View {
            Picker("Accessory Type", selection: $accessoryType) {
                Text(".none").tag(ListItemAccessoryType.none)
                Text(".disclosureIndicator").tag(ListItemAccessoryType.disclosureIndicator)
                Text(".checkmark").tag(ListItemAccessoryType.checkmark)
                Text(".detailButton").tag(ListItemAccessoryType.detailButton)
            }
            .accessibilityIdentifier("accessoryTypePicker")
            Picker("Leading Content Size", selection: $leadingContentSize) {
                Text(".default").tag(ListItemLeadingContentSize.default)
                Text(".zero").tag(ListItemLeadingContentSize.zero)
                Text(".small").tag(ListItemLeadingContentSize.small)
                Text(".medium").tag(ListItemLeadingContentSize.medium)
            }
            .accessibilityIdentifier("leadingContentSizePicker")
            Picker("Background Style", selection: $backgroundStyle) {
                Text(".plain").tag(ListItemBackgroundStyleType.plain)
                Text(".grouped").tag(ListItemBackgroundStyleType.grouped)
                Text(".clear").tag(ListItemBackgroundStyleType.clear)
                Text(".custom").tag(ListItemBackgroundStyleType.custom)
            }
        }

        @ViewBuilder
        var steppers: some View {
            Stepper(value: $titleLineLimit, in: 0...5) {
                Text("Title Line Limit: \(titleLineLimit)")
            }
            Stepper(value: $subtitleLineLimit, in: 0...5) {
                Text("Subtitle Line Limit: \(subtitleLineLimit)")
            }
            Stepper(value: $footerLineLimit, in: 0...5) {
                Text("Footer Line Limit: \(footerLineLimit)")
            }
            Stepper(value: $trailingContentFocusableElementCount, in: 0...2) {
                Text("Trailing Content focusable element count: \(trailingContentFocusableElementCount)")
            }
        }

        @ViewBuilder
        var controls: some View {
            Section {
                textFields
                    .listRowSeparator(.hidden)
                toggles
                pickers
                steppers
            } header: {
                Text("Settings")
            }
        }

        @ViewBuilder
        var leadingContent: some View {
            Image("excelIcon")
                .resizable()
        }

        @ViewBuilder
        var content: some View {
            VStack {
                List {
                    Section {
                        ListItem(title: title,
                                 subtitle: showSubtitle ? subtitle : "",
                                 footer: showFooter ? footer : "",
                                 leadingContent: {
                            if showLeadingContent {
                                leadingContent
                            }
                        },
                                 trailingContent: {
                            if showTrailingContent {
                                switch trailingContentFocusableElementCount {
                                case 0:
                                    Text("Spreadsheet")
                                case 1:
                                    Toggle("", isOn: $trailingContentToggleEnabled)
                                default:
                                    HStack {
                                        Button {
                                            showingAlert = true
                                        } label: {
                                            Text("Button 1")
                                        }
                                        Button {
                                            showingAlert = true
                                        } label: {
                                            Text("Button 2")
                                        }
                                    }
                                }
                            }
                        })
                        .backgroundStyleType(backgroundStyle)
                        .accessoryType(accessoryType)
                        .leadingContentSize(leadingContentSize)
                        .titleLineLimit(titleLineLimit)
                        .subtitleLineLimit(subtitleLineLimit)
                        .footerLineLimit(footerLineLimit)
                        .combineTrailingContentAccessibilityElement(trailingContentFocusableElementCount < 2)
                        .onAccessoryTapped {
                            showingAlert = true
                        }
                        .disabled(isDisabled)
                        .alert("Detail button tapped", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    } header: {
                        Text("ListItem")
                    }
                    controls
                }
                .background(ListItem.listBackgroundColor(for: .grouped))
                .fluentTheme(fluentTheme)
                .listStyle(.insetGrouped)
            }
        }

        return content
    }
}

struct UIViewWrapper: UIViewRepresentable {

    var view: () -> UIView

    func makeUIView(context: Context) -> UIView {
        return view()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
