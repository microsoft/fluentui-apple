//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

// MARK: - DividerStyle

/// Pre-defined styles of the divider
@objc public enum MSFDividerStyle: Int {
    case `default`
    case shadow
}

/// Pre-defined spacings of the divider
@objc public enum MSFDividerSpacing: Int {
    case none
    case medium
}

/// Representation of design tokens to dividers at runtime which interfaces with the Design Token System auto-generated code
/// Updating these properties causes the SwiftUI divider to updates its view automatically
class MSFDividerTokens: MSFTokensBase, ObservableObject {
    @Published public var color: UIColor!
    @Published public var padding: CGFloat!

    var style: MSFDividerStyle
    var spacing: MSFDividerSpacing

    init(style: MSFDividerStyle,
         spacing: MSFDividerSpacing) {
        self.style = style
        self.spacing = spacing

        super.init()
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .default:
            appearanceProxy = currentTheme.MSFDividerTokens
        case .shadow:
            appearanceProxy = currentTheme.MSFShadowDividerTokens
        }
        color = appearanceProxy.color.rest

        switch spacing {
        case .none:
            padding = appearanceProxy.spacing.none
        case .medium:
            padding = appearanceProxy.spacing.medium
        }
    }
}
