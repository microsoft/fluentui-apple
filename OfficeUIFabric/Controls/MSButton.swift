//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

// MARK: MSButtonStyle

@objc public enum MSButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case secondaryOutline
    case borderless

    public var contentEdgeInsets: UIEdgeInsets {
        switch self {
        case .primaryFilled, .primaryOutline:
            return UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        case .secondaryOutline, .borderless:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
}

// MARK: - MSButton

@IBDesignable
open class MSButton: UIButton {
    private struct Constants {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static var titleFont: UIFont { return MSFonts.subhead }
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

    @objc public init(style: MSButtonStyle = .secondaryOutline) {
        self.style = style
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        layer.cornerRadius = Constants.cornerRadius
        update()

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    private func update() {
        let titleColor = style == .primaryFilled ? MSColors.Button.titleWithFilledBackground : MSColors.Button.title
        let titleColorHighlighted = style == .primaryFilled ? titleColor : MSColors.Button.titleHighlighted
        let titleColorDisabled = style == .primaryFilled ? titleColor : MSColors.Button.titleDisabled
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColorHighlighted, for: .highlighted)
        setTitleColor(titleColorDisabled, for: .disabled)

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

        titleLabel?.font = Constants.titleFont

        layer.borderWidth = style == .primaryOutline || style == .secondaryOutline ? Constants.borderWidth : 0

        contentEdgeInsets = style.contentEdgeInsets
    }

    @objc private func handleContentSizeCategoryDidChange() {
        update()
    }
}
