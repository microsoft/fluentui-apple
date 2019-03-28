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
 */
open class MSTableViewCell: UITableViewCell {
    @objc public enum CustomViewSize: Int {
        case `default`
        case zero
        case small
        case medium

        var size: CGSize {
            switch self {
            case .zero:
                return .zero
            case .small:
                return CGSize(width: 25, height: 25)
            case .medium, .default:
                return CGSize(width: 40, height: 40)
            }
        }
    }

    private enum LayoutType {
        case oneLine
        case twoLines
        case threeLines

        var customViewSize: CustomViewSize { return self == .oneLine ? .small : .medium }

        var subtitleTextStyle: MSTextStyle {
            switch self {
            case .oneLine, .twoLines:
                return Constants.subtitleTwoLineTextStyle
            case .threeLines:
                return Constants.subtitleThreeLineTextStyle
            }
        }

        var labelVerticalMargin: CGFloat {
            switch self {
            case .oneLine, .threeLines:
                return Constants.labelVerticalMarginForOneAndThreeLines
            case .twoLines:
                return Constants.labelVerticalMarginForTwoLines
            }
        }
    }

    private struct Constants {
        static let accessoryViewOffset: CGFloat = 3
        static let customViewMarginLeft: CGFloat = 16
        static let customViewMarginRight: CGFloat = 12
        static let detailButtonSize = CGSize(width: 44, height: 44)
        static let labelVerticalMarginForTwoLines: CGFloat = 10
        static let labelVerticalMarginForOneAndThreeLines: CGFloat = 11
        static let labelVerticalSpacing: CGFloat = 0
        static let labelMarginRight: CGFloat = 16
        static let titleTextStyle: MSTextStyle = .body
        static let subtitleTwoLineTextStyle: MSTextStyle = .footnote
        static let subtitleThreeLineTextStyle: MSTextStyle = .subhead
        static let footerTextStyle: MSTextStyle = .footnote
        static let minHeight: CGFloat = 44
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

    /**
     Use the appropriate left inset for the cell separator based on the size of the `customView` provided.

     `separatorLeftInsetForSmallCustomView` - For use when displaying a cell with a small size custom view.
     `separatorLeftInsetForMediumCustomView` - For use when displaying a cell with a medium size custom view.
     `separatorLeftInsetForNoCustomView` - For use when no custom view is provided.
     */
    @objc public static var separatorLeftInsetForSmallCustomView: CGFloat {
        return Constants.customViewMarginLeft + CustomViewSize.small.size.width + Constants.customViewMarginRight
    }
    @objc public static var separatorLeftInsetForMediumCustomView: CGFloat {
        return Constants.customViewMarginLeft + CustomViewSize.medium.size.width + Constants.customViewMarginRight
    }
    @objc public static var separatorLeftInsetForNoCustomView: CGFloat {
        return Constants.customViewMarginLeft
    }

