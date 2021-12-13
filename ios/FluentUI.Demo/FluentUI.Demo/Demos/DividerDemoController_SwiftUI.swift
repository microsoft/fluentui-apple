//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class DividerDemoControllerSwiftUI: UIHostingController<DividerDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: DividerDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: DividerDemoView())
        self.title = "Divider (SwiftUI)"
    }
}

struct DividerDemoView: View {
    @State var spacing: MSFDividerSpacing = .none

    public var body: some View {
        VStack (spacing: 0) {
            FluentDivider(spacing: spacing)
            HStack (spacing: 0) {
                FluentDivider(orientation: .vertical, spacing: spacing)
                Text("Text 1")
                FluentDivider(orientation: .vertical, spacing: spacing)
                Text("Text 2")
                FluentDivider(orientation: .vertical, spacing: spacing)
            }
            .frame(maxHeight: 20)
            FluentDivider(spacing: spacing)
        }

        ScrollView {
            Group {
                VStack(spacing: 0) {
                    Text("Spacing")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                        .padding()
                    Divider()
                }

                Picker(selection: $spacing, label: EmptyView()) {
                    Text(".none").tag(MSFDividerSpacing.none)
                    Text(".medium").tag(MSFDividerSpacing.medium)
                }
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}
