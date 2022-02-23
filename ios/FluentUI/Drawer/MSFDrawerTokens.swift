//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
class MSFDrawerTokens: MSFTokensBase {

    var shadow1Color: UIColor!
    var shadow1Blur: CGFloat!
    var shadow1DepthX: CGFloat!
    var shadow1DepthY: CGFloat!
    var shadow2Color: UIColor!
    var shadow2Blur: CGFloat!
    var shadow2DepthX: CGFloat!
    var shadow2DepthY: CGFloat!
    var backgroundDimmedColor: UIColor!
    var drawerContentBackground: UIColor!
    var popoverContentBackground: UIColor!
    var navigationBarBackground: UIColor!
    var cornerRadius: CGFloat!
    var minHorizontalMargin: CGFloat!
    var minVerticalMargin: CGFloat!
    var shadowOffset: CGFloat!

    /// Notifies the drawer controller to refresh its UI to reflect its design token values
    var themeDidUpdate: (() -> Void)?

    override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        if let themeChanged = themeDidUpdate {
            themeChanged()
        }

        let appearanceProxy = theme.MSFDrawerTokens

        shadow1Color = appearanceProxy.shadow1Color
        shadow1Blur = appearanceProxy.shadow1Blur
        shadow1DepthX = appearanceProxy.shadow1OffsetX
        shadow1DepthY = appearanceProxy.shadow1OffsetY
        shadow2Color = appearanceProxy.shadow2Color
        shadow2Blur = appearanceProxy.shadow2Blur
        shadow2DepthX = appearanceProxy.shadow2OffsetX
        shadow2DepthY = appearanceProxy.shadow2OffsetY
        backgroundDimmedColor = appearanceProxy.backgroundDimmedColor
        drawerContentBackground = appearanceProxy.drawerBackground
        popoverContentBackground = appearanceProxy.popoverContentBackground
        navigationBarBackground = appearanceProxy.navigationBarBackground
        cornerRadius = appearanceProxy.cornerRadius
        minHorizontalMargin = appearanceProxy.minMargin.horizontal
        minVerticalMargin = appearanceProxy.minMargin.vertical
        shadowOffset = appearanceProxy.shadowOffset
    }
}

/// Design token set for the `Drawer` control
open class DrawerTokens: ControlTokens {
    /// `ShadowInfo` for the shadow used in the `Drawer` control.
    open var shadow: ShadowInfo { return aliasTokens.shadow[.shadow28] }

    /// Color used when dimming the background while showing the `Drawer` control.
    open var backgroundDimmedColor: DynamicColor {
        return DynamicColor(light: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.40),
                            dark: ColorValue(r: 0.0, g: 0.0, b: 0.0, a: 0.60))
    }

    /// Color used for the background of the content of the `Drawer` control.
    open var drawerContentBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.backgroundColors[.neutral3].dark)
    }

    /// Color used for the background of the popover style `Drawer` control.
    open var popoverContentBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: aliasTokens.backgroundColors[.surfaceQuaternary].dark)
    }

    /// Color used for the navigation bar of the `Drawer` control.
    open var navigationBarBackground: DynamicColor {
        return DynamicColor(light: aliasTokens.backgroundColors[.neutral1].light, dark: globalTokens.neutralColors[.grey14])
    }

    /// Corner radius for the popover style `Drawer` control.
    open var cornerRadius: CGFloat { return globalTokens.borderRadius[.xxLarge] }

    /// Minimum horizontal margin for the `Drawer` control.
    open var minHorizontalMargin: CGFloat { return globalTokens.spacing[.xxxLarge] }

    /// Minimum vertical margin for the `Drawer` control.
    open var minVerticalMargin: CGFloat { return globalTokens.spacing[.large] }

    /// Offset of the shadow for the `Drawer` control.
    open var shadowOffset: CGFloat { return globalTokens.spacing[.xSmall] }
}
