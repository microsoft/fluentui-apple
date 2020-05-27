//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TableViewHeaderFooterViewDelegate

@available(*, deprecated, renamed: "TableViewHeaderFooterViewDelegate")
public typealias MSTableViewHeaderFooterViewDelegate = TableViewHeaderFooterViewDelegate

@objc(MSFTableViewHeaderFooterViewDelegate)
public protocol TableViewHeaderFooterViewDelegate: AnyObject {
    /// Returns: true if the interaction with the header view should be allowed; false if the interaction should not be allowed.
    @objc optional func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

// MARK: - TableViewHeaderFooterView

@available(*, deprecated, renamed: "TableViewHeaderFooterView")
public typealias MSTableViewHeaderFooterView = TableViewHeaderFooterView

/**
 `TableViewHeaderFooterView` is used to present a section header or footer with a `title` and an optional accessory button.

 Set the `TableViewHeaderFooterView.Style` of the view to specify its visual style. While the `default` style may be used for headers, the `footer` style, which lays out the `title` near the top of the view, may be used for footers in grouped lists. Use `divider` and `dividerHighlighted` as headers for plain lists.

 The optional accessory button should only be used with `default` style headers with the `title` as a single line of text.

 Use `titleNumberOfLines` to configure the number of lines for the `title`. Headers generally use the default number of lines of 1 while footers may use a multiple number of lines.
 */
@objc(MSFTableViewHeaderFooterView)
open class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    @objc(MSFTableViewHeaderFooterViewAccessoryButtonStyle)
    public enum AccessoryButtonStyle: Int {
        case regular
        case primary

        var textColor: UIColor {
            switch self {
            case .regular:
                return Colors.Table.HeaderFooter.accessoryButtonText
            case .primary:
                return Colors.Table.HeaderFooter.accessoryButtonTextPrimary
            }
        }
    }

    /// Defines the visual style of the view
    @objc(MSFTableViewHeaderFooterViewStyle)
    public enum Style: Int {
        case header
        case divider
        case dividerHighlighted
        case footer

        var backgroundColor: UIColor {
            switch self {
            case .header, .footer:
                return Colors.Table.HeaderFooter.background
            case .divider:
                return Colors.Table.HeaderFooter.backgroundDivider
            case .dividerHighlighted:
                return Colors.Table.HeaderFooter.backgroundDividerHighlighted
            }
        }

        var textColor: UIColor {
            switch self {
            case .header, .footer:
                return Colors.Table.HeaderFooter.text
            case .divider:
                return Colors.Table.HeaderFooter.textDivider
            case .dividerHighlighted:
                return Colors.Table.HeaderFooter.textDividerHighlighted
            }
        }
    }

    private struct Constants {
        static let horizontalMargin: CGFloat = 16

        static let titleDefaultTopMargin: CGFloat = 24
        static let titleDefaultBottomMargin: CGFloat = 8
        static let titleDividerVerticalMargin: CGFloat = 3
        static let titleTextStyle: TextStyle = .footnote

        static let accessoryButtonBottomMargin: CGFloat = 2
        static let accessoryButtonMarginLeft: CGFloat = 8
        static var accessoryButtonTextStyle: TextStyle = .button2
    }

    @objc public static var identifier: String { return String(describing: self) }

    /// The height of the view based on the height of its content.
    ///
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - titleNumberOfLines: The number of lines that the title should display.
    ///   - containerWidth: The width of the view's super view (e.g. the table view's width).
    /// - Returns: a value representing the calculated height of the view.
    @objc public class func height(style: Style, title: String, titleNumberOfLines: Int = 1, containerWidth: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let titleWidth = containerWidth - (Constants.horizontalMargin + TableViewHeaderFooterView.titleRightOffset())
        let titleHeight = title.preferredSize(for: Constants.titleTextStyle.font, width: titleWidth, numberOfLines: titleNumberOfLines).height

        let verticalMargin: CGFloat
        switch style {
        case .header, .footer:
            verticalMargin = Constants.titleDefaultTopMargin + Constants.titleDefaultBottomMargin
        case .divider, .dividerHighlighted:
            verticalMargin = Constants.titleDividerVerticalMargin * 2
        }

        return verticalMargin + titleHeight
    }

     /// The preferred width of the view based on the width of its content.
     ///
     /// - Parameters:
     ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
     ///   - title: The title string.
     ///   - accessoryButton: An optional accessory button that appears near the trailing edge of the view.
     /// - Returns: a value representing the calculated preferred width of the view.
     @objc public class func preferredWidth(style: Style, title: String, accessoryButton: UIButton? = nil) -> CGFloat {
        let titleSize = title.preferredSize(for: Constants.titleTextStyle.font)

        var width = Constants.horizontalMargin + titleSize.width + Constants.horizontalMargin

        if let accessoryButton = accessoryButton {
            width += Constants.accessoryButtonMarginLeft + accessoryButton.frame.width
        }

        return width
    }

    private static func titleRightOffset(accessoryButton: UIButton? = nil) -> CGFloat {
        let accessoryButtonSpacing: CGFloat
        if let accessoryButton = accessoryButton {
            accessoryButtonSpacing = Constants.accessoryButtonMarginLeft + accessoryButton.frame.width
        } else {
            accessoryButtonSpacing = 0
        }
        return accessoryButtonSpacing + Constants.horizontalMargin
    }

    @objc open var accessoryButtonStyle: AccessoryButtonStyle = .regular {
        didSet {
            updateAccessoryButtonTitleStyle()
        }
    }

