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

        /// The leading padding in the cell.
        case paddingLeading
    }

    init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        self.customViewSize = customViewSize
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    .init(light: GlobalTokens.neutralColors(.white),
                          dark: GlobalTokens.neutralColors(.black))
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
                        return GlobalTokens.iconSize(.medium)
                    case .medium, .default:
                        return GlobalTokens.iconSize(.xxLarge)
                    }
                }

            case .customViewTrailingMargin:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return GlobalTokens.spacing(.none)
                    case .small:
                        return GlobalTokens.spacing(.medium)
                    case .medium, .default:
                        return GlobalTokens.spacing(.small)
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

            case .accessoryDisclosureIndicatorColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral4] }

            case .accessoryDetailButtonColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .mainBrandColor:
                return .dynamicColor { theme.aliasTokens.brandColors[.primary] }

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

            case .paddingLeading:
                return .float { GlobalTokens.spacing(.medium) }
            }
        }
    }

    /// Defines the size of the customView size.
    var customViewSize: () -> MSFTableViewCellCustomViewSize
}

// MARK: Constants

extension TableViewCellTokenSet {
    /// The minimum TableViewCell height; the height of a TableViewCell with one line of text.
    static let oneLineMinHeight: CGFloat = GlobalTokens.spacing(.xxxLarge)

    /// The height of a TableViewCell with two lines of text.
    static let twoLineMinHeight: CGFloat = 64.0

    /// The height of a TableViewCell with three lines of text.
    static let threeLineMinHeight: CGFloat = 84.0

    /// The default horizontal spacing in the cell.
    static let horizontalSpacing: CGFloat = GlobalTokens.spacing(.medium)

    /// The vertical padding in the cell.
    static let paddingVertical: CGFloat = 11.0

    /// The trailing padding in the cell.
    static let paddingTrailing: CGFloat = GlobalTokens.spacing(.medium)

    static let selectionImageOff = UIImage.staticImageNamed("selection-off")
    static let selectionImageOn = UIImage.staticImageNamed("selection-on")

    /// The minimum height for the title label.
    static let titleHeight: CGFloat = 22.0

    /// The minimum height for the subtitle label when the TableViewCell has two lines.
    static let subtitleTwoLineHeight: CGFloat = 18.0

    /// The minimum height for the subtitle label when the TableViewCell has three lines.
    static let subtitleThreeLineHeight: CGFloat = 20.0

    /// The minimum height for the footer label.
    static let footerHeight: CGFloat = 18.0

    /// The leading margin for the labelAccessoryView.
    static let labelAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.xSmall)

    /// The trailing margin for the labelAccessoryView.
    static let labelAccessoryViewMarginTrailing: CGFloat = GlobalTokens.spacing(.xSmall)

    /// The leading margin for the customAccessoryView.
    static let customAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.xSmall)

    /// The minimum vertical margin for the customAccessoryView.
    static let customAccessoryViewMinVerticalMargin: CGFloat = 6.0

    /// The vertical margin for the label when it has one or three lines.
    static let defaultLabelVerticalMarginForOneAndThreeLines: CGFloat = 11.0

    /// The vertical margin for the label when it has two lines.
    static let labelVerticalMarginForTwoLines: CGFloat = GlobalTokens.spacing(.small)

    /// The vertical spacing for the label.
    static let labelVerticalSpacing: CGFloat = GlobalTokens.spacing(.none)

    /// The trailing margin for the selectionImage.
    static let selectionImageMarginTrailing: CGFloat = GlobalTokens.spacing(.medium)

    /// The size for the selectionImage.
    static let selectionImageSize: CGFloat = GlobalTokens.iconSize(.medium)

    /// The duration for the selectionModeAnimation.
    static let selectionModeAnimationDuration: CGFloat = 0.2

    /// The minimum width for any text area.
    static let textAreaMinWidth: CGFloat = 100.0

    /// The alpha value that enables the user's ability to interact with a cell.
    static let enabledAlpha: CGFloat = 1.0

    /// The alpha value that disables the user's ability to interact with a cell; dims cell's contents.
    static let disabledAlpha: CGFloat = 0.35
}

/// Pre-defined sizes of the customView size.
@objc public enum MSFTableViewCellCustomViewSize: Int, CaseIterable {
    case `default`
    case zero
    case small
    case medium
}
