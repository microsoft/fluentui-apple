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
        addBadgeSection(title: "Severe badge", style: .severe)
        addBadgeSection(title: "Success badge", style: .success)
        addBadgeSection(title: "Disabled badge Default", style: .default, isEnabled: false)
        addBadgeSection(title: "Disabled badge Neutral", style: .neutral, isEnabled: false)
        addBadgeSection(title: "Custom badge", style: .default, overrideColor: true)
        addBadgeSection(title: "Custom disabled badge", style: .default, isEnabled: false, overrideColor: true)

        addCustomBadgeSections()
        addAccessibleBadges()
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
                    badge.tokenSet[.backgroundTintColor] = .uiColor {
                        GlobalTokens.sharedColor(.purple, .primary)
                    }
                    badge.tokenSet[.backgroundFilledColor] = .uiColor {
                        GlobalTokens.sharedColor(.darkTeal, .tint20)
                    }
                    badge.tokenSet[.foregroundTintColor] = .uiColor {
                        GlobalTokens.neutralColor(.grey94)
                    }
                    badge.tokenSet[.foregroundFilledColor] = .uiColor {
                        GlobalTokens.neutralColor(.grey88)
                    }
                } else {
                    badge.tokenSet[.backgroundDisabledColor] = .uiColor {
                        GlobalTokens.neutralColor(.grey88)
                    }
                    badge.tokenSet[.foregroundDisabledColor] = .uiColor {
                        GlobalTokens.neutralColor(.grey26)
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
            badge.tokenSet[.backgroundDisabledColor] = .uiColor {
                GlobalTokens.sharedColor(.purple, .primary)
            }
            badge.tokenSet[.foregroundDisabledColor] = .uiColor {
                GlobalTokens.neutralColor(.white)
            }
            addRow(text: sizeCategory.description, items: [badge])
        }
        container.addArrangedSubview(UIView())
    }

    func addAccessibleBadges() {
        addTitle(text: "Accessible Badges")
        for style in BadgeView.Style.allCases {
            let badge = createBadge(text: "Kat Larsson", style: style, sizeCategory: .medium, isEnabled: true)
            badge.showAccessibleStroke = true
            addRow(text: style.description, items: [badge])
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
            .backgroundTintColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.plum, .tint40),
                               dark: GlobalTokens.sharedColor(.plum, .shade30))
            },
            .backgroundFilledColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.berry, .shade30),
                               dark: GlobalTokens.sharedColor(.berry, .tint40))
            },
            .foregroundTintColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.white),
                               dark: GlobalTokens.neutralColor(.grey98))
            },
            .foregroundFilledColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.white),
                               dark: GlobalTokens.neutralColor(.black))
            },
            .labelFont: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 20.0), size: 20.0)
            }
        ]
    }

    private var perControlOverrideBadgeViewTokens: [BadgeViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundTintColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.forest, .tint40),
                               dark: GlobalTokens.sharedColor(.forest, .shade30))
            },
            .backgroundFilledColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.seafoam, .shade30),
                               dark: GlobalTokens.sharedColor(.seafoam, .tint40))
            },
            .foregroundTintColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.black),
                               dark: GlobalTokens.neutralColor(.white))
            },
            .foregroundFilledColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.white),
                               dark: GlobalTokens.neutralColor(.black))
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

extension BadgeView.Style {
    var description: String {
        switch self {
        case .default:
            return "Brand"
        case .danger:
            return "Danger"
        case .severe:
            return "Severe"
        case .warning:
            return "Warning"
        case .success:
            return "Success"
        case .neutral:
            return "Neutral"
        }
    }
}
