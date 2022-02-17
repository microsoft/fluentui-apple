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
    public var hoverBackgroundColor: UIColor!
    public var onBrandHoverBackgroundColor: UIColor!

    override init() {
        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let appearanceProxy = theme.MSFPillButtonBarTokens

        cornerRadius = appearanceProxy.cornerRadius
        maxButtonsSpacing = appearanceProxy.maxButtonsSpacing
        minButtonsSpacing = appearanceProxy.minButtonsSpacing
        minButtonVisibleWidth = appearanceProxy.minButtonVisibleWidth
        minButtonWidth = appearanceProxy.minButtonWidth
        minHeight = appearanceProxy.minHeight
        sideInset = appearanceProxy.sideInset
        hoverBackgroundColor = appearanceProxy.hoverBackgroundColor.primary
        onBrandHoverBackgroundColor = appearanceProxy.hoverBackgroundColor.onBrand
    }
}

/// Design token set for the `PillButtonBar` control
open class PillButtonBarTokens: ControlTokens {
    /// Maximum spacing between `PillButton` controls
    open var maxButtonSpacing: CGFloat { 10 }

    /// Minimum spacing between `PillButton` controls
    open var minButtonSpacing: CGFloat { globalTokens.spacing[.xSmall] }

    /// Minimum width of the last button that must be showing on screen when the `PillButtonBar` loads or redraws
    open var minButtonVisibleWidth: CGFloat { globalTokens.spacing[.large] }

    /// Minimum width of a `PillButton`
    open var minButtonWidth: CGFloat { 56 }

    /// Minimum height of a `PillButton`
    open var minButtonHeight: CGFloat { 28 }

    /// Offset from the leading edge when the `PillButtonBar` loads or redraws
    open var sideInset: CGFloat { globalTokens.spacing[.medium] }
}
