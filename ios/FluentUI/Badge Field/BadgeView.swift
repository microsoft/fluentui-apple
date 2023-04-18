//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeViewDataSource
@objc(MSFBadgeViewDataSource)
open class BadgeViewDataSource: NSObject {
    @objc open var text: String
    @objc open var style: BadgeView.Style
    @objc open var sizeCategory: BadgeView.SizeCategory
    @objc open var customView: UIView?
    @objc open var customViewVerticalPadding: NSNumber?
    @objc open var customViewPaddingLeft: NSNumber?
    @objc open var customViewPaddingRight: NSNumber?

    @objc public init(text: String, style: BadgeView.Style = .default, sizeCategory: BadgeView.SizeCategory = .medium) {
        self.text = text
        self.style = style
        self.sizeCategory = sizeCategory
        super.init()
    }

    @objc public convenience init(
        text: String,
        style: BadgeView.Style = .default,
        sizeCategory: BadgeView.SizeCategory = .medium,
        customView: UIView? = nil,
        customViewVerticalPadding: NSNumber? = nil,
        customViewPaddingLeft: NSNumber? = nil,
        customViewPaddingRight: NSNumber? = nil
    ) {
        self.init(text: text, style: style, sizeCategory: sizeCategory)

        self.customView = customView
        self.customViewVerticalPadding = customViewVerticalPadding
        self.customViewPaddingLeft = customViewPaddingLeft
        self.customViewPaddingRight = customViewPaddingRight
    }
}

// MARK: - BadgeViewDelegate
@objc(MSFBadgeViewDelegate)
public protocol BadgeViewDelegate {
    func didSelectBadge(_ badge: BadgeView)
    func didTapSelectedBadge(_ badge: BadgeView)
}

// MARK: - BadgeView

/**
 `BadgeView` is used to present text with a colored background in the form of a "badge". It is used in `BadgeField` to represent a selected item.

 `BadgeView` can be selected with a tap gesture and tapped again after entering a selected state for the purpose of displaying more details about the entity represented by the selected badge.
 */
@objc(MSFBadgeView)
open class BadgeView: UIView, TokenizedControlInternal {
    @objc open var dataSource: BadgeViewDataSource? {
        didSet {
            reload()
        }
    }

    @objc open weak var delegate: BadgeViewDelegate?

    @objc open var isActive: Bool = true {
        didSet {
            updateColors()
            isUserInteractionEnabled = isActive
            if isActive {
                accessibilityTraits.remove(.notEnabled)
            } else {
                accessibilityTraits.insert(.notEnabled)
            }
        }
    }

