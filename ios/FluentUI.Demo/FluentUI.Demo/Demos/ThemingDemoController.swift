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

        let overridingTheme = FluentUIStyle()
        let colorAP = overridingTheme.Colors
        let brandAP = colorAP.Brand
        brandAP.primary = UIColor(red: 0.384, green: 0.392, blue: 0.655, alpha: 1.0)
        brandAP.tint10 = UIColor(red: 0.651, green: 0.655, blue: 0.863, alpha: 1.0)
        brandAP.tint20 = UIColor(red: 0.741, green: 0.741, blue: 0.902, alpha: 1.0)
        brandAP.tint30 = UIColor(red: 0.226, green: 0.226, blue: 0.246, alpha: 1.0)
        brandAP.tint40 = UIColor(red: 0.898, green: 0.898, blue: 0.945, alpha: 1.0)
        brandAP.shade10 = UIColor(red: 0.345, green: 0.353, blue: 0.588, alpha: 1.0)
        brandAP.shade20 = UIColor(red: 0.275, green: 0.278, blue: 0.459, alpha: 1.0)
        brandAP.shade30 = UIColor(red: 0.200, green: 0.204, blue: 0.290, alpha: 1.0)
        colorAP.Brand = brandAP

        let border = overridingTheme.Border
        let radius = border.radius
        radius.small = 0
        radius.medium = 0
        radius.large = 0
        radius.xlarge = 0
        border.radius = radius

        overridingTheme.Border = border
        overridingTheme.Colors = colorAP

        let customThemeButtonPrimary = MSFButton(style: .primary,
                                                      size: .medium,
                                                      action: nil,
                                                      theme: overridingTheme)
        customThemeButtonPrimary.state.text = "Button"
        customThemeButtonPrimary.state.image = UIImage(named: "Placeholder_24")!

        let customThemeButtonSecondary = MSFButton(style: .secondary,
                                                        size: .medium,
                                                        action: nil,
                                                        theme: overridingTheme)
        customThemeButtonSecondary.state.text = "Button"
        customThemeButtonSecondary.state.image = UIImage(named: "Placeholder_24")!

        let customThemeButtonGhost = MSFButton(style: .ghost,
                                                    size: .medium,
                                                    action: nil,
                                                    theme: overridingTheme)
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
            let greenTheme = DemoColorThemeGreenWindow()
            let stylesheet = FluentUIStyle()
            let colors = stylesheet.Colors
            let brandColors = colors.Brand

            brandColors.primary = greenTheme.primaryColor(for: window)!
            brandColors.tint10 = greenTheme.primaryTint10Color(for: window)!
            brandColors.tint20 = greenTheme.primaryTint20Color(for: window)!
            brandColors.tint30 = greenTheme.primaryTint30Color(for: window)!
            brandColors.tint40 = greenTheme.primaryTint40Color(for: window)!
            brandColors.shade10 = greenTheme.primaryShade10Color(for: window)!
            brandColors.shade20 = greenTheme.primaryShade20Color(for: window)!
            brandColors.shade30 = greenTheme.primaryShade30Color(for: window)!

            colors.Brand = brandColors
            stylesheet.Colors = colors

            FluentUIThemeManager.setStylesheet(stylesheet: stylesheet, for: window)
        }
    }

    func didPressResetThemeButton() {
        if let window = self.view.window {
            FluentUIThemeManager.removeStylesheet(for: window)
        }
    }
}
