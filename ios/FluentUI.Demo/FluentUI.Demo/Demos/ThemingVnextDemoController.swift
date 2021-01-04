//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ThemingVnextDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Default / Current window theme")

        let customThemeButton = MSFButtonVnext(style: .primary,
                                               size: .medium,
                                               action: { [weak self] _ in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                strongSelf.didPressOverrideThemeButton()
                                               })
        customThemeButton.state.text = "Override theme for current window"

        let disabledCstomThemeButton = MSFButtonVnext(style: .secondary,
                                                      size: .medium,
                                                      action: { [weak self] _ in
                                                        guard let strongSelf = self else {
                                                            return
                                                        }
                                                        strongSelf.didPressResetThemeButton()
                                                      })
        disabledCstomThemeButton.state.text = "Reset theme for current window"

        addRow(items: [customThemeButton.view, disabledCstomThemeButton.view], itemSpacing: 20)
        container.addArrangedSubview(UIView())

        addTitle(text: "Theme overriding")
        let overridingTheme = FluentUIStyle()
        let colorAP = overridingTheme.Colors
        let brandAP = colorAP.Brand
        brandAP.primary = .purple
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

        for style in MSFButtonVnextStyle.allCases {
            let customThemeButton = MSFButtonVnext(style: style,
                                                   size: .medium,
                                                   action: nil,
                                                   theme: overridingTheme)
            customThemeButton.state.text = "Button"
            customThemeButton.state.image = style.image

            addRow(items: [customThemeButton.view], itemSpacing: 20)
        }

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

            StylesheetManager.setStylesheet(stylesheet: stylesheet, for: window)
        }
    }

    func didPressResetThemeButton() {
        if let window = self.view.window {
            StylesheetManager.removeStylesheet(for: window)
        }
    }
}
