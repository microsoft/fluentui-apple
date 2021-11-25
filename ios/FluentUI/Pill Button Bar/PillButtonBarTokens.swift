//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSFPillButtonBarTokens: MSFTokensBase {
    public var cornerRadius: CGFloat!
    public var maxButtonsSpacing: CGFloat!
    public var minButtonsSpacing: CGFloat!
    public var minButtonVisibleWidth: CGFloat!
    public var minButtonWidth: CGFloat!
    public var minHeight: CGFloat!
    public var sideInset: CGFloat!

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
        let appearanceProxy = currentTheme.MSFPillButtonBarTokens

        cornerRadius = appearanceProxy.cornerRadius
        maxButtonsSpacing = appearanceProxy.maxButtonsSpacing
        minButtonsSpacing = appearanceProxy.minButtonsSpacing
        minButtonVisibleWidth = appearanceProxy.minButtonVisibleWidth
        minButtonWidth = appearanceProxy.minButtonWidth
        minHeight = appearanceProxy.minHeight
        sideInset = appearanceProxy.sideInset
    }
}
