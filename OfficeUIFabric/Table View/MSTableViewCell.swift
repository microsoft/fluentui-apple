//
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
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

 If a `subtitle` and `footer` are not provided the cell will be configured as a "small" size cell showing only the `title` line of text and a smaller custom view. This cell should be configured with `smallHeight` for the height of the cell and `separatorLeftInsetForSmallCustomView` for the cell's separator left inset.

 If a `subtitle` is provided and a `footer` is not provided the cell will display two lines of text and will leave space for the `title` if it is not provided. Use `mediumHeight` for the height of the cell in this case.

 If a `footer` is provided the cell will display three lines of text and will leave space for the `subtitle` and `title` if they are not provided. Use `largeHeight` for the height of the cell in this case.

 If a `customView` is provided when the cell has either two or three lines of text use `separatorLeftInsetForMediumCustomView` for the cell's separator left inset. If a `customView` is not provided the `customView` will be hidden and the displayed text will take up the empty space left by the hidden `customView`. Use `separatorLeftInsetForNoCustomView` as the separator left inset to align the separator correctly to the displayed text.

 Specify `accessoryType` on setup to show either a disclosure indicator or a `detailButton`. The `detailButton` will display a button with an ellipsis icon which can be configured by passing in a closure to the cell's `onAccessoryTapped` property or by implementing UITableViewDelegate's `accessoryButtonTappedForRowWith` method.
 */
open class MSTableViewCell: UITableViewCell {
    @objc public enum CustomViewSize: Int {
        case small
        case medium

        var size: CGSize {
            switch self {
            case .small:
                return CGSize(width: 25, height: 25)
            case .medium:
                return CGSize(width: 40, height: 40)
            }
        }
    }

    private enum LayoutType {
        case oneLine
        case twoLines
        case threeLines
    }

    private struct Constants {
        static let accessoryViewSize = CGSize(width: 44, height: 44)
        static let accessoryViewOffset: CGFloat = 3
        static let customViewMarginLeft: CGFloat = 16
        static let customViewMarginRight: CGFloat = 12
        static let detailButtonSize = CGSize(width: 44, height: 44)
        static let labelVerticalSpacing: CGFloat = 2
        static let labelMarginRight: CGFloat = 16
    }

    // TODO: Make into static func that calculates height based on content and system settings to support multiline labels and large type for accessibility
    /**
     The height for the cell based on the text provided.

     `smallHeight` - Height for the cell when only the `title` is provided in a single line of text.
     `mediumHeight` - Height for the cell when only the `title` and `subtitle` are provided in 2 lines of text.
     `largeHeight` - Height for the cell when the `title`, `subtitle`, and `footer` are provided in 3 lines of text.
     */
    @objc public static let smallHeight: CGFloat = 44
    @objc public static let mediumHeight: CGFloat = 60
    @objc public static let largeHeight: CGFloat = 82

    @objc public static var identifier: String { return String(describing: self) }

