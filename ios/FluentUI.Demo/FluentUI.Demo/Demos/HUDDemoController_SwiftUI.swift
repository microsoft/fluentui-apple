//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class HUDDemoControllerSwiftUI: UIHostingController<HUDDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: HUDDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: HUDDemoView())
        self.title = "HUD (SwiftUI)"
    }
}

struct HUDDemoView: View {

    public var body: some View {
        VStack {
            HeadsUpDisplay(type: type,
                           label: label)

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Presentation")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        FluentUIDemoToggle(titleKey: "Blocks interaction",
                                           isOn: $isBlocking)

                        FluentButton(style: .primary,
                                     size: .large,
                                     text: "Present HUD for 3 seconds") {
                            isPresented = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isPresented = false
                            }
                        }
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Label")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        TextField("Label", text: $label)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        VStack(spacing: 0) {
                            Text("Type")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $type, label: EmptyView()) {
                            Text(".activity").tag(HUDType.activity)
                            Text(".success").tag(HUDType.success)
                            Text(".failure").tag(HUDType.failure)
                            Text(".custom").tag(HUDType.custom(image: UIImage(named: "flag-40x40")!))
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
        .presentHUD(type: type,
                    isBlocking: isBlocking,
                    isPresented: $isPresented,
                    label: label)
    }

    @State var isBlocking: Bool = true
    @State var isPresented: Bool = false
    @State var label: String = ""
    @State var type: HUDType = .activity
}
