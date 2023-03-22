//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TwoLineTitleViewDemoController: DemoController {
    private let displayedNavigationItem = UINavigationItem()
    private let twoLineTitleView = TwoLineTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "TwoLineTitleView is intended to be used in a navigation bar or the title of a sheet. It features the ability to show custom icons, a disclosure chevron, and other things."

        container.alignment = .leading

        twoLineTitleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        twoLineTitleView.layer.borderWidth = 1

        displayedNavigationItem.title = "Title"
        displayedNavigationItem.titleImage = UIImage(systemName: "f.circle")
        displayedNavigationItem.subtitle = "Subtitle"
        displayedNavigationItem.usesLargeTitle = false

        twoLineTitleView.setup(navigationItem: displayedNavigationItem)
        addRow(items: [twoLineTitleView])
    }
}

extension TwoLineTitleViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TwoLineTitleViewTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        twoLineTitleView.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TwoLineTitleViewTokenSet.self) != nil
    }

    private var themeWideOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.orange, .primary) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.red, .primary) }
        ]
    }

    private var perControlOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.blue, .primary) },
            .titleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 12), size: 12) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.green, .primary) },
            .subtitleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 10), size: 10) }
        ]
    }
}
