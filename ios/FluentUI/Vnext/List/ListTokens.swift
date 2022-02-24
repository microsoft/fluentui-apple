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

// MARK: ListCell Tokens

public class MSFCellBaseTokens: ControlTokens {
    public internal(set) var cellLeadingViewSize: MSFListCellLeadingViewSize = .medium

    open var disclosureIconForegroundColor: DynamicColor { aliasTokens.foregroundColors[.neutral4] }

    open var labelColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    open var leadingViewColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    open var sublabelColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    open var trailingItemForegroundColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    open var highlightedBackgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral5] }

    open var cellHeightOneLine: CGFloat { globalTokens.spacing[.xxxLarge] }

    open var cellHeightTwoLines: CGFloat { 64 }

    open var cellHeightThreeLines: CGFloat { globalTokens.spacing[.xxxxLarge] }

    open var disclosureInterspace: CGFloat { globalTokens.spacing[.xxSmall] }

    open var disclosureSize: CGFloat { globalTokens.iconSize[.small] }

    open var horizontalCellPadding: CGFloat { globalTokens.spacing[.small] }

    open var iconInterspace: CGFloat { globalTokens.spacing[.medium] }

    open var labelAccessoryInterspace: CGFloat { globalTokens.spacing[.xSmall] }

    open var labelAccessorySize: CGFloat { globalTokens.iconSize[.xxSmall] }

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

    open var leadingViewAreaSize: CGFloat { globalTokens.spacing[.xxxLarge] }

    open var sublabelAccessorySize: CGFloat { globalTokens.iconSize[.xxSmall] }

    open var trailingItemSize: CGFloat { globalTokens.iconSize[.medium] }

    open var verticalCellPadding: CGFloat { globalTokens.spacing[.xSmall] }

    open var footnoteFont: FontInfo { aliasTokens.typography[.caption1] }

    open var sublabelFont: FontInfo { aliasTokens.typography[.body2] }

    open var labelFont: FontInfo { aliasTokens.typography[.body1] }
}
