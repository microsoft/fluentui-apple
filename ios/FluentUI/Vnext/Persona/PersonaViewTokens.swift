//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

class MSFPersonaViewTokens: MSFCellBaseTokens {
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
        let appearanceProxy = currentTheme.MSFPersonaViewTokens

        borderColor = appearanceProxy.borderColor
        disclosureIconForegroundColor = appearanceProxy.disclosureIconForegroundColor
        labelColor = appearanceProxy.labelColor
        leadingViewColor = appearanceProxy.leadingViewColor
        sublabelColor = appearanceProxy.sublabelColor
        trailingItemForegroundColor = appearanceProxy.trailingItemForegroundColor

        backgroundColor = appearanceProxy.backgroundColor.rest
        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed

        cellHeightOneLine = appearanceProxy.cellHeight.oneLine
        cellHeightTwoLines = appearanceProxy.cellHeight.twoLines
        cellHeightThreeLines = appearanceProxy.cellHeight.threeLines
        disclosureInterspace = appearanceProxy.disclosureInterspace
        disclosureSize = appearanceProxy.disclosureSize
        horizontalCellPadding = appearanceProxy.horizontalCellPadding
        iconInterspace = appearanceProxy.iconInterspace
        labelAccessoryInterspace = appearanceProxy.labelAccessoryInterspace
        labelAccessorySize = appearanceProxy.labelAccessorySize
        leadingViewSize = appearanceProxy.leadingViewSize.xlarge
        sublabelAccessorySize = appearanceProxy.sublabelAccessorySize
        trailingItemSize = appearanceProxy.trailingItemSize

        footnoteFont = appearanceProxy.footnoteFont
        sublabelFont = appearanceProxy.sublabelFont
        labelFont = appearanceProxy.labelFont
    }
}
