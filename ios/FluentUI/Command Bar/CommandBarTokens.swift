//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSFCommandBarTokens: MSFTokensBase {
    public var defaultBackgroundColor: UIColor!
    public var defaultIconColor: UIColor!

    public var pressedBackgroundColor: UIColor!
    public var pressedIconColor: UIColor!

    public var dismissBackgroundColor: UIColor!
    public var dismissIconColor: UIColor!
    public var groupBorderRadius: CGFloat!
    public var groupInterspace: CGFloat!
    public var iconSize: CGFloat!
    public var itemInterspace: CGFloat!

    /// Notifies the CommandBar  to refresh its UI to reflect its design token values
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
