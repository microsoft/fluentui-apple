//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

// MARK: TableViewHeaderFooterViewDelegate

@objc(MSFTableViewHeaderFooterViewDelegate)
public protocol TableViewHeaderFooterViewDelegate: AnyObject {
    /// Returns: true if the interaction with the header view should be allowed; false if the interaction should not be allowed.
    @available(iOS, deprecated: 17, message: "Replaced by primaryActionForTextItem: and menuConfigurationForTextItem: for additional customization options.")
    @available(visionOS, deprecated: 1, message: "Replaced by primaryActionForTextItem: and menuConfigurationForTextItem: for additional customization options.")
    @objc optional func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool

    /// Asks the delegate for the action to be performed when interacting with a text item. If a nil action is provided, the text view
    /// will request a menu to be presented on primary action if possible.
    ///
    /// @param headerFooterView  The `TableViewHeaderFooterView` requesting the primary action.
    /// @param textItem  The text item for performing said action.
    /// @param defaultAction The default action for the text item. Return this to perform the default action.
    ///
    /// @return Return a UIAction to be performed when the text item is interacted with. Return @c nil to prevent the action from being performed.
    @available(iOS, introduced: 17)
    @objc optional func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction?

    /// Asks the delegate for the menu configuration to be performed when interacting with a text item.
    ///
    /// @param headerFooterView  The `TableViewHeaderFooterView` requesting the menu.
    /// @param textItem  The text item for performing said action.
    /// @param defaultMenu  The default menu for the specified text item.
    ///
    /// @return Return a menu configuration to be presented when the text item is interacted with. Return @c nil to prevent the menu from being presented.
    @available(iOS, introduced: 17)
    @objc optional func headerFooterView(_ headerFooterView: TableViewHeaderFooterView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration?
}

// MARK: - TableViewHeaderFooterView

/// `TableViewHeaderFooterView` is used to present a section header or footer with a `title` and an optional accessory button.
/// Set the `TableViewHeaderFooterView.Style` of the view to specify its visual style. The `default` and `headerPrimary` style may be used for headers.
/// The `footer` style, which lays out the `title` near the top of the view, may be used for footers in grouped lists.
/// The optional accessory button should only be used with `default` style headers with the `title` as a single line of text.
/// Use `titleNumberOfLines` to configure the number of lines for the `title`. Headers generally use the default number of lines of 1 while footers may use a multiple number of lines.
@objc(MSFTableViewHeaderFooterView)
open class TableViewHeaderFooterView: UITableViewHeaderFooterView, TokenizedControl {
    @objc public static var identifier: String { return String(describing: self) }

