//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSFCommandBarTokens: MSFTokensBase, ObservableObject {
    @Published public var defaultBackgroundColor: UIColor!
    @Published public var defaultIconColor: UIColor!

    @Published public var pressedBackgroundColor: UIColor!
    @Published public var pressedIconColor: UIColor!

    @Published public var dismissBackgroundColor: UIColor!
    @Published public var dismissIconColor: UIColor!
    @Published public var groupBorderRadius: CGFloat!
    @Published public var groupInterspace: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var itemInterspace: CGFloat!

    override init() {
        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFCommandBarTokens

        defaultBackgroundColor = appearanceProxy.backgroundColor.rest
        defaultIconColor = appearanceProxy.iconColor.rest
        dismissBackgroundColor = appearanceProxy.dismissBackgroundColor
        dismissIconColor = appearanceProxy.dismissIconColor
        groupBorderRadius = appearanceProxy.groupBorderRadius
        groupInterspace = appearanceProxy.groupInterspace
        iconSize = appearanceProxy.iconSize
        itemInterspace = appearanceProxy.itemInterspace
        pressedBackgroundColor = appearanceProxy.backgroundColor.pressed
        pressedIconColor = appearanceProxy.iconColor.pressed
    }
}
