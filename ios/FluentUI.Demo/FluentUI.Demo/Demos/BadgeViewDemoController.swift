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

        addBadgeSection(title: "Default badge", style: Style.default)
        addBadgeSection(title: "Danger badge", style: Style.danger)
        addBadgeSection(title: "Warning badge", style: Style.warning)
        addBadgeSection(title: "Neutral badge", style: Style.neutral)
        addBadgeSection(title: "Severe Warning badge", style: Style.severeWarning)
        addBadgeSection(title: "Success badge", style: Style.success)
        addBadgeSection(title: "Disabled badge Default", style: Style.default, isEnabled: false)
        addBadgeSection(title: "Disabled badge Neutral", style: Style.neutral, isEnabled: false)
        addBadgeSection(title: "Custom badge", style: Style.default, overrideColor: true)
        addBadgeSection(title: "Custom disabled badge", style: Style.default, isEnabled: false, overrideColor: true)

        addCustomBadgeSections()
    }

    func createBadge(
        text: String,
        style: Style,
        size: Size,
        isEnabled: Bool,
        customView: UIView? = nil,
        customViewVerticalPadding: NSNumber? = nil,
        customViewLeftPadding: NSNumber? = nil,
        customViewRightPadding: NSNumber? = nil
    ) -> BadgeView {
        let dataSource = BadgeViewDataSource(
            text: text,
            style: style,
            size: size,
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

    func addBadgeSection(title: String, style: Style, isEnabled: Bool = true, overrideColor: Bool = false) {
        addTitle(text: title)
        for size in Size.allCases.reversed() {
            let badge = createBadge(text: "Kat Larsson", style: style, size: size, isEnabled: isEnabled)
            if overrideColor {
                if isEnabled {
                    var customTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
                        return [
                            .backgroundTintColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .primary))
                            },
                            .backgroundFilledColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.sharedColors(.darkTeal, .tint20))
                            },
                            .foregroundTintColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.neutralColors(.grey94))
                            },
                            .foregroundFilledColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.neutralColors(.grey88))
                            }
                        ]
                    }
                    badge.tokenSet.replaceAllOverrides(with: customTokens)
                } else {
                    var customTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
                        return [
                            .backgroundDisabledColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.neutralColors(.grey88))
                            },
                            .foregroundDisabledColor: .dynamicColor {
                                return DynamicColor(light: GlobalTokens.neutralColors(.grey26))
                            }
                        ]
                    }
                    badge.tokenSet.replaceAllOverrides(with: customTokens)
                }
            }
            addRow(text: size.description, items: [badge])
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

        let dataSource: [(Size, UIView)] = [
            (.medium, imageView),
            (.small, avatar)
        ]

        for (size, customView) in dataSource {
            let badge = createBadge(
                text: "Kat Larsson",
                style: .default,
                size: size,
                isEnabled: false,
                customView: customView,
                customViewVerticalPadding: 3
            )
            var customTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
                return [
                    .backgroundDisabledColor: .dynamicColor {
                        return DynamicColor(light: GlobalTokens.sharedColors(.purple, .primary))
                    },
                    .foregroundDisabledColor: .dynamicColor {
                        return DynamicColor(light: GlobalTokens.neutralColors(.white))
                    }
                ]
            }
            badge.tokenSet.replaceAllOverrides(with: customTokens)
            addRow(text: size.description, items: [badge])
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

extension Size {
    var description: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        }
    }
}