    /// The height of the cell based on the height of its content.
    ///
    /// - Parameters:
    ///   - title: The title string
    ///   - subtitle: The subtitle string
    ///   - footer: The footer string
    ///   - customViewSize: The custom view size for the cell based on `MSTableViewCell.CustomViewSize`.
    ///   - accessoryType: The `MSTableViewCellAccessoryType` that the cell should display
    ///   - titleNumberOfLines: The number of lines that the title should display
    ///   - subtitleNumberOfLines: The number of lines that the subtitle should display
    ///   - footerNumberOfLines: The number of lines that the footer should display
    ///   - containerWidth: The width of the cell's super view (e.g. the table view's width)
    /// - Returns: a value representing the calculated height of the cell
    @objc public class func height(title: String, subtitle: String = "", footer: String = "", customViewSize: CustomViewSize = .default, accessoryType: MSTableViewCellAccessoryType = .none, titleNumberOfLines: Int = 1, subtitleNumberOfLines: Int = 1, footerNumberOfLines: Int = 1, containerWidth: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let layoutType: LayoutType = footer == "" ? (subtitle == "" ? .oneLine : .twoLines) : .threeLines
        let customViewSize = customViewSize == .default ? layoutType.customViewSize : customViewSize

        let textAreaLeftOffset = self.textAreaLeftOffset(customViewSize: customViewSize)
        let textAreaRightOffset = self.textAreaRightOffset(accessoryType: accessoryType)
        let textAreaWidth = containerWidth - (textAreaLeftOffset + textAreaRightOffset)

        var textAreaHeight = title.preferredSize(for: Constants.titleTextStyle.font, width: textAreaWidth, numberOfLines: titleNumberOfLines).height
        if layoutType == .twoLines || layoutType == .threeLines {
            textAreaHeight += subtitle.preferredSize(for: layoutType.subtitleTextStyle.font, width: textAreaWidth, numberOfLines: subtitleNumberOfLines).height
            textAreaHeight += Constants.labelVerticalSpacing

            if layoutType == .threeLines {
                textAreaHeight += footer.preferredSize(for: Constants.footerTextStyle.font, width: textAreaWidth, numberOfLines: footerNumberOfLines).height
                textAreaHeight += Constants.labelVerticalSpacing
            }
        }

        return max(layoutType.labelVerticalMargin * 2 + textAreaHeight, Constants.minHeight)
    }

    private static func textAreaLeftOffset(customViewSize: CustomViewSize) -> CGFloat {
        var textAreaLeftOffset = Constants.customViewMarginLeft
        if customViewSize != .zero {
            textAreaLeftOffset += customViewSize.size.width + Constants.customViewMarginRight
        }
        return textAreaLeftOffset
    }

    private static func textAreaRightOffset(accessoryType: MSTableViewCellAccessoryType) -> CGFloat {
        return accessoryType != .none ? MSTableViewCellAccessoryView.size.width + Constants.accessoryViewOffset : Constants.labelMarginRight
    }

