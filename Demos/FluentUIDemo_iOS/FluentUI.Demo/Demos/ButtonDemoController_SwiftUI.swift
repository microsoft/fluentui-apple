//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(ButtonDemoView()), title: "Button (SwiftUI)")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

struct ButtonDemoView: View {
    public var body: some View {
        VStack {
            if showToggle {
                demoToggle(size, isDisabled: isDisabled)
            } else {
                demoButton(style, size, isDisabled: isDisabled)
            }
            demoOptions
        }
    }

    @State var isDisabled: Bool = false
    @State var text: String = "Button"
    @State var showImage: Bool = true
    @State var showLabel: Bool = true
    @State var showAlert: Bool = false
    @State var size: ControlSize = .large
    @State var style: FluentUI.ButtonStyle = .accent
    @State var showToggle: Bool = false
    @State var showThemeOverrides: Bool = false

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    @State var isToggleOn: Bool = false

    @ViewBuilder
    private var buttonLabel: some View {
        HStack {
            if showImage {
                Image("Placeholder_24")
            }
            if showLabel && text.count > 0 {
                Text(text)
            }
        }
    }

    @ViewBuilder
    private func demoButton(_ buttonStyle: FluentUI.ButtonStyle, _ controlSize: ControlSize, isDisabled: Bool) -> some View {
        Button(action: {
            showAlert = true
        }, label: {
            buttonLabel
        })
        .buttonStyle(fluentButtonStyle(style: buttonStyle))
        .controlSize(controlSize)
        .disabled(isDisabled)
        .fixedSize()
        .padding(GlobalTokens.spacing(.size80))
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Button tapped"))
        })
    }

    @ViewBuilder
    private func demoToggle(_ controlSize: ControlSize, isDisabled: Bool) -> some View {
        Toggle(isOn: $isToggleOn, label: {
            buttonLabel
        })
        .toggleStyle(fluentButtonToggleStyle())
        .controlSize(controlSize)
        .disabled(isDisabled)
        .fixedSize()
        .padding(GlobalTokens.spacing(.size80))
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

            Section("Style and Size") {
                FluentUIDemoToggle(titleKey: "Present as toggle", isOn: $showToggle)
                if !showToggle {
                    Picker("Style", selection: $style) {
                        ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                            Text("\(buttonStyle.description)").tag(buttonStyle.rawValue)
                        }
                    }
                }

                Picker("Control Size", selection: $size) {
                    ForEach(Array(SwiftUI.ControlSize.allCases.enumerated()), id: \.element) { _, buttonSize in
                        Text("\(buttonSize.description)").tag(buttonSize)
                    }
                }

                FluentUIDemoToggle(titleKey: "Show theme overrides", isOn: $showThemeOverrides)
            }

            Section("More") {
                NavigationLink("All Button Styles") {
                    allButtonStyles
                }
            }
        }
    }

    @ViewBuilder
    private var allButtonStyles: some View {
        ScrollView {
            ForEach(Array(FluentUI.ButtonStyle.allCases.enumerated()), id: \.element) { _, buttonStyle in
                Text("\(buttonStyle.description)")
                    .font(Font(fluentTheme.typography(.title2)))
                ForEach(Array([ControlSize.small, ControlSize.regular, ControlSize.large].enumerated()), id: \.element) { _, controlSize in
                    HStack {
                        demoButton(buttonStyle, controlSize, isDisabled: false)
                        demoButton(buttonStyle, controlSize, isDisabled: true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func fluentButtonStyle(style: FluentUI.ButtonStyle) -> FluentButtonStyle {
        var buttonStyle = FluentButtonStyle(style: style)
        if showThemeOverrides {
            buttonStyle.overrideTokens(tokenOverrides)
        }
        return buttonStyle
    }

    private func fluentButtonToggleStyle() -> FluentButtonToggleStyle {
        var buttonToggleStyle = FluentButtonToggleStyle()
        if showThemeOverrides {
            buttonToggleStyle.overrideTokens(tokenOverrides)
        }
        return buttonToggleStyle
    }

    private var tokenOverrides: [ButtonToken: ControlTokenValue] = [
        .backgroundPressedColor: .uiColor { .red }
    ]
}

private extension ControlSize {
    var description: String {
        switch self {
        case .mini:
            return "mini"
        case .small:
            return "small"
        case .regular:
            return "regular"
        case .large:
            return "large"
        case .extraLarge:
            return "extraLarge"
        @unknown default:
            return "UNKNOWN"
        }
    }
}
