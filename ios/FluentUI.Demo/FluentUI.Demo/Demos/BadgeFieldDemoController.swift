//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BadgeFieldDemoController: DemoController {
    private var badgeFields = [BadgeField]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let badgeDataSources1 = [
            BadgeViewDataSource(text: "Kat Larsson", style: .default),
            BadgeViewDataSource(text: "Allan Munger", style: .default),
            BadgeViewDataSource(text: "Mona Kane", style: .default),
            BadgeViewDataSource(text: "Mauricio August", style: .default),
            BadgeViewDataSource(text: "Kevin Sturgis", style: .default),
            BadgeViewDataSource(text: "Tim Debeor", style: .default),
            BadgeViewDataSource(text: "Daisy Phillips", style: .default)
        ]
        let badgeDataSources2 = [
            BadgeViewDataSource(text: "Lydia Bauer", style: .default),
            BadgeViewDataSource(text: "Kristin Patterson", style: .default),
            BadgeViewDataSource(text: "Ashley McCarthy", style: .default),
            BadgeViewDataSource(text: "Carole Poland", style: .default),
            BadgeViewDataSource(text: "Amanda Brady", style: .default)
        ]

        let badgeField1 = setupBadgeField(label: "Send to:", dataSources: badgeDataSources1)
        badgeField1.numberOfLines = 1
        badgeFields.append(badgeField1)
        let badgeField2 = setupBadgeField(label: "Cc:", dataSources: badgeDataSources2)
        badgeFields.append(badgeField2)

        addDescription(text: "Badge field with limited number of lines")
        container.addArrangedSubview(badgeField1)
        container.addArrangedSubview(Separator())
        container.addArrangedSubview(UIView())
        addDescription(text: "Badge field with unlimited number of lines")
        container.addArrangedSubview(badgeField2)
        container.addArrangedSubview(Separator())
    }

    private func setupBadgeField(label: String, dataSources: [BadgeViewDataSource]) -> BadgeField {
        let badgeField = BadgeField()
        badgeField.translatesAutoresizingMaskIntoConstraints = false
        badgeField.hardBadgingCharacters = ",;"
        badgeField.label = label
        badgeField.badgeFieldDelegate = self
        badgeField.addBadges(withDataSources: dataSources)
        badgeField.isActive = true
        return badgeField
    }
}

extension BadgeFieldDemoController: BadgeFieldDelegate {
    func badgeField(_ badgeField: BadgeField, badgeDataSourceForText text: String) -> BadgeViewDataSource {
        return BadgeViewDataSource(text: text, style: .default)
    }

    func badgeField(_ badgeField: BadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: BadgeViewDataSource) -> Bool {
        return !badgeField.badgeDataSources.contains(where: { $0.text == badgeDataSource.text })
    }

    func badgeField(_ badgeField: BadgeField, didTapSelectedBadge badge: BadgeView) {
        badge.isSelected = false
        showMessage("\(badge.dataSource?.text ?? "A selected badge") was tapped")
    }
}

extension BadgeFieldDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: BadgeFieldTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideBadgeFieldTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for badgeField in badgeFields {
            badgeField.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideBadgeFieldTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: BadgeFieldTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideBadgeFieldTokens: [BadgeFieldTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.lavender, .tint40),
                               dark: GlobalTokens.sharedColor(.lavender, .shade30))
            },
            .labelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 18.0), size: 18.0)
            },
            .placeholderFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 18.0), size: 18.0)
            },
            .textFieldFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 18.0), size: 18.0)
            }
        ]
    }

    private var perControlOverrideBadgeFieldTokens: [BadgeFieldTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orange, .tint40),
                               dark: GlobalTokens.sharedColor(.orange, .shade30))
            },
            .labelColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.navy, .tint40),
                               dark: GlobalTokens.sharedColor(.navy, .shade30))
            },
            .placeholderColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.navy, .tint40),
                               dark: GlobalTokens.sharedColor(.navy, .shade30))
            },
            .textFieldColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.navy, .tint40),
                               dark: GlobalTokens.sharedColor(.navy, .shade30))
            },
            .labelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 18.0), size: 18.0)
            },
            .placeholderFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 18.0), size: 18.0)
            },
            .textFieldFont: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 18.0), size: 18.0)
            }
        ]
    }
}
