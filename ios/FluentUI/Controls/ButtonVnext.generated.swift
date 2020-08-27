//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(MSFButtonVnextStyle)
/// Pre-defined styles of the button (same values currently defined in the current FluentUI button)
public enum ButtonVnextStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless
}

/// Source of design tokens to buttons at runtime. Each button style has its own singleton.
/// Once a property is changed on this instance, all associated buttons will automatically update their layout accordingly.
public class ButtonVnextAppearanceProxyAdapter: ObservableObject {

    @Published public var titleFont: Font!

    @Published public var titleColor: UIColor!
    @Published public var borderColor: UIColor!
    @Published public var backgroundColor: UIColor!

    @Published public var highlightedTitleColor: UIColor!
    @Published public var highlightedBorderColor: UIColor!
    @Published public var highlightedBackgroundColor: UIColor!

    @Published public var disabledTitleColor: UIColor!
    @Published public var disabledBorderColor: UIColor!
    @Published public var disabledBackgroundColor: UIColor!

    @Published public var cornerRadius: CGFloat!

    @Published public var edgeInsets: UIEdgeInsets!

    @Published public var hasBorders: Bool!
    @Published public var borderWidth: CGFloat!

    var style: ButtonVnextStyle!

    public init(style: ButtonVnextStyle) {
        self.style = style
        self.themeAware = true
        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        var appearanceProxy: ApperanceProxyType

        switch style {
        case .primaryFilled:
            appearanceProxy = StylesheetManager.S.PrimaryFilledButton
        case .primaryOutline:
            appearanceProxy = StylesheetManager.S.PrimaryOutlineButton
        case .secondaryOutline:
            appearanceProxy = StylesheetManager.S.SecondaryOutlineButton
        case .tertiaryOutline:
            appearanceProxy = StylesheetManager.S.TertiaryOutlineButton
        case .borderless:
            appearanceProxy = StylesheetManager.S.BorderlessButton
        case .none:
            appearanceProxy = StylesheetManager.S.ButtonVNext
        }

        titleFont = Font(appearanceProxy.titleFont)

        titleColor = appearanceProxy.titleColor.standard
        borderColor = appearanceProxy.borderColor.standard
        backgroundColor = appearanceProxy.backgroundColor.standard

        highlightedTitleColor = appearanceProxy.titleColor.highlighted
        highlightedBorderColor = appearanceProxy.borderColor.highlighted
        highlightedBackgroundColor = appearanceProxy.backgroundColor.highlighted

        disabledTitleColor = appearanceProxy.titleColor.disabled
        disabledBorderColor = appearanceProxy.borderColor.disabled
        disabledBackgroundColor = appearanceProxy.backgroundColor.disabled

        cornerRadius = appearanceProxy.cornerRadius

        edgeInsets = appearanceProxy.contentInsets

        hasBorders = appearanceProxy.hasBorders
        borderWidth = appearanceProxy.borderWidth
    }
}
