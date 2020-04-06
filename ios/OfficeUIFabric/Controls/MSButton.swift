//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSButtonStyle

@objc public enum MSButtonStyle: Int, CaseIterable {
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
}

// MARK: - MSButton

@IBDesignable
open class MSButton: UIButton {
    private struct Constants {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static var titleFont: UIFont { return MSFonts.button1 }
    }

    @objc open var style: MSButtonStyle = .secondaryOutline {
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

    @objc public init(style: MSButtonStyle = .secondaryOutline) {
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
        layer.cornerRadius = Constants.cornerRadius
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }

        titleLabel?.font = Constants.titleFont
        update()

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        proposedTitleLabelWidth = bounds.width - (contentEdgeInsets.left + contentEdgeInsets.right)
    }

    public func updateTitleColors() {
        let titleColor = style == .primaryFilled ? MSColors.Button.titleWithFilledBackground : MSColors.Button.title
        let titleColorHighlighted = style == .primaryFilled ? titleColor : MSColors.Button.titleHighlighted
        let titleColorDisabled = style == .primaryFilled ? titleColor : MSColors.Button.titleDisabled
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColorHighlighted, for: .highlighted)
        setTitleColor(titleColorDisabled, for: .disabled)
    }

    private func update() {
        updateTitleColors()

        let backgroundColor: UIColor
        let borderColor: UIColor
        if isHighlighted {
            backgroundColor = style == .primaryFilled ? MSColors.Button.backgroundFilledHighlighted : MSColors.Button.background
            borderColor = MSColors.Button.borderHighlighted
        } else if !isEnabled {
            backgroundColor = style == .primaryFilled ? MSColors.Button.backgroundFilledDisabled : MSColors.Button.background
            borderColor = MSColors.Button.borderDisabled
        } else {
            backgroundColor = style == .primaryFilled ? MSColors.Button.backgroundFilled : MSColors.Button.background
            borderColor = MSColors.Button.border
        }
        self.backgroundColor = backgroundColor
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = style.hasBorders ? Constants.borderWidth : 0

        contentEdgeInsets = style.contentEdgeInsets
    }

    @objc private func handleContentSizeCategoryDidChange() {
        update()
    }
}
