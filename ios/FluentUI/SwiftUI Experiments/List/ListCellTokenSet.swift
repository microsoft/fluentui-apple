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

public class ListCellTokenSet: ControlTokenSet<ListCellTokenSet.Tokens> {
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
        super.init { [cellLeadingViewSize] token, theme in
            switch token {

            case .disclosureIconForegroundColor:
                return .uiColor { theme.color(.foreground3) }

            case .labelColor:
                return .uiColor { theme.color(.foreground1) }

            case .labelSelectedColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .leadingViewColor:
                return .uiColor { theme.color(.foreground3) }

            case .sublabelColor:
                return .uiColor { theme.color(.foreground2) }

            case .sublabelSelectedColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .trailingItemForegroundColor:
                return .uiColor { theme.color(.foreground3) }

            case .trailingItemSelectedForegroundColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .backgroundColor:
                return .uiColor { theme.color(.background1) }

            case .highlightedBackgroundColor:
                return .uiColor { theme.color(.background1Pressed) }

            case .cellHeightOneLine:
                return .float { GlobalTokens.spacing(.size480) }

            case .cellHeightTwoLines:
                return .float { 64 }

            case .cellHeightThreeLines:
                return .float { GlobalTokens.spacing(.size560) }

            case .disclosureInterspace:
                return .float { GlobalTokens.spacing(.size40) }

            case .disclosureSize:
                return .float { GlobalTokens.icon(.size200) }

            case .horizontalCellPadding:
                return .float { GlobalTokens.spacing(.size120) }

            case .iconInterspace:
                return .float { GlobalTokens.spacing(.size160) }

            case .labelAccessoryInterspace:
                return .float { GlobalTokens.spacing(.size80) }

            case .labelAccessorySize:
                return .float { GlobalTokens.icon(.size120) }

            case .leadingViewSize:
                return .float {
                    switch cellLeadingViewSize() {
                    case .small:
                        return GlobalTokens.icon(.size160)
                    case .medium:
                        return GlobalTokens.icon(.size240)
                    case .large:
                        return GlobalTokens.icon(.size400)
                    }
                }

            case .leadingViewAreaSize:
                return .float { GlobalTokens.spacing(.size480) }

            case .sublabelAccessorySize:
                return .float { GlobalTokens.icon(.size120) }

            case .trailingItemSize:
                return .float { GlobalTokens.icon(.size240) }

            case .verticalCellPadding:
                return .float { GlobalTokens.spacing(.size80) }

            case .footnoteFont:
                return .uiFont { theme.typography(.caption1) }

            case .sublabelFont:
                return .uiFont { theme.typography(.body2) }

            case .labelFont:
                return .uiFont { theme.typography(.body1) }
            }
        }
    }

    /// Defines the size of the leading view of the Cell.
    var cellLeadingViewSize: () -> MSFListCellLeadingViewSize
}
