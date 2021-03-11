//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
class DrawerTokens: MSFTokensBase, ObservableObject {

    public var shadow1Color: Color!
    public var shadow1Blur: CGFloat!
    public var shadow1DepthX: CGFloat!
    public var shadow1DepthY: CGFloat!
    public var shadow2Color: Color!
    public var shadow2Blur: CGFloat!
    public var shadow2DepthX: CGFloat!
    public var shadow2DepthY: CGFloat!
    public var backgroundDimmedColor: Color!
    public var backgroundClearColor: Color!

    /// callback for theme change
    public var themeChanged: (() -> Void)?

    override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
        if let themeChanged = themeChanged {
            themeChanged()
        }
    }

    override func updateForCurrentTheme() {
        let appearanceProxy = theme.DrawerTokens

        shadow1Color = Color(appearanceProxy.shadow1Color)
        shadow1Blur = appearanceProxy.shadow1Blur
        shadow1DepthX = appearanceProxy.shadow1OffsetX
        shadow1DepthY = appearanceProxy.shadow1OffsetY
        shadow2Color = Color(appearanceProxy.shadow2Color)
        shadow2Blur = appearanceProxy.shadow2Blur
        shadow2DepthX = appearanceProxy.shadow2OffsetX
        shadow2DepthY = appearanceProxy.shadow2OffsetY
        backgroundClearColor = Color(appearanceProxy.backgroundClearColor)
        backgroundDimmedColor = Color(appearanceProxy.backgroundDimmedColor)
    }
}
