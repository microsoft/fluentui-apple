//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TableViewCellAccessoryType

@objc(MSFTableViewCellAccessoryType)
public enum TableViewCellAccessoryType: Int {
    case none
    case disclosureIndicator
    case detailButton
    case checkmark

    private struct Constants {
        static let horizontalSpacing: CGFloat = 16
        static let height: CGFloat = 44
    }

    var icon: UIImage? {
        let icon: UIImage?
        switch self {
        case .none:
            icon = nil
        case .disclosureIndicator:
            icon = UIImage.staticImageNamed("iOS-chevron-right-20x20")
        case .detailButton:
            icon = UIImage.staticImageNamed("more-24x24")
        case .checkmark:
            icon = UIImage.staticImageNamed("checkmark-24x24")
        }
        return icon
    }

    func iconColor(tokens: TableViewCellTokens) -> UIColor? {
        switch self {
        case .none:
            return nil
        case .disclosureIndicator:
            return UIColor(dynamicColor: tokens.accessoryDisclosureIndicatorColor)
        case .detailButton:
            return UIColor(dynamicColor: tokens.accessoryDetailButtonColor)
        case .checkmark:
            return UIColor(dynamicColor: tokens.mainBrandColor)
        }
    }

    var size: CGSize {
        if self == .none {
            return .zero
        }
        // Horizontal spacing includes 16pt spacing from content to icon and 16pt spacing from icon to trailing edge of cell
        let horizontalSpacing: CGFloat = Constants.horizontalSpacing * 2
        let iconWidth: CGFloat = icon?.size.width ?? 0
        return CGSize(width: horizontalSpacing + iconWidth, height: Constants.height)
    }
}

// Different background color is used for `TableViewCell` by getting the appropriate tokens and integrate with the cell's `UIBackgroundConfiguration`
@objc(MSFTableViewCellBackgroundStyleType)
public enum TableViewCellBackgroundStyleType: Int {
    // use for flat list of cells
    case plain
    // use for grouped list of cells
    case grouped
    // clear background so that TableView's background can be shown
    case clear
    // in case clients want to override the background on their own without using token system
    case custom

    func defaultColor(tokens: TableViewCellTokens) -> UIColor? {
        switch self {
        case .plain:
            return UIColor(dynamicColor: tokens.cellBackgroundColor)
        case .grouped:
            return UIColor(dynamicColor: tokens.cellBackgroundGroupedColor)
        case .clear:
            return .clear
        case .custom:
            return nil
        }
    }
}

// MARK: - Table Colors

public extension Colors {
    internal struct Table {
        struct Cell {
            static var image: UIColor = iconSecondary
            static var title: UIColor = textPrimary
            static var subtitle: UIColor = textSecondary
        }

        struct HeaderFooter {
            static var accessoryButtonText: UIColor = textSecondary
            static var background: UIColor = .clear
            static var backgroundDivider: UIColor = surfaceSecondary
            static var text: UIColor = textSecondary
            static var textDivider: UIColor = textSecondary
            static var textLink = UIColor(light: Palette.communicationBlueShade10.color, dark: communicationBlue)
        }

        static var background: UIColor = surfacePrimary
        static var backgroundGrouped = UIColor(light: surfaceSecondary, dark: surfacePrimary)
    }

    // Objective-C support
    @objc static var tableBackground: UIColor { return surfacePrimary }
    @objc static var tableBackgroundGrouped: UIColor { return UIColor(light: surfaceSecondary, dark: surfacePrimary) }
    @objc static var tableCellBackground: UIColor { return surfacePrimary }
    @objc static var tableCellBackgroundGrouped: UIColor { return UIColor(light: surfacePrimary, dark: surfaceSecondary) }
    @objc static var tableCellBackgroundSelected: UIColor { return surfaceTertiary }
    @objc static var tableCellImage: UIColor { return iconSecondary }
}

// MARK: - TableViewCell

/**
`TableViewCell` is used to present a cell with one, two, or three lines of text with an optional custom view and an accessory.

The `title` is displayed as the first line of text with the `subtitle` as the second line and the `footer` the third line.

If a `subtitle` and `footer` are not provided the cell will be configured as a "small" size cell showing only the `title` line of text and a smaller custom view.

If a `subtitle` is provided and a `footer` is not provided the cell will display two lines of text and will leave space for the `title` if it is not provided.

If a `footer` is provided the cell will display three lines of text and will leave space for the `subtitle` and `title` if they are not provided.

If a `customView` is not provided the `customView` will be hidden and the displayed text will take up the empty space left by the hidden `customView`.

Specify `accessoryType` on setup to show either a disclosure indicator or a `detailButton`. The `detailButton` will display a button with an ellipsis icon which can be configured by passing in a closure to the cell's `onAccessoryTapped` property or by implementing UITableViewDelegate's `accessoryButtonTappedForRowWith` method.

NOTE: This cell implements its own custom separator. Make sure to remove the UITableViewCell built-in separator by setting `separatorStyle = .none` on your table view. To remove the cell's custom separator set `bottomSeparatorType` to `.none`.
*/
@objc(MSFTableViewCell)
open class TableViewCell: UITableViewCell, TokenizedControlInternal {
    @objc(MSFTableViewCellSeparatorType)
    public enum SeparatorType: Int {
        case none
        case inset
        case full
    }

    fileprivate enum LayoutType {
        case oneLine
        case twoLines
        case threeLines

        var customViewSize: MSFTableViewCellCustomViewSize { return self == .oneLine ? .small : .medium }
    }

    private struct Constants {
        static let labelVerticalMarginForOneAndThreeLines: CGFloat = 11

        static let selectionImageOff = UIImage.staticImageNamed("selection-off")
        static let selectionImageOn = UIImage.staticImageNamed("selection-on")
    }

    /**
     The height for the cell based on the text provided. Useful when `numberOfLines` of `title`, `subtitle`, `footer` is 1.
     `smallHeight` - Height for the cell when only the `title` is provided in a single line of text.
     `mediumHeight` - Height for the cell when only the `title` and `subtitle` are provided in 2 lines of text.
     `largeHeight` - Height for the cell when the `title`, `subtitle`, and `footer` are provided in 3 lines of text.
     */
    @objc public static var smallHeight: CGFloat { return height(title: "", customViewSize: .small) }
    @objc public static var mediumHeight: CGFloat { return height(title: "", subtitle: " ") }
    @objc public static var largeHeight: CGFloat { return height(title: "", subtitle: " ", footer: " ") }

    /// Identifier string for TableViewCell
    @objc public static var identifier: String { return String(describing: self) }

    /// A constant representing the number of lines for a label in which no change will be made when the `preferredContentSizeCategory` returns a size greater than `.large`.
    @objc public static let defaultNumberOfLinesForLargerDynamicType: Int = -1

    /// The default leading padding in the cell.
    @objc public static let defaultPaddingLeading: CGFloat = { TableViewCellTokens().paddingLeading }()

    /// The default trailing padding in the cell.
    @objc public static let defaultPaddingTrailing: CGFloat = { TableViewCellTokens().paddingTrailing }()

    /// The vertical margins for cells with one or three lines of text
    class var labelVerticalMarginForOneAndThreeLines: CGFloat { return Constants.labelVerticalMarginForOneAndThreeLines }

    // MARK: - TableViewCell TokenizedControl
    @objc public var tableViewCellOverrideTokens: TableViewCellTokens? {
        didSet {
            self.overrideTokens = tableViewCellOverrideTokens
        }
    }

    let defaultTokens: TableViewCellTokens = .init()
    var tokens: TableViewCellTokens = .init()
    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TableViewCellTokens? {
        didSet {
            updateTokens()
        }
    }

    public func overrideTokens(_ tokens: TableViewCellTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    @objc func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateTokens()
    }

    /// The height of the cell based on the height of its content.
    ///
    /// - Parameters:
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - titleLeadingAccessoryView: The accessory view on the leading edge of the title
    ///   - titleTrailingAccessoryView: The accessory view on the trailing edge of the title
    ///   - subtitleLeadingAccessoryView: The accessory view on the leading edge of the subtitle
    ///   - subtitleTrailingAccessoryView: The accessory view on the trailing edge of the subtitle
    ///   - footerLeadingAccessoryView: The accessory view on the leading edge of the footer
    ///   - footerTrailingAccessoryView: The accessory view on the trailing edge of the footer
    ///   - customViewSize: The custom view size for the cell based on `TableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `TableViewCellAccessoryType` that the cell should display
    ///   - titleNumberOfLines: The number of lines that the title should display
    ///   - subtitleNumberOfLines: The number of lines that the subtitle should display
    ///   - footerNumberOfLines: The number of lines that the footer should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - containerWidth: The width of the cell's super view (e.g. the table view's width)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the calculated height of the cell
    @objc public class func height(title: String,
                                   subtitle: String = "",
                                   footer: String = "",
                                   titleLeadingAccessoryView: UIView? = nil,
                                   titleTrailingAccessoryView: UIView? = nil,
                                   subtitleLeadingAccessoryView: UIView? = nil,
                                   subtitleTrailingAccessoryView: UIView? = nil,
                                   footerLeadingAccessoryView: UIView? = nil,
                                   footerTrailingAccessoryView: UIView? = nil,
                                   customViewSize: MSFTableViewCellCustomViewSize = .default,
                                   customAccessoryView: UIView? = nil,
                                   accessoryType: TableViewCellAccessoryType = .none,
                                   titleNumberOfLines: Int = 1,
                                   subtitleNumberOfLines: Int = 1,
                                   footerNumberOfLines: Int = 1,
                                   customAccessoryViewExtendsToEdge: Bool = false,
                                   containerWidth: CGFloat = .greatestFiniteMagnitude,
                                   isInSelectionMode: Bool = false) -> CGFloat {
        return self.height(tokens: .init(),
                           title: title,
                           subtitle: subtitle,
                           footer: footer,
                           titleFont: nil,
                           subtitleFont: nil,
                           footerFont: nil,
                           titleLeadingAccessoryView: titleLeadingAccessoryView,
                           titleTrailingAccessoryView: titleTrailingAccessoryView,
                           subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                           subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                           footerLeadingAccessoryView: footerLeadingAccessoryView,
                           footerTrailingAccessoryView: footerTrailingAccessoryView,
                           customViewSize: customViewSize,
                           customAccessoryView: customAccessoryView,
                           accessoryType: accessoryType,
                           titleNumberOfLines: titleNumberOfLines,
                           subtitleNumberOfLines: subtitleNumberOfLines,
                           footerNumberOfLines: footerNumberOfLines,
                           customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                           containerWidth: containerWidth,
                           isInSelectionMode: isInSelectionMode)
    }

