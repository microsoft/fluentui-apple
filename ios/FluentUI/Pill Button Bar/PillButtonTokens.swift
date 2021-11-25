//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - PillButtonStyle

@objc(MSFPillButtonStyle)
public enum PillButtonStyle: Int {
    /// primary: the default style of PillButton; use this style in conjunction with a neutral or white background.
    case primary

    /// onBrand: use this style in conjunction with branded background where the background features
    /// a prominent brand color in light mode and a muted gray in dark mode.
    case onBrand
}

class MSFPillButtonTokens: MSFTokensBase {
    public var backgroundColor: UIColor!
    public var titleColor: UIColor!

    public var hoverBackgroundColor: UIColor!

    public var selectedBackgroundColor: UIColor!
    public var selectedTitleColor: UIColor!

    public var disabledBackgroundColor: UIColor!
    public var disabledTitleColor: UIColor!

    public var selectedDisabledBackgroundColor: UIColor!
    public var selectedDisabledTitleColor: UIColor!

    public var highlightedBackgroundColor: UIColor!
    public var highlightedTitleColor: UIColor!

    public var selectedHighlightedBackgroundColor: UIColor!
    public var selectedHighlightedTitleColor: UIColor!

    public var enabledUnreadDotColor: UIColor!
    public var disabledUnreadDotColor: UIColor!

    public var bottomInset: CGFloat!
    public var horizontalInset: CGFloat!
    public var topInset: CGFloat!
    public var unreadDotOffsetX: CGFloat!
    public var unreadDotOffsetY: CGFloat!
    public var unreadDotSize: CGFloat!

    var style: PillButtonStyle

    init(style: PillButtonStyle) {
        self.style = style

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .primary:
            appearanceProxy = currentTheme.MSFPillButtonTokens
        case .onBrand:
            appearanceProxy = currentTheme.MSFOnBrandPillButtonTokens
        }

        backgroundColor = appearanceProxy.backgroundColor.rest
        titleColor = appearanceProxy.titleColor.rest

        hoverBackgroundColor = appearanceProxy.backgroundColor.hover

        selectedBackgroundColor = appearanceProxy.backgroundColor.selected
        selectedTitleColor = appearanceProxy.titleColor.selected

        disabledBackgroundColor = appearanceProxy.backgroundColor.disabled
        disabledTitleColor = appearanceProxy.titleColor.disabled

        selectedDisabledBackgroundColor = appearanceProxy.backgroundColor.selectedDisabled
        selectedDisabledTitleColor = appearanceProxy.titleColor.selectedDisabled

        highlightedBackgroundColor = appearanceProxy.backgroundColor.highlighted
        highlightedTitleColor = appearanceProxy.titleColor.highlighted

        selectedHighlightedBackgroundColor = appearanceProxy.backgroundColor.selectedHighlighted
        selectedHighlightedTitleColor = appearanceProxy.titleColor.selected

        enabledUnreadDotColor = appearanceProxy.unreadDotColor.rest
        disabledUnreadDotColor = appearanceProxy.unreadDotColor.disabled

        bottomInset = appearanceProxy.bottomInset
        horizontalInset = appearanceProxy.horizontalInset
        topInset = appearanceProxy.topInset
        unreadDotOffsetX = appearanceProxy.unreadDotOffsetX
        unreadDotOffsetY = appearanceProxy.unreadDotOffsetY
        unreadDotSize = appearanceProxy.unreadDotSize
    }
}
