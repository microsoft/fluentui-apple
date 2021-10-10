//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonDemoControllerSwiftUI: UIHostingController<ButtonDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ButtonDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ButtonDemoView())
        self.title = "Button Vnext (SwiftUI)"
    }
}

struct ButtonDemoView: View {
    @State var isDisabled: Bool = false
    @State var text: String = "Button"
    @State var showImage: Bool = true
    @State var showLabel: Bool = true
    @State var showAlert: Bool = false
    @State var size: MSFButtonSize = .large
    @State var style: MSFButtonStyle = .accentFloating

    public var body: some View {
        VStack {
            FluentButton(style: style,
                         size: size,
                         image: showImage ? UIImage(named: "Placeholder_24") : nil,
                         text: showLabel ? text : nil) {
                showAlert = true
            }
            .disabled(isDisabled)
            .fixedSize()
            .padding()
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Button tapped"))
            })

            ScrollView {
                Group {
                    Group {
                        DemoHeading(title: "Content")

                        TextField("Text", text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        FluentUIDemoToggle(titleKey: "Show image", isOn: $showImage)
                        FluentUIDemoToggle(titleKey: "Show label", isOn: $showLabel)
                        FluentUIDemoToggle(titleKey: "Disable", isOn: $isDisabled)
                    }

                    Group {
                        DemoHeading(title: "Style")

                        Picker(selection: $style, label: EmptyView()) {
                            Text(".primary").tag(MSFButtonStyle.primary)
                            Text(".secondary").tag(MSFButtonStyle.secondary)
                            Text(".ghost").tag(MSFButtonStyle.ghost)
                            Text(".accentFloating").tag(MSFButtonStyle.accentFloating)
                            Text(".subtleFloating").tag(MSFButtonStyle.subtleFloating)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Group {
                        DemoHeading(title: "Size")

                        Picker(selection: $size, label: EmptyView()) {
                            Text(".large").tag(MSFButtonSize.large)
                            Text(".medium").tag(MSFButtonSize.medium)
                            Text(".small").tag(MSFButtonSize.small)
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
