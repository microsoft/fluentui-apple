//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Pre-defined styles of the button
@objc public enum MSFButtonStyle: Int, CaseIterable {
    case primary
    case secondary
    case ghost
    /// For use with small and large sizes only
    case accentFloating
    /// For use with small and large sizes only
    case subtleFloating

    var isFloatingStyle: Bool {
        return self == .accentFloating || self == .subtleFloating
    }
}

/// Pre-defined sizes of the button
@objc public enum MSFButtonSize: Int, CaseIterable {
    case small
    case medium
    case large
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
class MSFButtonTokens: MSFTokensBase, ObservableObject {
    @Published public var borderRadius: CGFloat!
    @Published public var borderSize: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var interspace: CGFloat!
    @Published public var padding: CGFloat!
    @Published public var textFont: UIFont!
    @Published public var textMinimumHeight: CGFloat!
    @Published public var textAdditionalHorizontalPadding: CGFloat!

    @Published public var titleColor: UIColor!
    @Published public var borderColor: UIColor!
    @Published public var backgroundColor: UIColor!
    @Published public var iconColor: UIColor!

    @Published public var highlightedTitleColor: UIColor!
    @Published public var highlightedBorderColor: UIColor!
    @Published public var highlightedBackgroundColor: UIColor!
    @Published public var highlightedIconColor: UIColor!

    @Published public var disabledTitleColor: UIColor!
    @Published public var disabledBorderColor: UIColor!
    @Published public var disabledBackgroundColor: UIColor!
    @Published public var disabledIconColor: UIColor!

    @Published public var restShadow1Color: Color!
    @Published public var restShadow1Blur: CGFloat!
    @Published public var restShadow1DepthX: CGFloat!
    @Published public var restShadow1DepthY: CGFloat!
    @Published public var restShadow2Color: Color!
    @Published public var restShadow2Blur: CGFloat!
    @Published public var restShadow2DepthX: CGFloat!
    @Published public var restShadow2DepthY: CGFloat!

    @Published public var pressedShadow1Color: Color!
    @Published public var pressedShadow1Blur: CGFloat!
    @Published public var pressedShadow1DepthX: CGFloat!
    @Published public var pressedShadow1DepthY: CGFloat!
    @Published public var pressedShadow2Color: Color!
    @Published public var pressedShadow2Blur: CGFloat!
    @Published public var pressedShadow2DepthX: CGFloat!
    @Published public var pressedShadow2DepthY: CGFloat!

    var style: MSFButtonStyle
    var size: MSFButtonSize

    init(style: MSFButtonStyle,
         size: MSFButtonSize) {
        self.style = style
        self.size = size

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
            appearanceProxy = currentTheme.MSFPrimaryButtonTokens
        case .secondary:
            appearanceProxy = currentTheme.MSFSecondaryButtonTokens
        case .ghost:
            appearanceProxy = currentTheme.MSFGhostButtonTokens
        case .accentFloating:
            appearanceProxy = currentTheme.MSFAccentFloatingActionButtonTokens
        case .subtleFloating:
            appearanceProxy = currentTheme.MSFSubtleFloatingActionButtonTokens
        }

        titleColor = appearanceProxy.textColor.rest
        borderColor = appearanceProxy.borderColor.rest
        backgroundColor = appearanceProxy.backgroundColor.rest
        iconColor = appearanceProxy.iconColor.rest

        highlightedTitleColor = appearanceProxy.textColor.pressed
        highlightedBorderColor = appearanceProxy.borderColor.pressed
        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed
        highlightedIconColor = appearanceProxy.iconColor.pressed

        disabledTitleColor = appearanceProxy.textColor.disabled
        disabledBorderColor = appearanceProxy.borderColor.disabled
        disabledBackgroundColor = appearanceProxy.backgroundColor.disabled
        disabledIconColor = appearanceProxy.iconColor.disabled

        restShadow1Color = Color(appearanceProxy.shadow1Color.rest)
        restShadow1Blur = appearanceProxy.shadow1Blur.rest
        restShadow1DepthX = appearanceProxy.shadow1OffsetX.rest
        restShadow1DepthY = appearanceProxy.shadow1OffsetY.rest
        restShadow2Color = Color(appearanceProxy.shadow2Color.rest)
        restShadow2Blur = appearanceProxy.shadow2Blur.rest
        restShadow2DepthX = appearanceProxy.shadow2OffsetX.rest
        restShadow2DepthY = appearanceProxy.shadow2OffsetY.rest

        pressedShadow1Color = Color(appearanceProxy.shadow1Color.pressed)
        pressedShadow1Blur = appearanceProxy.shadow1Blur.pressed
        pressedShadow1DepthX = appearanceProxy.shadow1OffsetX.pressed
        pressedShadow1DepthY = appearanceProxy.shadow1OffsetY.pressed
        pressedShadow2Color = Color(appearanceProxy.shadow2Color.pressed)
        pressedShadow2Blur = appearanceProxy.shadow2Blur.pressed
        pressedShadow2DepthX = appearanceProxy.shadow2OffsetX.pressed
        pressedShadow2DepthY = appearanceProxy.shadow2OffsetY.pressed

        switch size {
        case .large:
            borderRadius = appearanceProxy.borderRadius.large
            borderSize = appearanceProxy.borderSize.large
            iconSize = appearanceProxy.iconSize.large
            interspace = appearanceProxy.interspace.large
            padding = appearanceProxy.padding.large
            textFont = appearanceProxy.textFont.large
            textMinimumHeight = appearanceProxy.textMinimumHeight.large
            textAdditionalHorizontalPadding = appearanceProxy.textAdditionalHorizontalPadding.large
        case .medium:
            borderRadius = appearanceProxy.borderRadius.medium
            borderSize = appearanceProxy.borderSize.medium
            iconSize = appearanceProxy.iconSize.medium
            interspace = appearanceProxy.interspace.medium
            padding = appearanceProxy.padding.medium
            textFont = appearanceProxy.textFont.medium
            textMinimumHeight = appearanceProxy.textMinimumHeight.medium
            textAdditionalHorizontalPadding = appearanceProxy.textAdditionalHorizontalPadding.medium
        case .small:
            borderRadius = appearanceProxy.borderRadius.small
            borderSize = appearanceProxy.borderSize.small
            iconSize = appearanceProxy.iconSize.small
            interspace = appearanceProxy.interspace.small
            padding = appearanceProxy.padding.small
            textFont = appearanceProxy.textFont.small
            textMinimumHeight = appearanceProxy.textMinimumHeight.small
            textAdditionalHorizontalPadding = appearanceProxy.textAdditionalHorizontalPadding.small
        }
    }
}
