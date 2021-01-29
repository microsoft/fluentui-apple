//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
public class MSFDrawerTokens: MSFTokensBase, ObservableObject {

    @Published public var shadow1Color: Color!
    @Published public var shadow1Blur: CGFloat!
    @Published public var shadow1DepthX: CGFloat!
    @Published public var shadow1DepthY: CGFloat!
    @Published public var shadow2Color: Color!
    @Published public var shadow2Blur: CGFloat!
    @Published public var shadow2DepthX: CGFloat!
    @Published public var shadow2DepthY: CGFloat!
    @Published public var backgroundDimmedColor: Color!
    @Published public var backgroundClearColor: Color!

    public override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let appearanceProxy = theme.MSFDrawerTokens

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
