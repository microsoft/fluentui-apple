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

    func iconColor(for window: UIWindow) -> UIColor? {
        switch self {
        case .none:
            return nil
        case .disclosureIndicator:
            return Colors.Table.Cell.accessoryDisclosureIndicator
        case .detailButton:
            return Colors.Table.Cell.accessoryDetailButton
        case .checkmark:
            return Colors.primary(for: window)
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

// MARK: - Table Colors

public extension Colors {
    internal struct Table {
        struct Cell {
            static var background: UIColor = surfacePrimary
            static var backgroundGrouped = UIColor(light: surfacePrimary, dark: surfaceSecondary)
            static var backgroundSelected: UIColor = surfaceTertiary
            static var image: UIColor = iconSecondary
            static var title: UIColor = textPrimary
            static var subtitle: UIColor = textSecondary
            static var footer: UIColor = textSecondary
            static var accessoryDisclosureIndicator: UIColor = iconSecondary
            static var accessoryDetailButton: UIColor = iconSecondary
            static var selectionIndicatorOff: UIColor = iconSecondary
        }

        struct ActionCell {
            static var textDestructive: UIColor = error
            static var textDestructiveHighlighted: UIColor = error.withAlphaComponent(0.4)
            static var textCommunication: UIColor = communicationBlue
            static var textCommunicationHighlighted: UIColor = communicationBlue.withAlphaComponent(0.4)
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
    @objc static var tableBackground: UIColor { return Table.background }
    @objc static var tableBackgroundGrouped: UIColor { return Table.backgroundGrouped }
    @objc static var tableCellBackground: UIColor { return Table.Cell.background }
    @objc static var tableCellBackgroundGrouped: UIColor { return Table.Cell.backgroundGrouped }
    @objc static var tableCellBackgroundSelected: UIColor { return Table.Cell.backgroundSelected }
    @objc static var tableCellImage: UIColor { return Table.Cell.image }
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
open class TableViewCell: UITableViewCell {
    @objc(MSFTableViewCellCustomViewSize)
    public enum CustomViewSize: Int {
        case `default`
        case zero
        case small
        case medium

        var size: CGSize {
            switch self {
            case .zero:
                return .zero
            case .small:
                return CGSize(width: 24, height: 24)
            case .medium, .default:
                return CGSize(width: 40, height: 40)
            }
        }
        var trailingMargin: CGFloat {
            switch self {
            case .zero:
                return 0
            case .small:
                return 16
            case .medium, .default:
                return 12
            }
        }

        fileprivate func validateLayoutTypeForHeightCalculation(_ layoutType: inout LayoutType) {
            if self == .medium && layoutType == .oneLine {
                layoutType = .twoLines
            }
        }
    }

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

        var customViewSize: CustomViewSize { return self == .oneLine ? .small : .medium }

        var subtitleTextStyle: TextStyle {
            switch self {
            case .oneLine, .twoLines:
                return TextStyles.subtitleTwoLines
            case .threeLines:
                return TextStyles.subtitleThreeLines
            }
        }

        var labelVerticalMargin: CGFloat {
            switch self {
            case .oneLine, .threeLines:
                return labelVerticalMarginForOneAndThreeLines
            case .twoLines:
                return labelVerticalMarginForTwoLines
            }
        }
    }

    struct TextStyles {
        static let title: TextStyle = .body
        static let subtitleTwoLines: TextStyle = .footnote
        static let subtitleThreeLines: TextStyle = .subhead
        static let footer: TextStyle = .footnote
    }

    private struct Constants {
        static let labelAccessoryViewMarginLeading: CGFloat = 8
        static let labelAccessoryViewMarginTrailing: CGFloat = 8

        static let customAccessoryViewMarginLeading: CGFloat = 8
        static let customAccessoryViewMinVerticalMargin: CGFloat = 6

        static let labelVerticalMarginForOneAndThreeLines: CGFloat = 11
        static let labelVerticalMarginForTwoLines: CGFloat = 12
        static let labelVerticalSpacing: CGFloat = 0

        static let minHeight: CGFloat = 48

        static let selectionImageMarginTrailing: CGFloat = horizontalSpacing
        static let selectionImageOff = UIImage.staticImageNamed("selection-off")
        static let selectionImageOn = UIImage.staticImageNamed("selection-on")
        static let selectionImageSize = CGSize(width: 24, height: 24)
        static let selectionModeAnimationDuration: TimeInterval = 0.2

        static let textAreaMinWidth: CGFloat = 100

        static let enabledAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.35
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

    @objc public static var identifier: String { return String(describing: self) }

    /// A constant representing the number of lines for a label in which no change will be made when the `preferredContentSizeCategory` returns a size greater than `.large`.
    @objc public static let defaultNumberOfLinesForLargerDynamicType: Int = -1

    /// The default horizontal spacing in the cell.
    @objc public static let horizontalSpacing: CGFloat = 16

    /// The default leading padding in the cell.
    @objc public static let defaultPaddingLeading: CGFloat = horizontalSpacing

    /// The default trailing padding in the cell.
    @objc public static let defaultPaddingTrailing: CGFloat = horizontalSpacing

    /// The vertical margins for cells with one or three lines of text
    class var labelVerticalMarginForOneAndThreeLines: CGFloat { return Constants.labelVerticalMarginForOneAndThreeLines }
    /// The vertical margins for cells with two lines of text
    class var labelVerticalMarginForTwoLines: CGFloat { return Constants.labelVerticalMarginForTwoLines }

    private var separatorLeadingInsetForSmallCustomView: CGFloat {
        return paddingLeading + CustomViewSize.small.size.width + CustomViewSize.small.trailingMargin
    }
    private var separatorLeadingInsetForMediumCustomView: CGFloat {
        return paddingLeading + CustomViewSize.medium.size.width + CustomViewSize.medium.trailingMargin
    }
    private var separatorLeadingInsetForNoCustomView: CGFloat {
        return paddingLeading
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
    ///   - paddingLeading: The cell's leading padding
    ///   - paddingTrailing: The cell's trailing padding
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
                                   customViewSize: CustomViewSize = .default,
                                   customAccessoryView: UIView? = nil,
                                   accessoryType: TableViewCellAccessoryType = .none,
                                   titleNumberOfLines: Int = 1,
                                   subtitleNumberOfLines: Int = 1,
                                   footerNumberOfLines: Int = 1,
                                   customAccessoryViewExtendsToEdge: Bool = false,
                                   containerWidth: CGFloat = .greatestFiniteMagnitude,
                                   isInSelectionMode: Bool = false,
                                   paddingLeading: CGFloat = defaultPaddingLeading,
                                   paddingTrailing: CGFloat = defaultPaddingTrailing) -> CGFloat {
        var layoutType = self.layoutType(subtitle: subtitle, footer: footer, subtitleLeadingAccessoryView: subtitleLeadingAccessoryView, subtitleTrailingAccessoryView: subtitleTrailingAccessoryView, footerLeadingAccessoryView: footerLeadingAccessoryView, footerTrailingAccessoryView: footerTrailingAccessoryView)
        customViewSize.validateLayoutTypeForHeightCalculation(&layoutType)
        let customViewSize = self.customViewSize(from: customViewSize, layoutType: layoutType)

        let textAreaLeadingOffset = self.textAreaLeadingOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading)
        let textAreaTrailingOffset = self.textAreaTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType, paddingTrailing: paddingTrailing)
        var textAreaWidth = containerWidth - (textAreaLeadingOffset + textAreaTrailingOffset)
        if textAreaWidth < Constants.textAreaMinWidth, let customAccessoryView = customAccessoryView {
            let oldAccessoryViewWidth = customAccessoryView.frame.width
            let availableWidth = oldAccessoryViewWidth - (Constants.textAreaMinWidth - textAreaWidth)
            customAccessoryView.frame.size = customAccessoryView.systemLayoutSizeFitting(CGSize(width: availableWidth, height: .infinity))
            textAreaWidth += oldAccessoryViewWidth - customAccessoryView.frame.width
        }

        let textAreaHeight = self.textAreaHeight(
            layoutType: layoutType,
            titleHeight: labelSize(text: title, font: TextStyles.title.font, numberOfLines: titleNumberOfLines, textAreaWidth: textAreaWidth, leadingAccessoryView: titleLeadingAccessoryView, trailingAccessoryView: titleTrailingAccessoryView).height,
            subtitleHeight: labelSize(text: subtitle, font: layoutType.subtitleTextStyle.font, numberOfLines: subtitleNumberOfLines, textAreaWidth: textAreaWidth, leadingAccessoryView: subtitleLeadingAccessoryView, trailingAccessoryView: subtitleTrailingAccessoryView).height,
            footerHeight: labelSize(text: footer, font: TextStyles.footer.font, numberOfLines: footerNumberOfLines, textAreaWidth: textAreaWidth, leadingAccessoryView: footerLeadingAccessoryView, trailingAccessoryView: footerTrailingAccessoryView).height
        )

        let labelVerticalMargin = layoutType == .twoLines ? labelVerticalMarginForTwoLines : labelVerticalMarginForOneAndThreeLines

        var minHeight = Constants.minHeight
        if let customAccessoryView = customAccessoryView {
            minHeight = max(minHeight, customAccessoryView.frame.height + 2 * Constants.customAccessoryViewMinVerticalMargin)
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
    ///   - paddingLeading: The cell's leading padding
    ///   - paddingTrailing: The cell's trailing padding
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
                                           customViewSize: CustomViewSize = .default,
                                           customAccessoryView: UIView? = nil,
                                           accessoryType: TableViewCellAccessoryType = .none,
                                           customAccessoryViewExtendsToEdge: Bool = false,
                                           isInSelectionMode: Bool = false,
                                           paddingLeading: CGFloat = defaultPaddingLeading,
                                           paddingTrailing: CGFloat = defaultPaddingTrailing) -> CGFloat {
        let layoutType = self.layoutType(subtitle: subtitle, footer: footer, subtitleLeadingAccessoryView: subtitleLeadingAccessoryView, subtitleTrailingAccessoryView: subtitleTrailingAccessoryView, footerLeadingAccessoryView: footerLeadingAccessoryView, footerTrailingAccessoryView: footerTrailingAccessoryView)
        let customViewSize = self.customViewSize(from: customViewSize, layoutType: layoutType)

        var textAreaWidth = labelPreferredWidth(text: title, font: TextStyles.title.font, leadingAccessoryView: titleLeadingAccessoryView, trailingAccessoryView: titleTrailingAccessoryView)
        if layoutType == .twoLines || layoutType == .threeLines {
            let subtitleWidth = labelPreferredWidth(text: subtitle, font: layoutType.subtitleTextStyle.font, leadingAccessoryView: subtitleLeadingAccessoryView, trailingAccessoryView: subtitleTrailingAccessoryView)
            textAreaWidth = max(textAreaWidth, subtitleWidth)
            if layoutType == .threeLines {
                let footerWidth = labelPreferredWidth(text: footer, font: TextStyles.footer.font, leadingAccessoryView: footerLeadingAccessoryView, trailingAccessoryView: footerTrailingAccessoryView)
                textAreaWidth = max(textAreaWidth, footerWidth)
            }
        }

        return textAreaLeadingOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading) +
            textAreaWidth +
            textAreaTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType, paddingTrailing: paddingTrailing)
    }

    private static func labelSize(text: String, font: UIFont, numberOfLines: Int, textAreaWidth: CGFloat, leadingAccessoryView: UIView?, trailingAccessoryView: UIView?) -> CGSize {
        let leadingAccessoryViewWidth = labelAccessoryViewSize(for: leadingAccessoryView).width
        let leadingAccessoryAreaWidth = labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryViewWidth)

        let trailingAccessoryViewWidth = labelAccessoryViewSize(for: trailingAccessoryView).width
        let trailingAccessoryAreaWidth = labelTrailingAccessoryAreaWidth(viewWidth: trailingAccessoryViewWidth, text: text)

        let availableWidth = textAreaWidth - (leadingAccessoryAreaWidth + trailingAccessoryAreaWidth)
        return text.preferredSize(for: font, width: availableWidth, numberOfLines: numberOfLines)
    }

    private static func labelPreferredWidth(text: String, font: UIFont, leadingAccessoryView: UIView?, trailingAccessoryView: UIView?) -> CGFloat {
        var labelWidth = text.preferredSize(for: font).width
        labelWidth += labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryView?.frame.width ?? 0) + labelTrailingAccessoryAreaWidth(viewWidth: trailingAccessoryView?.frame.width ?? 0, text: text)
        return labelWidth
    }

    private static func layoutType(subtitle: String, footer: String, subtitleLeadingAccessoryView: UIView?, subtitleTrailingAccessoryView: UIView?, footerLeadingAccessoryView: UIView?, footerTrailingAccessoryView: UIView?) -> LayoutType {
        if footer == "" && footerLeadingAccessoryView == nil && footerTrailingAccessoryView == nil {
            if subtitle == "" && subtitleLeadingAccessoryView == nil && subtitleTrailingAccessoryView == nil {
                return .oneLine
            }
            return .twoLines
        } else {
            return .threeLines
        }
    }

    private static func selectionModeAreaWidth(isInSelectionMode: Bool) -> CGFloat {
        return isInSelectionMode ? Constants.selectionImageSize.width + Constants.selectionImageMarginTrailing : 0
    }

    private static func customViewSize(from size: CustomViewSize, layoutType: LayoutType) -> CustomViewSize {
        return size == .default ? layoutType.customViewSize : size
    }

    private static func customViewLeadingOffset(isInSelectionMode: Bool, paddingLeading: CGFloat) -> CGFloat {
        return paddingLeading + selectionModeAreaWidth(isInSelectionMode: isInSelectionMode)
    }

    private static func textAreaLeadingOffset(customViewSize: CustomViewSize, isInSelectionMode: Bool, paddingLeading: CGFloat) -> CGFloat {
        var textAreaLeadingOffset = customViewLeadingOffset(isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading)
        if customViewSize != .zero {
            textAreaLeadingOffset += customViewSize.size.width + customViewSize.trailingMargin
        }

        return textAreaLeadingOffset
    }

    private static func textAreaTrailingOffset(customAccessoryView: UIView?, customAccessoryViewExtendsToEdge: Bool, accessoryType: TableViewCellAccessoryType, paddingTrailing: CGFloat) -> CGFloat {
        let customAccessoryViewAreaWidth: CGFloat
        if let customAccessoryView = customAccessoryView {
            // Trigger layout so we can have the frame calculated correctly at this point in time
            customAccessoryView.layoutIfNeeded()
            customAccessoryViewAreaWidth = customAccessoryView.frame.width + Constants.customAccessoryViewMarginLeading
        } else {
            customAccessoryViewAreaWidth = 0
        }

        return customAccessoryViewAreaWidth + TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType, paddingTrailing: paddingTrailing)
    }

    private static func textAreaHeight(layoutType: TableViewCell.LayoutType, titleHeight: @autoclosure () -> CGFloat, subtitleHeight: @autoclosure () -> CGFloat, footerHeight: @autoclosure () -> CGFloat) -> CGFloat {
        var textAreaHeight = titleHeight()
        if layoutType == .twoLines || layoutType == .threeLines {
            textAreaHeight += Constants.labelVerticalSpacing + subtitleHeight()

            if layoutType == .threeLines {
                textAreaHeight += Constants.labelVerticalSpacing + footerHeight()
            }
        }
        return textAreaHeight
    }

    private static func customAccessoryViewTrailingOffset(customAccessoryView: UIView?, customAccessoryViewExtendsToEdge: Bool, accessoryType: TableViewCellAccessoryType, paddingTrailing: CGFloat) -> CGFloat {
        if accessoryType != .none {
            return accessoryType.size.width
        }
        if customAccessoryView != nil && customAccessoryViewExtendsToEdge {
            return 0
        }
        return paddingTrailing
    }

    private static func labelTrailingAccessoryMarginLeading(text: String) -> CGFloat {
        return text == "" ? 0 : Constants.labelAccessoryViewMarginLeading
    }

    private static func labelLeadingAccessoryAreaWidth(viewWidth: CGFloat) -> CGFloat {
        return viewWidth != 0 ? viewWidth + Constants.labelAccessoryViewMarginTrailing : 0
    }

    private static func labelTrailingAccessoryAreaWidth(viewWidth: CGFloat, text: String) -> CGFloat {
        return viewWidth != 0 ? labelTrailingAccessoryMarginLeading(text: text) + viewWidth : 0
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
    @objc public var paddingLeading: CGFloat = defaultPaddingLeading {
        didSet {
            if oldValue != paddingLeading {
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
    }

    /// The trailing padding.
    @objc public var paddingTrailing: CGFloat = defaultPaddingTrailing {
        didSet {
            if oldValue != paddingTrailing {
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
    }

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

    /// Override to set a specific `CustomViewSize` on the `customView`
    @objc open var customViewSize: CustomViewSize {
        get {
            if customView == nil {
                return .zero
            }
            return _customViewSize == .default ? layoutType.customViewSize : _customViewSize
        }
        set {
            if _customViewSize == newValue {
                return
            }
            _customViewSize = newValue
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    private var _customViewSize: CustomViewSize = .default

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

    /// When `isEnabled` is `false`, disables ability for a user to interact with a cell and dims cell's contents
    @objc open var isEnabled: Bool = true {
        didSet {
            contentView.alpha = isEnabled ? Constants.enabledAlpha : Constants.disabledAlpha
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
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
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
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
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
            accessoryTypeView = _accessoryType == .none ? nil : TableViewCellAccessoryView(type: _accessoryType)
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

            subtitleLabel.style = layoutType.subtitleTextStyle

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
        let textAreaLeadingOffset = TableViewCell.textAreaLeadingOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading)
        let textAreaTrailingOffset = TableViewCell.textAreaTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: _accessoryType, paddingTrailing: paddingTrailing)
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
        let label = Label(style: TextStyles.title)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let subtitleLabel: Label = {
        let label = Label(style: TextStyles.subtitleTwoLines)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    let footerLabel: Label = {
        let label = Label(style: TextStyles.footer)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

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

    internal let topSeparator = Separator(style: .default, orientation: .horizontal)
    internal let bottomSeparator = Separator(style: .default, orientation: .horizontal)

    private var superTableView: UITableView? {
        return findSuperview(of: UITableView.self) as? UITableView
    }

    @objc public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        textLabel?.text = ""

        updateTextColors()

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(footerLabel)
        contentView.addSubview(selectionImageView)
        addSubview(topSeparator)
        addSubview(bottomSeparator)

        setupBackgroundColors()

        hideSystemSeparator()
        updateSeparator(topSeparator, with: topSeparatorType)
        updateSeparator(bottomSeparator, with: bottomSeparatorType)

        updateAccessibility()

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
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
    @objc open func setup(title: String, subtitle: String = "", footer: String = "", customView: UIView? = nil, customAccessoryView: UIView? = nil, accessoryType: TableViewCellAccessoryType = .none) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        footerLabel.text = footer
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
            UIView.animate(withDuration: Constants.selectionModeAnimationDuration, delay: 0, options: [.layoutSubviews], animations: layoutIfNeeded, completion: completion)
        } else {
            completion(true)
        }

        initAccessoryTypeView()

        selectionStyle = isInSelectionMode ? .none : .default
    }

    private var isUsingCustomTextColors: Bool = false

    public func updateTextColors() {
        if !isUsingCustomTextColors {
            titleLabel.textColor = Colors.Table.Cell.title
            subtitleLabel.textColor = Colors.Table.Cell.subtitle
            footerLabel.textColor = Colors.Table.Cell.footer
        }
    }

    /// To set color for title label
    /// - Parameter color: UIColor to set
    @objc public func setTitleLabelTextColor(color: UIColor) {
        titleLabel.textColor = color
        isUsingCustomTextColors = true
    }

    /// To set color for subTitle label
    /// - Parameter color: UIColor to set
    @objc public func setSubTitleLabelTextColor(color: UIColor) {
        subtitleLabel.textColor = color
        isUsingCustomTextColors = true
    }

    /// To set color for footer label
    /// - Parameter color: UIColor to set
    public func setFooterLabelTextColor(color: UIColor) {
        footerLabel.textColor = color
        isUsingCustomTextColors = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layoutContentSubviews()
        contentView.flipSubviewsForRTL()

        layoutSeparator(topSeparator, with: topSeparatorType, at: 0)
        layoutSeparator(bottomSeparator, with: bottomSeparatorType, at: frame.height - bottomSeparator.frame.height)
    }

    open func layoutContentSubviews() {
        if isInSelectionMode {
            let selectionImageViewYOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - Constants.selectionImageSize.height) / 2)
            selectionImageView.frame = CGRect(
                origin: CGPoint(x: paddingLeading, y: selectionImageViewYOffset),
                size: Constants.selectionImageSize
            )
        }

        if let customView = customView {
            let customViewYOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - customViewSize.size.height) / 2)
            let customViewXOffset = TableViewCell.customViewLeadingOffset(isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading)
            customView.frame = CGRect(
                origin: CGPoint(x: customViewXOffset, y: customViewYOffset),
                size: customViewSize.size
            )
        }

        layoutLabelViews(label: titleLabel, numberOfLines: titleNumberOfLines, topOffset: 0, leadingAccessoryView: titleLeadingAccessoryView, leadingAccessoryViewSize: titleLeadingAccessoryViewSize, trailingAccessoryView: titleTrailingAccessoryView, trailingAccessoryViewSize: titleTrailingAccessoryViewSize)

        if layoutType == .twoLines || layoutType == .threeLines {
            layoutLabelViews(label: subtitleLabel, numberOfLines: subtitleNumberOfLines, topOffset: titleLabel.frame.maxY + Constants.labelVerticalSpacing, leadingAccessoryView: subtitleLeadingAccessoryView, leadingAccessoryViewSize: subtitleLeadingAccessoryViewSize, trailingAccessoryView: subtitleTrailingAccessoryView, trailingAccessoryViewSize: subtitleTrailingAccessoryViewSize)

            if layoutType == .threeLines {
                layoutLabelViews(label: footerLabel, numberOfLines: footerNumberOfLines, topOffset: subtitleLabel.frame.maxY + Constants.labelVerticalSpacing, leadingAccessoryView: footerLeadingAccessoryView, leadingAccessoryViewSize: footerLeadingAccessoryViewSize, trailingAccessoryView: footerTrailingAccessoryView, trailingAccessoryViewSize: footerTrailingAccessoryViewSize)
            }
        }

        let textAreaHeight = TableViewCell.textAreaHeight(layoutType: layoutType, titleHeight: titleLabel.frame.height, subtitleHeight: subtitleLabel.frame.height, footerHeight: footerLabel.frame.height)
        let textAreaTopOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - textAreaHeight) / 2)
        adjustLabelViewsTop(by: textAreaTopOffset, label: titleLabel, leadingAccessoryView: titleLeadingAccessoryView, trailingAccessoryView: titleTrailingAccessoryView)
        adjustLabelViewsTop(by: textAreaTopOffset, label: subtitleLabel, leadingAccessoryView: subtitleLeadingAccessoryView, trailingAccessoryView: subtitleTrailingAccessoryView)
        adjustLabelViewsTop(by: textAreaTopOffset, label: footerLabel, leadingAccessoryView: footerLeadingAccessoryView, trailingAccessoryView: footerTrailingAccessoryView)

        if let customAccessoryView = customAccessoryView {
            let trailingOffset = TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: _accessoryType, paddingTrailing: paddingTrailing)
            let xOffset = contentView.frame.width - customAccessoryView.frame.width - trailingOffset
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - customAccessoryView.frame.height) / 2)
            customAccessoryView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: customAccessoryView.frame.size)
        }

        if let accessoryTypeView = accessoryTypeView {
            let xOffset = contentView.frame.width - TableViewCell.customAccessoryViewTrailingOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: _accessoryType, paddingTrailing: paddingTrailing)
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.frame.height - _accessoryType.size.height) / 2)
            accessoryTypeView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: _accessoryType.size)
        }
    }

    private func layoutLabelViews(label: UILabel, numberOfLines: Int, topOffset: CGFloat, leadingAccessoryView: UIView?, leadingAccessoryViewSize: CGSize, trailingAccessoryView: UIView?, trailingAccessoryViewSize: CGSize) {
        let textAreaLeadingOffset = TableViewCell.textAreaLeadingOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode, paddingLeading: paddingLeading)

        let text = label.text ?? ""
        let size = text.preferredSize(for: label.font, width: textAreaWidth, numberOfLines: numberOfLines)

        if let leadingAccessoryView = leadingAccessoryView {
            let yOffset = UIScreen.main.roundToDevicePixels(topOffset + (size.height - leadingAccessoryViewSize.height) / 2)
            leadingAccessoryView.frame = CGRect(
                x: textAreaLeadingOffset,
                y: yOffset,
                width: leadingAccessoryViewSize.width,
                height: leadingAccessoryViewSize.height
            )
        }

        let leadingAccessoryAreaWidth = TableViewCell.labelLeadingAccessoryAreaWidth(viewWidth: leadingAccessoryViewSize.width)
        let labelSize = TableViewCell.labelSize(text: text, font: label.font, numberOfLines: numberOfLines, textAreaWidth: textAreaWidth, leadingAccessoryView: leadingAccessoryView, trailingAccessoryView: trailingAccessoryView)
        label.frame = CGRect(
            x: textAreaLeadingOffset + leadingAccessoryAreaWidth,
            y: topOffset,
            width: labelSize.width,
            height: labelSize.height
        )

        if let trailingAccessoryView = trailingAccessoryView {
            let yOffset = UIScreen.main.roundToDevicePixels(topOffset + (labelSize.height - trailingAccessoryViewSize.height) / 2)
            let availableWidth = textAreaWidth - labelSize.width - leadingAccessoryAreaWidth
            let leadingMargin = TableViewCell.labelTrailingAccessoryMarginLeading(text: text)
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

    private func layoutSeparator(_ separator: Separator, with type: SeparatorType, at verticalOffset: CGFloat) {
        separator.frame = CGRect(
            x: separatorLeadingInset(for: type),
            y: verticalOffset,
            width: frame.width - separatorLeadingInset(for: type),
            height: separator.frame.height
        )
        separator.flipForRTL()
    }

    func separatorLeadingInset(for type: SeparatorType) -> CGFloat {
        guard type == .inset else {
            return 0
        }
        let baseOffset = safeAreaInsets.left + TableViewCell.selectionModeAreaWidth(isInSelectionMode: isInSelectionMode)
        switch customViewSize {
        case .zero:
            return baseOffset + separatorLeadingInsetForNoCustomView
        case .small:
            return baseOffset + separatorLeadingInsetForSmallCustomView
        case .medium, .default:
            return baseOffset + separatorLeadingInsetForMediumCustomView
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
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(
            width: min(
                type(of: self).preferredWidth(
                    title: titleLabel.text ?? "",
                    subtitle: subtitleLabel.text ?? "",
                    footer: footerLabel.text ?? "",
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
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
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
                isInSelectionMode: isInSelectionMode,
                paddingLeading: paddingLeading,
                paddingTrailing: paddingTrailing
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
        updateSelectionImageColor()
    }

    open func selectionDidChange() { }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionImageView()
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
        backgroundColor = Colors.Table.Cell.background

        let selectedStateBackgroundView = UIView()
        selectedStateBackgroundView.backgroundColor = Colors.Table.Cell.backgroundSelected
        selectedBackgroundView = selectedStateBackgroundView
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
        if let window = window {
            selectionImageView.tintColor = isSelected ? Colors.primary(for: window) : Colors.Table.Cell.selectionIndicatorOff
        }
    }

    private func updateSeparator(_ separator: Separator, with type: SeparatorType) {
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

    init(type: TableViewCellAccessoryType) {
        self.type = type
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
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return type.size
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateWindowSpecificColors()
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

        if #available(iOS 13.4, *) {
            // Workaround check for beta iOS versions missing the Pointer Interactions API
            if arePointerInteractionAPIsAvailable() {
                button.isPointerInteractionEnabled = true
            }
        }

        return button
    }()

    private func updateWindowSpecificColors() {
        if let window = window {
            let iconColor = type.iconColor(for: window)
            iconView?.tintColor = customTintColor ?? iconColor
            if type == .detailButton {
                detailButton.tintColor = iconColor
            }
        }
    }
}
