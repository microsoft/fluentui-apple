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

open class CellBaseTokens: ControlTokens {
    /// Defines the size of the leading view of the Cell.
    public internal(set) var cellLeadingViewSize: MSFListCellLeadingViewSize = .medium

    /// Defines the foreground color of the disclosure icon of the Cell.
    open var disclosureIconForegroundColor: DynamicColor { aliasTokens.foregroundColors[.neutral4] }

    /// Defines the color of the label of the Cell.
    open var labelColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    /// Defines the color of the label when the Cell is selected.
    open var labelSelectedColor: DynamicColor { aliasTokens.foregroundColors[.brandRest] }

    /// Defines the color of the leading view of the Cell.
    open var leadingViewColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    /// Defines the color of the sublabel of the Cell.
    open var sublabelColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// Defines the color of the sublabel when the Cell is selected.
    open var sublabelSelectedColor: DynamicColor { aliasTokens.foregroundColors[.brandRest] }

    /// Defines the foreground color of the trailing item of the Cell.
    open var trailingItemForegroundColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// Defines the foreground color of the trailing item when the Cell is selected.
    open var trailingItemSelectedForegroundColor: DynamicColor { aliasTokens.foregroundColors[.brandRest] }

    /// Defines the color of the background when the Cell is at rest.
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// Defines the color of the background when the Cell is highlighted.
    open var highlightedBackgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral5] }

    /// Defines the height of the Cell with one line.
    open var cellHeightOneLine: CGFloat { globalTokens.spacing[.xxxLarge] }

    /// Defines the height of the Cell with two lines.
    open var cellHeightTwoLines: CGFloat { 64 }

    /// Defines the height of the Cell with three lines.
    open var cellHeightThreeLines: CGFloat { globalTokens.spacing[.xxxxLarge] }

    /// Defines the padding on the leading side of the disclosure of the Cell.
    open var disclosureInterspace: CGFloat { globalTokens.spacing[.xxSmall] }

    /// Defines the size of the disclosure of the Cell.
    open var disclosureSize: CGFloat { globalTokens.iconSize[.small] }

    /// Defines the horizontal padding around the content of the Cell.
    open var horizontalCellPadding: CGFloat { globalTokens.spacing[.small] }

    /// Defines the padding on the leading side of the non-disclosure accessory icons
    open var iconInterspace: CGFloat { globalTokens.spacing[.medium] }

    /// Defines the space between a label and its accessory view
    open var labelAccessoryInterspace: CGFloat { globalTokens.spacing[.xSmall] }

    /// Defines the size of the accessory view of a label
    open var labelAccessorySize: CGFloat { globalTokens.iconSize[.xxSmall] }

    /// Defines the size of the leading view of the Cell.
    open var leadingViewSize: CGFloat {
        switch cellLeadingViewSize {
        case .small:
            return globalTokens.iconSize[.xSmall]
        case .medium:
            return globalTokens.iconSize[.medium]
        case .large:
            return globalTokens.iconSize[.xxLarge]
        }
    }

    /// Defines the size of the area aroudn the leading view of the Cell.
    open var leadingViewAreaSize: CGFloat { globalTokens.spacing[.xxxLarge] }

    /// Defines the size of the accessories for the sublabel
    open var sublabelAccessorySize: CGFloat { globalTokens.iconSize[.xxSmall] }

    /// Defines the size of the trailing item of the Cell.
    open var trailingItemSize: CGFloat { globalTokens.iconSize[.medium] }

    /// Defines the vertical padding of the Cell.
    open var verticalCellPadding: CGFloat { globalTokens.spacing[.xSmall] }

    /// Defines the font of the footnote of the Cell.
    open var footnoteFont: FontInfo { aliasTokens.typography[.caption1] }

    /// Defiens the font of the sublabel of the Cell.
    open var sublabelFont: FontInfo { aliasTokens.typography[.body2] }

    /// Defines the font of the label of the Cell.
    open var labelFont: FontInfo { aliasTokens.typography[.body1] }
}
