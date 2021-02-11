//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

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

public class MSFListTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var highlightedBackgroundColor: UIColor!

    @Published public var borderColor: UIColor!
    @Published public var borderSize: CGFloat!

    @Published public var horizontalCellPadding: CGFloat!

    public override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFListTokens

        backgroundColor = appearanceProxy.backgroundColor.rest
        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed

        borderColor = appearanceProxy.borderColor
        borderSize = appearanceProxy.borderSize

        horizontalCellPadding = appearanceProxy.horizontalCellPadding
    }
}

public class MSFListCellTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var borderColor: UIColor!
    @Published public var disclosureIconForegroundColor: UIColor!
    @Published public var leadingTextColor: UIColor!
    @Published public var leadingViewColor: UIColor!
    @Published public var subtitleColor: UIColor!
    @Published public var trailingItemForegroundColor: UIColor!

    @Published public var highlightedBackgroundColor: UIColor!

    @Published public var borderSize: CGFloat!
    @Published public var cellHeightOneLine: CGFloat!
    @Published public var cellHeightTwoLines: CGFloat!
    @Published public var cellHeightThreeLines: CGFloat!
    @Published public var disclosureInterspace: CGFloat!
    @Published public var disclosureSize: CGFloat!
    @Published public var horizontalCellPadding: CGFloat!
    @Published public var iconInterspace: CGFloat!
    @Published public var leadingViewSize: CGFloat!
    @Published public var trailingItemSize: CGFloat!

    @Published public var subtitleFont: UIFont!
    @Published public var textFont: UIFont!

    @Published public var cellLeadingViewSize: MSFListCellLeadingViewSize!

    public init(cellLeadingViewSize: MSFListCellLeadingViewSize) {
        self.cellLeadingViewSize = cellLeadingViewSize

        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    public override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy: AppearanceProxyType = currentTheme.MSFListCellTokens

        switch cellLeadingViewSize {
        case .small:
            leadingViewSize = appearanceProxy.leadingViewSize.small
        case .medium, .none:
            leadingViewSize = appearanceProxy.leadingViewSize.medium
        case .large:
            leadingViewSize = appearanceProxy.leadingViewSize.large
        }

        backgroundColor = appearanceProxy.backgroundColor.rest
        borderColor = appearanceProxy.borderColor
        disclosureIconForegroundColor = appearanceProxy.disclosureIconForegroundColor
        leadingTextColor = appearanceProxy.labelColor
        leadingViewColor = appearanceProxy.leadingViewColor
        subtitleColor = appearanceProxy.sublabelColor
        trailingItemForegroundColor = appearanceProxy.trailingItemForegroundColor

        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed

        borderSize = appearanceProxy.borderSize
        cellHeightOneLine = appearanceProxy.cellHeight.oneLine
        cellHeightTwoLines = appearanceProxy.cellHeight.twoLines
        cellHeightThreeLines = appearanceProxy.cellHeight.threeLines
        disclosureInterspace = appearanceProxy.disclosureInterspace
        disclosureSize = appearanceProxy.disclosureSize
        horizontalCellPadding = appearanceProxy.horizontalCellPadding
        iconInterspace = appearanceProxy.iconInterspace
        trailingItemSize = appearanceProxy.trailingItemSize

        subtitleFont = appearanceProxy.sublabelFont
        textFont = appearanceProxy.labelFont
    }
}
