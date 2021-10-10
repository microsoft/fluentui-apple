//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ThemingDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Default / Current window theme")
        addDescription(text: "The default theme is defined by the FluentUIStyle class. The client app can override any of its properties and associate it to a specific UIWindow instance.")

        let overrideThemeButton = MSFButton(style: .primary,
                                            size: .medium,
                                            action: { [weak self] _ in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                strongSelf.didPressOverrideThemeButton()
                                            })
        overrideThemeButton.state.text = "Override theme for current window"

        let resetThemeButton = MSFButton(style: .secondary,
                                         size: .medium,
                                         action: { [weak self] _ in
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            strongSelf.didPressResetThemeButton()
                                         })
        resetThemeButton.state.text = "Reset theme for current window"

        addRow(items: [overrideThemeButton.view, resetThemeButton.view], itemSpacing: 20)

        let avatarAccent = MSFAvatar(style: .accent, size: .xlarge)
        avatarAccent.state.isRingVisible = true
        avatarAccent.state.presence = .available

        let avatarDefault = MSFAvatar(style: .default, size: .xlarge)
        avatarDefault.state.isRingVisible = true
        avatarDefault.state.presence = .busy

        let avatarOutlinedPrimary = MSFAvatar(style: .outlinedPrimary, size: .xlarge)
        avatarOutlinedPrimary.state.isRingVisible = true
        avatarOutlinedPrimary.state.presence = .away

        addRow(items: [avatarAccent.view, avatarDefault.view, avatarOutlinedPrimary.view], itemSpacing: 20)

        container.addArrangedSubview(UIView())

        addTitle(text: "Theme overriding")
        addDescription(text: "A theme can also be applied to a specific control or SwiftUI view hierarichy. This has the highest priority for the controls.")

        let overridingTheme = CustomStyle()
        let customThemeButtonPrimary = MSFButton(style: .primary,
                                                      size: .medium,
                                                      theme: overridingTheme,
                                                      action: nil)
        customThemeButtonPrimary.state.text = "Button"
        customThemeButtonPrimary.state.image = UIImage(named: "Placeholder_24")!

        let customThemeButtonSecondary = MSFButton(style: .secondary,
                                                        size: .medium,
                                                        theme: overridingTheme,
                                                        action: nil)
        customThemeButtonSecondary.state.text = "Button"
        customThemeButtonSecondary.state.image = UIImage(named: "Placeholder_24")!

        let customThemeButtonGhost = MSFButton(style: .ghost,
                                                    size: .medium,
                                                    theme: overridingTheme,
                                                    action: nil)
        customThemeButtonGhost.state.text = "Button"

        addRow(items: [customThemeButtonPrimary.view, customThemeButtonSecondary.view, customThemeButtonGhost.view], itemSpacing: 20)

        let customThemeAvatarAccent = MSFAvatar(style: .accent,
                                                  size: .xlarge,
                                                  theme: overridingTheme)
        customThemeAvatarAccent.state.isRingVisible = true
        customThemeAvatarAccent.state.presence = .available

        let customThemeAvatarDefault = MSFAvatar(style: .default,
                                                   size: .xlarge,
                                                   theme: overridingTheme)
        customThemeAvatarDefault.state.isRingVisible = true
        customThemeAvatarDefault.state.presence = .busy

        let customThemeAvatarOutlinedPrimary = MSFAvatar(style: .outlinedPrimary,
                                                           size: .xlarge,
                                                           theme: overridingTheme)
        customThemeAvatarOutlinedPrimary.state.isRingVisible = true
        customThemeAvatarOutlinedPrimary.state.presence = .away

        addRow(items: [customThemeAvatarAccent.view, customThemeAvatarDefault.view, customThemeAvatarOutlinedPrimary.view], itemSpacing: 20)

        container.addArrangedSubview(UIView())
    }

    func didPressOverrideThemeButton() {
        if let window = self.view.window {
            let greenThemeColorProviding = DemoColorGreenTheme()
            let stylesheet = ColorProvidingStyle(colorProviding: greenThemeColorProviding,
                                                 window: window)
            FluentUIThemeManager.setStylesheet(stylesheet: stylesheet, for: window)
        }
    }

    func didPressResetThemeButton() {
        if let window = self.view.window {
            FluentUIThemeManager.removeStylesheet(for: window)
        }
    }
}

open class CustomStyle: FluentUIStyle {
    open override var Colors: FluentUIStyle.ColorsAppearanceProxy {
        return FluentUIStyleCustomColorsAppearanceProxy(proxy: { return self })
    }

    open override var Border: FluentUIStyle.BorderAppearanceProxy {
        return CustomBorderAppearanceProxy(proxy: { return self })
    }

    open class FluentUIStyleCustomColorsAppearanceProxy: FluentUIStyle.ColorsAppearanceProxy {
        open override var Brand: FluentUIStyle.ColorsAppearanceProxy.BrandAppearanceProxy {
            return CustomBrandAppearanceProxy(proxy: self.mainProxy)
        }
    }

    open class CustomBrandAppearanceProxy: FluentUIStyle.ColorsAppearanceProxy.BrandAppearanceProxy {
        open override var primary: UIColor {
            return UIColor(red: 0.384, green: 0.392, blue: 0.655, alpha: 1.0)
        }

        open override var tint10: UIColor {
            return UIColor(red: 0.651, green: 0.655, blue: 0.863, alpha: 1.0)
        }

        open override var tint20: UIColor {
            return UIColor(red: 0.741, green: 0.741, blue: 0.902, alpha: 1.0)
        }

        open override var tint30: UIColor {
            return UIColor(red: 0.226, green: 0.226, blue: 0.246, alpha: 1.0)
        }

        open override var tint40: UIColor {
            return UIColor(red: 0.898, green: 0.898, blue: 0.945, alpha: 1.0)
        }

        open override var shade10: UIColor {
            return UIColor(red: 0.345, green: 0.353, blue: 0.588, alpha: 1.0)
        }

        open override var shade20: UIColor {
            return UIColor(red: 0.275, green: 0.278, blue: 0.459, alpha: 1.0)
        }

        open override var shade30: UIColor {
            return UIColor(red: 0.200, green: 0.204, blue: 0.290, alpha: 1.0)
        }
    }

    open class CustomBorderAppearanceProxy: FluentUIStyle.BorderAppearanceProxy {
        open override var radius: FluentUIStyle.BorderAppearanceProxy.radiusAppearanceProxy {
            return CustomRadiusAppearanceProxy(proxy: self.mainProxy)
        }
    }

    open class CustomRadiusAppearanceProxy: FluentUIStyle.BorderAppearanceProxy.radiusAppearanceProxy {
        open override var small: CGFloat {
            return 0.0
        }

        open override var medium: CGFloat {
            return 0.0
        }

        open override var large: CGFloat {
            return 0.0
        }

        open override var xLarge: CGFloat {
            return 0.0
        }
    }
}
