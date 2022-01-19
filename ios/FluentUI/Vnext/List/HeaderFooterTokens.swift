//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// HeaderFooter styles
@objc public enum MSFHeaderFooterStyle: Int, CaseIterable {
    case headerPrimary
    case headerSecondary
}

class MSFHeaderFooterTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var textColor: UIColor!

    @Published public var headerHeight: CGFloat!
    @Published public var topPadding: CGFloat!
    @Published public var leadingPadding: CGFloat!
    @Published public var bottomPadding: CGFloat!
    @Published public var trailingPadding: CGFloat!

    @Published public var textFont: UIFont!

    var style: MSFHeaderFooterStyle {
            didSet {
                if oldValue != style {
                    updateForCurrentTheme()
                }
            }
        }

    init(style: MSFHeaderFooterStyle) {
        self.style = style

        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy: AppearanceProxyType

        switch style {
        case .headerSecondary:
            appearanceProxy = currentTheme.MSFHeaderFooterTokens
        case .headerPrimary:
            appearanceProxy = currentTheme.MSFPrimaryHeaderTokens
        }

        textColor = appearanceProxy.textColor
        textFont = appearanceProxy.textFont
        backgroundColor = appearanceProxy.backgroundColor
        headerHeight = appearanceProxy.headerHeight
        topPadding = appearanceProxy.topPadding
        leadingPadding = appearanceProxy.leadingPadding
        bottomPadding = appearanceProxy.bottomPadding
        trailingPadding = appearanceProxy.trailingPadding
    }
}
