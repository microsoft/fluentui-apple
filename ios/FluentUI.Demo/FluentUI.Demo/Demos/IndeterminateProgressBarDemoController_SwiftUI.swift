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
        self.title = "IndeterminateProgressBar Vnext (SwiftUI)"
    }
}

struct IndeterminateProgressBarDemoView: View {
    @State var isAnimating: Bool = true
    @State var hidesWhenStopsAnimating: Bool = true

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
    }
}
