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
            demoButton
            demoOptions
        }
    }

    @ViewBuilder
    private var demoButton: some View {
        Button(action: {
            showAlert = true
            // TODO: add a real theme switcher to the demo controller
//            DemoColorTheme.currentAppWideTheme = .purple
        }, label: {
            HStack {
                if showImage {
                    Image("Placeholder_24")
                }
                if showLabel && text.count > 0 {
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
    }

    @ViewBuilder
    private var demoOptions: some View {
        Form {
            Section("Content") {
                HStack(alignment: .firstTextBaseline) {
                    Text("Button Text")
                    Spacer()
                    TextField("Text", text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity)

                FluentUIDemoToggle(titleKey: "Show image", isOn: $showImage)
                FluentUIDemoToggle(titleKey: "Show label", isOn: $showLabel)
                FluentUIDemoToggle(titleKey: "Disabled", isOn: $isDisabled)
            }

            Section("Style") {
                Picker("Style", selection: $style) {
                    ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                        Text("\(buttonStyle.description)").tag(buttonStyle.rawValue)
                    }
                }
            }

            Section("Size") {
                Picker("Size", selection: $size) {
                    ForEach(Array(FluentUI.ButtonSizeCategory.allCases.enumerated()), id: \.element) { _, buttonSize in
                        Text("\(buttonSize.description)").tag(buttonSize.rawValue)
                    }
                }
            }
        }
    }
}
