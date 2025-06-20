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
                demoPillButton(style: .onBrand, viewModel: viewModels[0])
                demoPillButton(style: .primary, viewModel: viewModels[1])
                demoPillButton(style: .onBrand, viewModel: viewModels[2], hasLeadingImage: true)
                demoPillButton(style: .primary, viewModel: viewModels[3], hasLeadingImage: true)
                demoPillButton(style: .onBrand, viewModel: viewModels[4], hasLeadingImage: true, isDisabled: true)
                demoPillButton(style: .primary, viewModel: viewModels[5], hasLeadingImage: true, isDisabled: true)
            }
            .fluentTheme(theme)

            FluentList {
                Toggle("Custom theme", isOn: $useCustomTheme)
                Toggle("Toggle unread dots", isOn: $isUnread)
                Toggle("Toggle leading images", isOn: $hasLeadingImage)
            }
            .fluentListStyle(.insetGrouped)
        }
        .background(FluentTheme.shared.swiftUIColor(.background1))
        .onChange_iOS17(of: isUnread) { _ in
            for viewModel in viewModels {
                viewModel.isUnread = isUnread
            }
        }
        .onChange_iOS17(of: hasLeadingImage) { value in
            for viewModel in viewModels {
                viewModel.leadingImage = value ? leadingImage : nil
            }
        }
    }

    @ViewBuilder
    private func demoPillButton(style: PillButtonStyle,
                                viewModel: PillButtonViewModel,
                                hasLeadingImage: Bool = false,
                                isDisabled: Bool = false) -> some View {
        PillButtonView(style: style,
                       viewModel: viewModel) {
                           showAlert = true
                       }
                       .disabled(isDisabled)
                       .alert(isPresented: $showAlert, content: {
                           Alert(title: Text("Pill button tapped"))
                       })
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @State private var showAlert = false
    @State var useCustomTheme: Bool = false
    @State var isUnread: Bool = false
    @State var hasLeadingImage: Bool = false

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

    private let viewModels: [PillButtonViewModel] = [
        PillButtonViewModel(title: "onBrand", isUnread: false),
        PillButtonViewModel(title: "Primary", isUnread: false),
        PillButtonViewModel(title: "onBrand", isUnread: false),
        PillButtonViewModel(title: "Primary", isUnread: false),
        PillButtonViewModel(title: "onBrand disabled", isUnread: false),
        PillButtonViewModel(title: "Primary disabled", isUnread: false)
    ]
}
