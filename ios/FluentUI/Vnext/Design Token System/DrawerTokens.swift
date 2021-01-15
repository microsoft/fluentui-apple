//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `DrawerTokens` assist to configure drawer apperance via UIKit components.
public class MSFDrawerTokens: MSFTokensBase, ObservableObject {

    @Published public var shadowColor: Color!
    @Published public var shadowOpacity: Double!
    @Published public var shadowBlur: CGFloat!
    @Published public var shadowDepthX: CGFloat!
    @Published public var shadowDepthY: CGFloat!
    @Published public var backgroundDimmedColor: Color!
    @Published public var backgroundClearColor: Color!
    @Published public var backgroundDimmedOpacity: Double!
    @Published public var backgroundClearOpacity: Double!

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

        shadowColor = Color(appearanceProxy.shadowColor)
        shadowOpacity = Double(appearanceProxy.shadowOpacity)
        shadowBlur = appearanceProxy.shadowBlur
        shadowDepthX = appearanceProxy.shadowX
        shadowDepthY = appearanceProxy.shadowY
        backgroundClearColor = Color(appearanceProxy.backgroundClearColor)
        backgroundDimmedColor = Color(appearanceProxy.backgroundDimmedColor)
        backgroundDimmedOpacity = Double(appearanceProxy.backgroundDimmedOpacity)
        backgroundClearOpacity = Double(appearanceProxy.backgroundClearOpacity)
    }
}
