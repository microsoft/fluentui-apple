//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

//class PillButtonDemoControllerSwiftUI: UIHostingController<PillButtonDemoView> {
//    init() {
//        super.init(rootView: PillButtonDemoView())
//    }
//
//    @objc required dynamic init?(coder aDecoder: NSCoder) {
//        preconditionFailure("init(coder:) has not been implemented")
//    }
//
//    @MainActor required dynamic init(rootView: AnyView) {
//        preconditionFailure("init(rootView:) has not been implemented")
//    }
//
//    override func willMove(toParent parent: UIViewController?) {
//        guard let parent,
//              let window = parent.view.window else {
//            return
//        }
//
//        rootView.fluentTheme = window.fluentTheme
//    }
//}

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

struct PillButtonDemoView: View {
    public var body: some View {
        let theme = useCustomTheme ? customTheme : fluentTheme

        return VStack(spacing: 30) {
            VStack(spacing: 20) {
                PillButtonView(style: .onBrand,
                               model: models[0],
                               action: nil)
                PillButtonView(style: .primary,
                               model: models[1],
                               action: nil)
                PillButtonView(style: .onBrand,
                               model: models[2],
                               leadingImage: leadingImage,
                               action: nil)
                PillButtonView(style: .primary,
                               model: models[3],
                               leadingImage: leadingImage,
                               action: nil)
                PillButtonView(style: .onBrand,
                               model: models[4],
                               leadingImage: leadingImage,
                               action: nil)
                    .disabled(true)
                PillButtonView(style: .primary,
                               model: models[5],
                               leadingImage: leadingImage,
                               action: nil)
                    .disabled(true)
            }
            .fluentTheme(theme)

            FluentList {
                Toggle("Custom theme", isOn: $useCustomTheme)
                Toggle("Toggle unread dots", isOn: $isUnread)
            }
            .fluentListStyle(.insetGrouped)
        }
        .background(FluentTheme.shared.swiftUIColor(.background1))
        .onChange_iOS17(of: isUnread) { _ in
            for model in models {
                model.isUnread = isUnread
            }
        }
    }

    @State var useCustomTheme: Bool = false
    @State var isUnread: Bool = false
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    private let leadingImage = Image(systemName: "circle.fill")

    private let customTheme: FluentTheme = {
        let colorOverrides = [
            FluentTheme.ColorToken.brandBackground2: GlobalTokens.sharedSwiftUIColor(.lavender, .shade20),
            FluentTheme.ColorToken.background5: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
            FluentTheme.ColorToken.foreground2: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.brandForeground1: GlobalTokens.sharedSwiftUIColor(.hotPink, .shade10),
            FluentTheme.ColorToken.foregroundOnColor: GlobalTokens.sharedSwiftUIColor(.hotPink, .shade10),
        ]
        return FluentTheme(colorOverrides: colorOverrides)
    }()

    private let models: [PillButtonViewModel] = [
        PillButtonViewModel(isUnread: false, title: "onBrand"),
        PillButtonViewModel(isUnread: false, title: "Primary"),
        PillButtonViewModel(isUnread: false, title: "Leading image onBrand"),
        PillButtonViewModel(isUnread: false, title: "Leading image primary"),
        PillButtonViewModel(isUnread: false, title: "Leading image onBrand disabled"),
        PillButtonViewModel(isUnread: false, title: "Leading image primary disabled")
    ]
}