    /// The height of the view based on the height of its content.
    ///
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - titleNumberOfLines: The number of lines that the title should display.
    ///   - containerWidth: The width of the view's super view (e.g. the table view's width).
    ///   - accessoryView: An optional accessory view that appears near the trailing edge of the view.
    /// - Returns: a value representing the calculated height of the view.
    @objc public class func height(style: Style,
                                   title: String,
                                   titleNumberOfLines: Int = 1,
                                   containerWidth: CGFloat = .greatestFiniteMagnitude,
                                   accessoryView: UIView? = nil) -> CGFloat {
        let tokenSet: TableViewHeaderFooterViewTokenSet = .init(style: { style }, accessoryButtonStyle: { AccessoryButtonStyle.regular })
        let font = tokenSet[.textFont].uiFont
        let verticalMargin = TableViewHeaderFooterViewTokenSet.titleDefaultTopMargin + TableViewHeaderFooterViewTokenSet.titleDefaultBottomMargin

        if let accessoryView = accessoryView {
            accessoryView.frame.size = accessoryView.systemLayoutSizeFitting(CGSize(width: containerWidth, height: .infinity))
        }

        let titleWidth = containerWidth - (TableViewHeaderFooterView.titleLeadingOffset() + TableViewHeaderFooterView.titleTrailingOffset(accessoryView: accessoryView))
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
    @objc public class func preferredWidth(style: Style,
                                           title: String,
                                           accessoryView: UIView? = nil,
                                           leadingView: UIView? = nil) -> CGFloat {
        let tokenSet: TableViewHeaderFooterViewTokenSet = .init(style: { style }, accessoryButtonStyle: { AccessoryButtonStyle.regular })
        let font = tokenSet[.textFont].uiFont
        let titleSize = title.preferredSize(for: font)

        var width = TableViewHeaderFooterViewTokenSet.horizontalMargin + titleSize.width + TableViewHeaderFooterViewTokenSet.horizontalMargin

        if let accessoryView = accessoryView {
            width += TableViewHeaderFooterViewTokenSet.accessoryViewMarginLeading + accessoryView.frame.width
        }

        if let leadingView = leadingView {
            width += TableViewHeaderFooterViewTokenSet.accessoryViewMarginLeading + leadingView.frame.width
        }

        return width
    }

    private static func titleLeadingOffset(leadingView: UIView? = nil) -> CGFloat {
        let leadingViewSpacing = leadingView?.frame.width ?? 0
        return leadingViewSpacing + TableViewHeaderFooterViewTokenSet.horizontalMargin
    }

    private static func titleTrailingOffset(accessoryView: UIView? = nil) -> CGFloat {
        let accessoryViewSpacing: CGFloat
        if let accessoryView = accessoryView {
            accessoryViewSpacing = TableViewHeaderFooterViewTokenSet.accessoryViewMarginLeading + accessoryView.frame.width
        } else {
            accessoryViewSpacing = 0
        }
        return accessoryViewSpacing + TableViewHeaderFooterViewTokenSet.horizontalMargin
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

    /// configure this variable to change the appropriate background color based on what type of TableViewCell style it is associated with
    @objc public var tableViewCellStyle: TableViewCellBackgroundStyleType = .grouped {
        didSet {
            if tableViewCellStyle != oldValue {
                updateTitleAndBackgroundColors()
            }
        }
    }

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

    public typealias TokenSetKeyType = TableViewHeaderFooterViewTokenSet.Tokens
    lazy public var tokenSet: TableViewHeaderFooterViewTokenSet = .init(style: { [weak self] in
        return self?.style ?? .header
    },
                                                                        accessoryButtonStyle: { [weak self] in
        return self?.accessoryButtonStyle ?? .regular
    })

    private var style: Style = .header {
        didSet {
            let view = UIView()
            backgroundView = view

            updateTitleAndBackgroundColors()
            invalidateIntrinsicContentSize()
        }
    }

    private let titleView = TableViewHeaderFooterTitleView()

    private var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = accessoryView {
                contentView.addSubview(accessoryView)
            }
        }
    }

    private var accessoryButton: UIButton? {
        didSet {
            accessoryView = accessoryButton
            if accessoryButton != nil {
                updateAccessoryButtonTitleStyle()
            }
        }
    }

    private var leadingView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let leadingView = leadingView {
                contentView.addSubview(leadingView)
                contentView.layoutIfNeeded()
                updateLeadingViewColor()
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

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateTokenizedValues()
        }
    }

    // MARK: Setup

