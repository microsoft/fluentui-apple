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

/// `TableViewHeaderFooterView` is used to present a section header or footer with a `title` and an optional accessory button.
/// Set the `TableViewHeaderFooterView.Style` of the view to specify its visual style. The `default` and `headerPrimary` style may be used for headers.
/// The `footer` style, which lays out the `title` near the top of the view, may be used for footers in grouped lists. Use `divider` and `dividerHighlighted` as headers for plain lists.
/// The optional accessory button should only be used with `default` style headers with the `title` as a single line of text.
/// Use `titleNumberOfLines` to configure the number of lines for the `title`. Headers generally use the default number of lines of 1 while footers may use a multiple number of lines.
@objc(MSFTableViewHeaderFooterView)
open class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    @objc(MSFTableViewHeaderFooterViewAccessoryButtonStyle)
    public enum AccessoryButtonStyle: Int {
        case regular
        case primary

        func textColor(for window: UIWindow) -> UIColor {
            switch self {
            case .regular:
                return Colors.Table.HeaderFooter.accessoryButtonText
            case .primary:
                return UIColor(light: Colors.primaryShade10(for: window), dark: Colors.primary(for: window))
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
        case headerPrimary

        func backgroundColor(for window: UIWindow) -> UIColor {
            switch self {
            case .header, .footer, .headerPrimary:
                return Colors.Table.HeaderFooter.background
            case .divider:
                return Colors.Table.HeaderFooter.backgroundDivider
            case .dividerHighlighted:
                return UIColor(light: Colors.primaryTint40(for: window), dark: Colors.surfaceSecondary)
            }
        }

        func textColor(for window: UIWindow) -> UIColor {
            switch self {
            case .header, .footer:
                return Colors.Table.HeaderFooter.text
            case .divider:
                return Colors.Table.HeaderFooter.textDivider
            case .dividerHighlighted:
                return Colors.primary(for: window)
            case .headerPrimary:
                return Colors.textPrimary
            }
        }

        func textFont() -> UIFont {
            switch self {
            case .headerPrimary:
                return Constants.primaryTitleTextStyle.font
            case .header, .footer, .divider, .dividerHighlighted:
                return Constants.titleTextStyle.font
            }
        }
    }

    private struct Constants {
        static let horizontalMargin: CGFloat = 16

        static let titleDefaultTopMargin: CGFloat = 24
        static let titleDefaultBottomMargin: CGFloat = 8
        static let titleDividerVerticalMargin: CGFloat = 3
        static let primaryTitleTextStyle: TextStyle = .headline
        static let titleTextStyle: TextStyle = .footnote

        static let accessoryViewBottomMargin: CGFloat = 2
        static let accessoryViewMarginLeft: CGFloat = 8
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
        let verticalMargin: CGFloat
        let font = style.textFont()
        switch style {
        case .header, .footer:
            verticalMargin = Constants.titleDefaultTopMargin + Constants.titleDefaultBottomMargin
        case .headerPrimary:
            verticalMargin = Constants.titleDefaultTopMargin + Constants.titleDefaultBottomMargin
        case .divider, .dividerHighlighted:
            verticalMargin = Constants.titleDividerVerticalMargin * 2
        }

        let titleWidth = containerWidth - (Constants.horizontalMargin + TableViewHeaderFooterView.titleTrailingOffset() + TableViewHeaderFooterView.titleLeadingOffset())
        let titleHeight = title.preferredSize(for: font, width: titleWidth, numberOfLines: titleNumberOfLines).height

        return verticalMargin + titleHeight
    }

    /// The preferred width of the view based on the width of its content.
    ///
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryView: An optional accessory view that appears near the trailing edge of the view.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    /// - Returns: a value representing the calculated preferred width of the view.
    @objc public class func preferredWidth(style: Style, title: String, accessoryView: UIView? = nil, leadingView: UIView? = nil) -> CGFloat {
        let font = style.textFont()
        let titleSize = title.preferredSize(for: font)

        var width = Constants.horizontalMargin + titleSize.width + Constants.horizontalMargin

        if let accessoryView = accessoryView {
            width += Constants.accessoryViewMarginLeft + accessoryView.frame.width
        }

        if let leadingView = leadingView {
            width += Constants.accessoryViewMarginLeft + leadingView.frame.width
        }

        return width
    }

    private static func titleLeadingOffset(leadingView: UIView? = nil) -> CGFloat {
        let leadingViewSpacing = leadingView?.frame.width ?? 0
        return leadingViewSpacing + Constants.horizontalMargin
    }

    private static func titleTrailingOffset(accessoryView: UIView? = nil) -> CGFloat {
        let accessoryViewSpacing: CGFloat
        if let accessoryView = accessoryView {
            accessoryViewSpacing = Constants.accessoryViewMarginLeft + accessoryView.frame.width
        } else {
            accessoryViewSpacing = 0
        }
        return accessoryViewSpacing + Constants.horizontalMargin
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
    @objc open var onHeaderViewTapped: (() -> Void)?

    @objc public weak var delegate: TableViewHeaderFooterViewDelegate?

    open override var intrinsicContentSize: CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleView.text ?? "",
                accessoryView: accessoryView,
                leadingView: leadingView
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
            backgroundView = view

            updateTitleAndBackgroundColors()
            invalidateIntrinsicContentSize()
        }
    }

    private let titleView = TableViewHeaderFooterTitleView()

    private var accessoryView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = accessoryView {
                contentView.addSubview(accessoryView)
            }
        }
    }

    private var accessoryButton: UIButton? = nil {
        didSet {
            accessoryView = accessoryButton
            if accessoryButton != nil {
                updateAccessoryButtonTitleStyle()
            }
        }
    }

    private var leadingView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let leadingView = leadingView {
                contentView.addSubview(leadingView)
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderViewTapped))
        contentView.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    // MARK: Setup

    /// Sets up the titleView based off of the following parameters:
    ///
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "") {
        setup(style: style, title: title, accessoryButtonTitle: accessoryButtonTitle, leadingView: nil)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "", leadingView: UIView? = nil) {
        titleView.attributedText = NSAttributedString(string: " ") // to clear attributes
        titleView.text = title
        titleView.isSelectable = false

        setup(style: style, accessoryButtonTitle: accessoryButtonTitle, leadingView: leadingView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - attributedTitle: Title as an NSAttributedString for additional attributes.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, attributedTitle: NSAttributedString, accessoryButtonTitle: String = "") {
        setup(style: style, attributedTitle: attributedTitle, accessoryButtonTitle: accessoryButtonTitle, leadingView: nil)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - attributedTitle: Title as an NSAttributedString for additional attributes.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    @objc open func setup(style: Style, attributedTitle: NSAttributedString, accessoryButtonTitle: String = "", leadingView: UIView? = nil) {
        titleView.attributedText = attributedTitle
        titleView.isSelectable = true

        setup(style: style, accessoryButtonTitle: accessoryButtonTitle, leadingView: leadingView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryView: The optional custom accessory view in the trailing edge of this view.
    @objc open func setup(style: Style, title: String, accessoryView: UIView) {
        setup(style: style, title: title, accessoryView: accessoryView, leadingView: nil)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryView: The optional custom accessory view in the trailing edge of this view.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    /// If `accessoryView` is set, the accessory button (if any) will be replaced by this custom view. Clients are responsible
    /// for the appearance and behavior of both the `accessoryView` and `leadingView`, including event handling and accessibility.
    @objc open func setup(style: Style, title: String, accessoryView: UIView, leadingView: UIView? = nil) {
        setup(style: style, title: title, accessoryButtonTitle: "")
        self.accessoryView = accessoryView
        self.leadingView = leadingView
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, accessoryButtonTitle: String) {
        setup(style: style, accessoryButtonTitle: accessoryButtonTitle, leadingView: nil)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    @objc open func setup(style: Style, title: String) {
        setup(style: style, title: title, accessoryButtonTitle: "")
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    private func setup(style: Style, accessoryButtonTitle: String, leadingView: UIView? = nil) {
        updateTitleViewFont()
        switch style {
        case .header, .divider, .dividerHighlighted, .headerPrimary:
            titleView.accessibilityTraits.insert(.header)
        case .footer:
            titleView.accessibilityTraits.remove(.header)
            // Bug in iOS - need to manually refresh VoiceOver text for accessibilityTraits
            titleView.isAccessibilityElement = false
            titleView.isAccessibilityElement = true
        }

        accessoryButton = !accessoryButtonTitle.isEmpty ? createAccessoryButton(withTitle: accessoryButtonTitle) : nil
        self.leadingView = leadingView

        self.style = style

        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        accessoryView?.sizeToFit()
        leadingView?.sizeToFit()

        let titleWidth = contentView.frame.width - (TableViewHeaderFooterView.titleTrailingOffset(accessoryView: accessoryView) + TableViewHeaderFooterView.titleLeadingOffset(leadingView: leadingView))
        var titleXOffset = Constants.horizontalMargin
        let titleHeight: CGFloat
        let titleYOffset: CGFloat
        switch style {
        case .header, .footer, .headerPrimary:
            titleYOffset = style == .footer ? Constants.titleDefaultBottomMargin : Constants.titleDefaultTopMargin
            titleHeight = contentView.frame.height - Constants.titleDefaultTopMargin - Constants.titleDefaultBottomMargin
        case .divider, .dividerHighlighted:
            titleYOffset = Constants.titleDividerVerticalMargin
            titleHeight = contentView.frame.height - (Constants.titleDividerVerticalMargin * 2)
        }

        if let leadingView = leadingView {
            let xOffset = Constants.accessoryViewMarginLeft
            let yOffset = contentView.frame.height - leadingView.frame.height - Constants.titleDefaultBottomMargin
            leadingView.frame = CGRect(
                origin: CGPoint(x: xOffset, y: yOffset),
                size: leadingView.frame.size
            )
            titleXOffset += leadingView.frame.width
        }

        titleView.frame = CGRect(
            x: titleXOffset,
            y: titleYOffset,
            width: titleWidth,
            height: titleHeight
        )

        if let accessoryView = accessoryView {
            let xOffset = titleView.frame.maxX + Constants.accessoryViewMarginLeft
            let yOffset = contentView.frame.height - accessoryView.frame.height - Constants.accessoryViewBottomMargin
            accessoryView.frame = CGRect(
                origin: CGPoint(x: xOffset, y: yOffset),
                size: accessoryView.frame.size
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
        onHeaderViewTapped = nil
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleView.text ?? "",
                accessoryView: accessoryView,
                leadingView: leadingView
            ),
            height: type(of: self).height(
                style: style,
                title: titleView.text ?? "",
                titleNumberOfLines: titleNumberOfLines,
                containerWidth: size.width
            )
        )
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTitleAndBackgroundColors()
        updateAccessoryButtonTitleColor()
    }

    private func updateTitleViewFont() {
        if let window = window {
            let titleFont = style.textFont()
            titleView.font = titleFont
            // offset text container to center its content
            let scale = window.rootViewController?.view.contentScaleFactor ?? window.screen.scale
            let offset = (floor((abs(titleFont.leading) / 2) * scale) / scale) / 2
            titleView.textContainerInset.top = offset
            titleView.textContainerInset.bottom = -offset
        }
    }

    private func updateTitleAndBackgroundColors() {
        if let window = window {
            titleView.textColor = style.textColor(for: window)
            backgroundView?.backgroundColor = style.backgroundColor(for: window)
            titleView.font = style.textFont()
        }
    }

    private func updateAccessoryButtonTitleColor() {
        if let window = window {
            accessoryButton?.setTitleColor(accessoryButtonStyle.textColor(for: window), for: .normal)
        }
    }

    private func updateAccessoryButtonTitleStyle() {
        accessoryButton?.titleLabel?.font = Constants.accessoryButtonTextStyle.font
        updateAccessoryButtonTitleColor()
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

    @objc private func handleHeaderViewTapped() {
        onHeaderViewTapped?()
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

    override func becomeFirstResponder() -> Bool {
        return false
    }

    override var selectedTextRange: UITextRange? {
        get {
            // No need for selection, but we need to keep it selectable in order for links to work
            return nil
        }

        set {
            // No-op because we don't want to allow this property to be set.
            // It should always return nil which indicates there is no current selection (https://developer.apple.com/documentation/uikit/uitextinput/1614541-selectedtextrange)
        }
    }
}