    /**
     Use the appropriate left inset for the cell separator based on the size of the `customView` provided.

     `separatorLeftInsetForSmallCustomView` - For use when displaying one line of text in a cell with a custom view.
     `separatorLeftInsetForMediumCustomView` - For use when displaying two or three lines of text with a custom view.
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

    @objc open var customViewSize: CustomViewSize {
        return layoutType == .oneLine ? .small : .medium
    }

    /// `onAccessoryTapped` is called when `detailButton` accessory view is tapped
    @objc open var onAccessoryTapped: (() -> Void)?
    /// `onSelected` is called when the cell is selected during `touchesEnded` event
    @objc open var onSelected: (() -> Void)?

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
        if customView == nil {
            return MSTableViewCell.separatorLeftInsetForNoCustomView
        }

        switch customViewSize {
        case .small:
            return MSTableViewCell.separatorLeftInsetForSmallCustomView
        case .medium:
            return MSTableViewCell.separatorLeftInsetForMediumCustomView
        }
    }

    private var layoutType: LayoutType = .oneLine

    private var customView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let customView = customView {
                contentView.addSubview(customView)
                customView.accessibilityElementsHidden = true
            }
        }
    }

    // TODO: Add multiline text support to title, subtitle, footer labels
    private let titleLabel: MSLabel = {
        let label = MSLabel(style: .body)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let subtitleLabel: MSLabel = {
        let label = MSLabel(style: .footnote, colorStyle: .secondary)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    private let footerLabel: MSLabel = {
        let label = MSLabel(style: .footnote, colorStyle: .secondary)
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
    @objc open func setup(title: String = "", subtitle: String = "", footer: String = "", customView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none) {
        layoutType = footer == "" ? (subtitle == "" ? .oneLine : .twoLines) : .threeLines

        titleLabel.text = title
        subtitleLabel.text = subtitle
        footerLabel.text = footer
        self.customView = customView

        switch accessoryType {
        case .none:
            accessory = nil
        case .disclosureIndicator:
            accessory = MSTableViewCellAccessoryView(type: accessoryType)
        case .detailButton:
            accessory = MSTableViewCellAccessoryView(type: accessoryType)
            accessory?.onTapped = handleDetailButtonTapped
        }

        if layoutType == .twoLines {
            subtitleLabel.isHidden = false
        } else if layoutType == .threeLines {
            footerLabel.isHidden = false
            subtitleLabel.isHidden = false
            subtitleLabel.style = .subhead
        }

        separatorInset.left = separatorLeftInset

        setNeedsLayout()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        customView = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
        subtitleLabel.style = .footnote
        footerLabel.text = nil
        footerLabel.isHidden = true
        accessory = nil
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        var horizontalOffset = Constants.customViewMarginLeft
        if let customView = customView {
            let customViewYOffset = UIScreen.main.roundToDevicePixels((contentView.height - customViewSize.size.height) / 2)
            customView.frame = CGRect(
                origin: CGPoint(x: horizontalOffset, y: customViewYOffset),
                size: customViewSize.size
            )
            horizontalOffset += customView.width + Constants.customViewMarginRight
        }

        let titleHeight = titleLabel.font.deviceLineHeight
        let subtitleHeight = subtitleLabel.font.deviceLineHeight
        let footerHeight = footerLabel.font.deviceLineHeight

        var textAreaHeight = titleHeight
        if layoutType == .twoLines || layoutType == .threeLines {
            textAreaHeight += subtitleHeight + Constants.labelVerticalSpacing
            if layoutType == .threeLines {
                textAreaHeight += footerHeight + Constants.labelVerticalSpacing
            }
        }

        let labelMarginRight = accessory != nil ? MSTableViewCellAccessoryView.size.width + Constants.accessoryViewOffset : Constants.labelMarginRight
        let titleYOffset = UIScreen.main.roundToDevicePixels((contentView.height - textAreaHeight) / 2)
        titleLabel.frame = CGRect(
            x: horizontalOffset,
            y: titleYOffset,
            width: contentView.width - (horizontalOffset + labelMarginRight),
            height: titleHeight
        )

        if layoutType == .twoLines || layoutType == .threeLines {
            subtitleLabel.frame = CGRect(
                x: titleLabel.left,
                y: titleLabel.bottom + Constants.labelVerticalSpacing,
                width: titleLabel.width,
                height: subtitleHeight
            )

            if layoutType == .threeLines {
                footerLabel.frame = CGRect(
                    x: subtitleLabel.left,
                    y: subtitleLabel.bottom + Constants.labelVerticalSpacing,
                    width: titleLabel.width,
                    height: footerHeight
                )
            }
        }

        if let accessory = accessory {
            let xOffset = contentView.width - MSTableViewCellAccessoryView.size.width - Constants.accessoryViewOffset
            let yOffset = UIScreen.main.roundToDevicePixels((contentView.height - MSTableViewCellAccessoryView.size.height) / 2)
            accessory.frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: MSTableViewCellAccessoryView.size)
        }
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