    /// Sets up the titleView based off of the following parameters:
    ///
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "") {
        setupBase(style: style, title: title, accessoryButtonTitle: accessoryButtonTitle)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "", leadingView: UIView? = nil) {
        setupBase(style: style, title: title, accessoryButtonTitle: accessoryButtonTitle, leadingView: leadingView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - attributedTitle: Title as an NSAttributedString for additional attributes.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, attributedTitle: NSAttributedString, accessoryButtonTitle: String = "") {
        setupBase(style: style, attributedTitle: attributedTitle, accessoryButtonTitle: accessoryButtonTitle)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - attributedTitle: Title as an NSAttributedString for additional attributes.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    @objc open func setup(style: Style, attributedTitle: NSAttributedString, accessoryButtonTitle: String = "", leadingView: UIView? = nil) {
        setupBase(style: style, attributedTitle: attributedTitle, accessoryButtonTitle: accessoryButtonTitle, leadingView: leadingView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryView: The optional custom accessory view in the trailing edge of this view.
    @objc open func setup(style: Style, title: String, accessoryView: UIView) {
        setupBase(style: style, title: title, accessoryView: accessoryView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - accessoryView: The optional custom accessory view in the trailing edge of this view.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    /// If `accessoryView` is set, the accessory button (if any) will be replaced by this custom view. Clients are responsible
    /// for the appearance and behavior of both the `accessoryView` and `leadingView`, including event handling and accessibility.
    @objc open func setup(style: Style, title: String, accessoryView: UIView, leadingView: UIView? = nil) {
        setupBase(style: style, title: title, accessoryView: accessoryView, leadingView: leadingView)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    @objc open func setup(style: Style, accessoryButtonTitle: String) {
        setupBase(style: style, accessoryButtonTitle: accessoryButtonTitle)
    }

    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    @objc open func setup(style: Style, title: String) {
        setupBase(style: style, title: title)
    }

    /// This is the base setup method. All other setup methods call this method with their parameters.
    /// - Parameters:
    ///   - style: The `TableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string
    ///   - attributedTitle: Title as an NSAttributedString for additional attributes.
    ///   - accessoryButtonTitle: Optional accessory button title string.
    ///   - accessoryView: The optional custom accessory view in the trailing edge of this view.
    ///   - leadingView: An optional custom view that appears near the leading edge of the view.
    private func setupBase(style: Style,
                           title: String? = nil,
                           attributedTitle: NSAttributedString? = nil,
                           accessoryButtonTitle: String = "",
                           accessoryView: UIView? = nil,
                           leadingView: UIView? = nil) {
        if let attributedTitle {
            self.attributedTitle = attributedTitle
            titleView.attributedText = attributedTitle
            titleView.isSelectable = true
        } else {
            self.attributedTitle = nil
            titleView.attributedText = NSAttributedString(string: " ") // to clear attributes
            titleView.text = title
            titleView.isSelectable = false
        }

        updateTitleViewFont()
        switch style {
        case .header, .headerPrimary:
            titleView.accessibilityTraits.insert(.header)
        case .footer:
            titleView.accessibilityTraits.remove(.header)
        }

        accessoryButton = !accessoryButtonTitle.isEmpty ? createAccessoryButton(withTitle: accessoryButtonTitle) : nil

        /// `accessoryButton` and `accessoryView` occupy the same space at the trailing end of the view. If both are provided, the `accessoryView` will be given priority
        if accessoryView != nil {
            self.accessoryView = accessoryView
        }

        self.leadingView = leadingView

        self.style = style

        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        accessoryView?.sizeToFit()
        leadingView?.sizeToFit()

        let titleWidth = contentView.frame.width - (TableViewHeaderFooterView.titleTrailingOffset(accessoryView: accessoryView) + TableViewHeaderFooterView.titleLeadingOffset(leadingView: leadingView))
        var titleXOffset = TableViewHeaderFooterViewTokenSet.horizontalMargin
        let titleHeight: CGFloat
        let titleYOffset: CGFloat
        switch style {
        case .header, .footer, .headerPrimary:
            titleYOffset = style == .footer ? TableViewHeaderFooterViewTokenSet.titleDefaultBottomMargin : TableViewHeaderFooterViewTokenSet.titleDefaultTopMargin
            titleHeight = contentView.frame.height - titleYOffset - TableViewHeaderFooterViewTokenSet.titleDefaultBottomMargin
        }

        if let leadingView = leadingView {
            let xOffset = TableViewHeaderFooterViewTokenSet.accessoryViewMarginLeading
            let yOffset = floor(titleYOffset + (titleHeight - leadingView.frame.height) / 2)
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
            let xOffset = titleView.frame.maxX + TableViewHeaderFooterViewTokenSet.accessoryViewMarginLeading
            let yOffset = contentView.frame.height - accessoryView.frame.height - TableViewHeaderFooterViewTokenSet.accessoryViewBottomMargin
            accessoryView.frame = CGRect(
                origin: CGPoint(x: xOffset, y: yOffset),
                size: accessoryView.frame.size
            )

            // seems like an iOS issue that any subviews of the headerView automatically gets the header trait which isn't the behavior we want other than the titleView.
            accessoryView.accessibilityTraits.remove(.header)
            if let accessoryButton = accessoryView as? UIButton {
                // unclear why just removing the .header traits remove the existing .button trait of the accessoryView but adding it back if needed
                accessoryButton.accessibilityTraits.insert(.button)
            }
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
                containerWidth: contentView.frame.width,
                accessoryView: accessoryView
            )
        )
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateTokenizedValues()
    }

    private func updateTokenizedValues() {
        updateTitleAndBackgroundColors()
        updateLeadingViewColor()
        updateAccessoryButtonTitleColor()
    }

    private func updateTitleViewFont() {
        if let window = window {
            let titleFont = tokenSet[.textFont].uiFont
            if !isUsingAttributedTitle {
                titleView.font = titleFont
            } else {
                updateAttributedTitleWithDefaultFluentThemeAttributes()
            }

            // offset text container to center its content
#if os(iOS)
            let scale = window.rootViewController?.view.contentScaleFactor ?? window.screen.scale
#elseif os(visionOS)
            let scale: CGFloat = 2.0
#endif // os(visionOS)
            let offset = (floor((abs(titleFont.leading) / 2) * scale) / scale) / 2
            titleView.textContainerInset.top = offset
            titleView.textContainerInset.bottom = -offset
        }
    }

    private func updateTitleAndBackgroundColors() {
        if tableViewCellStyle == .grouped {
            backgroundView?.backgroundColor = tokenSet[.backgroundColorGrouped].uiColor
        } else if tableViewCellStyle == .plain {
            backgroundView?.backgroundColor = tokenSet[.backgroundColorPlain].uiColor
        } else {
            backgroundView?.backgroundColor = .clear
        }

        if !isUsingAttributedTitle {
            titleView.textColor = tokenSet[.textColor].uiColor
            titleView.font = tokenSet[.textFont].uiFont
        } else {
            updateAttributedTitleWithDefaultFluentThemeAttributes()
        }
        titleView.linkColor = tokenSet[.linkTextColor].uiColor
    }

    private func updateAttributedTitleWithDefaultFluentThemeAttributes() {
        if let attributedTitle = self.attributedTitle {
            /// Create an attributed string with the default fluent text color and font for the given style
            let attributedTitleWithFluentTheme = NSMutableAttributedString(string: attributedTitle.string, attributes: [NSAttributedString.Key.foregroundColor: tokenSet[.textColor].uiColor, NSAttributedString.Key.font: tokenSet[.textFont].uiFont])

            /// Iterate over the attributes set by the consumer and apply them to our attributed string
            attributedTitle.enumerateAttributes(in: NSRange(location: 0, length: attributedTitle.length)) { attributes, range, _ in
                attributedTitleWithFluentTheme.addAttributes(attributes, range: range)
            }

            /// Update the `titleView` attributed string
            titleView.attributedText = attributedTitleWithFluentTheme
        }
    }

    private func updateLeadingViewColor() {
        leadingView?.tintColor = tokenSet[.leadingViewColor].uiColor
    }

    private func updateAccessoryButtonTitleColor() {
        accessoryButton?.setTitleColor(tokenSet[.accessoryButtonTextColor].uiColor, for: .normal)
    }

    private func updateAccessoryButtonTitleStyle() {
        accessoryButton?.titleLabel?.font = tokenSet[.accessoryButtonTextFont].uiFont
        updateAccessoryButtonTitleColor()
    }

    private func createAccessoryButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(handleAccessoryButtonTapped), for: .touchUpInside)
        if #available(iOS 17, *) {
            button.hoverStyle = UIHoverStyle(shape: .capsule)
        }
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

    private var attributedTitle: NSAttributedString? {
        didSet {
            isUsingAttributedTitle = attributedTitle != nil
        }
    }

    private var isUsingAttributedTitle: Bool = false
}

// MARK: - TableViewHeaderFooterView: UITextViewDelegate

extension TableViewHeaderFooterView: UITextViewDelegate {
    @available(iOS, deprecated: 17, message: "Replaced by primaryActionForTextItem: and menuConfigurationForTextItem: for additional customization options.")
    @available(visionOS, deprecated: 1, message: "Replaced by primaryActionForTextItem: and menuConfigurationForTextItem: for additional customization options.")
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // If the delegate function is not set, return `true` to let the default interaction handle this
        return delegate?.headerFooterView?(self, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }

    @available(iOS, introduced: 17)
    public func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        return delegate?.headerFooterView?(self, primaryActionFor: textItem, defaultAction: defaultAction) ?? defaultAction
    }

    @available(iOS, introduced: 17)
    public func textView(_ textView: UITextView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration? {
        return delegate?.headerFooterView?(self, menuConfigurationFor: textItem, defaultMenu: defaultMenu) ?? .init(menu: defaultMenu)
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
        self.textContainer.lineBreakMode = .byTruncatingTail
        self.textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        layoutManager.usesFontLeading = false
        updateLinkTextColor()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        return false
    }

    private func updateLinkTextColor() {
        linkTextAttributes = [.foregroundColor: linkColor]
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

    lazy var linkColor: UIColor = fluentTheme.color(.brandForeground1) {
        didSet {
            if linkColor != oldValue {
                updateLinkTextColor()
            }
        }
    }
}
