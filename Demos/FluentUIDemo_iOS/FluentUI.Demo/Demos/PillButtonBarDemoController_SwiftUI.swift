//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class PillButtonBarDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(PillButtonBarDemoView()), title: "Pill Button Bar (SwiftUI)")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

private struct PillButtonBarDemoView: View {
    fileprivate var body: some View {
        let theme = useCustomTheme ? customTheme : fluentTheme

        return VStack(spacing: 30) {
            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {
                PillButtonBarView(style: .primary, datas: pillButtonBarSmallDatas, selected: $selectedTitle, shouldCenterAlign: true)
                PillButtonBarView(style: .primary, datas: pillButtonBarLargeDatas, selected: $selectedIndex)
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

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @State var showAlert = false
    @State var useCustomTheme: Bool = false
    @State var isUnread: Bool = false
    @State var hasLeadingImage: Bool = false
    @State var showTokenOverrides: Bool = false
    @State var selectedIndex: Int = 3
    @State var selectedTitle: String = ""

    private let leadingImage = Image(systemName: "circle.fill")

    private let pillButtonBarLargeDatas = [PillButtonViewModel(title: "Recommended", selectionValue: 0),
                                           PillButtonViewModel(title: "Some shit", selectionValue: 1, isUnread: true),
                                           PillButtonViewModel(title: "Some other shit", selectionValue: 2),
                                           PillButtonViewModel(title: "Invoices", selectionValue: 3, isUnread: true),
                                           PillButtonViewModel(title: "Mariama", selectionValue: 4),
                                           PillButtonViewModel(title: "Some other shit", selectionValue: 5, isUnread: true),
                                           PillButtonViewModel(title: "Invoices", selectionValue: 6),
                                           PillButtonViewModel(title: "Mariama", selectionValue: 7)]

    private let pillButtonBarSmallDatas = [PillButtonViewModel(title: "Recommended", selectionValue: "Recommended"),
                                           PillButtonViewModel(title: "Some shit", selectionValue: "Some shit", isUnread: true)]

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
