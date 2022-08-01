//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Pre-defined styles of icons.
@objc public enum MSFListCellLeadingViewSize: Int, CaseIterable {
    case small
    case medium
    case large
}

/// Pre-defined accessory types.
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

/// Pre-defined styles for selection in the List.
@objc public enum MSFListSelectionStyle: Int, CaseIterable {
    case trailingCheckmark
    // TODO: Add more styles, including a leading circle
}

// MARK: ListCell Tokens

public class CellBaseTokenSet: ControlTokenSet<CellBaseTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the foreground color of the disclosure icon of the Cell.
        case disclosureIconForegroundColor

        /// Defines the color of the label of the Cell.
        case labelColor

        /// Defines the color of the label when the Cell is selected.
        case labelSelectedColor

        /// Defines the color of the leading view of the Cell.
        case leadingViewColor

        /// Defines the color of the sublabel of the Cell.
        case sublabelColor

        /// Defines the color of the sublabel when the Cell is selected.
        case sublabelSelectedColor

        /// Defines the foreground color of the trailing item of the Cell.
        case trailingItemForegroundColor

        /// Defines the foreground color of the trailing item when the Cell is selected.
        case trailingItemSelectedForegroundColor

        /// Defines the color of the background when the Cell is at rest.
        case backgroundColor

        /// Defines the color of the background when the Cell is highlighted.
        case highlightedBackgroundColor

        /// Defines the height of the Cell with one line.
        case cellHeightOneLine

        /// Defines the height of the Cell with two lines.
        case cellHeightTwoLines

        /// Defines the height of the Cell with three lines.
        case cellHeightThreeLines

        /// Defines the padding on the leading side of the disclosure of the Cell.
        case disclosureInterspace

        /// Defines the size of the disclosure of the Cell.
        case disclosureSize

        /// Defines the horizontal padding around the content of the Cell.
        case horizontalCellPadding

        /// Defines the padding on the leading side of the non-disclosure accessory icons
        case iconInterspace

        /// Defines the space between a label and its accessory view
        case labelAccessoryInterspace

        /// Defines the size of the accessory view of a label
        case labelAccessorySize

        /// Defines the size of the leading view of the Cell.
        case leadingViewSize

        /// Defines the size of the area aroudn the leading view of the Cell.
        case leadingViewAreaSize

        /// Defines the size of the accessories for the sublabel
        case sublabelAccessorySize

        /// Defines the size of the trailing item of the Cell.
        case trailingItemSize

        /// Defines the vertical padding of the Cell.
        case verticalCellPadding

        /// Defines the font of the footnote of the Cell.
        case footnoteFont

        /// Defiens the font of the sublabel of the Cell.
        case sublabelFont

        /// Defines the font of the label of the Cell.
        case labelFont
    }

    init(cellLeadingViewSize: @escaping () -> MSFListCellLeadingViewSize) {
        self.cellLeadingViewSize = cellLeadingViewSize
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {

        case .disclosureIconForegroundColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral4] }

        case .labelColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral1] }

        case .labelSelectedColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.brandRest] }

        case .leadingViewColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral1] }

        case .sublabelColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral3] }

        case .sublabelSelectedColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.brandRest] }

        case .trailingItemForegroundColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral3] }

        case .trailingItemSelectedForegroundColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.brandRest] }

        case .backgroundColor:
            return .dynamicColor { self.aliasTokens.backgroundColors[.neutral1] }

        case .highlightedBackgroundColor:
            return .dynamicColor { self.aliasTokens.backgroundColors[.neutral5] }

        case .cellHeightOneLine:
            return .float { self.globalTokens.spacing[.xxxLarge] }

        case .cellHeightTwoLines:
            return .float { 64 }

        case .cellHeightThreeLines:
            return .float { self.globalTokens.spacing[.xxxxLarge] }

        case .disclosureInterspace:
            return .float { self.globalTokens.spacing[.xxSmall] }

        case .disclosureSize:
            return .float { self.globalTokens.iconSize[.small] }

        case .horizontalCellPadding:
            return .float { self.globalTokens.spacing[.small] }

        case .iconInterspace:
            return .float { self.globalTokens.spacing[.medium] }

        case .labelAccessoryInterspace:
            return .float { self.globalTokens.spacing[.xSmall] }

        case .labelAccessorySize:
            return .float { self.globalTokens.iconSize[.xxSmall] }

        case .leadingViewSize:
            return .float {
                switch self.cellLeadingViewSize() {
                case .small:
                    return self.globalTokens.iconSize[.xSmall]
                case .medium:
                    return self.globalTokens.iconSize[.medium]
                case .large:
                    return self.globalTokens.iconSize[.xxLarge]
                }
            }

        case .leadingViewAreaSize:
            return .float { self.globalTokens.spacing[.xxxLarge] }

        case .sublabelAccessorySize:
            return .float { self.globalTokens.iconSize[.xxSmall] }

        case .trailingItemSize:
            return .float { self.globalTokens.iconSize[.medium] }

        case .verticalCellPadding:
            return .float { self.globalTokens.spacing[.xSmall] }

        case .footnoteFont:
            return .fontInfo { self.aliasTokens.typography[.caption1] }

        case .sublabelFont:
            return .fontInfo { self.aliasTokens.typography[.body2] }

        case .labelFont:
            return .fontInfo { self.aliasTokens.typography[.body1] }
        }
    }

    /// Defines the size of the leading view of the Cell.
    var cellLeadingViewSize: () -> MSFListCellLeadingViewSize
}
