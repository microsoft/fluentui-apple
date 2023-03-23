//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TwoLineTitleViewDemoController: DemoController {
    private static func createDemoTitleView() -> TwoLineTitleView {
        let twoLineTitleView = TwoLineTitleView()

        // Give it a visible margin so we can confirm it centers properly
        twoLineTitleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        twoLineTitleView.layer.borderWidth = GlobalTokens.stroke(.width10)
        twoLineTitleView.layer.borderColor = GlobalTokens.neutralColor(.grey50).cgColor

        return twoLineTitleView
    }

    private static func makeNavigationTitleView(_ navigationItemModifier: (UINavigationItem) -> Void) -> TwoLineTitleView {
        let twoLineTitleView = createDemoTitleView()

        let aNavigationItem = UINavigationItem()
        navigationItemModifier(aNavigationItem)

        twoLineTitleView.setup(navigationItem: aNavigationItem)

        return twoLineTitleView
    }

    private static func makeStandardTitleView(title: String,
                                              titleImage: UIImage? = nil,
                                              subtitle: String? = nil,
                                              alignment: TwoLineTitleView.Alignment = .center,
                                              interactivePart: TwoLineTitleView.InteractivePart = .none,
                                              animatesWhenPressed: Bool = true,
                                              accessoryType: TwoLineTitleView.AccessoryType = .none) -> TwoLineTitleView {
        let twoLineTitleView = createDemoTitleView()
        twoLineTitleView.setup(title: title,
                               titleImage: titleImage,
                               subtitle: subtitle,
                               alignment: alignment,
                               interactivePart: interactivePart,
                               animatesWhenPressed: animatesWhenPressed,
                               accessoryType: accessoryType)
        return twoLineTitleView
    }

    private let setupExamples: [TwoLineTitleView] = [
        makeStandardTitleView(title: "Title here", subtitle: "Optional subtitle", animatesWhenPressed: false),
        makeStandardTitleView(title: "Custom image", titleImage: UIImage(named: "ic_fluent_star_16_regular"), animatesWhenPressed: false),
        makeStandardTitleView(title: "This one", subtitle: "can be tapped", interactivePart: .all),
        makeStandardTitleView(title: "All the bells", titleImage: UIImage(named: "ic_fluent_star_16_regular"), subtitle: "and whistles", alignment: .leading, interactivePart: .subtitle, accessoryType: .disclosure)
    ]

    private let navigationExamples: [TwoLineTitleView] = [
        makeNavigationTitleView {
            $0.title = "Title here"
        },
        makeNavigationTitleView {
            $0.title = "Another title"
            $0.subtitle = "With a subtitle"
        },
        makeNavigationTitleView {
            $0.title = "This one"
            $0.subtitle = "has an image"
            $0.titleImage = UIImage(named: "ic_fluent_star_16_regular")
        },
        makeNavigationTitleView {
            $0.title = "This one"
            $0.subtitle = "has a disclosure chevron"
            $0.titleAccessory = .init(location: .title, style: .disclosure)
        },
        makeNavigationTitleView {
            $0.title = "They can also be"
            $0.subtitle = "leading-aligned"
            $0.usesLargeTitle = true
        }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "TwoLineTitleView is intended to be used in a navigation bar or the title of a sheet. It features the ability to show custom icons, a disclosure chevron, and other things."

        container.alignment = .leading

        addTitle(text: "Made by calling TwoLineTitleView.setup")
        setupExamples.forEach {
            addRow(items: [$0])
        }

        addTitle(text: "Made from UINavigationItem")
        navigationExamples.forEach {
            addRow(items: [$0])
        }
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
        (setupExamples + navigationExamples).forEach {
            $0.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TwoLineTitleViewTokenSet.self) != nil
    }

    private var themeWideOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.green, .primary) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.red, .primary) }
        ]
    }

    private var perControlOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor { GlobalTokens.sharedColor(.blue, .primary) },
            .titleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 12), size: 12) },
            .subtitleColor: .uiColor { GlobalTokens.sharedColor(.orange, .primary) },
            .subtitleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 10), size: 10) }
        ]
    }
}
