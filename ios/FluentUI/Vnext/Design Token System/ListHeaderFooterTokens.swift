//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// HeaderFooter styles
@objc public enum MSFListHeaderFooterStyle: Int, CaseIterable {
    case headerPrimary
    case headerSecondary
}

public class MSFListHeaderFooterTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var textColor: UIColor!

    @Published public var horizontalCellPadding: CGFloat!

    @Published public var textFont: UIFont!

    var style: MSFListHeaderFooterStyle!

    public init(style: MSFListHeaderFooterStyle) {
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
            appearanceProxy = currentTheme.MSFListHeaderFooterTokens
        case .headerPrimary, .none:
            appearanceProxy = currentTheme.MSFPrimaryHeaderListTokens
        }

        textColor = appearanceProxy.textColor
        textFont = appearanceProxy.textFont
        backgroundColor = appearanceProxy.backgroundColor.rest
        horizontalCellPadding = appearanceProxy.horizontalCellPadding
    }
}
