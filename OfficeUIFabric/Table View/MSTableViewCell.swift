//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTableViewCellAccessoryType

@objc public enum MSTableViewCellAccessoryType: Int {
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
            icon = UIImage.staticImageNamed(OfficeUIFabricFramework.usesFluentIcons ? "chevron-right-20x20" : "disclosure")?.imageFlippedForRightToLeftLayoutDirection()
        case .detailButton:
            icon = UIImage.staticImageNamed(OfficeUIFabricFramework.usesFluentIcons ? "more-24x24" : "details")
        case .checkmark:
            icon = UIImage.staticImageNamed(OfficeUIFabricFramework.usesFluentIcons ? "checkmark-24x24" : "checkmark-blue-20x20")
        }
        return icon?.withRenderingMode(.alwaysTemplate)
    }

    var iconColor: UIColor? {
        switch self {
        case .none:
            return nil
        case .disclosureIndicator:
            return MSColors.Table.Cell.accessoryDisclosureIndicator
        case .detailButton:
            return MSColors.Table.Cell.accessoryDetailButton
        case .checkmark:
            return MSColors.Table.Cell.accessoryCheckmark
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

// MARK: - MSTableViewCell

/**
 `MSTableViewCell` is used to present a cell with one, two, or three lines of text with an optional custom view and an accessory.

 The `title` is displayed as the first line of text with the `subtitle` as the second line and the `footer` the third line.

 If a `subtitle` and `footer` are not provided the cell will be configured as a "small" size cell showing only the `title` line of text and a smaller custom view.

 If a `subtitle` is provided and a `footer` is not provided the cell will display two lines of text and will leave space for the `title` if it is not provided.

 If a `footer` is provided the cell will display three lines of text and will leave space for the `subtitle` and `title` if they are not provided.

 If a `customView` is not provided the `customView` will be hidden and the displayed text will take up the empty space left by the hidden `customView`.

 Specify `accessoryType` on setup to show either a disclosure indicator or a `detailButton`. The `detailButton` will display a button with an ellipsis icon which can be configured by passing in a closure to the cell's `onAccessoryTapped` property or by implementing UITableViewDelegate's `accessoryButtonTappedForRowWith` method.

 NOTE: This cell implements its own custom separator. Make sure to remove the UITableViewCell built-in separator by setting `separatorStyle = .none` on your table view. To remove the cell's custom separator set `bottomSeparatorType` to `.none`.
 */
open class MSTableViewCell: UITableViewCell {
    @objc(MSTableViewCellCustomViewSize)
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
                return OfficeUIFabricFramework.usesFluentIcons ? CGSize(width: 24, height: 24) : CGSize(width: 25, height: 25)
            case .medium, .default:
                return CGSize(width: 40, height: 40)
            }
        }
        var rightMargin: CGFloat {
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

    @objc(MSTableViewCellSeparatorType)
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

        var subtitleTextStyle: MSTextStyle {
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
        static let title: MSTextStyle = .body
        static let subtitleTwoLines: MSTextStyle = .footnote
        static let subtitleThreeLines: MSTextStyle = .subhead
        static let footer: MSTextStyle = .footnote
    }

    private struct Constants {
        static let horizontalSpacing: CGFloat = 16

        static let paddingLeft: CGFloat = horizontalSpacing
        static let paddingRight: CGFloat = horizontalSpacing

        static let customAccessoryViewMarginLeft: CGFloat = 8

        static let labelVerticalMarginForOneAndThreeLines: CGFloat = 11
        static let labelVerticalMarginForTwoLines: CGFloat = 12
        static let labelVerticalSpacing: CGFloat = 0

        static let minHeight: CGFloat = 44

        static let selectionImageMarginRight: CGFloat = horizontalSpacing
        static let selectionImageOff = UIImage.staticImageNamed("selection-off")?.withRenderingMode(.alwaysTemplate)
        static let selectionImageOn = UIImage.staticImageNamed("selection-on")?.withRenderingMode(.alwaysTemplate)
        static let selectionImageSize = CGSize(width: 24, height: 24)
        static let selectionModeAnimationDuration: TimeInterval = 0.2

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

    /// The vertical margins for cells with one or three lines of text
    class var labelVerticalMarginForOneAndThreeLines: CGFloat { return Constants.labelVerticalMarginForOneAndThreeLines }
    /// The vertical margins for cells with two lines of text
    class var labelVerticalMarginForTwoLines: CGFloat { return Constants.labelVerticalMarginForTwoLines }

    private static var separatorLeftInsetForSmallCustomView: CGFloat {
        return Constants.paddingLeft + CustomViewSize.small.size.width + CustomViewSize.small.rightMargin
    }
    private static var separatorLeftInsetForMediumCustomView: CGFloat {
        return Constants.paddingLeft + CustomViewSize.medium.size.width + CustomViewSize.medium.rightMargin
    }
    private static var separatorLeftInsetForNoCustomView: CGFloat {
        return Constants.paddingLeft
    }

    /// The height of the cell based on the height of its content.
    ///
    /// - Parameters:
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - customViewSize: The custom view size for the cell based on `MSTableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `MSTableViewCellAccessoryType` that the cell should display
    ///   - titleNumberOfLines: The number of lines that the title should display
    ///   - subtitleNumberOfLines: The number of lines that the subtitle should display
    ///   - footerNumberOfLines: The number of lines that the footer should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - containerWidth: The width of the cell's super view (e.g. the table view's width)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the calculated height of the cell
    @objc public class func height(title: String, subtitle: String = "", footer: String = "", customViewSize: CustomViewSize = .default, customAccessoryView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none, titleNumberOfLines: Int = 1, subtitleNumberOfLines: Int = 1, footerNumberOfLines: Int = 1, customAccessoryViewExtendsToEdge: Bool = false, containerWidth: CGFloat = .greatestFiniteMagnitude, isInSelectionMode: Bool = false) -> CGFloat {
        var layoutType = self.layoutType(subtitle: subtitle, footer: footer)
        customViewSize.validateLayoutTypeForHeightCalculation(&layoutType)
        let customViewSize = self.customViewSize(from: customViewSize, layoutType: layoutType)

        let textAreaLeftOffset = self.textAreaLeftOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode)
        let textAreaRightOffset = self.textAreaRightOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType)
        let textAreaWidth = containerWidth - (textAreaLeftOffset + textAreaRightOffset)

        var textAreaHeight = title.preferredSize(for: TextStyles.title.font, width: textAreaWidth, numberOfLines: titleNumberOfLines).height
        if layoutType == .twoLines || layoutType == .threeLines {
            textAreaHeight += subtitle.preferredSize(for: layoutType.subtitleTextStyle.font, width: textAreaWidth, numberOfLines: subtitleNumberOfLines).height
            textAreaHeight += Constants.labelVerticalSpacing

            if layoutType == .threeLines {
                textAreaHeight += footer.preferredSize(for: TextStyles.footer.font, width: textAreaWidth, numberOfLines: footerNumberOfLines).height
                textAreaHeight += Constants.labelVerticalSpacing
            }
        }

        let labelVerticalMargin = layoutType == .twoLines ? labelVerticalMarginForTwoLines : labelVerticalMarginForOneAndThreeLines

        return max(labelVerticalMargin * 2 + textAreaHeight, Constants.minHeight)
    }

    /// The preferred width of the cell based on the width of its content.
    ///
    /// - Parameters:
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - customViewSize: The custom view size for the cell based on `MSTableViewCell.CustomViewSize`
    ///   - customAccessoryView: The custom accessory view that appears near the trailing edge of the cell
    ///   - accessoryType: The `MSTableViewCellAccessoryType` that the cell should display
    ///   - customAccessoryViewExtendsToEdge: Boolean defining whether custom accessory view is extended to the trailing edge of the cell or not (ignored when accessory type is not `.none`)
    ///   - isInSelectionMode: Boolean describing if the cell is in multi-selection mode which shows/hides a checkmark image on the leading edge
    /// - Returns: a value representing the preferred width of the cell
    @objc public class func preferredWidth(title: String, subtitle: String = "", footer: String = "", customViewSize: CustomViewSize = .default, customAccessoryView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none, customAccessoryViewExtendsToEdge: Bool = false, isInSelectionMode: Bool = false) -> CGFloat {
        let layoutType = self.layoutType(subtitle: subtitle, footer: footer)
        let customViewSize = self.customViewSize(from: customViewSize, layoutType: layoutType)

        let titleSize = title.preferredSize(for: TextStyles.title.font)
        let labelAreaWidth: CGFloat
        switch layoutType {
        case .oneLine:
            labelAreaWidth = titleSize.width
        case .twoLines:
            let subtitleSize = subtitle.preferredSize(for: TextStyles.subtitleTwoLines.font)
            labelAreaWidth = max(titleSize.width, subtitleSize.width)
        case .threeLines:
            let subtitleSize = subtitle.preferredSize(for: TextStyles.subtitleThreeLines.font)
            let footerSize = footer.preferredSize(for: TextStyles.footer.font)
            labelAreaWidth = max(titleSize.width, subtitleSize.width, footerSize.width)
        }

        return textAreaLeftOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode) +
            labelAreaWidth +
            textAreaRightOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType)
    }

    private static func layoutType(subtitle: String, footer: String) -> LayoutType {
        return footer == "" ? (subtitle == "" ? .oneLine : .twoLines) : .threeLines
    }

    private static func customViewSize(from size: CustomViewSize, layoutType: LayoutType) -> CustomViewSize {
        return size == .default ? layoutType.customViewSize : size
    }

    private static func selectionModeAreaWidth(isInSelectionMode: Bool) -> CGFloat {
        return isInSelectionMode ? Constants.selectionImageSize.width + Constants.selectionImageMarginRight : 0
    }

    private static func customViewLeftOffset(isInSelectionMode: Bool) -> CGFloat {
        return Constants.paddingLeft + selectionModeAreaWidth(isInSelectionMode: isInSelectionMode)
    }

    private static func textAreaLeftOffset(customViewSize: CustomViewSize, isInSelectionMode: Bool) -> CGFloat {
        var textAreaLeftOffset = customViewLeftOffset(isInSelectionMode: isInSelectionMode)
        if customViewSize != .zero {
            textAreaLeftOffset += customViewSize.size.width + customViewSize.rightMargin
        }
        return textAreaLeftOffset
    }

    private static func textAreaRightOffset(customAccessoryView: UIView?, customAccessoryViewExtendsToEdge: Bool, accessoryType: MSTableViewCellAccessoryType) -> CGFloat {
        let customAccessoryViewSpacing: CGFloat
        if let customAccessoryView = customAccessoryView {
            customAccessoryViewSpacing = customAccessoryView.width + Constants.customAccessoryViewMarginLeft
        } else {
            customAccessoryViewSpacing = 0
        }
        return customAccessoryViewSpacing + MSTableViewCell.customAccessoryViewRightOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: accessoryType)
    }

    private static func customAccessoryViewRightOffset(customAccessoryView: UIView?, customAccessoryViewExtendsToEdge: Bool, accessoryType: MSTableViewCellAccessoryType) -> CGFloat {
        if accessoryType != .none {
            return accessoryType.size.width
        }
        if customAccessoryView != nil && customAccessoryViewExtendsToEdge {
            return 0
        }
        return Constants.paddingRight
    }

    /// Text that appears as the first line of text
    @objc public var title: String { return titleLabel.text ?? "" }
    /// Text that appears as the second line of text
    @objc public var subtitle: String { return subtitleLabel.text ?? "" }
    /// Text that appears as the third line of text
    @objc public var footer: String { return footerLabel.text ?? "" }

    /// The maximum number of lines to be shown for `title`
    @objc open var titleNumberOfLines: Int {
        get {
            if titleNumberOfLinesForLargerDynamicType != MSTableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
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
            if subtitleNumberOfLinesForLargerDynamicType != MSTableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
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
            if footerNumberOfLinesForLargerDynamicType != MSTableViewCell.defaultNumberOfLinesForLargerDynamicType && preferredContentSizeIsLargerThanDefault {
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
            initAccessoryView()
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
            return super.accessibilityHint
        }
        set {
            super.accessibilityHint = newValue
        }
    }

    // swiftlint:disable identifier_name
    var _accessoryType: MSTableViewCellAccessoryType = .none {
        didSet {
            if _accessoryType == oldValue {
                return
            }
            _accessoryView = _accessoryType == .none ? nil : MSTableViewCellAccessoryView(type: _accessoryType)
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    // swiftlint:enable identifier_name

    private var layoutType: LayoutType = .oneLine

    private var preferredContentSizeIsLargerThanDefault: Bool {
        switch traitCollection.preferredContentSizeCategory {
        case .unspecified, .extraSmall, .small, .medium, .large:
            return false
        default:
            return true
        }
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

    let titleLabel: MSLabel = {
        let label = MSLabel(style: TextStyles.title)
        label.textColor = MSColors.Table.Cell.title
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let subtitleLabel: MSLabel = {
        let label = MSLabel(style: TextStyles.subtitleTwoLines)
        label.textColor = MSColors.Table.Cell.subtitle
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    let footerLabel: MSLabel = {
        let label = MSLabel(style: TextStyles.footer)
        label.textColor = MSColors.Table.Cell.footer
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    @objc open private(set) var customAccessoryView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let customAccessoryView = customAccessoryView {
                contentView.addSubview(customAccessoryView)
            }
        }
    }

    private var _accessoryView: MSTableViewCellAccessoryView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = _accessoryView {
                contentView.addSubview(accessoryView)
                initAccessoryView()
            }
        }
    }

    private var selectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()

    private let topSeparator = MSSeparator(style: .default, orientation: .horizontal)
    private let bottomSeparator = MSSeparator(style: .default, orientation: .horizontal)

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
    @objc open func setup(title: String, subtitle: String = "", footer: String = "", customView: UIView? = nil, customAccessoryView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none) {
        layoutType = MSTableViewCell.layoutType(subtitle: subtitle, footer: footer)

        titleLabel.text = title
        subtitleLabel.text = subtitle
        footerLabel.text = footer
        self.customView = customView
        self.customAccessoryView = customAccessoryView
        _accessoryType = accessoryType

        switch layoutType {
        case .oneLine:
            subtitleLabel.isHidden = true
            footerLabel.isHidden = true
        case .twoLines:
            subtitleLabel.isHidden = false
            footerLabel.isHidden = true
        case .threeLines:
            footerLabel.isHidden = false
            subtitleLabel.isHidden = false
        }

        subtitleLabel.style = layoutType.subtitleTextStyle

        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    /// Allows to change the accessory type without doing a full `setup`.
    @objc open func changeAccessoryType(to accessoryType: MSTableViewCellAccessoryType) {
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

        initAccessoryView()

        selectionStyle = isInSelectionMode ? .none : .default
    }

    open func layoutContentSubviews() {
        if isInSelectionMode {
            let selectionImageViewYOffset = UIScreen.main.roundToDevicePixels((contentView.height - Constants.selectionImageSize.height) / 2)
            selectionImageView.frame = CGRect(
                origin: CGPoint(x: Constants.paddingLeft, y: selectionImageViewYOffset),
                size: Constants.selectionImageSize
            )
        }

        if let customView = customView {
            let customViewYOffset = UIScreen.main.roundToDevicePixels((contentView.height - customViewSize.size.height) / 2)
            let customViewXOffset = MSTableViewCell.customViewLeftOffset(isInSelectionMode: isInSelectionMode)
            customView.frame = CGRect(
                origin: CGPoint(x: customViewXOffset, y: customViewYOffset),
                size: customViewSize.size
            )
        }

        let titleLeftOffset = MSTableViewCell.textAreaLeftOffset(customViewSize: customViewSize, isInSelectionMode: isInSelectionMode)
        let titleRightOffset = MSTableViewCell.textAreaRightOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: _accessoryType)
        let titleWidth = contentView.width - (titleLeftOffset + titleRightOffset)
        let titleText = titleLabel.text ?? ""
        let titleSize = titleText.preferredSize(for: titleLabel.font, width: titleWidth, numberOfLines: titleNumberOfLines)
        let titleLineHeight = titleLabel.font.deviceLineHeightWithLeading
        let titleCenteredTopMargin = UIScreen.main.roundToDevicePixels((contentView.height - titleLineHeight) / 2)
        let titleTopOffset: CGFloat
        if layoutType != .oneLine || titleSize.height > titleLineHeight {
            titleTopOffset = layoutType.labelVerticalMargin
        } else {
            titleTopOffset = titleCenteredTopMargin
        }
        titleLabel.frame = CGRect(
            x: titleLeftOffset,
            y: titleTopOffset,
            width: titleSize.width,
            height: titleSize.height
        )

        if layoutType == .twoLines || layoutType == .threeLines {
            let subtitleText = subtitleLabel.text ?? ""
            let subtitleSize = subtitleText.preferredSize(for: subtitleLabel.font, width: titleWidth, numberOfLines: subtitleNumberOfLines)
            subtitleLabel.frame = CGRect(
                x: titleLeftOffset,
                y: titleLabel.bottom + Constants.labelVerticalSpacing,
                width: subtitleSize.width,
                height: subtitleSize.height
            )

            if layoutType == .threeLines {
                let footerText = footerLabel.text ?? ""
                let footerSize = footerText.preferredSize(for: footerLabel.font, width: titleWidth, numberOfLines: footerNumberOfLines)
                footerLabel.frame = CGRect(
                    x: titleLeftOffset,
                    y: subtitleLabel.bottom + Constants.labelVerticalSpacing,
                    width: footerSize.width,
                    height: footerSize.height
                )
            }
        }

        if let customAccessoryView = customAccessoryView {
            let xOffset = contentView.width - titleRightOffset + Constants.customAccessoryViewMarginLeft
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.height - customAccessoryView.height) / 2)
            customAccessoryView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: customAccessoryView.frame.size)
        }

        if let accessoryView = _accessoryView {
            let xOffset = contentView.width - MSTableViewCell.customAccessoryViewRightOffset(customAccessoryView: customAccessoryView, customAccessoryViewExtendsToEdge: customAccessoryViewExtendsToEdge, accessoryType: _accessoryType)
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.height - _accessoryType.size.height) / 2)
            accessoryView.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: _accessoryType.size)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layoutContentSubviews()
        contentView.flipSubviewsForRTL()

        layoutSeparator(topSeparator, with: topSeparatorType, at: 0)
        layoutSeparator(bottomSeparator, with: bottomSeparatorType, at: height - bottomSeparator.height)
    }

    private func layoutSeparator(_ separator: MSSeparator, with type: SeparatorType, at verticalOffset: CGFloat) {
        separator.frame = CGRect(
            x: separatorLeftInset(for: type),
            y: verticalOffset,
            width: width - separatorLeftInset(for: type),
            height: separator.height
        )
        separator.flipForRTL()
    }

    func separatorLeftInset(for type: SeparatorType) -> CGFloat {
        guard type == .inset else {
            return 0
        }
        let baseOffset = safeAreaInsets.left + MSTableViewCell.selectionModeAreaWidth(isInSelectionMode: isInSelectionMode)
        switch customViewSize {
        case .zero:
            return baseOffset + MSTableViewCell.separatorLeftInsetForNoCustomView
        case .small:
            return baseOffset + MSTableViewCell.separatorLeftInsetForSmallCustomView
        case .medium, .default:
            return baseOffset + MSTableViewCell.separatorLeftInsetForMediumCustomView
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(
            width: min(
                type(of: self).preferredWidth(
                    title: titleLabel.text ?? "",
                    subtitle: subtitleLabel.text ?? "",
                    footer: footerLabel.text ?? "",
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

    open func selectionDidChange() { }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionImageView()
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

    private func initAccessoryView() {
        guard let accessoryView = _accessoryView else {
            return
        }

        if accessoryView.type == .detailButton {
            accessoryView.isUserInteractionEnabled = isEnabled && !isInSelectionMode
            accessoryView.onTapped = handleDetailButtonTapped
        }
    }

    private func setupBackgroundColors() {
        backgroundColor = MSColors.Table.Cell.background

        let selectedStateBackgroundView = UIView()
        selectedStateBackgroundView.backgroundColor = MSColors.Table.Cell.backgroundSelected
        selectedBackgroundView = selectedStateBackgroundView
    }

    private func updateAccessibility() {
        if isEnabled {
            accessibilityTraits.remove(.notEnabled)
        } else {
            accessibilityTraits.insert(.notEnabled)
        }
    }

    private func updateSelectionImageView() {
        selectionImageView.image = isSelected ? Constants.selectionImageOn : Constants.selectionImageOff
        selectionImageView.tintColor = isSelected ? MSColors.Table.Cell.selectionIndicatorOn : MSColors.Table.Cell.selectionIndicatorOff
    }

    private func updateSeparator(_ separator: MSSeparator, with type: SeparatorType) {
        separator.isHidden = type == .none
        setNeedsLayout()
    }

    @objc private func handleContentSizeCategoryDidChange() {
        updateTitleNumberOfLines()
        updateSubtitleNumberOfLines()
        updateFooterNumberOfLines()
    }
}

// MARK: - MSTableViewCellAccessoryView

private class MSTableViewCellAccessoryView: UIView {
    override var accessibilityElementsHidden: Bool { get { return !isUserInteractionEnabled } set { } }
    override var intrinsicContentSize: CGSize { return type.size }

    let type: MSTableViewCellAccessoryType

    /// `onTapped` is called when `detailButton` is tapped
    var onTapped: (() -> Void)?

    init(type: MSTableViewCellAccessoryType) {
        self.type = type
        super.init(frame: .zero)

        switch type {
        case .none:
            break
        case .disclosureIndicator, .checkmark:
            addIconView(type: type)
        case .detailButton:
            let button = UIButton(type: .custom)
            button.setImage(type.icon, for: .normal)
            button.frame.size = type.size
            button.contentMode = .center
            button.tintColor = type.iconColor
            button.accessibilityLabel = "Accessibility.TableViewCell.MoreActions.Label".localized
            button.accessibilityHint = "Accessibility.TableViewCell.MoreActions.Hint".localized
            button.addTarget(self, action: #selector(handleOnAccessoryTapped), for: .touchUpInside)

            addSubview(button)
            button.fitIntoSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return type.size
    }

    private func addIconView(type: MSTableViewCellAccessoryType) {
        let iconView = UIImageView(image: type.icon)
        iconView.frame.size = type.size
        iconView.contentMode = .center
        iconView.tintColor = type.iconColor
        addSubview(iconView)
        iconView.fitIntoSuperview()
    }

    @objc private func handleOnAccessoryTapped() {
        onTapped?()
    }
}
