//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

open class TableViewCellTokens: ControlTokens {
    /// The background color of the TableView.
    open var backgroundColor: DynamicColor {
        .init(light: globalTokens.neutralColors[.white],
              dark: globalTokens.neutralColors[.black])
    }

    /// The grouped background color of the TableView.
    open var backgroundGrouped: DynamicColor {
        .init(light: aliasTokens.backgroundColors[.neutral2].light,
              dark: aliasTokens.backgroundColors[.neutral1].dark)
    }

    /// The background color of the TableViewCell.
    open var cellBackgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The grouped background color of the TableViewCell.
    open var cellBackgroundGrouped: DynamicColor {
        .init(light: aliasTokens.backgroundColors[.neutral1].light,
              dark: aliasTokens.backgroundColors[.neutral2].dark)}

    /// The selected background color of the TableViewCell.
    open var cellBackgroundSelectedColor: DynamicColor { aliasTokens.backgroundColors[.neutral5] }

    /// The leading image color.
    open var imageColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    /// The title label color.
    open var titleColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    /// The subtitle label color.
    open var subtitleColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// The footer label color.
    open var footerColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// The color of the selectionImageView when it is not selected.
    open var selectionIndicatorOffColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// The font for the title.
    open var titleFont: FontInfo { aliasTokens.typography[.body1] }

    /// The font for the subtitle when the TableViewCell is two lines.
    open var subtitleTwoLinesFont: FontInfo { aliasTokens.typography[.caption1] }

    /// The font for the subtitle when the TableViewCell is three lines.
    open var subtitleThreeLinesFont: FontInfo { aliasTokens.typography[.body2] }

    /// The font for the footer.
    open var footerFont: FontInfo { aliasTokens.typography[.caption1] }

    /// The leading margin for the labelAccessoryView.
    open var labelAccessoryViewMarginLeading: CGFloat { globalTokens.spacing[.xSmall] }

    /// The trailing margin for the labelAccessoryView.
    open var labelAccessoryViewMarginTrailing: CGFloat { globalTokens.spacing[.xSmall] }

    /// The leading margin for the customAccessoryView.
    open var customAccessoryViewMarginLeading: CGFloat { globalTokens.spacing[.xSmall] }

    /// The minimum vertical margin for the customAccessoryView.
    open var customAccessoryViewMinVerticalMargin: CGFloat = 6

    /// The vertical margin for the label when it has one or three lines.
    open var labelVerticalMarginForOneAndThreeLines: CGFloat = 11

    /// The vertical margin for the label when it has two lines.
    open var labelVerticalMarginForTwoLines: CGFloat { globalTokens.spacing[.small] }

    /// The vertical spacing for the label.
    open var labelVerticalSpacing: CGFloat { globalTokens.spacing[.none] }

    /// The minimum TableViewCell height.
    open var minHeight: CGFloat { globalTokens.spacing[.xxxLarge] }

    /// The trailing margin for the selectionImage.
    open var selectionImageMarginTrailing: CGFloat { globalTokens.spacing[.medium] }

    /// The size for the selectionImage.
    open var selectionImageSize: CGSize { CGSize(width: globalTokens.iconSize[.medium], height: globalTokens.iconSize[.medium]) }

    /// The duration for the selectionModeAnimation.
    open var selectionModeAnimationDuration: TimeInterval = 0.2

    /// The minimum width for any text area.
    open var textAreaMinWidth: CGFloat = 100

    /// The alpha value that enables the user's ability to interact with a cell.
    open var enabledAlpha: CGFloat = 1

    /// The alpha value that disables the user's ability to interact with a cell; dims cell's contents.
    open var disabledAlpha: CGFloat = 0.35

    /// The default horizontal spacing in the cell.
    open var horizontalSpacing: CGFloat { globalTokens.spacing[.medium] }

    /// The leading padding in the cell.
    open var paddingLeading: CGFloat { globalTokens.spacing[.medium] }

    /// The trailing padding in the cell.
    open var paddingTrailing: CGFloat { globalTokens.spacing[.medium] }

    /// The color for the accessoryDisclosureIndicator.
    open var accessoryDisclosureIndicatorColor: DynamicColor { aliasTokens.foregroundColors[.neutral4] }

    /// The color for the accessoryDetailButtonColor.
    open var accessoryDetailButtonColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }
}
