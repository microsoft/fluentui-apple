//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
 import UIKit

 open class TableViewTokens: ControlTokens {
    //TODO: Update darkElevated value
    open var backgroundColor: DynamicColor {
        .init(light: globalTokens.neutralColors[.white],
              dark: globalTokens.neutralColors[.black])
    }

     //TODO: Update backgroundGrouped for light/dark/darkElevated
    open var backgroundGrouped: DynamicColor {
        .init(light: aliasTokens.backgroundColors[.neutral2].light,
              dark: aliasTokens.backgroundColors[.neutral1].dark)
    }
}

 open class TableViewCellTokens: TableViewTokens {
    open var cellBackgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

     //TODO: Replace cellBackgroundGrouped with 2.0 token
    open var cellBackgroundGrouped: DynamicColor {
        .init(light: aliasTokens.backgroundColors[.neutral1].light,
              dark: aliasTokens.backgroundColors[.neutral2].dark)}

     open var cellBackgroundSelectedColor: DynamicColor { aliasTokens.backgroundColors[.neutral5] }

     open var imageColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

     open var titleColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

     open var subtitleColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

     open var footerColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

     open var selectionIndicatorOffColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

     open var titleFont: FontInfo { aliasTokens.typography[.body1] }

     open var subtitleTwoLines: FontInfo { aliasTokens.typography[.caption1] }

     open var subtitleThreeLines: FontInfo { aliasTokens.typography[.body2] }

     open var footer: FontInfo { aliasTokens.typography[.caption1] }

     open var labelAccessoryViewMarginLeading: CGFloat { globalTokens.spacing[.xSmall] }

     open var labelAccessoryViewMarginTrailing: CGFloat { globalTokens.spacing[.xSmall] }

     open var customAccessoryViewMarginLeading: CGFloat { globalTokens.spacing[.xSmall] }

     open var customAccessoryViewMinVerticalMargin: CGFloat = 6

     open var labelVerticalMarginForOneAndThreeLines: CGFloat = 11

     open var labelVerticalMarginForTwoLines: CGFloat { globalTokens.spacing[.small] }

     open var labelVerticalSpacing: CGFloat { globalTokens.spacing[.none] }

     open var minHeight: CGFloat { globalTokens.iconSize[.xxxLarge] }

     open var selectionImageMarginTrailing: CGFloat { globalTokens.spacing[.medium] }

    open var selectionImageSize: CGSize { CGSize(width: globalTokens.iconSize[.medium], height: globalTokens.iconSize[.medium]) }

     open var selectionModeAnimationDuration: TimeInterval = 0.2

     open var textAreaMinWidth: CGFloat = 100

     open var enabledAlpha: CGFloat = 1

     open var disabledAlpha: CGFloat = 0.35

     /// The default horizontal spacing in the cell.
    open var horizontalSpacing: CGFloat { globalTokens.spacing[.medium] }

     /// The  leading padding in the cell.
    open var paddingLeading: CGFloat { globalTokens.spacing[.medium] }

     /// The  trailing padding in the cell.
    open var paddingTrailing: CGFloat { globalTokens.spacing[.medium] }
}

 open class TableViewCellAccessoryTokens: ControlTokens {
    open var accessoryDisclosureIndicatorColor: DynamicColor { aliasTokens.foregroundColors[.neutral4] }
    open var accessoryDetailButtonColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }
}
