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
        self.title = "ListItem Fluent 2 (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct ListItemDemoView: View {
    @State var showingAlert: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared
    let accessoryTypes: [ListItemAccessoryType] = [.none, .checkmark, .detailButton, .disclosureIndicator]

    public var body: some View {
        List {
            ForEach(ListItemSampleData.sections) { section in
                Section {
                    ForEach(section.items) { item in
                        ForEach(accessoryTypes, id: \.rawValue) { accessoryType in
                            ListItem(title: item.text1,
                                     subtitle: item.text2,
                                     footer: item.text3,
                                     leadingContent: {
                                if !item.image.isEmpty {
                                    Image(item.image)
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
                                .onAccessoryTapped {
                                    if accessoryType == .detailButton {
                                        showingAlert.toggle()
                                    }
                                }
                                .alert("Detail button tapped", isPresented: $showingAlert) {
                                    Button("OK", role: .cancel) { }
                                }
                        }
                    }
                } header: {
                    Text(section.title)
                        .textCase(nil)
                }
            }
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