    /// The height of the cell based on the height of its content.
    ///
    /// - Parameters:
    ///   - tokens: The TableViewCell tokens
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - attributedTitle: The attributed title
    ///   - attributedSubtitle: The attributed subtitle
    ///   - attributedFooter: The attributed footer
    ///   - isAttributedTitleSet: Boolean defining whether or not the `attributedTitle` has been set
    ///   - isAttributedSubtitleSet: Boolean defining whether or not the `attributedSubtitle` has been set
    ///   - isAttributedFooterSet: Boolean defining whether or not the `attributedFooter` has been set
    ///   - titleFont: The title font; If not set, it will default to the font definition in tokens
    ///   - subtitleFont: The subtitle font; If not set, it will default to the font definition in tokens
    ///   - footerFont: The footer font; If not set, it will default to the font definition in tokens
    ///   - titleLeadingAccessoryView: The accessory view on the leading edge of the title
    ///   - titleTrailingAccessoryView: The accessory view on the trailing edge of the title
    ///   - subtitleLeadingAccessoryView: The accessory view on the leading edge of the subtitle
    ///   - subtitleTrailingAccessoryView: The accessory view on the trailing edge of the subtitle
    ///   - footerLeadingAccessoryView: The accessory view on the leading edge of the footer
    ///   - footerTrailingAccessoryView: The accessory view on the trailing edge of the footer
    ///   - customViewSize: The custom view size for the cell based on `TableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `TableViewCellAccessoryType` that the cell should display
    ///   - titleNumberOfLines: The number of lines that the title should display
    ///   - subtitleNumberOfLines: The number of lines that the subtitle should display
    ///   - footerNumberOfLines: The number of lines that the footer should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - containerWidth: The width of the cell's super view (e.g. the table view's width)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the calculated height of the cell
    public class func height(tokens: TableViewCellTokens = .init(),
                             title: String,
                             subtitle: String = "",
                             footer: String = "",
                             attributedTitle: NSAttributedString? = nil,
                             attributedSubtitle: NSAttributedString? = nil,
                             attributedFooter: NSAttributedString? = nil,
                             isAttributedTitleSet: Bool = false,
                             isAttributedSubtitleSet: Bool = false,
                             isAttributedFooterSet: Bool = false,
                             titleFont: UIFont? = nil,
                             subtitleFont: UIFont? = nil,
                             footerFont: UIFont? = nil,
                             titleLeadingAccessoryView: UIView? = nil,
                             titleTrailingAccessoryView: UIView? = nil,
                             subtitleLeadingAccessoryView: UIView? = nil,
                             subtitleTrailingAccessoryView: UIView? = nil,
                             footerLeadingAccessoryView: UIView? = nil,
                             footerTrailingAccessoryView: UIView? = nil,
                             customViewSize: MSFTableViewCellCustomViewSize = .default,
                             customAccessoryView: UIView? = nil,
                             accessoryType: TableViewCellAccessoryType = .none,
                             titleNumberOfLines: Int = 1,
                             subtitleNumberOfLines: Int = 1,
                             footerNumberOfLines: Int = 1,
                             customAccessoryViewExtendsToEdge: Bool = false,
                             containerWidth: CGFloat = .greatestFiniteMagnitude,
                             isInSelectionMode: Bool = false) -> CGFloat {
        var layoutType = Self.layoutType(subtitle: subtitle,
                                         footer: footer,
                                         subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                                         subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                                         footerLeadingAccessoryView: footerLeadingAccessoryView,
                                         footerTrailingAccessoryView: footerTrailingAccessoryView)
        // Layout type should accommodate for the customViewSize, even if it is only one line.
        if customViewSize == .medium && layoutType == .oneLine {
            layoutType = .twoLines
        }
        let customViewSize = Self.customViewSize(from: customViewSize, layoutType: layoutType)

        let textAreaLeadingOffset = Self.textAreaLeadingOffset(customViewSize: customViewSize,
                                                               isInSelectionMode: isInSelectionMode,
                                                               tokens: tokens)
        let textAreaTrailingOffset = Self.textAreaTrailingOffset(customAccessoryView: customAccessoryView,
                                                                 customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                                                 accessoryType: accessoryType,
                                                                 paddingTrailing: tokens.paddingTrailing,
                                                                 customAccessoryViewMarginLeading: tokens.customAccessoryViewMarginLeading)
        var textAreaWidth = containerWidth - (textAreaLeadingOffset + textAreaTrailingOffset)
        let textAreaMinWidth = tokens.textAreaMinWidth
        let labelAccessoryViewMarginLeading = tokens.labelAccessoryViewMarginLeading
        let labelAccessoryViewMarginTrailing = tokens.labelAccessoryViewMarginTrailing
        if textAreaWidth < textAreaMinWidth, let customAccessoryView = customAccessoryView {
            let oldAccessoryViewWidth = customAccessoryView.frame.width
            let availableWidth = oldAccessoryViewWidth - (textAreaMinWidth - textAreaWidth)
            customAccessoryView.frame.size = customAccessoryView.systemLayoutSizeFitting(CGSize(width: availableWidth, height: .infinity))
            textAreaWidth += oldAccessoryViewWidth - customAccessoryView.frame.width
        }

        let textAreaHeight = Self.textAreaHeight(
            layoutType: layoutType,
            titleHeight: labelSize(text: title,
                                   attributedText: attributedTitle,
                                   isAttributedTextSet: isAttributedTitleSet,
                                   font: titleFont ?? UIFont.fluent(tokens.titleFont),
                                   numberOfLines: titleNumberOfLines,
                                   textAreaWidth: textAreaWidth,
                                   leadingAccessoryView: titleLeadingAccessoryView,
                                   labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading,
                                   trailingAccessoryView: titleTrailingAccessoryView,
                                   labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing).height,
            subtitleHeight: labelSize(text: subtitle,
                                      attributedText: attributedSubtitle,
                                      isAttributedTextSet: isAttributedSubtitleSet,
                                      font: subtitleFont ?? UIFont.fluent(layoutType == .twoLines ? tokens.subtitleTwoLinesFont : tokens.subtitleThreeLinesFont),
                                      numberOfLines: subtitleNumberOfLines,
                                      textAreaWidth: textAreaWidth,
                                      leadingAccessoryView: subtitleLeadingAccessoryView,
                                      labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading,
                                      trailingAccessoryView: subtitleTrailingAccessoryView,
                                      labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing).height,
            footerHeight: labelSize(text: footer,
                                    attributedText: attributedFooter,
                                    isAttributedTextSet: isAttributedFooterSet,
                                    font: footerFont ?? UIFont.fluent(tokens.subtitleThreeLinesFont),
                                    numberOfLines: footerNumberOfLines,
                                    textAreaWidth: textAreaWidth,
                                    leadingAccessoryView: footerLeadingAccessoryView,
                                    labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading,
                                    trailingAccessoryView: footerTrailingAccessoryView,
                                    labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing).height,
            labelVerticalSpacing: tokens.labelVerticalSpacing
        )

        let labelVerticalMargin = layoutType == .twoLines ? tokens.labelVerticalMarginForTwoLines : tokens.labelVerticalMarginForOneAndThreeLines

        var minHeight: CGFloat
        switch layoutType {
        case .oneLine:
            minHeight = tokens.minHeight
        case .twoLines:
            minHeight = tokens.mediumHeight
        case .threeLines:
            minHeight = tokens.largeHeight
        }
        if let customAccessoryView = customAccessoryView {
            minHeight = max(minHeight, customAccessoryView.frame.height + 2 * tokens.customAccessoryViewMinVerticalMargin)
        }
        return max(labelVerticalMargin * 2 + textAreaHeight, minHeight)
    }

