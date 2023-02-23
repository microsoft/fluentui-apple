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
    @objc open var size: BadgeView.Size
    @objc open var customView: UIView?
    @objc open var customViewVerticalPadding: NSNumber?
    @objc open var customViewPaddingLeft: NSNumber?
    @objc open var customViewPaddingRight: NSNumber?

    @objc public init(text: String, style: BadgeView.Style = .default, size: BadgeView.Size = .medium) {
        self.text = text
        self.style = style
        self.size = size
        super.init()
    }

    @objc public convenience init(
        text: String,
        style: BadgeView.Style = .default,
        size: BadgeView.Size = .medium,
        customView: UIView? = nil,
        customViewVerticalPadding: NSNumber? = nil,
        customViewPaddingLeft: NSNumber? = nil,
        customViewPaddingRight: NSNumber? = nil
    ) {
        self.init(text: text, style: style, size: size)

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
    @objc(MSFBadgeViewStyle)
    public enum Style: Int {
        case `default`
        case warning
        case error
        case neutral
        case severeWarning
        case success
    }

    @objc(MSFBadgeViewSize)
    public enum Size: Int, CaseIterable {
        case small
        case medium

        var labelTextStyle: AliasTokens.TypographyTokens {
            switch self {
            case .small:
                return .caption1
            case .medium:
                return .body2
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return 4
            case .medium:
                return 5
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small:
                return 1.5
            case .medium:
                return 4
            }
        }
    }

    private struct Constants {
        static let defaultMinWidth: CGFloat = 25
        static let backgroundCornerRadius: CGFloat = 3
    }

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

    private var _labelTextColor: UIColor?
    @objc open var labelTextColor: UIColor? {
        get {
            if let customLabelTextColor = _labelTextColor {
                return customLabelTextColor
            }
            switch style {
            case .default:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.brandForegroundTint])
            case .warning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.warningForeground1])
            case .error:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.dangerForeground1])
            case .neutral:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foreground2])
            case .severeWarning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.severeForeground1])
            case .success:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.successForeground1])
            }
        }
        set {
            if labelTextColor != newValue {
                _labelTextColor = newValue
                updateColors()
            }
        }
    }

    private var _selectedLabelTextColor: UIColor?
    @objc open var selectedLabelTextColor: UIColor {
        get {
            if let customSelectedLabelTextColor = _selectedLabelTextColor {
                return customSelectedLabelTextColor
            }

            switch style {
            case .default:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foregroundOnColor])
            case .warning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foregroundDarkStatic])
            case .error,
                 .severeWarning,
                 .success:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foregroundLightStatic])
            case .neutral:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foreground1])
            }
        }
        set {
            if selectedLabelTextColor != newValue {
                _selectedLabelTextColor = newValue
                updateColors()
            }
        }
    }

    private var _disabledLabelTextColor: UIColor?
    @objc open var disabledLabelTextColor: UIColor? {
        get {
            if let customDisabledLabelTextColor = _disabledLabelTextColor {
                return customDisabledLabelTextColor
            }

            let textDisabledColor = UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.foregroundDisabled1])
            if style == .default {
                return UIColor(light: UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.brandForegroundDisabled1]), dark: textDisabledColor)
            } else {
                return textDisabledColor
            }
        }
        set {
            if disabledBackgroundColor != newValue {
                _disabledLabelTextColor = newValue
                updateColors()
            }
        }
    }

    private var _backgroundColor: UIColor?
    @objc open override var backgroundColor: UIColor? {
        get {
            if let customBackgroundColor = _backgroundColor {
                return customBackgroundColor
            }
            switch style {
            case .default:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.brandBackgroundTint])
            case .warning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.warningBackground1])
            case .error:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.dangerBackground1])
            case .neutral:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.background5])
            case .severeWarning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.severeBackground1])
            case .success:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.successBackground1])
            }
        }
        set {
            if backgroundColor != newValue {
                _backgroundColor = newValue
                updateColors()
            }
        }
    }

    private var _selectedBackgroundColor: UIColor?
    @objc open var selectedBackgroundColor: UIColor? {
        get {
            if let customSelectedBackgroundColor = _selectedBackgroundColor {
                return customSelectedBackgroundColor
            }
            switch style {
            case .default:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.brandBackground1])
            case .warning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.warningBackground2])
            case .error:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.dangerBackground2])
            case .neutral:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.background5Selected])
            case .severeWarning:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.severeBackground2])
            case .success:
                return UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.successBackground2])
            }
        }
        set {
            if selectedBackgroundColor != newValue {
                _selectedBackgroundColor = newValue
                updateColors()
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

    private var _disabledBackgroundColor: UIColor?
    open var disabledBackgroundColor: UIColor? {
        get {
            if let customDisabledBackgroundColor = _disabledBackgroundColor {
                return customDisabledBackgroundColor
            }

            let backgroundDisabledColor = UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.background5])
            if style == .default {
                return UIColor(light: UIColor(dynamicColor: tokenSet.fluentTheme.aliasTokens.colors[.brandBackground3]), dark: backgroundDisabledColor)
            } else {
                return backgroundDisabledColor
            }
        }
        set {
            if disabledBackgroundColor != newValue {
                _disabledBackgroundColor = newValue
                updateColors()
            }
        }
    }

    @objc open var minWidth: CGFloat = Constants.defaultMinWidth {
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

    public typealias TokenSetKeyType = EmptyTokenSet.Tokens
    public var tokenSet: EmptyTokenSet = .init()

    private var style: Style = .default {
        didSet {
            updateColors()
        }
    }

    private var size: Size = .medium {
        didSet {
            label.style = size.labelTextStyle
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
        let defaultVerticalPadding = size.verticalPadding
        let defaultHorizontalPadding = size.horizontalPadding
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

        backgroundView.layer.cornerRadius = Constants.backgroundCornerRadius
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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        defer {
            self.dataSource = dataSource
        }

        updateFonts()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateColors()
        updateFonts()
    }

    private func updateFonts() {
        switch size {
        case .small:
            label.font = UIFont.fluent(tokenSet.fluentTheme.aliasTokens.typography[.caption1])
        case .medium:
            label.font = UIFont.fluent(tokenSet.fluentTheme.aliasTokens.typography[.body2])
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
            label.frame = bounds.insetBy(dx: size.horizontalPadding, dy: size.verticalPadding)
        }

        flipSubviewsForRTL()
    }

    func reload() {
        label.text = dataSource?.text
        style = dataSource?.style ?? .default
        size = dataSource?.size ?? .medium

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
            let heightForLabel = labelSize.height + self.size.verticalPadding * 2
            height = max(heightForCustomView, heightForLabel)
            width = labelSize.width + customViewSize.width + customViewPadding.left + customViewPadding.right + self.size.horizontalPadding * 2
        } else {
            height = labelSize.height + self.size.verticalPadding * 2
            width = labelSize.width + self.size.horizontalPadding * 2
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
        backgroundView.backgroundColor = isActive ? (isSelected ? selectedBackgroundColor : backgroundColor) : disabledBackgroundColor
        super.backgroundColor = .clear
    }

    private func updateLabelTextColor() {
        label.textColor = isActive ? (isSelected ? selectedLabelTextColor : labelTextColor) : disabledLabelTextColor
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
}
