//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSFCommandBarTokens: MSFTokensBase {
    public var itemBackgroundColor: UIColor!
    public var itemIconColor: UIColor!

    public var itemHoverBackgroundColor: UIColor!
    public var itemHoverIconColor: UIColor!

    public var itemPressedBackgroundColor: UIColor!
    public var itemPressedIconColor: UIColor!

    public var itemSelectedBackgroundColor: UIColor!
    public var itemSelectedIconColor: UIColor!

    public var itemDisabledBackgroundColor: UIColor!
    public var itemDisabledIconColor: UIColor!

    public var backgroundColor: UIColor!
    public var itemFixedIconColor: UIColor!
    public var groupBorderRadius: CGFloat!
    public var groupInterspace: CGFloat!
    public var itemInterspace: CGFloat!

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

        itemBackgroundColor = appearanceProxy.itemBackgroundColor.rest
        itemIconColor = appearanceProxy.itemIconColor.rest

        itemHoverBackgroundColor = appearanceProxy.itemBackgroundColor.hover
        itemHoverIconColor = appearanceProxy.itemIconColor.hover

        itemPressedBackgroundColor = appearanceProxy.itemBackgroundColor.pressed
        itemPressedIconColor = appearanceProxy.itemIconColor.pressed

        itemSelectedBackgroundColor = appearanceProxy.itemBackgroundColor.selected
        itemSelectedIconColor = appearanceProxy.itemIconColor.selected

        itemDisabledBackgroundColor = appearanceProxy.itemBackgroundColor.disabled
        itemDisabledIconColor = appearanceProxy.itemIconColor.disabled

        backgroundColor = appearanceProxy.backgroundColor
        itemFixedIconColor = appearanceProxy.itemFixedIconColor
        groupBorderRadius = appearanceProxy.groupBorderRadius
        groupInterspace = appearanceProxy.groupInterspace
        itemInterspace = appearanceProxy.itemInterspace
    }
}
