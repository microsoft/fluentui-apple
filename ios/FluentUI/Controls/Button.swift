//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ButtonStyle

@available(*, deprecated, renamed: "ButtonStyle")
public typealias MSButtonStyle = ButtonStyle

@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless

    public var contentEdgeInsets: UIEdgeInsets {
        switch self {
        case .primaryFilled, .primaryOutline:
            return UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        case .secondaryOutline:
            return UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        case .borderless:
            return UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
        case .tertiaryOutline:
            return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primaryFilled, .primaryOutline, .secondaryOutline, .borderless:
            return 8
        case .tertiaryOutline:
            return 5
        }
    }

    var hasBorders: Bool {
        switch self {
        case .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return true
        case .primaryFilled, .borderless:
            return false
        }
    }

    var minTitleLabelHeight: CGFloat {
        switch self {
        case .primaryFilled, .primaryOutline, .borderless:
            return 20
        case .secondaryOutline, .tertiaryOutline:
            return 18
        }
    }

    var titleFont: UIFont {
        switch self {
        case .primaryFilled, .primaryOutline, .borderless:
            return MSFonts.button1
        case .secondaryOutline, .tertiaryOutline:
            return MSFonts.button2
        }
    }
}

// MARK: - Button

/// By default, `titleLabel`'s `adjustsFontForContentSizeCategory` is set to true to automatically update its font when device's content size category changes
@available(*, deprecated, renamed: "Button")
public typealias MSButton = Button

@IBDesignable
@objc(MSFButton)
open class Button: UIButton {
    private struct Constants {
        static let borderWidth: CGFloat = 1
    }

    @objc open var style: ButtonStyle = .secondaryOutline {
        didSet {
            if style != oldValue {
                update()
            }
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                update()
            }
        }
    }

    open override var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                update()
            }
        }
    }

    open override var intrinsicContentSize: CGSize {
        var size = titleLabel?.systemLayoutSizeFitting(CGSize(width: proposedTitleLabelWidth == 0 ? .greatestFiniteMagnitude : proposedTitleLabelWidth, height: .greatestFiniteMagnitude)) ?? .zero
        size.width = ceil(size.width + contentEdgeInsets.left + contentEdgeInsets.right)
        size.height = ceil(max(size.height, style.minTitleLabelHeight) + contentEdgeInsets.top + contentEdgeInsets.bottom)
        return size
    }

    /// if value is 0.0, CGFloat.greatestFiniteMagnitude is used to calculate the width of the `titleLabel` in `intrinsicContentSize`
    private var proposedTitleLabelWidth: CGFloat = 0.0 {
        didSet {
            if proposedTitleLabelWidth != oldValue {
                invalidateIntrinsicContentSize()
            }
        }
    }

    @objc public init(style: ButtonStyle = .secondaryOutline) {
        self.style = style
        super.init(frame: .zero)
        initialize()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        layer.cornerRadius = style.cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }

        titleLabel?.font = style.titleFont
        titleLabel?.adjustsFontForContentSizeCategory = true
        update()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        proposedTitleLabelWidth = bounds.width - (contentEdgeInsets.left + contentEdgeInsets.right)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13, *) {
            if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                updateBorderColor()
            }
        }
    }

    public func updateTitleColors() {
        let titleColor = style == .primaryFilled ? Colors.Button.titleWithFilledBackground : Colors.Button.title
        let titleColorHighlighted = style == .primaryFilled ? titleColor : Colors.Button.titleHighlighted
        let titleColorDisabled = style == .primaryFilled ? titleColor : Colors.Button.titleDisabled
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColorHighlighted, for: .highlighted)
        setTitleColor(titleColorDisabled, for: .disabled)
    }

    private func update() {
        updateTitleColors()
        updateBackgroundColor()
        updateBorderColor()

        layer.borderWidth = style.hasBorders ? Constants.borderWidth : 0

        contentEdgeInsets = style.contentEdgeInsets
    }

    private func updateBackgroundColor() {
        let backgroundColor: UIColor
        if isHighlighted {
            backgroundColor = style == .primaryFilled ? Colors.Button.backgroundFilledHighlighted : Colors.Button.background
        } else if !isEnabled {
            backgroundColor = style == .primaryFilled ? Colors.Button.backgroundFilledDisabled : Colors.Button.background
        } else {
            backgroundColor = style == .primaryFilled ? Colors.Button.backgroundFilled : Colors.Button.background
        }
        self.backgroundColor = backgroundColor
    }

    private func updateBorderColor() {
        if !style.hasBorders {
            return
        }

        let borderColor: UIColor
        if isHighlighted {
            borderColor = Colors.Button.borderHighlighted
        } else if !isEnabled {
            borderColor = Colors.Button.borderDisabled
        } else {
            borderColor = Colors.Button.border
        }
        layer.borderColor = borderColor.cgColor
    }
}
