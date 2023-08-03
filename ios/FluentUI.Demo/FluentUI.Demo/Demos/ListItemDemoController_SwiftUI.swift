//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

typealias ListItemSampleData = TableViewCellSampleData

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

    public var body: some View {
        List {
            ForEach(ListItemSampleData.sections, id: \.title) { section in
                Section {
                    ForEach(accessoryTypes, id: \.rawValue) { accessoryType in
                        ListItem(title: section.item.text1,
                                 subtitle: section.item.text2,
                                 footer: section.item.text3,
                                 leadingContent: {
                            if !section.item.image.isEmpty {
                                Image(section.item.image)
                                    .resizable()
                            }
                        },
                                 trailingContent: {
                            if section.hasAccessory {
                                UIViewWrapper {
                                    ListItemSampleData.customAccessoryView
                                }
                                .fixedSize()
                            }
                        })
                            .backgroundStyleType(.grouped)
                            .accessoryType(accessoryType)
                            .titleLineLimit(section.numberOfLines)
                            .subtitleLineLimit(section.numberOfLines)
                            .footerLineLimit(section.numberOfLines)
                            .onAccessoryTapped {
                                if accessoryType == .detailButton {
                                    showingAlert.toggle()
                                }
                            }
                    }
                } header: {
                    Text(section.title)
                        .textCase(nil)
                }
            }
            Section {
                ListActionItem(title: "Search Directory") {
                    showingAlert.toggle()
                }
                ListActionItem(primaryActionTitle: "Done",
                               onPrimaryActionTapped: {
                    showingAlert.toggle()
                }, secondaryActionTitle: "Cancel", onSecondaryActionTapped: {
                    showingAlert.toggle()
                }, secondaryActionType: .destructive)
            } header: {
                Text("Action Item")
                    .textCase(nil)
            }
        }
        .alert("Button tapped", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .listStyle(.insetGrouped)
        .fluentTheme(fluentTheme)
    }
}

struct UIViewWrapper: UIViewRepresentable {

    var view: () -> UIView

    func makeUIView(context: Context) -> UIView {
        return view()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
