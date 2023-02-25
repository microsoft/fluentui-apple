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

        /// The main brand text color..
        case brandTextColor

        /// The brand background color for the boolean cell.
        case booleanCellBrandColor

        /// The danger text color in an ActionsCell.
        case dangerTextColor

        /// The communication text color in an ActionsCell.
        case communicationTextColor
    }

    init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        self.customViewSize = customViewSize
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.colors[.background1] }

            case .backgroundGroupedColor:
                return .dynamicColor { theme.aliasTokens.colors[.backgroundCanvas] }

            case .cellBackgroundColor:
                return .dynamicColor { theme.aliasTokens.colors[.background1] }

            case .cellBackgroundGroupedColor:
                return .dynamicColor { theme.aliasTokens.colors[.background3] }

            case .cellBackgroundSelectedColor:
                return .dynamicColor { theme.aliasTokens.colors[.background1Pressed] }

            case .imageColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground3] }

            case .customViewDimensions:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return 0.0
                    case .small:
                        return GlobalTokens.icon(.size240)
                    case .medium, .default:
                        return GlobalTokens.icon(.size400)
                    }
                }

            case .customViewTrailingMargin:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return GlobalTokens.spacing(.sizeNone)
                    case .small:
                        return GlobalTokens.spacing(.size160)
                    case .medium, .default:
                        return GlobalTokens.spacing(.size120)
                    }
                }

            case .titleColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground1] }

            case .subtitleColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground2] }

            case .footerColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground2] }

            case .selectionIndicatorOffColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground3] }

            case .titleFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }

            case .subtitleTwoLinesFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }

            case .subtitleThreeLinesFont:
                return .fontInfo { theme.aliasTokens.typography[.body2] }

            case .footerFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }

            case .accessoryDisclosureIndicatorColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground3] }

            case .accessoryDetailButtonColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground3] }

            case .dangerTextColor:
                return .dynamicColor { theme.aliasTokens.colors[.dangerForeground2] }

            case .brandTextColor:
                return .dynamicColor { theme.aliasTokens.colors[.brandForeground1] }

            case .booleanCellBrandColor:
                return .dynamicColor { theme.aliasTokens.colors[.brandBackground1] }

            case .communicationTextColor:
                return .dynamicColor {
                    DynamicColor(light: GlobalTokens.brandColors(.comm80),
                                 dark: GlobalTokens.brandColors(.comm100))
                }
            }
        }
    }

    /// Defines the size of the customView size.
    var customViewSize: () -> MSFTableViewCellCustomViewSize
}

// MARK: Constants

extension TableViewCellTokenSet {
    /// The minimum TableViewCell height; the height of a TableViewCell with one line of text.
    static let oneLineMinHeight: CGFloat = GlobalTokens.spacing(.size480)

    /// The height of a TableViewCell with two lines of text.
    static let twoLineMinHeight: CGFloat = 64.0

    /// The height of a TableViewCell with three lines of text.
    static let threeLineMinHeight: CGFloat = 84.0

    /// The default horizontal spacing in the cell.
    static let horizontalSpacing: CGFloat = GlobalTokens.spacing(.size160)

    /// The leading padding in the cell.
    static let paddingLeading: CGFloat = GlobalTokens.spacing(.size160)

    /// The vertical padding in the cell.
    static let paddingVertical: CGFloat = 11.0

    /// The trailing padding in the cell.
    static let paddingTrailing: CGFloat = GlobalTokens.spacing(.size160)

    /// The leading and trailing padding for the unreadDotLayer.
    static let unreadDotHorizontalPadding: CGFloat = GlobalTokens.spacing(.size40)

    /// The size dimensions of the unreadDotLayer.
    static let unreadDotDimensions: CGFloat = 8.0

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
    static let labelAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.size80)

    /// The trailing margin for the labelAccessoryView of the title label.
    static let titleLabelAccessoryViewMarginTrailing: CGFloat = GlobalTokens.spacing(.size80)

    /// The trailing margin for the labelAccessoryView of the subtitle label.
    static let subtitleLabelAccessoryViewMarginTrailing: CGFloat = GlobalTokens.spacing(.size40)

    /// The leading margin for the customAccessoryView.
    static let customAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.size80)

    /// The minimum vertical margin for the customAccessoryView.
    static let customAccessoryViewMinVerticalMargin: CGFloat = 6.0

    /// The vertical margin for the label when it has one or three lines.
    static let defaultLabelVerticalMarginForOneAndThreeLines: CGFloat = 11.0

    /// The vertical margin for the label when it has two lines.
    static let labelVerticalMarginForTwoLines: CGFloat = GlobalTokens.spacing(.size120)

    /// The vertical spacing for the label.
    static let labelVerticalSpacing: CGFloat = GlobalTokens.spacing(.sizeNone)

    /// The trailing margin for the selectionImage.
    static let selectionImageMarginTrailing: CGFloat = GlobalTokens.spacing(.size160)

    /// The size for the selectionImage.
    static let selectionImageSize: CGFloat = GlobalTokens.icon(.size240)

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
