//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class PillButtonDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(PillButtonDemoView()), title: "Pill Button (SwiftUI)")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

private struct PillButtonDemoView: View {
    fileprivate var body: some View {
        let theme = useCustomTheme ? customTheme : fluentTheme

        return VStack(spacing: 30) {
            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {
                demoPillButton(style: .onBrand, title: "onBrand")
                demoPillButton(style: .primary, title: "Primary")
                demoPillButton(style: .onBrand, title: "onBrand disabled", isDisabled: true)
                demoPillButton(style: .primary, title: "Primary disabled", isDisabled: true)
            }
            .fluentTheme(theme)

            FluentList {
                Toggle("Toggle Custom theme", isOn: $useCustomTheme)
                Toggle("Toggle unread dots", isOn: $isUnread)
                Toggle("Toggle leading images", isOn: $hasLeadingImage)
                Toggle("Toggle token overrides", isOn: $showTokenOverrides)
            }
            .fluentListStyle(.insetGrouped)
        }
        .background(FluentTheme.shared.swiftUIColor(.background1))
    }

    @ViewBuilder
    private func demoPillButton(style: PillButtonStyle,
                                title: String,
                                isDisabled: Bool = false) -> some View {
        Button(action: {
            showAlert = true
        }, label: {
            Text(title)
        })
        .buttonStyle(pillButtonStyle(style: style))
        .disabled(isDisabled)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Pill button tapped"))
        })
    }

    private func pillButtonStyle(style: PillButtonStyle) -> FluentPillButtonStyle {
        var pillButtonStyle = FluentPillButtonStyle(style: style,
                                                    isSelected: false,
                                                    isUnread: isUnread,
                                                    leadingImage: hasLeadingImage ? leadingImage : nil)

        if showTokenOverrides {
            pillButtonStyle.overrideTokens(tokenOverrides)
        }

        return pillButtonStyle
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @State var showAlert = false
    @State var useCustomTheme: Bool = false
    @State var isUnread: Bool = false
    @State var hasLeadingImage: Bool = false
    @State var showTokenOverrides: Bool = false

    private let leadingImage = Image(systemName: "circle.fill")

    private let customTheme: FluentTheme = {
        let colorOverrides = [
            FluentTheme.ColorToken.brandBackground2: GlobalTokens.sharedSwiftUIColor(.lavender, .shade20),
            FluentTheme.ColorToken.background5: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
            FluentTheme.ColorToken.foreground2: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.foreground3: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.brandForeground1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.foregroundOnColor: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.foregroundDisabled1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.brandForegroundDisabled1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
        ]
        return FluentTheme(colorOverrides: colorOverrides)
    }()

    private let tokenOverrides: [PillButtonToken: ControlTokenValue] = [
        .backgroundColor: .uiColor { GlobalTokens.sharedColor(.lime, .shade10) },
        .backgroundColorDisabled: .uiColor { GlobalTokens.sharedColor(.hotPink, .primary) }
    ]
}