    /// The maximum number of lines to be shown for `title`
    @objc open var titleNumberOfLines: Int = 1 {
        didSet {
            titleLabel.numberOfLines = titleNumberOfLines
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    /// The maximum number of lines to be shown for `subtitle`
    @objc open var subtitleNumberOfLines: Int = 1 {
        didSet {
            subtitleLabel.numberOfLines = subtitleNumberOfLines
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    /// The maximum number of lines to be shown for `footer`
    @objc open var footerNumberOfLines: Int = 1 {
        didSet {
            footerLabel.numberOfLines = footerNumberOfLines
            setNeedsLayout()
            invalidateIntrinsicContentSize()
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
        return customView != nil ? layoutType.customViewSize : .zero
    }

    /// `onAccessoryTapped` is called when `detailButton` accessory view is tapped
    @objc open var onAccessoryTapped: (() -> Void)?
    /// `onSelected` is called when the cell is selected during `touchesEnded` event
    @objc open var onSelected: (() -> Void)?

    open override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: MSTableViewCell.height(
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
                customViewSize: customViewSize,
                accessoryType: customAccessoryType,
                titleNumberOfLines: titleNumberOfLines,
                subtitleNumberOfLines: subtitleNumberOfLines,
                footerNumberOfLines: footerNumberOfLines,
                containerWidth: width > 0 ? width : .infinity
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

    open override var separatorInset: UIEdgeInsets {
        get {
            var value = super.separatorInset
            // Enforce the left inset (required when cell is used outside of UITableView)
            value.left = separatorLeftInset
            return value
        }
        set { super.separatorInset = newValue }
    }

    private var separatorLeftInset: CGFloat {
        let separatorLeftOffset = safeAreaInsetsIfAvailable.left
        switch customViewSize {
        case .zero:
            return separatorLeftOffset + MSTableViewCell.separatorLeftInsetForNoCustomView
        case .small:
            return separatorLeftOffset + MSTableViewCell.separatorLeftInsetForSmallCustomView
        case .medium, .default:
            return separatorLeftOffset + MSTableViewCell.separatorLeftInsetForMediumCustomView
        }
    }

    private var layoutType: LayoutType = .oneLine

    private var customAccessoryType: MSTableViewCellAccessoryType = .none {
        didSet {
            switch customAccessoryType {
            case .none:
                accessory = nil
            case .disclosureIndicator:
                accessory = MSTableViewCellAccessoryView(type: customAccessoryType)
            case .detailButton:
                accessory = MSTableViewCellAccessoryView(type: customAccessoryType)
                accessory?.onTapped = handleDetailButtonTapped
            }
        }
    }

    private var customView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let customView = customView {
                contentView.addSubview(customView)
                customView.accessibilityElementsHidden = true
            }
        }
    }

    private let titleLabel: MSLabel = {
        let label = MSLabel(style: Constants.titleTextStyle)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let subtitleLabel: MSLabel = {
        let label = MSLabel(style: Constants.subtitleTwoLineTextStyle, colorStyle: .secondary)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    private let footerLabel: MSLabel = {
        let label = MSLabel(style: Constants.footerTextStyle, colorStyle: .secondary)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    private var accessory: MSTableViewCellAccessoryView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessory = accessory {
                addSubview(accessory)
            }
        }
    }

    private var superTableView: UITableView? {
        return findSuperview(of: UITableView.self) as? UITableView
    }

    @objc public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(footerLabel)

        setupBackgroundColors()

        NotificationCenter.default.addObserver(self, selector: #selector(invalidateIntrinsicContentSize), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up the cell with text, a custom view, and an accessory type
    ///
    /// - Parameters:
    ///   - title: Text that appears as the first line of text
    ///   - subtitle: Text that appears as the second line of text
    ///   - footer: Text that appears as the third line of text
    ///   - customView: The custom view that appears near the leading edge next to the text
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc open func setup(title: String, subtitle: String = "", footer: String = "", customView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none) {
        layoutType = footer == "" ? (subtitle == "" ? .oneLine : .twoLines) : .threeLines

        titleLabel.text = title
        subtitleLabel.text = subtitle
        footerLabel.text = footer
        self.customView = customView
        customAccessoryType = accessoryType

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

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let customView = customView {
            let customViewYOffset = UIScreen.main.roundToDevicePixels((contentView.height - customViewSize.size.height) / 2)
            customView.frame = CGRect(
                origin: CGPoint(x: Constants.customViewMarginLeft, y: customViewYOffset),
                size: customViewSize.size
            )
        }

        let titleLeftOffset = MSTableViewCell.textAreaLeftOffset(customViewSize: customViewSize)
        let titleRightOffset = MSTableViewCell.textAreaRightOffset(accessoryType: customAccessoryType)
        let titleWidth = contentView.width - (titleLeftOffset + titleRightOffset)
        let titleLineHeight = titleLabel.font.deviceLineHeightWithLeading
        let titleText = titleLabel.text ?? ""
        let titleHeight = titleText.preferredSize(for: titleLabel.font, width: titleWidth, numberOfLines: titleNumberOfLines).height
        let titleCenteredTopMargin = UIScreen.main.roundToDevicePixels((contentView.height - titleLineHeight) / 2)
        let titleTopOffset: CGFloat
        if layoutType != .oneLine || titleHeight > titleLineHeight {
            titleTopOffset = layoutType.labelVerticalMargin
        } else {
            titleTopOffset = titleCenteredTopMargin
        }
        titleLabel.frame = CGRect(
            x: titleLeftOffset,
            y: titleTopOffset,
            width: titleWidth,
            height: titleHeight
        )

        if layoutType == .twoLines || layoutType == .threeLines {
            let subtitleText = subtitleLabel.text ?? ""
            let subtitleHeight = subtitleText.preferredSize(for: subtitleLabel.font, width: titleWidth, numberOfLines: subtitleNumberOfLines).height
            subtitleLabel.frame = CGRect(
                x: titleLeftOffset,
                y: titleLabel.bottom + Constants.labelVerticalSpacing,
                width: titleWidth,
                height: subtitleHeight
            )

            if layoutType == .threeLines {
                let footerText = footerLabel.text ?? ""
                let footerHeight = footerText.preferredSize(for: footerLabel.font, width: titleWidth, numberOfLines: footerNumberOfLines).height
                footerLabel.frame = CGRect(
                    x: titleLeftOffset,
                    y: subtitleLabel.bottom + Constants.labelVerticalSpacing,
                    width: titleWidth,
                    height: footerHeight
                )
            }
        }

        if let accessory = accessory {
            let xOffset = contentView.width - MSTableViewCellAccessoryView.size.width - Constants.accessoryViewOffset
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.height - MSTableViewCellAccessoryView.size.height) / 2)
            accessory.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: MSTableViewCellAccessoryView.size)
        }

        updateSeparatorInset()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: size.width,
            height: MSTableViewCell.height(
                title: titleLabel.text ?? "",
                subtitle: subtitleLabel.text ?? "",
                footer: footerLabel.text ?? "",
                customViewSize: customViewSize,
                accessoryType: customAccessoryType,
                titleNumberOfLines: titleNumberOfLines,
                subtitleNumberOfLines: subtitleNumberOfLines,
                footerNumberOfLines: footerNumberOfLines,
                containerWidth: size.width
            )
        )
    }

    @available(iOS 11, *)
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        updateSeparatorInset()
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil {
            setSelected(true, animated: false)
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil {
            setSelected(false, animated: true)
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isSelected {
            onSelected?()
        }
        // If using cell within a superview other than UITableView override setSelected()
        if superTableView == nil {
            setSelected(false, animated: true)
        }
    }

    @objc private func handleDetailButtonTapped() {
        onAccessoryTapped?()
        if let tableView = superTableView, let indexPath = tableView.indexPath(for: self) {
            tableView.delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
        }
    }

    private func updateSeparatorInset() {
        separatorInset.left = separatorLeftInset
    }

    private func setupBackgroundColors() {
        backgroundColor = MSColors.TableViewCell.background

        let selectedStateBackgroundView = UIView()
        selectedStateBackgroundView.backgroundColor = MSColors.TableViewCell.backgroundSelected
        selectedBackgroundView = selectedStateBackgroundView
    }
}

// MARK: - MSTableViewCellAccessoryView

private class MSTableViewCellAccessoryView: UIView {
    private struct Constants {
        static let disclosureLeftOffset: CGFloat = 12
    }

    public static let size = CGSize(width: 44, height: 44)

    open override var intrinsicContentSize: CGSize { return MSTableViewCellAccessoryView.size }

    /// `onTapped` is called when `detailButton` is tapped
    @objc open var onTapped: (() -> Void)?

    public init(type: MSTableViewCellAccessoryType) {
        super.init(frame: .zero)

        switch type {
        case .none:
            break
        case .disclosureIndicator:
            let iconView = UIImageView(image: UIImage.staticImageNamed("disclosure"))
            iconView.frame.size = MSTableViewCellAccessoryView.size
            iconView.contentMode = .center
            addSubview(iconView)
            iconView.fitIntoSuperview(margins: UIEdgeInsets(top: 0, left: Constants.disclosureLeftOffset, bottom: 0, right: 0))
        case .detailButton:
            let button = UIButton(type: .custom)
            button.frame.size = MSTableViewCellAccessoryView.size
            button.setImage(UIImage.staticImageNamed("details"), for: .normal)
            button.contentMode = .center
            button.addTarget(self, action: #selector(handleonAccessoryTapped), for: .touchUpInside)
            button.accessibilityLabel = "Accessibility.TableViewCell.MoreActions.Label".localized
            button.accessibilityHint = "Accessibility.TableViewCell.MoreActions.Hint".localized
            addSubview(button)
            button.fitIntoSuperview()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return MSTableViewCellAccessoryView.size
    }

    @objc private func handleonAccessoryTapped() {
        onTapped?()
    }
}
