//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTableViewHeaderFooterView

/**
 `MSTableViewHeaderFooterView` is used to present a section header or footer with a `title` and an optional accessory button.

 Set the `MSTableViewHeaderFooterView.Style` of the view to specify its visual style. While the `default` style may be used for headers, the `footer` style, which lays out the `title` near the top of the view, may be used for footers in grouped lists. Use `divider` and `dividerHighlighted` as headers for plain lists.

 The optional accessory button should only be used with `default` style headers with the `title` as a single line of text.

 Use `titleNumberOfLines` to configure the number of lines for the `title`. Headers generally use the default number of lines of 1 while footers may use a multiple number of lines.
 */
open class MSTableViewHeaderFooterView: UITableViewHeaderFooterView {
    /// Defines the visual style of the view
    @objc(MSTableViewHeaderFooterViewStyle)
    public enum Style: Int {
        case header
        case divider
        case dividerHighlighted
        case footer

        var backgroundColor: UIColor {
            switch self {
            case .header, .footer:
                return MSColors.Table.HeaderFooter.background
            case .divider:
                return MSColors.Table.HeaderFooter.backgroundDivider
            case .dividerHighlighted:
                return MSColors.Table.HeaderFooter.backgroundDividerHighlighted
            }
        }

        var textColor: UIColor {
            switch self {
            case .header, .footer:
                return MSColors.Table.HeaderFooter.text
            case .divider:
                return MSColors.Table.HeaderFooter.textDivider
            case .dividerHighlighted:
                return MSColors.Table.HeaderFooter.textDividerHighlighted
            }
        }
    }

    private struct Constants {
        static let horizontalMargin: CGFloat = 16

        static let titleDefaultTopMargin: CGFloat = 24
        static let titleDefaultBottomMargin: CGFloat = 8
        static let titleDividerVerticalMargin: CGFloat = 3
        static let titleTextStyle: MSTextStyle = .footnote

        static let accessoryButtonBottomMargin: CGFloat = 2
        static let accessoryButtonMarginLeft: CGFloat = 8
        static var accessoryButtonTextStyle: MSTextStyle = .button2
    }

    @objc public static var identifier: String { return String(describing: self) }

    /// The height of the view based on the height of its content.
    ///
    /// - Parameters:
    ///   - style: The `MSTableViewHeaderFooterView.Style` used to set up the view.
    ///   - title: The title string.
    ///   - titleNumberOfLines: The number of lines that the title should display.
    ///   - containerWidth: The width of the view's super view (e.g. the table view's width).
    /// - Returns: a value representing the calculated height of the view.
    @objc public class func height(style: Style, title: String, titleNumberOfLines: Int = 1, containerWidth: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let titleWidth = containerWidth - (Constants.horizontalMargin + MSTableViewHeaderFooterView.titleRightOffset())
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
     ///   - style: The `MSTableViewHeaderFooterView.Style` used to set up the view.
     ///   - title: The title string.
     ///   - accessoryButton: An optional accessory button that appears near the trailing edge of the view.
     /// - Returns: a value representing the calculated preferred width of the view.
     @objc public class func preferredWidth(style: Style, title: String, accessoryButton: UIButton? = nil) -> CGFloat {
        let titleSize = title.preferredSize(for: Constants.titleTextStyle.font)

        var width = Constants.horizontalMargin + titleSize.width + Constants.horizontalMargin

        if let accessoryButton = accessoryButton {
            width += Constants.accessoryButtonMarginLeft + accessoryButton.width
        }

        return width
    }

    private static func titleRightOffset(accessoryButton: UIButton? = nil) -> CGFloat {
        let accessoryButtonSpacing: CGFloat
        if let accessoryButton = accessoryButton {
            accessoryButtonSpacing = Constants.accessoryButtonMarginLeft + accessoryButton.width
        } else {
            accessoryButtonSpacing = 0
        }
        return accessoryButtonSpacing + Constants.horizontalMargin
    }

    /// The maximum number of lines to be shown for `title`
    @objc open var titleNumberOfLines: Int = 1 {
        didSet {
            titleLabel.numberOfLines = titleNumberOfLines
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    /// `onAccessoryButtonTapped` is called when `accessoryButton` is tapped
    @objc open var onAccessoryButtonTapped: (() -> Void)?

    open override var intrinsicContentSize: CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleLabel.text ?? "",
                accessoryButton: accessoryButton
            ),
            height: type(of: self).height(
                style: style,
                title: titleLabel.text ?? "",
                titleNumberOfLines: titleNumberOfLines,
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

    private var style: Style = .header {
        didSet {
            let view = UIView()
            view.backgroundColor = style.backgroundColor
            backgroundView = view

            titleLabel.textColor = style.textColor

            invalidateIntrinsicContentSize()
        }
    }

    private let titleLabel = MSLabel(style: Constants.titleTextStyle)

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
        contentView.addSubview(titleLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @objc open func setup(style: Style, title: String, accessoryButtonTitle: String = "") {
        titleLabel.text = title
        accessoryButton = accessoryButtonTitle != "" ? createAccessoryButton(withTitle: accessoryButtonTitle) : nil
        self.style = style

        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        accessoryButton?.sizeToFit()

        let titleWidth = contentView.width - (Constants.horizontalMargin + MSTableViewHeaderFooterView.titleRightOffset(accessoryButton: accessoryButton))
        let titleHeight: CGFloat
        let titleYOffset: CGFloat
        switch style {
        case .header, .footer:
            titleYOffset = style == .header ? Constants.titleDefaultTopMargin : Constants.titleDefaultBottomMargin
            titleHeight = contentView.height - Constants.titleDefaultTopMargin - Constants.titleDefaultBottomMargin
        case .divider, .dividerHighlighted:
            titleYOffset = Constants.titleDividerVerticalMargin
            titleHeight = contentView.height - (Constants.titleDividerVerticalMargin * 2)
        }
        titleLabel.frame = CGRect(
            x: Constants.horizontalMargin,
            y: titleYOffset,
            width: titleWidth,
            height: titleHeight
        )

        if let accessoryButton = accessoryButton {
            let xOffset = titleLabel.frame.maxX + Constants.accessoryButtonMarginLeft
            let yOffset = contentView.height - accessoryButton.height - Constants.accessoryButtonBottomMargin
            accessoryButton.frame = CGRect(
                origin: CGPoint(x: xOffset, y: yOffset),
                size: accessoryButton.frame.size
            )
        }

        contentView.flipSubviewsForRTL()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: type(of: self).preferredWidth(
                style: style,
                title: titleLabel.text ?? "",
                accessoryButton: accessoryButton
            ),
            height: type(of: self).height(
                style: style,
                title: titleLabel.text ?? "",
                titleNumberOfLines: titleNumberOfLines,
                containerWidth: size.width
            )
        )
    }

    private func updateAccessoryButtonTitleStyle() {
        accessoryButton?.titleLabel?.font = Constants.accessoryButtonTextStyle.font
        accessoryButton?.setTitleColor(MSColors.Table.HeaderFooter.text, for: .normal)
    }

    private func createAccessoryButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(handleAccessoryButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func handleContentSizeCategoryDidChange() {
        updateAccessoryButtonTitleStyle()
    }

    @objc private func handleAccessoryButtonTapped() {
        onAccessoryButtonTapped?()
    }
}
