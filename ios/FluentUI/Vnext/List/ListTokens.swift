//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: List Tokens

/// Pre-defined styles of icons
@objc public enum MSFListCellLeadingViewSize: Int, CaseIterable {
    case small
    case medium
    case large
}

/// Pre-defined accessory types
@objc public enum MSFListAccessoryType: Int, CaseIterable {
    case none
    case disclosure
    case detailButton
    case checkmark

    var icon: UIImage? {
        let icon: UIImage?
        switch self {
        case .none:
            icon = nil
        case .disclosure:
            icon = UIImage.staticImageNamed("iOS-chevron-right-20x20")
        case .detailButton:
            icon = UIImage.staticImageNamed("more-24x24")
        case .checkmark:
            icon = UIImage.staticImageNamed("checkmark-24x24")
        }
        return icon
    }
}

// MARK: ListCell Tokens

class MSFListTokens: MSFTokensBase, ObservableObject {
    @Published public var borderColor: UIColor!

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
        let appearanceProxy = currentTheme.MSFListTokens

        borderColor = appearanceProxy.borderColor
    }
}

class MSFCellBaseTokens: MSFTokensBase, ObservableObject {
    @Published public var borderColor: UIColor!
    @Published public var disclosureIconForegroundColor: UIColor!
    @Published public var labelColor: UIColor!
    @Published public var leadingViewColor: UIColor!
    @Published public var sublabelColor: UIColor!
    @Published public var trailingItemForegroundColor: UIColor!

    @Published public var backgroundColor: UIColor!
    @Published public var highlightedBackgroundColor: UIColor!

    @Published public var cellHeightOneLine: CGFloat!
    @Published public var cellHeightTwoLines: CGFloat!
    @Published public var cellHeightThreeLines: CGFloat!
    @Published public var disclosureInterspace: CGFloat!
    @Published public var disclosureSize: CGFloat!
    @Published public var horizontalCellPadding: CGFloat!
    @Published public var iconInterspace: CGFloat!
    @Published public var labelAccessoryInterspace: CGFloat!
    @Published public var labelAccessorySize: CGFloat!
    @Published public var cellLeadingViewSize: MSFListCellLeadingViewSize!
    @Published public var leadingViewSize: CGFloat!
    @Published public var sublabelAccessorySize: CGFloat!
    @Published public var trailingItemSize: CGFloat!

    @Published public var footnoteFont: UIFont!
    @Published public var sublabelFont: UIFont!
    @Published public var labelFont: UIFont!
}

class MSFListCellTokens: MSFCellBaseTokens {
    init(cellLeadingViewSize: MSFListCellLeadingViewSize = .medium) {
        super.init()

        self.cellLeadingViewSize = cellLeadingViewSize
        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFListCellTokens

        switch cellLeadingViewSize {
        case .small:
            leadingViewSize = appearanceProxy.leadingViewSize.small
        case .medium, .none:
            leadingViewSize = appearanceProxy.leadingViewSize.medium
        case .large:
            leadingViewSize = appearanceProxy.leadingViewSize.large
        }

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
        sublabelAccessorySize = appearanceProxy.sublabelAccessorySize
        trailingItemSize = appearanceProxy.trailingItemSize

        footnoteFont = appearanceProxy.footnoteFont
        sublabelFont = appearanceProxy.sublabelFont
        labelFont = appearanceProxy.labelFont
    }
}
