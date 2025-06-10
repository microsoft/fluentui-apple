//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class PillButtonDemoControllerSwiftUI: UIHostingController<PillButtonDemoView> {
    init() {
        super.init(rootView: PillButtonDemoView())
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct PillButtonDemoView: View {
    @State var useCustomTheme: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared

    public var body: some View {
        let theme = useCustomTheme ? customTheme : fluentTheme

        return VStack(spacing: 30) {
            VStack(spacing: 10) {
                PillButtonView(style: .onBrand, title: "onBrand", isUnread: true, action: nil)
                PillButtonView(style: .primary, title: "Primary", isUnread: true, action: nil)
                PillButtonView(style: .onBrand, title: "Leading image onBrand", leadingImage: Image("ic_fluent_star_16_regular"), isUnread: true, action: nil)
                PillButtonView(style: .primary, title: "Leading image primary", leadingImage: Image("ic_fluent_star_16_regular"), isDisabled: true, isUnread: true, action: nil)
            }
            .fluentTheme(theme)

            FluentList {
                Toggle("Custom theme", isOn: $useCustomTheme)
            }
            .fluentListStyle(.insetGrouped)
        }
        .background(FluentTheme.shared.swiftUIColor(.background1Selected))
    }

    let customTheme: FluentTheme = {
        let colorOverrides = [
            FluentTheme.ColorToken.brandBackground2: GlobalTokens.sharedSwiftUIColor(.lavender, .shade20),
            FluentTheme.ColorToken.background5: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
            FluentTheme.ColorToken.foreground2: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.brandForeground1: GlobalTokens.sharedSwiftUIColor(.hotPink, .shade10),
            FluentTheme.ColorToken.foregroundOnColor: GlobalTokens.sharedSwiftUIColor(.hotPink, .shade10),
        ]
        return FluentTheme(colorOverrides: colorOverrides)
    }()
}
