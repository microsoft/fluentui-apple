//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
class DrawerTokens: MSFTokensBase, ObservableObject {

    public var shadow1Color: UIColor!
    public var shadow1Blur: CGFloat!
    public var shadow1DepthX: CGFloat!
    public var shadow1DepthY: CGFloat!
    public var shadow2Color: UIColor!
    public var shadow2Blur: CGFloat!
    public var shadow2DepthX: CGFloat!
    public var shadow2DepthY: CGFloat!
    public var backgroundDimmedColor: UIColor!
    public var backgroundClearColor: UIColor!
    public var drawerContentBackground: UIColor!
    public var popoverContentBackground: UIColor!
    public var navigationBarBackground: UIColor!
    public var resizingHandleViewBackgroundColor: UIColor!
    public var cornerRadius: CGFloat!
    public var dropShadowRadius: CGFloat!
    public var dropShadowOffset: CGFloat!
    public var dropShadowOpacity: Float!
    public var minHorizontalMargin: CGFloat!
    public var minVerticalMargin: CGFloat!
    public var verticalShadowOffset: CGFloat!

    /// callback for theme change
    public var themeChanged: (() -> Void)?

    override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        if let themeChanged = themeChanged {
            themeChanged()
        }

        let appearanceProxy = theme.DrawerTokens

        shadow1Color = appearanceProxy.shadow1Color
        shadow1Blur = appearanceProxy.shadow1Blur
        shadow1DepthX = appearanceProxy.shadow1OffsetX
        shadow1DepthY = appearanceProxy.shadow1OffsetY
        shadow2Color = appearanceProxy.shadow2Color
        shadow2Blur = appearanceProxy.shadow2Blur
        shadow2DepthX = appearanceProxy.shadow2OffsetX
        shadow2DepthY = appearanceProxy.shadow2OffsetY
        backgroundClearColor = appearanceProxy.backgroundClearColor
        backgroundDimmedColor = appearanceProxy.backgroundDimmedColor
        drawerContentBackground = appearanceProxy.drawerContentBackground
        popoverContentBackground = appearanceProxy.popoverContentBackground
        navigationBarBackground = appearanceProxy.navigationBarBackground
        resizingHandleViewBackgroundColor = appearanceProxy.resizingHandleViewBackgroundColor
        cornerRadius = appearanceProxy.cornerRadius
        dropShadowRadius = appearanceProxy.dropShadowRadius
        dropShadowOffset = appearanceProxy.dropShadowOffset
        dropShadowOpacity = Float(appearanceProxy.dropShadowOpacity)
        minHorizontalMargin = appearanceProxy.minMargin.horizontal
        minVerticalMargin = appearanceProxy.minMargin.vertical
        verticalShadowOffset = appearanceProxy.verticalShadowOffset
    }
}
