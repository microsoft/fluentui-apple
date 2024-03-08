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
        self.title = "Button (SwiftUI)"
    }
}

struct ButtonDemoView: View {
    @State var isDisabled: Bool = false
    @State var text: String = "Button"
    @State var showImage: Bool = true
    @State var showLabel: Bool = true
    @State var showAlert: Bool = false
    @State var size: FluentUI.ButtonSizeCategory = .large
    @State var style: FluentUI.ButtonStyle = .accent

    public var body: some View {
        VStack {
            Button(action: {
                showAlert = true
                // TODO: add a real theme switcher to the demo controller
//                DemoColorTheme.currentAppWideTheme = .purple
            }, label: {
                HStack {
                    if showImage {
                        Image("Placeholder_24")
                    }
                    if showLabel {
                        Text(text)
                    }
                }
            })
            .buttonStyle(FluentButtonStyle(style: style, size: size))
            .disabled(isDisabled)
            .fixedSize()
            .padding()
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Button tapped"))
            })

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        TextField("Text", text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        FluentUIDemoToggle(titleKey: "Show image", isOn: $showImage)
                        FluentUIDemoToggle(titleKey: "Show label", isOn: $showLabel)
                        FluentUIDemoToggle(titleKey: "Disable", isOn: $isDisabled)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Style")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $style, label: EmptyView()) {
                            Text("accent").tag(FluentUI.ButtonStyle.accent)
                            Text("outlineAccent").tag(FluentUI.ButtonStyle.outlineAccent)
                            Text("outlineNeutral").tag(FluentUI.ButtonStyle.outlineNeutral)
                            Text("subtle").tag(FluentUI.ButtonStyle.subtle)
                            Text("transparentNeutral").tag(FluentUI.ButtonStyle.transparentNeutral)
                            Text("danger").tag(FluentUI.ButtonStyle.danger)
                            Text("dangerOutline").tag(FluentUI.ButtonStyle.dangerOutline)
                            Text("dangerSubtle").tag(FluentUI.ButtonStyle.dangerSubtle)
                            Text("floatingAccent").tag(FluentUI.ButtonStyle.floatingAccent)
                            Text("floatingSubtle").tag(FluentUI.ButtonStyle.floatingSubtle)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Size")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $size, label: EmptyView()) {
                            Text(".large").tag(FluentUI.ButtonSizeCategory.large)
                            Text(".medium").tag(FluentUI.ButtonSizeCategory.medium)
                            Text(".small").tag(FluentUI.ButtonSizeCategory.small)
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
