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
    var drawerVerticalContentBackground: UIColor!
    var drawerHorizontalContentBackground: UIColor!
    var popoverContentBackground: UIColor!
    var navigationBarBackground: UIColor!
    var cornerRadius: CGFloat!
    var dropShadowRadius: CGFloat!
    var dropShadowOffset: CGFloat!
    var dropShadowOpacity: Float!
    var minHorizontalMargin: CGFloat!
    var minVerticalMargin: CGFloat!
    var verticalShadowOffset: CGFloat!
    var horizontalShadowOffset: CGFloat!

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
        drawerVerticalContentBackground = appearanceProxy.drawerVerticalContentBackground
        drawerHorizontalContentBackground = appearanceProxy.drawerHorizontalContentBackground
        popoverContentBackground = appearanceProxy.popoverContentBackground
        navigationBarBackground = appearanceProxy.navigationBarBackground
        cornerRadius = appearanceProxy.cornerRadius
        dropShadowRadius = appearanceProxy.dropShadowRadius
        dropShadowOffset = appearanceProxy.dropShadowOffset
        dropShadowOpacity = Float(appearanceProxy.dropShadowOpacity)
        minHorizontalMargin = appearanceProxy.minMargin.horizontal
        minVerticalMargin = appearanceProxy.minMargin.vertical
        verticalShadowOffset = appearanceProxy.verticalShadowOffset
        horizontalShadowOffset = appearanceProxy.horizontalShadowOffset
    }
}
