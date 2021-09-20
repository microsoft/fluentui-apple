//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSFCommandBarTokens: MSFTokensBase {
    public var backgroundColor: UIColor!
    public var iconColor: UIColor!

    public var hoverBackgroundColor: UIColor!
    public var hoverIconColor: UIColor!

    public var pressedBackgroundColor: UIColor!
    public var pressedIconColor: UIColor!

    public var selectedBackgroundColor: UIColor!
    public var selectedIconColor: UIColor!

    public var disabledBackgroundColor: UIColor!
    public var disabledIconColor: UIColor!

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

        backgroundColor = appearanceProxy.backgroundColor.rest
        iconColor = appearanceProxy.iconColor.rest

        hoverBackgroundColor = appearanceProxy.backgroundColor.hover
        hoverIconColor = appearanceProxy.iconColor.hover

        pressedBackgroundColor = appearanceProxy.backgroundColor.pressed
        pressedIconColor = appearanceProxy.iconColor.pressed

        selectedBackgroundColor = appearanceProxy.backgroundColor.selected
        selectedIconColor = appearanceProxy.iconColor.selected

        disabledBackgroundColor = appearanceProxy.backgroundColor.disabled
        disabledIconColor = appearanceProxy.iconColor.disabled

        dismissIconColor = appearanceProxy.dismissIconColor

        groupBorderRadius = appearanceProxy.groupBorderRadius
        groupInterspace = appearanceProxy.groupInterspace
        iconSize = appearanceProxy.iconSize
        itemInterspace = appearanceProxy.itemInterspace
    }
}
