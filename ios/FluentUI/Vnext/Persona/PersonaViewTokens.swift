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
        let personaViewAP = currentTheme.MSFPersonaViewTokens
        let listCellAP = currentTheme.MSFListCellTokens

        disclosureIconForegroundColor = listCellAP.disclosureIconForegroundColor
        labelColor = listCellAP.labelColor
        leadingViewColor = listCellAP.leadingViewColor
        sublabelColor = personaViewAP.sublabelColor
        trailingItemForegroundColor = listCellAP.trailingItemForegroundColor

        backgroundColor = listCellAP.backgroundColor.rest
        highlightedBackgroundColor = listCellAP.backgroundColor.pressed

        cellHeightOneLine = listCellAP.cellHeight.oneLine
        cellHeightTwoLines = listCellAP.cellHeight.twoLines
        cellHeightThreeLines = listCellAP.cellHeight.threeLines
        disclosureInterspace = listCellAP.disclosureInterspace
        disclosureSize = listCellAP.disclosureSize
        horizontalCellPadding = listCellAP.horizontalCellPadding
        iconInterspace = personaViewAP.iconInterspace
        labelAccessoryInterspace = personaViewAP.labelAccessoryInterspace
        labelAccessorySize = personaViewAP.labelAccessorySize
        leadingViewSize = listCellAP.leadingViewSize.large
        leadingViewAreaSize = listCellAP.leadingViewAreaSize
        sublabelAccessorySize = listCellAP.sublabelAccessorySize
        trailingItemSize = listCellAP.trailingItemSize
        verticalCellPadding = listCellAP.verticalCellPadding

        footnoteFont = personaViewAP.footnoteFont
        sublabelFont = listCellAP.sublabelFont
        labelFont = personaViewAP.labelFont
    }
}