    /// The preferred width of the cell based on the width of its content.
    ///
    /// - Parameters:
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - titleLeadingAccessoryView: The accessory view on the leading edge of the title
    ///   - titleTrailingAccessoryView: The accessory view on the trailing edge of the title
    ///   - subtitleLeadingAccessoryView: The accessory view on the leading edge of the subtitle
    ///   - subtitleTrailingAccessoryView: The accessory view on the trailing edge of the subtitle
    ///   - footerLeadingAccessoryView: The accessory view on the leading edge of the footer
    ///   - footerTrailingAccessoryView: The accessory view on the trailing edge of the footer
    ///   - customViewSize: The custom view size for the cell based on `TableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `TableViewCellAccessoryType` that the cell should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the preferred width of the cell
    @objc public class func preferredWidth(title: String,
                                           subtitle: String = "",
                                           footer: String = "",
                                           titleLeadingAccessoryView: UIView? = nil,
                                           titleTrailingAccessoryView: UIView? = nil,
                                           subtitleLeadingAccessoryView: UIView? = nil,
                                           subtitleTrailingAccessoryView: UIView? = nil,
                                           footerLeadingAccessoryView: UIView? = nil,
                                           footerTrailingAccessoryView: UIView? = nil,
                                           customViewSize: MSFTableViewCellCustomViewSize = .default,
                                           customAccessoryView: UIView? = nil,
                                           accessoryType: TableViewCellAccessoryType = .none,
                                           customAccessoryViewExtendsToEdge: Bool = false,
                                           isInSelectionMode: Bool = false) -> CGFloat {
        return self.preferredWidth(tokens: .init(),
                                   title: title,
                                   subtitle: subtitle,
                                   footer: footer,
                                   titleFont: nil,
                                   subtitleFont: nil,
                                   footerFont: nil,
                                   titleLeadingAccessoryView: titleLeadingAccessoryView,
                                   titleTrailingAccessoryView: titleTrailingAccessoryView,
                                   subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                                   subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                                   footerLeadingAccessoryView: footerLeadingAccessoryView,
                                   footerTrailingAccessoryView: footerTrailingAccessoryView,
                                   customViewSize: customViewSize,
                                   customAccessoryView: customAccessoryView,
                                   accessoryType: accessoryType,
                                   customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                   isInSelectionMode: isInSelectionMode)
    }

