//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(MSFButtonVnextStyle)
/// Pre-defined styles of the button
public enum MSFButtonVnextStyle: Int, CaseIterable {
    case primary
    case secondary
    case ghost
}

@objc(MSFButtonVnextSize)
/// Pre-defined sizes of the button
public enum MSFButtonVnextSize: Int, CaseIterable {
    case small
    case medium
    case large
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
public class ButtonTokens: TokensBase, ObservableObject {
    @Published public var borderRadius: CGFloat!
    @Published public var borderSize: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var interspace: CGFloat!
    @Published public var padding: CGFloat!
    @Published public var textFont: UIFont!

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

    var style: MSFButtonVnextStyle
    var size: MSFButtonVnextSize

    public init(style: MSFButtonVnextStyle,
                size: MSFButtonVnextSize) {
        self.style = style
        self.size = size

        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .primary:
            appearanceProxy = currentTheme.PrimaryButtonTokens
        case .secondary:
            appearanceProxy = currentTheme.SecondaryButtonTokens
        case .ghost:
            appearanceProxy = currentTheme.GhostButtonTokens
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

        switch size {
        case .large:
            borderRadius = appearanceProxy.borderRadius.large
            borderSize = appearanceProxy.borderSize.large
            iconSize = appearanceProxy.iconSize.large
            interspace = appearanceProxy.interspace.large
            padding = appearanceProxy.padding.large
            textFont = appearanceProxy.textFont.large
        case .medium:
            borderRadius = appearanceProxy.borderRadius.medium
            borderSize = appearanceProxy.borderSize.medium
            iconSize = appearanceProxy.iconSize.medium
            interspace = appearanceProxy.interspace.medium
            padding = appearanceProxy.padding.medium
            textFont = appearanceProxy.textFont.medium
        case .small:
            borderRadius = appearanceProxy.borderRadius.small
            borderSize = appearanceProxy.borderSize.small
            iconSize = appearanceProxy.iconSize.small
            interspace = appearanceProxy.interspace.small
            padding = appearanceProxy.padding.small
            textFont = appearanceProxy.textFont.small
        }
    }
}
