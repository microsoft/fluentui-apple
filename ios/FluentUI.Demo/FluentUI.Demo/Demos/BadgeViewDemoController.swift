//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BadgeViewDemoController: DemoController {
    private var badges = [BadgeView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        readmeString = "A badge is a compact, interactive, \ntextual representation of a person. It is generally a representation of user-input text that maps to an entry in a database."

        addBadgeSection(title: "Default badge", style: .default)
        addBadgeSection(title: "Danger badge", style: .danger)
        addBadgeSection(title: "Warning badge", style: .warning)
        addBadgeSection(title: "Neutral badge", style: .neutral)
        addBadgeSection(title: "Severe Warning badge", style: .severeWarning)
        addBadgeSection(title: "Success badge", style: .success)
        addBadgeSection(title: "Disabled badge Default", style: .default, isEnabled: false)
        addBadgeSection(title: "Disabled badge Neutral", style: .neutral, isEnabled: false)
        addBadgeSection(title: "Custom badge", style: .default, overrideColor: true)
        addBadgeSection(title: "Custom disabled badge", style: .default, isEnabled: false, overrideColor: true)

        addCustomBadgeSections()
    }

    func createBadge(
        text: String,
        style: BadgeView.Style,
        sizeCategory: BadgeView.SizeCategory,
        isEnabled: Bool,
        customView: UIView? = nil,
        customViewVerticalPadding: NSNumber? = nil,
        customViewLeftPadding: NSNumber? = nil,
        customViewRightPadding: NSNumber? = nil
    ) -> BadgeView {
        let dataSource = BadgeViewDataSource(
            text: text,
            style: style,
            sizeCategory: sizeCategory,
            customView: customView,
            customViewVerticalPadding: customViewVerticalPadding,
            customViewPaddingLeft: customViewLeftPadding,
            customViewPaddingRight: customViewRightPadding
        )

        let badge = BadgeView(dataSource: dataSource)
        badge.delegate = self
        badge.isActive = isEnabled
        badges.append(badge)
        return badge
    }

    func addBadgeSection(title: String, style: BadgeView.Style, isEnabled: Bool = true, overrideColor: Bool = false) {
        addTitle(text: title)
        for sizeCategory in BadgeView.SizeCategory.allCases.reversed() {
            let badge = createBadge(text: "Kat Larsson", style: style, sizeCategory: sizeCategory, isEnabled: isEnabled)
            if overrideColor {
                if isEnabled {
                    badge.tokenSet[.backgroundTintColor] = .dynamicColor {
                        .init(light: GlobalTokens.sharedColors(.purple, .primary))
                    }
                    badge.tokenSet[.backgroundFilledColor] = .dynamicColor {
                        .init(light: GlobalTokens.sharedColors(.darkTeal, .tint20))
                    }
                    badge.tokenSet[.foregroundTintColor] = .dynamicColor {
                        .init(light: GlobalTokens.neutralColors(.grey94))
                    }
                    badge.tokenSet[.foregroundFilledColor] = .dynamicColor {
                        .init(light: GlobalTokens.neutralColors(.grey88))
                    }
                } else {
                    badge.tokenSet[.backgroundDisabledColor] = .dynamicColor {
                        .init(light: GlobalTokens.neutralColors(.grey88))
                    }
                    badge.tokenSet[.foregroundDisabledColor] = .dynamicColor {
                        .init(light: GlobalTokens.neutralColors(.grey26))
                    }
                }
            }
            addRow(text: sizeCategory.description, items: [badge])
        }
        container.addArrangedSubview(UIView())
    }

    func addCustomBadgeSections() {
        addTitle(text: "Badge with custom view")

        let imageView = UIImageView(image: UIImage(named: "ic_fluent_add_20_regular")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.frame.size = CGSize(width: 20, height: 20)

        let avatar = MSFAvatar(style: .default, size: .size16)
        avatar.state.image = UIImage(named: "avatar_kat_larsson")

        let dataSource: [(BadgeView.SizeCategory, UIView)] = [
            (.medium, imageView),
            (.small, avatar)
        ]

        for (sizeCategory, customView) in dataSource {
            let badge = createBadge(
                text: "Kat Larsson",
                style: .default,
                sizeCategory: sizeCategory,
                isEnabled: false,
                customView: customView,
                customViewVerticalPadding: 3
            )
            badge.tokenSet[.backgroundDisabledColor] = .dynamicColor {
                .init(light: GlobalTokens.sharedColors(.purple, .primary))
            }
            badge.tokenSet[.foregroundDisabledColor] = .dynamicColor {
                .init(light: GlobalTokens.neutralColors(.white))
            }
            addRow(text: sizeCategory.description, items: [badge])
        }
        container.addArrangedSubview(UIView())
    }
}

extension BadgeViewDemoController: BadgeViewDelegate {
    func didSelectBadge(_ badge: BadgeView) { }

    func didTapSelectedBadge(_ badge: BadgeView) {
        badge.isSelected = false
        let alert = UIAlertController(title: "A selected badge was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension BadgeViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: BadgeViewTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideBadgeViewTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for badge in badges {
            badge.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideBadgeViewTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: BadgeViewTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideBadgeViewTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundTintColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.plum, .tint40),
                                    dark: GlobalTokens.sharedColors(.plum, .shade30))
            },
            .backgroundFilledColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.berry, .shade30),
                                    dark: GlobalTokens.sharedColors(.berry, .tint40))
            },
            .foregroundTintColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                    dark: GlobalTokens.neutralColors(.grey98))
            },
            .foregroundFilledColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                    dark: GlobalTokens.neutralColors(.black))
            }
        ]
    }

    private var perControlOverrideBadgeViewTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundTintColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.forest, .tint40),
                                    dark: GlobalTokens.sharedColors(.forest, .shade30))
            },
            .backgroundFilledColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.seafoam, .shade30),
                                    dark: GlobalTokens.sharedColors(.seafoam, .tint40))
            },
            .foregroundTintColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.neutralColors(.black),
                                    dark: GlobalTokens.neutralColors(.white))
            },
            .foregroundFilledColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens.neutralColors(.white),
                                    dark: GlobalTokens.neutralColors(.black))
            }
        ]
    }
}

extension BadgeView.SizeCategory {
    var description: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        }
    }
}
