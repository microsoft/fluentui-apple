//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ProgressBarDemoControllerSwiftUI: UIHostingController<ProgressBarDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ProgressBarDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ProgressBarDemoView())
        self.title = "ProgressBar Fluent 2 (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct ProgressBarDemoView: View {
    @State var isAnimating: Bool = true
    @State var hidesWhenStopsAnimating: Bool = true
    @State var isDeterminate: Bool = false
    @State var autoAdvanceProgress: Bool = false
    @State var progress: Double = 0.4
    @ObservedObject var fluentTheme: FluentTheme = .shared

    public var body: some View {
        VStack {
            VStack {
                ProgressBar()
                    .isAnimating(isAnimating)
                    .hidesWhenStopped(hidesWhenStopsAnimating)
                    .progress(isDeterminate ? progress : nil)
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
                        FluentUIDemoToggle(titleKey: "Determinate", isOn: $isDeterminate)
                        if isDeterminate {
                            FluentUIDemoToggle(titleKey: "Auto-advance progress", isOn: $autoAdvanceProgress)
                        }
                    }
                }
                .padding()
            }
        }
        .fluentTheme(fluentTheme)
        .task(id: isDeterminate && autoAdvanceProgress) {
            guard isDeterminate && autoAdvanceProgress else {
                return
            }

            // Continuously advance the determinate progress so the bar appears to animate,
            // wrapping back to zero once it completes.
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30 * NSEC_PER_MSEC)
                if Task.isCancelled {
                    break
                }
                progress = progress >= 1.0 ? 0.0 : min(progress + 0.01, 1.0)
            }
        }
    }
}
