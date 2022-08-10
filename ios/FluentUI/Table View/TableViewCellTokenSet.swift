//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

public class TableViewCellTokenSet: ControlTokenSet<TableViewCellTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the TableView.
        case backgroundColor

        /// The grouped background color of the TableView.
        case backgroundGroupedColor

        /// The background color of the TableViewCell.
        case cellBackgroundColor

        /// The grouped background color of the TableViewCell.
        case cellBackgroundGroupedColor

        /// The selected background color of the TableViewCell.
        case cellBackgroundSelectedColor

        /// The leading image color.
        case imageColor

        /// The size dimensions of the customView.
        case customViewDimensions

        /// The trailing margin of the customView.
        case customViewTrailingMargin

        /// The title label color.
        case titleColor

        /// The subtitle label color.
        case subtitleColor

        /// The footer label color.
        case footerColor

        /// The color of the selectionImageView when it is not selected.
        case selectionIndicatorOffColor

        /// The font for the title.
        case titleFont

        /// The font for the subtitle when the TableViewCell has two lines.
        case subtitleTwoLinesFont

        /// The font for the subtitle when the TableViewCell has three lines.
        case subtitleThreeLinesFont

        /// The font for the footer.
        case footerFont

        /// The minimum height for the title label.
        case titleHeight

        /// The minimum height for the subtitle label when the TableViewCell has two lines.
        case subtitleTwoLineHeight

        /// The minimum height for the subtitle label when the TableViewCell has three lines.
        case subtitleThreeLineHeight

        /// The minimum height for the footer label.
        case footerHeight

        /// The leading margin for the labelAccessoryView.
        case labelAccessoryViewMarginLeading

        /// The trailing margin for the labelAccessoryView.
        case labelAccessoryViewMarginTrailing

        /// The leading margin for the customAccessoryView.
        case customAccessoryViewMarginLeading

        /// The minimum vertical margin for the customAccessoryView.
        case customAccessoryViewMinVerticalMargin

        /// The vertical margin for the label when it has one or three lines.
        case labelVerticalMarginForOneAndThreeLines

        /// The vertical margin for the label when it has two lines.
        case labelVerticalMarginForTwoLines

        /// The vertical spacing for the label.
        case labelVerticalSpacing

        /// The minimum TableViewCell height; the height of a TableViewCell with one line of text.
        case minHeight

        /// The height of a TableViewCell with two lines of text.
        case mediumHeight

        /// The height of a TableViewCell with three lines of text.
        case largeHeight

        /// The trailing margin for the selectionImage.
        case selectionImageMarginTrailing

        /// The size for the selectionImage.
        case selectionImageSize

        /// The duration for the selectionModeAnimation.
        case selectionModeAnimationDuration

        /// The minimum width for any text area.
        case textAreaMinWidth

        /// The alpha value that enables the user's ability to interact with a cell.
        case enabledAlpha

        /// The alpha value that disables the user's ability to interact with a cell; dims cell's contents.
        case disabledAlpha

        /// The default horizontal spacing in the cell.
        case horizontalSpacing

        /// The leading padding in the cell.
        case paddingLeading

        /// The vertical padding in the cell.
        case paddingVertical

        /// The trailing padding in the cell.
        case paddingTrailing

        /// The color for the accessoryDisclosureIndicator.
        case accessoryDisclosureIndicatorColor

        /// The color for the accessoryDetailButtonColor.
        case accessoryDetailButtonColor

        /// The main primary brand color of the theme.
        case mainBrandColor

        /// The destructive text color in an ActionsCell.
        case destructiveTextColor

        /// The communication text color in an ActionsCell.
        case communicationTextColor
    }

    init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        self.customViewSize = customViewSize
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    .init(light: theme.globalTokens.neutralColors[.white],
                          dark: theme.globalTokens.neutralColors[.black])
                }

            case .backgroundGroupedColor:
                return .dynamicColor {
                    .init(light: theme.aliasTokens.backgroundColors[.neutral2].light,
                          dark: theme.aliasTokens.backgroundColors[.neutral1].dark)
                }

            case .cellBackgroundColor:
                return .dynamicColor {
                    .init(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                          dark: theme.aliasTokens.backgroundColors[.neutral1].dark,
                          darkElevated: theme.aliasTokens.backgroundColors[.neutral2].darkElevated)
                }

            case .cellBackgroundGroupedColor:
                return .dynamicColor {
                    .init(light: theme.aliasTokens.backgroundColors[.neutral1].light,
                          dark: theme.aliasTokens.backgroundColors[.neutral3].dark,
                          darkElevated: ColorValue(0x212121))
                }

            case .cellBackgroundSelectedColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral5] }

            case .imageColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .customViewDimensions:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return 0.0
                    case .small:
                        return theme.globalTokens.iconSize[.medium]
                    case .medium, .default:
                        return theme.globalTokens.iconSize[.xxLarge]
                    }
                }

            case .customViewTrailingMargin:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return theme.globalTokens.spacing[.none]
                    case .small:
                        return theme.globalTokens.spacing[.medium]
                    case .medium, .default:
                        return theme.globalTokens.spacing[.small]
                    }
                }

            case .titleColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .subtitleColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .footerColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .selectionIndicatorOffColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .titleFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }

            case .subtitleTwoLinesFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }

            case .subtitleThreeLinesFont:
                return .fontInfo { theme.aliasTokens.typography[.body2] }

            case .footerFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }

            case .titleHeight:
                return .float { 22 }

            case .subtitleTwoLineHeight:
                return .float { 18 }

            case .subtitleThreeLineHeight:
                return .float { 20 }

            case .footerHeight:
                return .float { 18 }

            case .labelAccessoryViewMarginLeading:
                return .float { theme.globalTokens.spacing[.xSmall] }

            case .labelAccessoryViewMarginTrailing:
                return .float { theme.globalTokens.spacing[.xSmall] }

            case .customAccessoryViewMarginLeading:
                return .float { theme.globalTokens.spacing[.xSmall] }

            case .customAccessoryViewMinVerticalMargin:
                return .float { 6 }

            case .labelVerticalMarginForOneAndThreeLines:
                return .float { 11 }

            case .labelVerticalMarginForTwoLines:
                return .float { theme.globalTokens.spacing[.small] }

            case .labelVerticalSpacing:
                return .float { theme.globalTokens.spacing[.none] }

            case .minHeight:
                return .float { theme.globalTokens.spacing[.xxxLarge] }

            case .mediumHeight:
                return .float { 64 }

            case .largeHeight:
                return .float { 84 }

            case .selectionImageMarginTrailing:
                return .float { theme.globalTokens.spacing[.medium] }

            case .selectionImageSize:
                return .float { theme.globalTokens.iconSize[.medium] }

            case .selectionModeAnimationDuration:
                return .float { 0.2 }

            case .textAreaMinWidth:
                return .float { 100 }

            case .enabledAlpha:
                return .float { 1 }

            case .disabledAlpha:
                return .float { 0.35 }

            case .horizontalSpacing:
                return .float { theme.globalTokens.spacing[.medium] }

            case .paddingLeading:
                return .float { theme.globalTokens.spacing[.medium] }

            case .paddingVertical:
                return .float { 11 }

            case .paddingTrailing:
                return .float { theme.globalTokens.spacing[.medium] }

            case .accessoryDisclosureIndicatorColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral4] }

            case .accessoryDetailButtonColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .mainBrandColor:
                return .dynamicColor { theme.globalTokens.brandColors[.primary] }

            case .destructiveTextColor:
                return .dynamicColor {
                    DynamicColor(light: ColorValue(0xD92C2C),
                                 dark: ColorValue(0xE83A3A))
                }

            case .communicationTextColor:
                return .dynamicColor {
                    DynamicColor(light: ColorValue(0x0078D4),
                                 dark: ColorValue(0x0086F0))
                }
            }
        }
    }

    /// Defines the size of the customView size.
    var customViewSize: () -> MSFTableViewCellCustomViewSize
}

/// Pre-defined sizes of the customView size.
@objc public enum MSFTableViewCellCustomViewSize: Int, CaseIterable {
    case `default`
    case zero
    case small
    case medium
}