    @objc open var isSelected: Bool = false {
        didSet {
            updateColors()
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    @objc open var lineBreakMode: NSLineBreakMode {
        set {
            label.lineBreakMode = newValue
        }
        get {
            label.lineBreakMode
        }
    }

    @objc open var minWidth: CGFloat = BadgeViewTokenSet.defaultMinWidth {
        didSet {
            setNeedsLayout()
        }
    }

    /**
     The maximum allowed size point for the label's font. This property can be used
     to restrict the largest size of the label when scaling due to Dynamic Type. The
     default value is 0, indicating there is no maximum size.
     */
    open var maxFontSize: CGFloat = 0 {
        didSet {
            label.maxFontSize = maxFontSize
            invalidateIntrinsicContentSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
    }

    public typealias TokenSetKeyType = BadgeViewTokenSet.Tokens
    lazy public var tokenSet: BadgeViewTokenSet = .init(style: { [weak self] in
        return self?.style ?? .default
    },
                                                     sizeCategory: { [weak self] in
        return self?.sizeCategory ?? .medium
    })

    private var style: Style = .default {
        didSet {
            updateColors()
        }
    }

    private var sizeCategory: SizeCategory = .medium {
        didSet {
            label.style = sizeCategory.labelTextStyle
            invalidateIntrinsicContentSize()
        }
    }

    private var labelSize: CGSize {
        let size = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
        let width = ceil(size.width)
        let height = ceil(size.height)
        return CGSize(width: width, height: height)
    }

    private var customViewPadding: UIEdgeInsets {
        let getFloat: (_ number: NSNumber?, _ defaultValue: CGFloat) -> CGFloat = { (number, defaultValue) in
            if let number = number {
                return CGFloat(truncating: number)
            }
            return defaultValue
        }
        let defaultVerticalPadding = BadgeViewTokenSet.verticalPadding
        let defaultHorizontalPadding = BadgeViewTokenSet.horizontalPadding(sizeCategory)
        return UIEdgeInsets(
            top: getFloat(dataSource?.customViewVerticalPadding, defaultVerticalPadding),
            left: getFloat(dataSource?.customViewPaddingLeft, defaultHorizontalPadding),
            bottom: getFloat(dataSource?.customViewVerticalPadding, defaultVerticalPadding),
            right: getFloat(dataSource?.customViewPaddingRight, defaultHorizontalPadding)
        )
    }

    private let backgroundView = UIView()

    private let label = Label()

    @objc public init(dataSource: BadgeViewDataSource) {
        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = tokenSet[.borderRadius].float
        backgroundView.layer.cornerCurve = .continuous

        addSubview(backgroundView)

        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.backgroundColor = .clear
        addSubview(label)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(badgeTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        isAccessibilityElement = true
        accessibilityTraits = .button

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(invalidateIntrinsicContentSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateColors()
            self?.updateFonts()
        }

        defer {
            self.dataSource = dataSource
        }

        updateFonts()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func updateFonts() {
        switch sizeCategory {
        case .small:
            label.font = tokenSet.fluentTheme.typography(.caption1)
        case .medium:
            label.font = tokenSet.fluentTheme.typography(.body2)
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds

        if let customViewSize = customViewSize(for: frame.size), customViewSize != .zero {
            let customViewOrigin = CGPoint(x: customViewPadding.left, y: (frame.height - customViewSize.height) / 2)
            dataSource?.customView?.frame = CGRect(origin: customViewOrigin, size: customViewSize)
            let labelOrigin = CGPoint(x: customViewPadding.left + customViewPadding.right + customViewSize.width, y: (frame.height - labelSize.height) / 2)
            let labelSizeThatFits = CGSize(width: frame.size.width - labelOrigin.x, height: labelSize.height)
            label.frame = CGRect(origin: labelOrigin, size: labelSizeThatFits)
        } else {
            label.frame = bounds.insetBy(dx: BadgeViewTokenSet.horizontalPadding(sizeCategory), dy: BadgeViewTokenSet.verticalPadding)
        }

        flipSubviewsForRTL()
    }

    func reload() {
        label.text = dataSource?.text
        style = dataSource?.style ?? .default
        sizeCategory = dataSource?.sizeCategory ?? .medium

        dataSource?.customView?.removeFromSuperview()
        if let customView = dataSource?.customView {
            addSubview(customView)
        }

        setNeedsLayout()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width: CGFloat
        let height: CGFloat

        if let customViewSize = customViewSize(for: size), customViewSize != .zero {
            let heightForCustomView = customViewSize.height + customViewPadding.top + customViewPadding.bottom
            let heightForLabel = labelSize.height + BadgeViewTokenSet.verticalPadding * 2
            height = max(heightForCustomView, heightForLabel)
            width = labelSize.width + customViewSize.width + customViewPadding.left + customViewPadding.right + BadgeViewTokenSet.horizontalPadding(self.sizeCategory) * 2
        } else {
            height = labelSize.height + BadgeViewTokenSet.verticalPadding * 2
            width = labelSize.width + BadgeViewTokenSet.horizontalPadding(self.sizeCategory) * 2
        }

        let maxWidth = size.width > 0 ? size.width : .infinity
        let maxHeight = size.height > 0 ? size.height : .infinity

        return CGSize(width: max(minWidth, min(width, maxWidth)), height: min(height, maxHeight))
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColors()
        updateFonts()
    }

    private func customViewSize(for size: CGSize) -> CGSize? {
        guard let customView = dataSource?.customView else {
            return nil
        }
        return customView.bounds == .zero ? customView.sizeThatFits(size) : customView.bounds.size
    }

    private func updateColors() {
        updateBackgroundColor()
        updateLabelTextColor()
    }

    private func updateBackgroundColor() {
        backgroundView.backgroundColor = isActive ? (isSelected ? tokenSet[.backgroundFilledColor].uiColor : tokenSet[.backgroundTintColor].uiColor) : tokenSet[.backgroundDisabledColor].uiColor
        super.backgroundColor = .clear
    }

    private func updateLabelTextColor() {
        label.textColor = isActive ? (isSelected ? tokenSet[.foregroundFilledColor].uiColor : tokenSet[.foregroundTintColor].uiColor) : tokenSet[.foregroundDisabledColor].uiColor
    }

    @objc private func badgeTapped() {
        if isSelected {
            delegate?.didTapSelectedBadge(self)
        } else {
            isSelected = true
            delegate?.didSelectBadge(self)
        }
    }

    // MARK: Accessibility

    open override var accessibilityLabel: String? {
        get { return dataSource?.accessibilityLabel ?? label.text }
        set { }
    }

#if DEBUG
    open override var accessibilityIdentifier: String? {
        get { return "Badge with label \(label.text ?? "") in style \(style.rawValue)" }
        set { }
    }
#endif
}