    /// The preferred width of the cell based on the width of its content.
    ///
    /// - Parameters:
    ///   - tokens: The TableViewCell tokens
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - attributedTitle: The attributed title
    ///   - attributedSubtitle: The attributed subtitle
    ///   - attributedFooter: The attributed footer
    ///   - isAttributedTitleSet: Boolean defining whether or not the `attributedTitle` has been set
    ///   - isAttributedSubtitleSet: Boolean defining whether or not the `attributedSubtitle` has been set
    ///   - isAttributedFooterSet: Boolean defining whether or not the `attributedFooter` has been set
    ///   - titleFont: The title font; If not set, it will default to the font definition in tokens
    ///   - subtitleFont: The subtitle font; If not set, it will default to the font definition in tokens
    ///   - footerFont: The footer font; If not set, it will default to the font definition in tokens
    ///   - titleLeadingAccessoryView: The accessory view on the leading edge of the title
    ///   - titleTrailingAccessoryView: The accessory view on the trailing edge of the title
    ///   - subtitleLeadingAccessoryView: The accessory view on the leading edge of the subtitle
    ///   - subtitleTrailingAccessoryView: The accessory view on the trailing edge of the subtitle
    ///   - footerLeadingAccessoryView: The accessory view on the leading edge of the footer
    ///   - footerTrailingAccessoryView: The accessory view on the trailing edge of the footer
    ///   - customViewSize: The custom view size for the cell based on `TableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `TableViewCellAccessoryType` that the cell should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the preferred width of the cell
    public class func preferredWidth(tokens: TableViewCellTokens = .init(),
                                     title: String,
                                     subtitle: String = "",
                                     footer: String = "",
                                     attributedTitle: NSAttributedString? = nil,
                                     attributedSubtitle: NSAttributedString? = nil,
                                     attributedFooter: NSAttributedString? = nil,
                                     isAttributedTitleSet: Bool = false,
                                     isAttributedSubtitleSet: Bool = false,
                                     isAttributedFooterSet: Bool = false,
                                     titleFont: UIFont? = nil,
                                     subtitleFont: UIFont? = nil,
                                     footerFont: UIFont? = nil,
                                     titleLeadingAccessoryView: UIView? = nil,
                                     titleTrailingAccessoryView: UIView? = nil,
                                     subtitleLeadingAccessoryView: UIView? = nil,
                                     subtitleTrailingAccessoryView: UIView? = nil,
                                     footerLeadingAccessoryView: UIView? = nil,
                                     footerTrailingAccessoryView: UIView? = nil,
                                     customViewSize: MSFTableViewCellCustomViewSize = .default,
                                     customAccessoryView: UIView? = nil,
                                     accessoryType: TableViewCellAccessoryType = .none,
                                     customAccessoryViewExtendsToEdge: Bool = false,
                                     isInSelectionMode: Bool = false) -> CGFloat {
        let layoutType = Self.layoutType(subtitle: subtitle,
                                         footer: footer,
                                         subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                                         subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                                         footerLeadingAccessoryView: footerLeadingAccessoryView,
                                         footerTrailingAccessoryView: footerTrailingAccessoryView)
        let customViewSize = Self.customViewSize(from: customViewSize, layoutType: layoutType)
        let labelAccessoryViewMarginLeading = tokens.labelAccessoryViewMarginLeading
        let labelAccessoryViewMarginTrailing = tokens.labelAccessoryViewMarginTrailing

        var textAreaWidth = Self.labelPreferredWidth(text: title,
                                                     attributedText: attributedTitle,
                                                     isAttributedTextSet: isAttributedTitleSet,
                                                     font: titleFont ?? UIFont.fluent(tokens.titleFont),
                                                     leadingAccessoryView: titleLeadingAccessoryView,
                                                     trailingAccessoryView: titleTrailingAccessoryView,
                                                     labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing,
                                                     labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading)
        if layoutType == .twoLines || layoutType == .threeLines {
            let subtitleWidth = Self.labelPreferredWidth(text: subtitle,
                                                         attributedText: attributedSubtitle,
                                                         isAttributedTextSet: isAttributedSubtitleSet,
                                                         font: subtitleFont ?? UIFont.fluent(layoutType == .twoLines ? tokens.subtitleTwoLinesFont : tokens.subtitleThreeLinesFont),
                                                         leadingAccessoryView: subtitleLeadingAccessoryView,
                                                         trailingAccessoryView: subtitleTrailingAccessoryView,
                                                         labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing,
                                                         labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading)
            textAreaWidth = max(textAreaWidth, subtitleWidth)
            if layoutType == .threeLines {
                let footerWidth = Self.labelPreferredWidth(text: footer,
                                                           attributedText: attributedFooter,
                                                           isAttributedTextSet: isAttributedFooterSet,
                                                           font: footerFont ?? UIFont.fluent(tokens.footerFont),
                                                           leadingAccessoryView: footerLeadingAccessoryView,
                                                           trailingAccessoryView: footerTrailingAccessoryView,
                                                           labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing,
                                                           labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading)
                textAreaWidth = max(textAreaWidth, footerWidth)
            }
        }

        return Self.textAreaLeadingOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode, tokens: tokens) + textAreaWidth +
        Self.textAreaTrailingOffset(customAccessoryView: customAccessoryView,
                                    customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                    accessoryType: accessoryType,
                                    paddingTrailing: tokens.paddingTrailing,
                                    customAccessoryViewMarginLeading: tokens.customAccessoryViewMarginLeading)
    }

    private static func labelSize(text: String,
                                  attributedText: NSAttributedString? = nil,
                                  isAttributedTextSet: Bool = false,
                                  font: UIFont,
                                  numberOfLines: Int,
                                  textAreaWidth: CGFloat,
                                  leadingAccessoryView: UIView?,
                                  labelAccessoryViewMarginLeading: CGFloat,
                                  trailingAccessoryView: UIView?,
                                  labelAccessoryViewMarginTrailing: CGFloat) -> CGSize {
        let leadingAccessoryViewWidth = Self.labelAccessoryViewSize(for: leadingAccessoryView).width
        let leadingAccessoryAreaWidth = Self.labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryViewWidth,
                                                                            labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing)

        let trailingAccessoryViewWidth = Self.labelAccessoryViewSize(for: trailingAccessoryView).width
        let trailingAccessoryAreaWidth = Self.labelTrailingAccessoryAreaWidth(viewWidth: trailingAccessoryViewWidth,
                                                                              text: text, labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading)

        let availableWidth = textAreaWidth - (leadingAccessoryAreaWidth + trailingAccessoryAreaWidth + labelAccessoryViewMarginTrailing)
        if isAttributedTextSet, let attributedText = attributedText {
            return preferredLabelSize(with: attributedText, availableTextWidth: availableWidth)
        }
        return text.preferredSize(for: font, width: availableWidth, numberOfLines: numberOfLines)
    }

    private static func preferredLabelSize(with attributedText: NSAttributedString,
                                           availableTextWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        // We need to have .usesDeviceMetrics to ensure that there is no trailing clipping in our label.
        // However, it causes the bottom portion of the label to be clipped instead. Creating a calculated CGRect
        // for width and height accommodates for both scenarios so that there is no clipping.
        let estimatedBoundsHeight = attributedText.boundingRect(
            with: CGSize(width: availableTextWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)

        // We want the larger width value so that the label does not undergo any trucation.
        return CGSize(width: ceil(availableTextWidth), height: ceil(estimatedBoundsHeight.height))

    }

    private static func labelPreferredWidth(text: String,
                                            attributedText: NSAttributedString? = nil,
                                            isAttributedTextSet: Bool = false,
                                            font: UIFont,
                                            leadingAccessoryView: UIView?,
                                            trailingAccessoryView: UIView?,
                                            labelAccessoryViewMarginTrailing: CGFloat,
                                            labelAccessoryViewMarginLeading: CGFloat) -> CGFloat {
        var labelWidth = text.preferredSize(for: font).width
        if isAttributedTextSet, let attributedText = attributedText {
            labelWidth = preferredLabelSize(with: attributedText).width
        } else {
            labelWidth = text.preferredSize(for: font).width
        }
        labelWidth += labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryView?.frame.width ?? 0,
                                                     labelAccessoryViewMarginTrailing: labelAccessoryViewMarginTrailing) +
        labelTrailingAccessoryAreaWidth(viewWidth: trailingAccessoryView?.frame.width ?? 0,
                                        text: text,
                                        labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading)
        return labelWidth
    }

    private static func layoutType(subtitle: String,
                                   footer: String,
                                   subtitleLeadingAccessoryView: UIView?,
                                   subtitleTrailingAccessoryView: UIView?,
                                   footerLeadingAccessoryView: UIView?,
                                   footerTrailingAccessoryView: UIView?) -> LayoutType {
        if footer == "" && footerLeadingAccessoryView == nil && footerTrailingAccessoryView == nil {
            if subtitle == "" && subtitleLeadingAccessoryView == nil && subtitleTrailingAccessoryView == nil {
                return .oneLine
            }
            return .twoLines
        } else {
            return .threeLines
        }
    }

    private static func selectionModeAreaWidth(isInSelectionMode: Bool,
                                               selectionImageMarginTrailing: CGFloat,
                                               selectionImageSize: CGFloat) -> CGFloat {
        return isInSelectionMode ? selectionImageSize + selectionImageMarginTrailing : 0
    }

    private static func customViewSize(from size: MSFTableViewCellCustomViewSize, layoutType: LayoutType) -> MSFTableViewCellCustomViewSize {
        return size == .default ? layoutType.customViewSize : size
    }

    private static func customViewLeadingOffset(isInSelectionMode: Bool,
                                                tokens: TableViewCellTokens) -> CGFloat {
        return tokens.paddingLeading + selectionModeAreaWidth(isInSelectionMode: isInSelectionMode,
                                                              selectionImageMarginTrailing: tokens.selectionImageMarginTrailing,
                                                              selectionImageSize: tokens.selectionImageSize.width)
    }

    private static func textAreaLeadingOffset(customViewSize: MSFTableViewCellCustomViewSize,
                                              isInSelectionMode: Bool,
                                              tokens: TableViewCellTokens) -> CGFloat {
        var textAreaLeadingOffset = customViewLeadingOffset(isInSelectionMode: isInSelectionMode, tokens: tokens)
        if customViewSize != .zero {
            textAreaLeadingOffset += tokens.customViewDimensions.width + tokens.customViewTrailingMargin
        }

        return textAreaLeadingOffset
    }

    private static func textAreaTrailingOffset(customAccessoryView: UIView?,
                                               customAccessoryViewExtendsToEdge: Bool,
                                               accessoryType: TableViewCellAccessoryType,
                                               paddingTrailing: CGFloat,
                                               customAccessoryViewMarginLeading: CGFloat) -> CGFloat {
        let customAccessoryViewAreaWidth: CGFloat
        if let customAccessoryView = customAccessoryView {
            // Trigger layout so we can have the frame calculated correctly at this point in time
            customAccessoryView.layoutIfNeeded()
            customAccessoryViewAreaWidth = customAccessoryView.frame.width + customAccessoryViewMarginLeading
        } else {
            customAccessoryViewAreaWidth = 0
        }

        return customAccessoryViewAreaWidth + TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView,
                                                                                              customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                                                                              accessoryType: accessoryType,
                                                                                              paddingTrailing: paddingTrailing)
    }

    private static func textAreaHeight(layoutType: TableViewCell.LayoutType,
                                       titleHeight: @autoclosure () -> CGFloat,
                                       subtitleHeight: @autoclosure () -> CGFloat,
                                       footerHeight: @autoclosure () -> CGFloat,
                                       labelVerticalSpacing: CGFloat) -> CGFloat {
        var textAreaHeight = titleHeight()
        if layoutType == .twoLines || layoutType == .threeLines {
            textAreaHeight += labelVerticalSpacing + subtitleHeight()

            if layoutType == .threeLines {
                textAreaHeight += labelVerticalSpacing + footerHeight()
            }
        }
        return textAreaHeight
    }

    private static func customAccessoryViewTrailingOffset(customAccessoryView: UIView?,
                                                          customAccessoryViewExtendsToEdge: Bool,
                                                          accessoryType: TableViewCellAccessoryType,
                                                          paddingTrailing: CGFloat) -> CGFloat {
        if accessoryType != .none {
            return accessoryType.size.width
        }
        if customAccessoryView != nil && customAccessoryViewExtendsToEdge {
            return 0
        }
        return paddingTrailing
    }

    private static func labelTrailingAccessoryMarginLeading(text: String, labelAccessoryViewMarginLeading: CGFloat) -> CGFloat {
        return text == "" ? 0 : labelAccessoryViewMarginLeading
    }

    private static func labelLeadingAccessoryAreaWidth(viewWidth: CGFloat, labelAccessoryViewMarginTrailing: CGFloat) -> CGFloat {
        return viewWidth != 0 ? viewWidth + labelAccessoryViewMarginTrailing : 0
    }

    private static func labelTrailingAccessoryAreaWidth(viewWidth: CGFloat,
                                                        text: String,
                                                        labelAccessoryViewMarginLeading: CGFloat) -> CGFloat {
        return viewWidth != 0 ? labelTrailingAccessoryMarginLeading(text: text, labelAccessoryViewMarginLeading: labelAccessoryViewMarginLeading) + viewWidth : 0
    }

    private static func labelAccessoryViewSize(for accessoryView: UIView?) -> CGSize {
        return accessoryView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? .zero
    }

    /// Text that appears as the first line of text
    @objc public var title: String { return titleLabel.text ?? "" }
    /// Text that appears as the second line of text
    @objc public var subtitle: String { return subtitleLabel.text ?? "" }
    /// Text that appears as the third line of text
    @objc public var footer: String { return footerLabel.text ?? "" }

    /// The leading padding.
    @objc public var paddingLeading: CGFloat {
        get {
            return _paddingLeading ?? tokens.paddingLeading
        }
        set {
            if newValue != _paddingLeading {
                _paddingLeading = newValue
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
    }
    private var _paddingLeading: CGFloat?

    /// The trailing padding.
    @objc public var paddingTrailing: CGFloat {
        get {
            return _paddingTrailing ?? tokens.paddingTrailing
        }
        set {
            if newValue != _paddingTrailing {
                _paddingTrailing = newValue
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
    }
    private var _paddingTrailing: CGFloat?

    /// The maximum number of lines to be shown for `title`
    @objc open var titleNumberOfLines: Int {
        get {
            if titleNumberOfLinesForLargerDynamicType != TableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
                return titleNumberOfLinesForLargerDynamicType
            }
            return _titleNumberOfLines
        }
        set {
            _titleNumberOfLines = newValue
            updateTitleNumberOfLines()
        }
    }
    private var _titleNumberOfLines: Int = 1

    /// The maximum number of lines to be shown for `subtitle`
    @objc open var subtitleNumberOfLines: Int {
        get {
            if subtitleNumberOfLinesForLargerDynamicType != TableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
                return subtitleNumberOfLinesForLargerDynamicType
            }
            return _subtitleNumberOfLines
        }
        set {
            _subtitleNumberOfLines = newValue
            updateSubtitleNumberOfLines()
        }
    }
    private var _subtitleNumberOfLines: Int = 1

    /// The maximum number of lines to be shown for `footer`
    @objc open var footerNumberOfLines: Int {
        get {
            if footerNumberOfLinesForLargerDynamicType != TableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
                return footerNumberOfLinesForLargerDynamicType
            }
            return _footerNumberOfLines
        }
        set {
            _footerNumberOfLines = newValue
            updateFooterNumberOfLines()
        }
    }
    private var _footerNumberOfLines: Int = 1

    /// The number of lines to show for the `title` if `preferredContentSizeCategory` is set to a size greater than `.large`. The default value indicates that no change will be made to the `title` and `titleNumberOfLines` will be used for all content sizes.
    @objc open var titleNumberOfLinesForLargerDynamicType: Int = defaultNumberOfLinesForLargerDynamicType {
        didSet {
            updateTitleNumberOfLines()
        }
    }
    /// The number of lines to show for the `subtitle` if `preferredContentSizeCategory` is set to a size greater than `.large`. The default value indicates that no change will be made to the `subtitle` and `subtitleNumberOfLines` will be used for all content sizes.
    @objc open var subtitleNumberOfLinesForLargerDynamicType: Int = defaultNumberOfLinesForLargerDynamicType {
        didSet {
            updateSubtitleNumberOfLines()
        }
    }
    /// The number of lines to show for the `footer` if `preferredContentSizeCategory` is set to a size greater than `.large`. The default value indicates that no change will be made to the `footer` and `footerNumberOfLines` will be used for all content sizes.
    @objc open var footerNumberOfLinesForLargerDynamicType: Int = defaultNumberOfLinesForLargerDynamicType {
        didSet {
            updateFooterNumberOfLines()
        }
    }

    /// Updates the lineBreakMode of the `title`
    @objc open var titleLineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            titleLabel.lineBreakMode = titleLineBreakMode
        }
    }
    /// Updates the lineBreakMode of the `subtitle`
    @objc open var subtitleLineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            subtitleLabel.lineBreakMode = subtitleLineBreakMode
        }
    }
    /// Updates the lineBreakMode of the `footer`
    @objc open var footerLineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            footerLabel.lineBreakMode = footerLineBreakMode
        }
    }

    /// The accessory view on the leading edge of the title
    @objc open var titleLeadingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: titleLeadingAccessoryView, size: &titleLeadingAccessoryViewSize)
        }
    }

    /// The accessory view on the trailing edge of the title
    @objc open var titleTrailingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: titleTrailingAccessoryView, size: &titleTrailingAccessoryViewSize)
        }
    }

    /// The accessory view on the leading edge of the subtitle
    @objc open var subtitleLeadingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: subtitleLeadingAccessoryView, size: &subtitleLeadingAccessoryViewSize)
        }
    }

    /// The accessory view on the trailing edge of the subtitle
    @objc open var subtitleTrailingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: subtitleTrailingAccessoryView, size: &subtitleTrailingAccessoryViewSize)
        }
    }

    /// The accessory view on the leading edge of the footer
    @objc open var footerLeadingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: footerLeadingAccessoryView, size: &footerLeadingAccessoryViewSize)
        }
    }

    /// The accessory view on the trailing edge of the footer
    @objc open var footerTrailingAccessoryView: UIView? {
        didSet {
            updateLabelAccessoryView(oldValue: oldValue, newValue: footerTrailingAccessoryView, size: &footerTrailingAccessoryViewSize)
        }
    }

    /// Override to set a specific `MSFTableViewCellCustomViewSize` on the `customView`
    @objc open var customViewSize: MSFTableViewCellCustomViewSize {
        get {
            if customView == nil {
                tokens.customViewSize = .zero
            } else {
                tokens.customViewSize = _customViewSize == .default ? layoutType.customViewSize : _customViewSize
            }
            return tokens.customViewSize
        }
        set {
            if _customViewSize == newValue {
                return
            }
            tokens.customViewSize = newValue
            _customViewSize = newValue
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    private var _customViewSize: MSFTableViewCellCustomViewSize = .default

    /// The custom accessory view of the TableViewCell.
    @objc open private(set) var customAccessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let customAccessoryView = customAccessoryView {
                if customAccessoryView is UISwitch {
                    customAccessoryView.isAccessibilityElement = false
                    customAccessoryView.accessibilityElementsHidden = true
                }
                contentView.addSubview(customAccessoryView)
            }
        }
    }

    /// Extends custom accessory view to the trailing edge of the cell. Ignored when accessory type is not `.none` since in this case the built-in accessory is placed at the edge of the cell preventing custom accessory view from extending.
    @objc open var customAccessoryViewExtendsToEdge: Bool = false {
        didSet {
            if customAccessoryViewExtendsToEdge == oldValue {
                return
            }
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    /// Style describing whether or not the cell's top separator should be visible and how wide it should extend
    @objc open var topSeparatorType: SeparatorType = .none {
        didSet {
            if topSeparatorType != oldValue {
                updateSeparator(topSeparator, with: topSeparatorType)
            }
        }
    }
    /// Style describing whether or not the cell's bottom separator should be visible and how wide it should extend
    @objc open var bottomSeparatorType: SeparatorType = .inset {
        didSet {
            if bottomSeparatorType != oldValue {
                updateSeparator(bottomSeparator, with: bottomSeparatorType)
            }
        }
    }

    @objc public var backgroundStyleType: TableViewCellBackgroundStyleType = .plain {
        didSet {
            if backgroundStyleType != oldValue {
                setupBackgroundColors()
            }
        }
    }

    /// When `isEnabled` is `false`, disables ability for a user to interact with a cell and dims cell's contents
    @objc open var isEnabled: Bool = true {
        didSet {
            contentView.alpha = isEnabled ? tokens.enabledAlpha : tokens.disabledAlpha
            isUserInteractionEnabled = isEnabled
            initAccessoryTypeView()
            updateAccessibility()
        }
    }

    /// Enables / disables multi-selection mode by showing / hiding a checkmark selection indicator on the leading edge
    @objc open var isInSelectionMode: Bool {
        get { return _isInSelectionMode }
        set { setIsInSelectionMode(newValue, animated: false) }
    }
    private var _isInSelectionMode: Bool = false

    /// `onAccessoryTapped` is called when `detailButton` accessory view is tapped
    @objc open var onAccessoryTapped: (() -> Void)?

    open override var intrinsicContentSize: CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                tokens: tokens,
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
                attributedTitle: titleLabel.attributedText,
                attributedSubtitle: subtitleLabel.attributedText,
                attributedFooter: footerLabel.attributedText,
                isAttributedTitleSet: isAttributedTitleSet,
                isAttributedSubtitleSet: isAttributedSubtitleSet,
                isAttributedFooterSet: isAttributedFooterSet,
                titleFont: titleLabel.font,
                subtitleFont: subtitleLabel.font,
                footerFont: footerLabel.font,
                titleLeadingAccessoryView: titleLeadingAccessoryView,
                titleTrailingAccessoryView: titleTrailingAccessoryView,
                subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                footerLeadingAccessoryView: footerLeadingAccessoryView,
                footerTrailingAccessoryView: footerTrailingAccessoryView,
                customViewSize: customViewSize,
                customAccessoryView: customAccessoryView,
                accessoryType: _accessoryType,
                customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                isInSelectionMode: isInSelectionMode
            ),
            height: type(of: self).height(
                tokens: tokens,
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
                attributedTitle: titleLabel.attributedText,
                attributedSubtitle: subtitleLabel.attributedText,
                attributedFooter: footerLabel.attributedText,
                isAttributedTitleSet: isAttributedTitleSet,
                isAttributedSubtitleSet: isAttributedSubtitleSet,
                isAttributedFooterSet: isAttributedFooterSet,
                titleFont: titleLabel.font,
                subtitleFont: subtitleLabel.font,
                footerFont: footerLabel.font,
                titleLeadingAccessoryView: titleLeadingAccessoryView,
                titleTrailingAccessoryView: titleTrailingAccessoryView,
                subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                footerLeadingAccessoryView: footerLeadingAccessoryView,
                footerTrailingAccessoryView: footerTrailingAccessoryView,
                customViewSize: customViewSize,
                customAccessoryView: customAccessoryView,
                accessoryType: _accessoryType,
                titleNumberOfLines: titleNumberOfLines,
                subtitleNumberOfLines: subtitleNumberOfLines,
                footerNumberOfLines: footerNumberOfLines,
                customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                containerWidth: .infinity,
                isInSelectionMode: isInSelectionMode
            )
        )
    }

    open override var bounds: CGRect {
        didSet {
            if bounds.width != oldValue.width {
                invalidateIntrinsicContentSize()
            }
        }
    }
    open override var frame: CGRect {
        didSet {
            if frame.width != oldValue.width {
                invalidateIntrinsicContentSize()
            }
        }
    }

    open override var accessibilityHint: String? {
        get {
            if isInSelectionMode && isEnabled {
                return "Accessibility.MultiSelect.Hint".localized
            }
            if let customSwitch = customAccessoryView as? UISwitch {
                if isEnabled && customSwitch.isEnabled {
                    return "Accessibility.TableViewCell.Switch.Hint".localized
                } else {
                    return nil
                }
            }
            return super.accessibilityHint
        }
        set { super.accessibilityHint = newValue }
    }

    open override var accessibilityValue: String? {
        get {
            if let customAccessoryView = customAccessoryView as? UISwitch {
                return (customAccessoryView.isOn ? "Accessibility.TableViewCell.Switch.On" : "Accessibility.TableViewCell.Switch.Off").localized
            }
            return super.accessibilityValue
        }
        set { super.accessibilityValue = newValue }
    }

    open override var accessibilityActivationPoint: CGPoint {
        get {
            if let customAccessoryView = customAccessoryView as? UISwitch {
                return contentView.convert(customAccessoryView.center, to: nil)
            }
            return super.accessibilityActivationPoint
        }
        set { super.accessibilityActivationPoint = newValue }
    }

    // swiftlint:disable identifier_name
    var _accessoryType: TableViewCellAccessoryType = .none {
        didSet {
            if _accessoryType == oldValue {
                return
            }
            accessoryTypeView = _accessoryType == .none ? nil : TableViewCellAccessoryView(type: _accessoryType, tokens: tokens)
            initAccessibilityForAccessoryType()
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    // swiftlint:enable identifier_name

    private var layoutType: LayoutType = .oneLine {
        didSet {
            subtitleLabel.isHidden = layoutType == .oneLine
            footerLabel.isHidden = layoutType != .threeLines

            updateFonts()

            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    private var preferredContentSizeIsLargerThanDefault: Bool {
        switch traitCollection.preferredContentSizeCategory {
        case .unspecified, .extraSmall, .small, .medium, .large:
            return false
        default:
            return true
        }
    }

    private var textAreaWidth: CGFloat {
        let textAreaLeadingOffset = TableViewCell.textAreaLeadingOffset(customViewSize: customViewSize,
                                                                        isInSelectionMode: isInSelectionMode,
                                                                        tokens: tokens)
        let textAreaTrailingOffset = TableViewCell.textAreaTrailingOffset(customAccessoryView: customAccessoryView,
                                                                          customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                                                          accessoryType: _accessoryType,
                                                                          paddingTrailing: paddingTrailing,
                                                                          customAccessoryViewMarginLeading: tokens.customAccessoryViewMarginLeading)
        return contentView.frame.width - (textAreaLeadingOffset + textAreaTrailingOffset)
    }

    private(set) var customView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let customView = customView {
                contentView.addSubview(customView)
                customView.accessibilityElementsHidden = true
            }
        }
    }

    let titleLabel: Label = {
        let label = Label()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let subtitleLabel: Label = {
        let label = Label()
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    let footerLabel: Label = {
        let label = Label()
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    private func updateFonts() {
        if !isAttributedTitleSet {
            titleLabel.font = UIFont.fluent(tokens.titleFont)
        }
        if !isAttributedSubtitleSet {
            subtitleLabel.font = UIFont.fluent(layoutType == .twoLines ? tokens.subtitleTwoLinesFont : tokens.subtitleThreeLinesFont)
        }
        if !isAttributedFooterSet {
            footerLabel.font = UIFont.fluent(tokens.footerFont)
        }
    }

    private func updateLabelAccessoryView(oldValue: UIView?, newValue: UIView?, size: inout CGSize) {
        if newValue == oldValue {
            return
        }
        oldValue?.removeFromSuperview()
        if let newValue = newValue {
            contentView.addSubview(newValue)
        }
        size = TableViewCell.labelAccessoryViewSize(for: newValue)
        updateLayoutType()
    }

    private var titleLeadingAccessoryViewSize: CGSize = .zero
    private var titleTrailingAccessoryViewSize: CGSize = .zero
    private var subtitleLeadingAccessoryViewSize: CGSize = .zero
    private var subtitleTrailingAccessoryViewSize: CGSize = .zero
    private var footerLeadingAccessoryViewSize: CGSize = .zero
    private var footerTrailingAccessoryViewSize: CGSize = .zero

    internal var accessoryTypeView: TableViewCellAccessoryView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryTypeView = accessoryTypeView {
                contentView.addSubview(accessoryTypeView)
                initAccessoryTypeView()
            }
        }
    }

    private var selectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()

    internal let topSeparator = MSFDivider()
    internal let bottomSeparator = MSFDivider()

    private var superTableView: UITableView? {
        return findSuperview(of: UITableView.self) as? UITableView
    }

    /// Initializes TableViewCell with the cell style.
    @objc public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let tokens = TableViewCellTokens()
        self.tokens = tokens

        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open func initialize() {
        textLabel?.text = ""

        updateTextColors()
        updateFonts()

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(footerLabel)
        contentView.addSubview(selectionImageView)
        contentView.addSubview(topSeparator)
        contentView.addSubview(bottomSeparator)

        setupBackgroundColors()

        hideSystemSeparator()
        updateSeparator(topSeparator, with: topSeparatorType)
        updateSeparator(bottomSeparator, with: bottomSeparatorType)

        updateAccessibility()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleContentSizeCategoryDidChange),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    /// Sets up the cell with text, a custom view, a custom accessory view, and an accessory type
    ///
    /// - Parameters:
    ///   - title: Text that appears as the first line of text
    ///   - subtitle: Text that appears as the second line of text
    ///   - footer: Text that appears as the third line of text
    ///   - customView: The custom view that appears near the leading edge next to the text
    ///   - customAccessoryView: The view acting as an accessory view that appears on the trailing edge, next to the accessory type if provided
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc open func setup(title: String,
                          subtitle: String = "",
                          footer: String = "",
                          customView: UIView? = nil,
                          customAccessoryView: UIView? = nil,
                          accessoryType: TableViewCellAccessoryType = .none) {
        setup(title: title,
              attributedTitle: nil,
              subtitle: subtitle,
              attributedSubtitle: nil,
              footer: footer,
              attributedFooter: nil,
              customView: customView,
              customAccessoryView: customAccessoryView,
              accessoryType: accessoryType)
    }

    /// Sets up the cell with text, a custom view, a custom accessory view, and an accessory type
    ///
    /// - Parameters:
    ///   - title: Text that appears as the first line of text
    ///   - attributedTitle: Optional attributed text for the first line of text. If this is not set, the title will be used
    ///   - subtitle: Text that appears as the second line of text
    ///   - attributedSubtitle: Optional attributed text for the second line of text. If this is not set, the subtitle will be used
    ///   - footer: Text that appears as the third line of text
    ///   - attributedFooter: Optional attributed text for the third line of text. If this is not set, the footer will be used
    ///   - customView: The custom view that appears near the leading edge next to the text
    ///   - customAccessoryView: The view acting as an accessory view that appears on the trailing edge, next to the accessory type if provided
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc open func setup(title: String = "",
                          attributedTitle: NSAttributedString? = nil,
                          subtitle: String = "",
                          attributedSubtitle: NSAttributedString? = nil,
                          footer: String = "",
                          attributedFooter: NSAttributedString? = nil,
                          customView: UIView? = nil,
                          customAccessoryView: UIView? = nil,
                          accessoryType: TableViewCellAccessoryType = .none) {
        if let attributedTitle = attributedTitle {
            self.attributedTitle = attributedTitle
            isAttributedTitleSet = true
        } else {
            self.attributedTitle = nil
            isAttributedTitleSet = false
            titleLabel.text = title
        }
        if let attributedSubtitle = attributedSubtitle {
            self.attributedSubtitle = attributedSubtitle
            isAttributedSubtitleSet = true
        } else {
            self.attributedSubtitle = nil
            isAttributedSubtitleSet = false
            subtitleLabel.text = subtitle
        }

        if let attributedFooter = attributedFooter {
            self.attributedFooter = attributedFooter
            isAttributedFooterSet = true
        } else {
            self.attributedFooter = nil
            isAttributedFooterSet = false
            footerLabel.text = footer
        }

        self.customView = customView
        self.customAccessoryView = customAccessoryView
        _accessoryType = accessoryType

        updateLayoutType()

        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    /// Allows to change the accessory type without doing a full `setup`.
    @objc open func changeAccessoryType(to accessoryType: TableViewCellAccessoryType) {
        _accessoryType = accessoryType
    }

    /// Sets the multi-selection state of the cell, optionally animating the transition between states.
    ///
    /// - Parameters:
    ///   - isInSelectionMode: true to set the cell as in selection mode, false to set it as not in selection mode. The default is false.
    ///   - animated: true to animate the transition in / out of selection mode, false to make the transition immediate.
    @objc open func setIsInSelectionMode(_ isInSelectionMode: Bool, animated: Bool) {
        if _isInSelectionMode == isInSelectionMode {
            return
        }

        _isInSelectionMode = isInSelectionMode

        if !isInSelectionMode {
            selectionImageView.isHidden = true
            isSelected = false
        }

        let completion = { (_: Bool) in
            if self.isInSelectionMode {
                self.updateSelectionImageView()
                self.selectionImageView.isHidden = false
            }
        }

        setNeedsLayout()
        invalidateIntrinsicContentSize()

        if animated {
            UIView.animate(withDuration: tokens.selectionModeAnimationDuration,
                           delay: 0,
                           options: [.layoutSubviews],
                           animations: layoutIfNeeded,
                           completion: completion)
        } else {
            completion(true)
        }

        initAccessoryTypeView()

        selectionStyle = isInSelectionMode ? .none : .default
    }

    private var isUsingCustomTextColors: Bool = false

    private var attributedTitle: NSAttributedString? {
        get {
            return titleLabel.attributedText
        }
        set {
            titleLabel.attributedText = newValue
            isAttributedTitleSet = newValue == nil ? false : true
        }
    }

    private var isAttributedTitleSet: Bool = false

    private var attributedSubtitle: NSAttributedString? {
        get {
            return subtitleLabel.attributedText
        }
        set {
            subtitleLabel.attributedText = newValue
            isAttributedSubtitleSet = newValue == nil ? false : true
        }
    }

    private var isAttributedSubtitleSet: Bool = false

    private var attributedFooter: NSAttributedString? {
        get {
            return footerLabel.attributedText
        }
        set {
            footerLabel.attributedText = newValue
            isAttributedFooterSet = newValue == nil ? false : true
        }
    }

    private var isAttributedFooterSet: Bool = false

    /// Updates label text colors.
    public func updateTextColors() {
        if !isUsingCustomTextColors {
            if !isAttributedTitleSet {
                titleLabel.textColor = UIColor(dynamicColor: tokens.titleColor)
            }
            if !isAttributedSubtitleSet {
                subtitleLabel.textColor = UIColor(dynamicColor: tokens.subtitleColor)
            }
            if !isAttributedFooterSet {
                footerLabel.textColor = UIColor(dynamicColor: tokens.footerColor)
            }
        }
    }

    /// To set color for title label
    /// - Parameter color: UIColor to set
    @available(*, deprecated, message: "Any color or stylistic changes on TableViewCell labels should be done through NSAttributedString (attributedTitle parameter of the setup method).")
    @objc public func setTitleLabelTextColor(color: UIColor) {
        titleLabel.textColor = color
        isUsingCustomTextColors = true
    }

    /// To set color for subTitle label
    /// - Parameter color: UIColor to set
    @available(*, deprecated, message: "Any color or stylistic changes on TableViewCell labels should be done through NSAttributedString (attributedSubtitle parameter of the setup method).")
    @objc public func setSubTitleLabelTextColor(color: UIColor) {
        subtitleLabel.textColor = color
        isUsingCustomTextColors = true
    }

    // Any color or stylistic changes on TableViewCell labels should be done through attributedFooter
    /// To set color for footer label
    /// - Parameter color: UIColor to set
    @available(*, deprecated, message: "Any color or stylistic changes on TableViewCell labels should be done through NSAttributedString (attributedFooter parameter of the setup method).")
    public func setFooterLabelTextColor(color: UIColor) {
        footerLabel.textColor = color
        isUsingCustomTextColors = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layoutContentSubviews()
        contentView.flipSubviewsForRTL()
    }

    open func layoutContentSubviews() {
        if isInSelectionMode {
            let selectionImageViewYOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - tokens.selectionImageSize.height) / 2)
            selectionImageView.frame = CGRect(
                origin: CGPoint(x: paddingLeading, y: selectionImageViewYOffset),
                size: tokens.selectionImageSize
            )
        }

        if let customView = customView {
            let customViewYOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - tokens.customViewDimensions.height) / 2)
            let customViewXOffset = TableViewCell.customViewLeadingOffset(isInSelectionMode: isInSelectionMode, tokens: tokens)
            customView.frame = CGRect(
                origin: CGPoint(x: customViewXOffset, y: customViewYOffset),
                size: tokens.customViewDimensions
            )
        }

        layoutLabelViews(label: titleLabel,
                         isAttributedTextSet: isAttributedTitleSet,
                         preferredHeight: tokens.titleHeight,
                         numberOfLines: titleNumberOfLines,
                         topOffset: 0,
                         leadingAccessoryView: titleLeadingAccessoryView,
                         leadingAccessoryViewSize: titleLeadingAccessoryViewSize,
                         trailingAccessoryView: titleTrailingAccessoryView,
                         trailingAccessoryViewSize: titleTrailingAccessoryViewSize)

        if layoutType == .twoLines || layoutType == .threeLines {
            layoutLabelViews(label: subtitleLabel,
                             isAttributedTextSet: isAttributedSubtitleSet,
                             preferredHeight: layoutType == .twoLines ? tokens.subtitleTwoLineHeight : tokens.subtitleThreeLineHeight,
                             numberOfLines: subtitleNumberOfLines,
                             topOffset: titleLabel.frame.maxY + tokens.labelVerticalSpacing,
                             leadingAccessoryView: subtitleLeadingAccessoryView,
                             leadingAccessoryViewSize: subtitleLeadingAccessoryViewSize,
                             trailingAccessoryView: subtitleTrailingAccessoryView,
                             trailingAccessoryViewSize: subtitleTrailingAccessoryViewSize)

            if layoutType == .threeLines {
                layoutLabelViews(label: footerLabel,
                                 isAttributedTextSet: isAttributedFooterSet,
                                 preferredHeight: tokens.footerHeight,
                                 numberOfLines: footerNumberOfLines,
                                 topOffset: subtitleLabel.frame.maxY + tokens.labelVerticalSpacing,
                                 leadingAccessoryView: footerLeadingAccessoryView,
                                 leadingAccessoryViewSize: footerLeadingAccessoryViewSize,
                                 trailingAccessoryView: footerTrailingAccessoryView,
                                 trailingAccessoryViewSize: footerTrailingAccessoryViewSize)
            }
        }

        let textAreaHeight = TableViewCell.textAreaHeight(layoutType: layoutType,
                                                          titleHeight: titleLabel.frame.height,
                                                          subtitleHeight: subtitleLabel.frame.height,
                                                          footerHeight: footerLabel.frame.height,
                                                          labelVerticalSpacing: tokens.labelVerticalSpacing)
        let textAreaTopOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - textAreaHeight) / 2)
        adjustLabelViewsTop(by: textAreaTopOffset,
                            label: titleLabel,
                            leadingAccessoryView: titleLeadingAccessoryView,
                            trailingAccessoryView: titleTrailingAccessoryView)
        adjustLabelViewsTop(by: textAreaTopOffset,
                            label: subtitleLabel,
                            leadingAccessoryView: subtitleLeadingAccessoryView,
                            trailingAccessoryView: subtitleTrailingAccessoryView)
        adjustLabelViewsTop(by: textAreaTopOffset,
                            label: footerLabel,
                            leadingAccessoryView: footerLeadingAccessoryView,
                            trailingAccessoryView: footerTrailingAccessoryView)

        if let customAccessoryView = customAccessoryView {
            let trailingOffset = TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView,
                                                                                 customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                                                                 accessoryType: _accessoryType,
                                                                                 paddingTrailing: paddingTrailing)
            let xOffset = contentView.frame.width - customAccessoryView.frame.width - trailingOffset
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - customAccessoryView.frame.height) / 2)
            customAccessoryView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: customAccessoryView.frame.size)
        }

        if let accessoryTypeView = accessoryTypeView {
            let xOffset = contentView.frame.width - TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView,
                                                                                                    customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                                                                                                    accessoryType: _accessoryType,
                                                                                                    paddingTrailing: paddingTrailing)
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - _accessoryType.size.height) / 2)
            accessoryTypeView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: _accessoryType.size)
        }

        layoutSeparator(topSeparator, with: topSeparatorType, at: 0)
        layoutSeparator(bottomSeparator, with: bottomSeparatorType, at: frame.height - bottomSeparator.state.thickness)
    }

    private func layoutLabelViews(label: UILabel,
                                  isAttributedTextSet: Bool = false,
                                  preferredHeight: CGFloat,
                                  numberOfLines: Int,
                                  topOffset: CGFloat,
                                  leadingAccessoryView: UIView?,
                                  leadingAccessoryViewSize: CGSize,
                                  trailingAccessoryView: UIView?,
                                  trailingAccessoryViewSize: CGSize) {
        let textAreaLeadingOffset = TableViewCell.textAreaLeadingOffset(customViewSize: customViewSize,
                                                                        isInSelectionMode: isInSelectionMode,
                                                                        tokens: tokens)
        let text = label.text ?? ""
        let size: CGSize
        let visibleText: String

        if isAttributedTextSet, let attributedText = label.attributedText {
            visibleText = attributedText.string
            size = Self.preferredLabelSize(with: attributedText, availableTextWidth: textAreaWidth)
        } else {
            visibleText = text
            size = text.preferredSize(for: label.font, width: textAreaWidth, numberOfLines: numberOfLines)
        }

        if let leadingAccessoryView = leadingAccessoryView {
            let yOffset = UIScreen.main.roundToDevicePixels(topOffset + (size.height - leadingAccessoryViewSize.height) / 2)
            leadingAccessoryView.frame = CGRect(
                x: textAreaLeadingOffset,
                y: yOffset,
                width: leadingAccessoryViewSize.width,
                height: leadingAccessoryViewSize.height
            )
        }

        let leadingAccessoryAreaWidth = TableViewCell.labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryViewSize.width,
                                                                                     labelAccessoryViewMarginTrailing: tokens.labelAccessoryViewMarginTrailing)
        let labelSize = TableViewCell.labelSize(text: text,
                                                attributedText: label.attributedText,
                                                isAttributedTextSet: isAttributedTextSet,
                                                font: label.font,
                                                numberOfLines: numberOfLines,
                                                textAreaWidth: textAreaWidth,
                                                leadingAccessoryView: leadingAccessoryView,
                                                labelAccessoryViewMarginLeading: tokens.labelAccessoryViewMarginLeading,
                                                trailingAccessoryView: trailingAccessoryView,
                                                labelAccessoryViewMarginTrailing: tokens.labelAccessoryViewMarginTrailing)
        label.frame = CGRect(
            x: textAreaLeadingOffset + leadingAccessoryAreaWidth,
            y: topOffset,
            width: labelSize.width,
            height: labelSize.height > preferredHeight ? labelSize.height : preferredHeight
        )

        if let trailingAccessoryView = trailingAccessoryView {
            let yOffset = UIScreen.main.roundToDevicePixels(topOffset + (labelSize.height - trailingAccessoryViewSize.height) / 2)
            let availableWidth = textAreaWidth - labelSize.width - leadingAccessoryAreaWidth
            let leadingMargin = TableViewCell.labelTrailingAccessoryMarginLeading(text: visibleText,
                                                                                  labelAccessoryViewMarginLeading: tokens.labelAccessoryViewMarginLeading)
            trailingAccessoryView.frame = CGRect(
                x: label.frame.maxX + leadingMargin,
                y: yOffset,
                width: availableWidth - leadingMargin,
                height: trailingAccessoryViewSize.height
            )
        }
    }

    private func adjustLabelViewsTop(by offset: CGFloat, label: UILabel, leadingAccessoryView: UIView?, trailingAccessoryView: UIView?) {
        label.frame.origin.y += offset
        leadingAccessoryView?.frame.origin.y += offset
        trailingAccessoryView?.frame.origin.y += offset
    }

    private func layoutSeparator(_ separator: MSFDivider, with type: SeparatorType, at verticalOffset: CGFloat) {
        separator.frame = CGRect(
            x: separatorLeadingInset(for: type),
            y: verticalOffset,
            width: frame.width - separatorLeadingInset(for: type),
            height: separator.state.thickness
        )
    }

    func separatorLeadingInset(for type: SeparatorType) -> CGFloat {
        switch type {
        case .none:
            return 0
        case .inset:
            let baseOffset = TableViewCell.selectionModeAreaWidth(isInSelectionMode: isInSelectionMode,
                                                                  selectionImageMarginTrailing: tokens.selectionImageMarginTrailing,
                                                                  selectionImageSize: tokens.selectionImageSize.width)
            return baseOffset + paddingLeading + tokens.customViewDimensions.width + tokens.customViewTrailingMargin
        case .full:
            return effectiveUserInterfaceLayoutDirection == .rightToLeft ? -safeAreaInsets.right : -safeAreaInsets.left
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        titleNumberOfLines = 1
        subtitleNumberOfLines = 1
        footerNumberOfLines = 1

        titleNumberOfLinesForLargerDynamicType = Self.defaultNumberOfLinesForLargerDynamicType
        subtitleNumberOfLinesForLargerDynamicType = Self.defaultNumberOfLinesForLargerDynamicType
        footerNumberOfLinesForLargerDynamicType = Self.defaultNumberOfLinesForLargerDynamicType

        titleLineBreakMode = .byTruncatingTail
        subtitleLineBreakMode = .byTruncatingTail
        footerLineBreakMode = .byTruncatingTail

        titleLeadingAccessoryView = nil
        titleTrailingAccessoryView = nil
        subtitleLeadingAccessoryView = nil
        subtitleTrailingAccessoryView = nil
        footerLeadingAccessoryView = nil
        footerTrailingAccessoryView = nil

        customViewSize = .default
        customAccessoryViewExtendsToEdge = false

        topSeparatorType = .none
        bottomSeparatorType = .inset

        isEnabled = true
        isInSelectionMode = false

        onAccessoryTapped = nil

        updateTokens()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(
            width: min(
                type(of: self).preferredWidth(
                    tokens: tokens,
                    title: titleLabel.text ?? "",
                    subtitle: subtitleLabel.text ?? "",
                    footer: footerLabel.text ?? "",
                    attributedTitle: titleLabel.attributedText,
                    attributedSubtitle: subtitleLabel.attributedText,
                    attributedFooter: footerLabel.attributedText,
                    isAttributedTitleSet: isAttributedTitleSet,
                    isAttributedSubtitleSet: isAttributedSubtitleSet,
                    isAttributedFooterSet: isAttributedFooterSet,
                    titleFont: titleLabel.font,
                    subtitleFont: subtitleLabel.font,
                    footerFont: footerLabel.font,
                    titleLeadingAccessoryView: titleLeadingAccessoryView,
                    titleTrailingAccessoryView: titleTrailingAccessoryView,
                    subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                    subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                    footerLeadingAccessoryView: footerLeadingAccessoryView,
                    footerTrailingAccessoryView: footerTrailingAccessoryView,
                    customViewSize: customViewSize,
                    customAccessoryView: customAccessoryView,
                    accessoryType: _accessoryType,
                    customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                    isInSelectionMode: isInSelectionMode
                ),
                maxWidth
            ),
            height: type(of: self).height(
                tokens: tokens,
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
                attributedTitle: titleLabel.attributedText,
                attributedSubtitle: subtitleLabel.attributedText,
                attributedFooter: footerLabel.attributedText,
                isAttributedTitleSet: isAttributedTitleSet,
                isAttributedSubtitleSet: isAttributedSubtitleSet,
                isAttributedFooterSet: isAttributedFooterSet,
                titleFont: titleLabel.font,
                subtitleFont: subtitleLabel.font,
                footerFont: footerLabel.font,
                titleLeadingAccessoryView: titleLeadingAccessoryView,
                titleTrailingAccessoryView: titleTrailingAccessoryView,
                subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
                subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
                footerLeadingAccessoryView: footerLeadingAccessoryView,
                footerTrailingAccessoryView: footerTrailingAccessoryView,
                customViewSize: customViewSize,
                customAccessoryView: customAccessoryView,
                accessoryType: _accessoryType,
                titleNumberOfLines: titleNumberOfLines,
                subtitleNumberOfLines: subtitleNumberOfLines,
                footerNumberOfLines: footerNumberOfLines,
                customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge,
                containerWidth: maxWidth,
                isInSelectionMode: isInSelectionMode
            )
        )
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil && !isInSelectionMode {
            setSelected(true, animated: false)
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let oldIsSelected = isSelected
        super.touchesCancelled(touches, with: event)
        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil {
            if isInSelectionMode {
                // Cell unselects itself in super.touchesCancelled which is not what we want in multi-selection mode - restore selection back
                setSelected(oldIsSelected, animated: false)
            } else {
                setSelected(false, animated: true)
            }
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if superTableView == nil && _isInSelectionMode {
            setSelected(!isSelected, animated: true)
        }

        selectionDidChange()

        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil && !isInSelectionMode {
            setSelected(false, animated: true)
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTokens()
    }

    private func updateTokens() {
        tokens = resolvedTokens
        updateFonts()
        updateTextColors()
        updateSelectionImageColor()
        setupBackgroundColors()
        updateAccessoryViewColor()
    }

    private func updateAccessoryViewColor() {
        accessoryTypeView?.tokens = tokens
    }

    open func selectionDidChange() { }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionImageView()
    }

    open override func updateConfiguration(using state: UICellConfigurationState) {
        if backgroundStyleType != .custom {
            // Customize the background color to use the tint color when the cell is highlighted or selected.
            if state.isHighlighted || state.isSelected || state.isFocused {
                backgroundConfiguration?.backgroundColor = UIColor(dynamicColor: tokens.cellBackgroundSelectedColor)
            } else {
                backgroundConfiguration?.backgroundColor = backgroundStyleType.defaultColor(tokens: tokens)
            }
        }
    }

    private func updateLayoutType() {
        layoutType = TableViewCell.layoutType(
            subtitle: subtitleLabel.text ?? "",
            footer: footerLabel.text ?? "",
            subtitleLeadingAccessoryView: subtitleLeadingAccessoryView,
            subtitleTrailingAccessoryView: subtitleTrailingAccessoryView,
            footerLeadingAccessoryView: footerLeadingAccessoryView,
            footerTrailingAccessoryView: footerTrailingAccessoryView
        )
    }

    private func updateTitleNumberOfLines() {
        titleLabel.numberOfLines = titleNumberOfLines
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    private func updateSubtitleNumberOfLines() {
        subtitleLabel.numberOfLines = subtitleNumberOfLines
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    private func updateFooterNumberOfLines() {
        footerLabel.numberOfLines = footerNumberOfLines
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    @objc private func handleDetailButtonTapped() {
        onAccessoryTapped?()
        if let tableView = superTableView, let indexPath = tableView.indexPath(for: self) {
            tableView.delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
        }
    }

    private func initAccessoryTypeView() {
        guard let accessoryTypeView = accessoryTypeView else {
            return
        }

        if accessoryTypeView.type == .detailButton {
            accessoryTypeView.isUserInteractionEnabled = isEnabled && !isInSelectionMode
            accessoryTypeView.onTapped = handleDetailButtonTapped
        }
    }

    private func setupBackgroundColors() {
        if backgroundStyleType != .custom {
            automaticallyUpdatesBackgroundConfiguration = false
            var backgroundConfiguration = UIBackgroundConfiguration.clear()
            backgroundConfiguration.backgroundColor = backgroundStyleType.defaultColor(tokens: tokens)
            self.backgroundConfiguration = backgroundConfiguration
        }
    }

    private func initAccessibilityForAccessoryType() {
        if _accessoryType == .checkmark || isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }
    }

    private func updateAccessibility() {
        accessibilityTraits.insert(.button)

        if isEnabled {
            accessibilityTraits.remove(.notEnabled)
        } else {
            accessibilityTraits.insert(.notEnabled)
        }
    }

    private func updateSelectionImageView() {
        selectionImageView.image = isSelected ? Constants.selectionImageOn : Constants.selectionImageOff
        updateSelectionImageColor()
    }

    private func updateSelectionImageColor() {
        selectionImageView.tintColor = UIColor(dynamicColor: isSelected ? tokens.mainBrandColor : tokens.selectionIndicatorOffColor)
    }

    private func updateSeparator(_ separator: MSFDivider, with type: SeparatorType) {
        separator.isHidden = type == .none
        setNeedsLayout()
    }

    @objc private func handleContentSizeCategoryDidChange() {
        updateTitleNumberOfLines()
        updateSubtitleNumberOfLines()
        updateFooterNumberOfLines()

        titleLeadingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: titleLeadingAccessoryView)
        titleTrailingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: titleTrailingAccessoryView)
        subtitleLeadingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: subtitleLeadingAccessoryView)
        subtitleTrailingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: subtitleTrailingAccessoryView)
        footerLeadingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: footerLeadingAccessoryView)
        footerTrailingAccessoryViewSize = TableViewCell.labelAccessoryViewSize(for: footerTrailingAccessoryView)

        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - TableViewCellAccessoryView

internal class TableViewCellAccessoryView: UIView {
    override var accessibilityElementsHidden: Bool { get { return !isUserInteractionEnabled } set { } }
    override var intrinsicContentSize: CGSize { return type.size }

    let type: TableViewCellAccessoryType
    var tokens: TableViewCellTokens {
        didSet {
            updateTintColor()
        }
    }
    var iconView: UIImageView?
    /// `onTapped` is called when `detailButton` is tapped
    var onTapped: (() -> Void)?
    var customTintColor: UIColor? {
        didSet {
            if let iconView = iconView {
                iconView.tintColor = customTintColor
            }
        }
    }

    init(type: TableViewCellAccessoryType, tokens: TableViewCellTokens) {
        self.type = type
        self.tokens = tokens
        super.init(frame: .zero)

        switch type {
        case .none:
            break
        case .disclosureIndicator, .checkmark:
            addIconView(type: type)
        case .detailButton:
            addSubview(detailButton)
            detailButton.fitIntoSuperview()
        }
        updateTintColor()
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return type.size
    }

    private func addIconView(type: TableViewCellAccessoryType) {
        iconView = UIImageView(image: type.icon)
        if let iconView = iconView {
            iconView.frame.size = type.size
            iconView.contentMode = .center
            addSubview(iconView)
            iconView.fitIntoSuperview()
        }
    }

    @objc private func handleOnAccessoryTapped() {
        onTapped?()
    }

    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(type.icon, for: .normal)
        button.frame.size = type.size
        button.contentMode = .center
        button.accessibilityLabel = "Accessibility.TableViewCell.MoreActions.Label".localized
        button.accessibilityHint = "Accessibility.TableViewCell.MoreActions.Hint".localized
        button.addTarget(self, action: #selector(handleOnAccessoryTapped), for: .touchUpInside)
        button.isPointerInteractionEnabled = true

        return button
    }()

    func updateTintColor() {
        iconView?.tintColor = customTintColor
        let iconColor = type.iconColor(tokens: tokens)
        iconView?.tintColor = customTintColor ?? iconColor
        if type == .detailButton {
            detailButton.tintColor = iconColor
        }
    }
}
