//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class AliasColorTokensDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(AliasColorTokensDemoView()), title: "Alias Color Tokens")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

struct AliasColorTokensDemoView: View {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    var body: some View {
        if #available(iOS 16.0, *) {
            formContent.scrollContentBackground(.hidden)
        } else {
            formContent.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }

    @ViewBuilder
    var formContent: some View {
        Form {
            ForEach(AliasColorTokensDemoSection.allCases, id: \.self) { demoSection in
                // No need for SwiftUI section in SwiftUI demo!
                if demoSection != .swiftUI {
                    colorSection(demoSection)
                }
            }
        }
        .background(fluentTheme.color(.backgroundCanvas))
    }

    @ViewBuilder
    func colorSection(_ demoSection: AliasColorTokensDemoSection) -> some View {
        Section(demoSection.title) {
            ForEach(demoSection.rows, id: \.self) { colorRow in
                Text(colorRow.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(fluentTheme.color(colorRow))
                    .foregroundStyle(Color(colorRow.textColor(fluentTheme)))
            }
        }
    }
}