    /// The maximum number of lines to be shown for `title`
    @objc open var titleNumberOfLines: Int = 1 {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    /// `onAccessoryButtonTapped` is called when `accessoryButton` is tapped
    @objc open var onAccessoryButtonTapped: (() -> Void)?

    @objc public weak var delegate: TableViewHeaderFooterViewDelegate?

    open override var intrinsicContentSize: CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleView.text ?? "",
                accessoryButton: accessoryButton
            ),
            height: type(of: self).height(
                style: style,
                title: titleView.text ?? "",
                titleNumberOfLines: titleNumberOfLines,
                containerWidth: frame.width > 0 ? frame.width : .infinity
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

    private var style: Style = .header {
        didSet {
            let view = UIView()
            view.backgroundColor = style.backgroundColor
            backgroundView = view

            titleView.textColor = style.textColor

            invalidateIntrinsicContentSize()
        }
    }

    private let titleView = TableViewHeaderFooterTitleView()

    private var accessoryButton: UIButton? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryButton = accessoryButton {
                updateAccessoryButtonTitleStyle()
                contentView.addSubview(accessoryButton)
            }
        }
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        titleView.delegate = self

        contentView.addSubview(titleView)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "") {
        titleView.attributedText = NSAttributedString(string: " ") // to clear attributes
        titleView.text = title
        titleView.isSelectable = false

        setup(style: style, accessoryButtonTitle: accessoryButtonTitle)
    }

    @objc open func setup(style: Style, attributedTitle: NSAttributedString, accessoryButtonTitle: String = "") {
        titleView.attributedText = attributedTitle
        titleView.isSelectable = true

        setup(style: style, accessoryButtonTitle: accessoryButtonTitle)
    }

    private func setup(style: Style, accessoryButtonTitle: String) {
        updateTitleViewFont()
        switch style {
        case .header, .divider, .dividerHighlighted:
            titleView.accessibilityTraits.insert(.header)
        case .footer:
            titleView.accessibilityTraits.remove(.header)
            // Bug in iOS - need to manually refresh VoiceOver text for accessibilityTraits
            titleView.isAccessibilityElement = false
            titleView.isAccessibilityElement = true
        }

        accessoryButton = accessoryButtonTitle != "" ? createAccessoryButton(withTitle: accessoryButtonTitle) : nil
        self.style = style

        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        accessoryButton?.sizeToFit()

        let titleWidth = contentView.frame.width - (Constants.horizontalMargin + TableViewHeaderFooterView.titleRightOffset(accessoryButton: accessoryButton))
        let titleHeight: CGFloat
        let titleYOffset: CGFloat
        switch style {
        case .header, .footer:
            titleYOffset = style == .header ? Constants.titleDefaultTopMargin : Constants.titleDefaultBottomMargin
            titleHeight = contentView.frame.height - Constants.titleDefaultTopMargin - Constants.titleDefaultBottomMargin
        case .divider, .dividerHighlighted:
            titleYOffset = Constants.titleDividerVerticalMargin
            titleHeight = contentView.frame.height - (Constants.titleDividerVerticalMargin * 2)
        }
        titleView.frame = CGRect(
            x: Constants.horizontalMargin,
            y: titleYOffset,
            width: titleWidth,
            height: titleHeight
        )

        if let accessoryButton = accessoryButton {
            let xOffset = titleView.frame.maxX + Constants.accessoryButtonMarginLeft
            let yOffset = contentView.frame.height - accessoryButton.frame.height - Constants.accessoryButtonBottomMargin
            accessoryButton.frame = CGRect(
                origin: CGPoint(x: xOffset, y: yOffset),
                size: accessoryButton.frame.size
            )
        }

        contentView.flipSubviewsForRTL()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil

        accessoryButtonStyle = .regular
        titleNumberOfLines = 1

        onAccessoryButtonTapped = nil
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleView.text ?? "",
                accessoryButton: accessoryButton
            ),
            height: type(of: self).height(
                style: style,
                title: titleView.text ?? "",
                titleNumberOfLines: titleNumberOfLines,
                containerWidth: size.width
            )
        )
    }

    private func updateTitleViewFont() {
        let font = Constants.titleTextStyle.font
        titleView.font = font
        // offset text container to center its content
        let offset = UIScreen.main.roundDownToDevicePixels(abs(font.leading) / 2)
        titleView.textContainerInset.top = offset
        titleView.textContainerInset.bottom = -offset
    }

    private func updateAccessoryButtonTitleStyle() {
        accessoryButton?.titleLabel?.font = Constants.accessoryButtonTextStyle.font
        accessoryButton?.setTitleColor(accessoryButtonStyle.textColor, for: .normal)
    }

    private func createAccessoryButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(handleAccessoryButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func handleContentSizeCategoryDidChange() {
        updateTitleViewFont()
        updateAccessoryButtonTitleStyle()
    }

    @objc private func handleAccessoryButtonTapped() {
        onAccessoryButtonTapped?()
    }
}

// MARK: - TableViewHeaderFooterView: UITextViewDelegate

extension TableViewHeaderFooterView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // If the delegate function is not set, return `true` to let the default interaction handle this
        return delegate?.headerFooterView?(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
}

// MARK: - TableViewHeaderFooterTitleView

private class TableViewHeaderFooterTitleView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = nil
        isEditable = false
        isScrollEnabled = false
        clipsToBounds = false    // to avoid clipping of "deep-touch" UI for links
        isAccessibilityElement = true
        self.textContainer.lineBreakMode = .byTruncatingTail
        self.textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        layoutManager.usesFontLeading = false
        linkTextAttributes = [.foregroundColor: Colors.Table.HeaderFooter.textLink]
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override var selectedTextRange: UITextRange? {
        didSet {
            // No need for selection, but we need to keep it selectable in order for links to work
            if selectedTextRange != nil {
                selectedTextRange = nil
            }
        }
    }
}
