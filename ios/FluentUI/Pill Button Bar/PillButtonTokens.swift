//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
    public var font: UIFont!
    public var horizontalInset: CGFloat!
    public var topInset: CGFloat!
    public var unreadDotOffsetX: CGFloat!
    public var unreadDotOffsetY: CGFloat!
    public var unreadDotSize: CGFloat!

    /// Notifies the PillButton to refresh its UI to reflect its design token values
    var themeDidUpdate: (() -> Void)?

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
        if let themeChanged = themeDidUpdate {
            themeChanged()
        }

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
        font = appearanceProxy.font
        horizontalInset = appearanceProxy.horizontalInset
        topInset = appearanceProxy.topInset
        unreadDotOffsetX = appearanceProxy.unreadDotOffsetX
        unreadDotOffsetY = appearanceProxy.unreadDotOffsetY
        unreadDotSize = appearanceProxy.unreadDotSize
    }
}

/// Represents the set of `DynamicColor` values for the various states of a `PillButton`
public struct PillButtonDynamicColors {
    let rest: DynamicColor
    let hover: DynamicColor
    let selected: DynamicColor
    let disabled: DynamicColor
    let selectedDisabled: DynamicColor
    let highlighted: DynamicColor
    let selectedHighlighted: DynamicColor
}

/// Design token set for the `PillButton` control.
public class PillButtonTokens: ControlTokens {
    /// Defines the style of the `PillButton`.
    public internal(set) var style: PillButtonStyle = .primary

    /// The background color of the `PillButton`.
    open var backgroundColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selected: globalTokens.brandColors[.primary],
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey80], dark: globalTokens.neutralColors[.grey30]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey8]),
                         selectedHighlighted: globalTokens.brandColors[.primary])
        case .onBrand:
            return .init(rest: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         hover: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         selected: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey32]),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade20].light, dark: globalTokens.neutralColors[.grey8]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey30]),
                         highlighted: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey8]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]))
        }
    }

    /// The color of the title of the `PillButton`.
    open var titleColor: PillButtonDynamicColors {
        switch style {
        case .primary:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         selected: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.black]),
                         disabled: DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey94], dark: globalTokens.neutralColors[.grey44]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.grey38], dark: globalTokens.neutralColors[.grey84]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.black]))
        case .onBrand:
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         hover: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         selected: DynamicColor(light: globalTokens.brandColors[.primary].light, dark: globalTokens.neutralColors[.white]),
                         disabled: DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26]),
                         selectedDisabled: DynamicColor(light: globalTokens.neutralColors[.grey74], dark: globalTokens.neutralColors[.grey44]),
                         highlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]),
                         selectedHighlighted: DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84]))
        }
    }

    /// The color of the unread dot when the `PillButton` is enabled.
    open var enabledUnreadDotColor: DynamicColor {
        switch style {
        case .primary:
            return globalTokens.brandColors[.primary]
        case .onBrand:
            return DynamicColor(light: globalTokens.neutralColors[.white], dark: globalTokens.neutralColors[.grey84])
        }
    }

    /// The color of the unread dot when the `PillButton` is disabled.
    open var disabledUnreadDotColor: DynamicColor {
        switch style {
        case .primary:
            return DynamicColor(light: globalTokens.neutralColors[.grey70], dark: globalTokens.neutralColors[.grey26])
        case .onBrand:
            return DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.neutralColors[.grey26])
        }
    }

    /// The distance of the content from the top of the `PillButton`.
    open var topInset: CGFloat { 6.0 }

    /// The distance of the content from the bottom of the `PillButton`.
    open var bottomInset: CGFloat { 6.0 }

    /// The distance of the content from the sides of the `PillButton`.
    open var horizontalInset: CGFloat { globalTokens.spacing[.medium] }

    /// The distance of the unread dot from the trailing edge of the content of the `PillButton`.
    open var unreadDotOffsetX: CGFloat { 6.0 }

    /// The distance of the unread dot from the bottom of the content of the `PillButton`.
    open var unreadDotOffsetY: CGFloat { 3.0 }

    /// The size of the unread dot of the `PillButton`
    open var unreadDotSize: CGFloat { 6.0 }

    /// The font used for the title of the `PillButton`.
    open var font: FontInfo { aliasTokens.typography[.body2] }
}
