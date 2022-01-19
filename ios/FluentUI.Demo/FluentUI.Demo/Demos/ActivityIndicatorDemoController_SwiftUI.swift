//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ActivityIndicatorDemoControllerSwiftUI: UIHostingController<ActivityIndicatorDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ActivityIndicatorDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ActivityIndicatorDemoView())
        self.title = "ActivityIndicator Vnext (SwiftUI)"
    }
}

struct ActivityIndicatorDemoView: View {
    @State var isAnimating: Bool = true
    @State var hidesWhenStopsAnimating: Bool = true
    @State var usesCustomColor: Bool = false
    @State var size: MSFActivityIndicatorSize = .xLarge

    public var body: some View {
        VStack {
            VStack {
                ActivityIndicator(size: size)
                    .isAnimating(isAnimating)
                    .hidesWhenStopped(hidesWhenStopsAnimating)
                    .color(usesCustomColor ? Colors.communicationBlue : nil)
            }
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Settings")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            FluentDivider()
                        }

                        FluentUIDemoToggle(titleKey: "Animating", isOn: $isAnimating)
                        FluentUIDemoToggle(titleKey: "Hides when stopped", isOn: $hidesWhenStopsAnimating)
                        FluentUIDemoToggle(titleKey: "Uses custom color", isOn: $usesCustomColor)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Size")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            FluentDivider()
                        }

                        Picker(selection: $size, label: EmptyView()) {
                            Text(".xLarge").tag(MSFActivityIndicatorSize.xLarge)
                            Text(".large").tag(MSFActivityIndicatorSize.large)
                            Text(".medium").tag(MSFActivityIndicatorSize.medium)
                            Text(".small").tag(MSFActivityIndicatorSize.small)
                            Text(".xSmall").tag(MSFActivityIndicatorSize.xSmall)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
    }
}
