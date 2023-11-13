//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class IndeterminateProgressBarDemoControllerSwiftUI: UIHostingController<IndeterminateProgressBarDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: IndeterminateProgressBarDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: IndeterminateProgressBarDemoView())
        self.title = "IndeterminateProgressBar Fluent 2 (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct IndeterminateProgressBarDemoView: View {
    @State var isAnimating: Bool = true
    @State var hidesWhenStopsAnimating: Bool = true
    @ObservedObject var fluentTheme: FluentTheme = .shared

    public var body: some View {
        VStack {
            VStack {
                IndeterminateProgressBar()
                    .isAnimating(isAnimating)
                    .hidesWhenStopped(hidesWhenStopsAnimating)
            }
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Settings")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        FluentUIDemoToggle(titleKey: "Animating", isOn: $isAnimating)
                        FluentUIDemoToggle(titleKey: "Hides when stopped", isOn: $hidesWhenStopsAnimating)
                    }
                }
                .padding()
            }
        }
        .fluentTheme(fluentTheme)
    }
}
