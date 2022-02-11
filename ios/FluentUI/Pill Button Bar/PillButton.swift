//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

/// A `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton, TokenizedUIControlInternal, ControlConfiguration {

    /// Set `backgroundColor` to customize background color of the pill button
    @objc open var customBackgroundColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    /// Set `selectedBackgroundColor` to customize background color of the pill button
    @objc open var customSelectedBackgroundColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    /// Set `textColor` to customize background color of the pill button
    @objc open var customTextColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    /// Set `selectedTextColor` to customize background color of the pill button
    @objc open var customSelectedTextColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    /// Set `unreadDotColor` to customize color of the pill button unread dot
    @objc open var customUnreadDotColor: UIColor? {
        didSet {
            updateAppearance()
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        updatePillButtonTokens()
        updateAppearance()
    }

    @objc public init(pillBarItem: PillButtonBarItem, style: PillButtonStyle = .primary) {
        self.pillBarItem = pillBarItem
        self.style = style
        tokens.style = style
        super.init(frame: .zero)
        setupView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: PillButtonBarItem.isUnreadValueDidChangeNotification,
                                               object: pillBarItem)
    }

    var unreadDotColor: UIColor = Colors.gray100

    @objc public static let cornerRadius: CGFloat = 16.0

    @objc public let pillBarItem: PillButtonBarItem

    @objc public let style: PillButtonStyle

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public override var isSelected: Bool {
        didSet {
            if oldValue != isSelected && isSelected == true {
                pillBarItem.isUnread = false
                updateUnreadDot()
            }
            updateAppearance()
            updateAccessibilityTraits()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateAppearance()
            updateAccessibilityTraits()
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            updateAppearance()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUnreadDot()
    }

    public func overrideTokens(_ tokens: PillButtonTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    public typealias TokenType = PillButtonTokens

    var config: PillButton { self }
    var tokens: PillButtonTokens = .init()
    var overrideTokens: PillButtonTokens? {
        didSet {
            updatePillButtonTokens()
        }
    }

    private func setupView() {
        setTitle(pillBarItem.title, for: .normal)
        titleLabel?.font = UIFont.fluent(tokens.font, shouldScale: false)
        layer.cornerRadius = PillButton.cornerRadius
        clipsToBounds = true

        layer.cornerCurve = .continuous
        largeContentTitle = titleLabel?.text
        showsLargeContentViewer = true

        contentEdgeInsets = UIEdgeInsets(top: tokens.topInset,
                                         left: tokens.horizontalInset,
                                         bottom: tokens.bottomInset,
                                         right: tokens.horizontalInset)

    }

    private func updateAccessibilityTraits() {
        if isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }

        if isEnabled {
            accessibilityTraits.remove(.notEnabled)
        } else {
            accessibilityTraits.insert(.notEnabled)
        }
    }

    private var isUnreadDotVisible: Bool = false {
        didSet {
            if oldValue != isUnreadDotVisible {
                if isUnreadDotVisible {
                    layer.addSublayer(unreadDotLayer)
                } else {
                    unreadDotLayer.removeFromSuperlayer()
                }
            }
        }
    }

    private lazy var unreadDotLayer: CALayer = initUnreadDotLayer()

    private func initUnreadDotLayer() -> CALayer {
        let unreadDotLayer = CALayer()

        unreadDotLayer.bounds.size = CGSize(width: tokens.unreadDotSize, height: tokens.unreadDotSize)
        unreadDotLayer.cornerRadius = tokens.unreadDotSize / 2

        return unreadDotLayer
    }

    @objc private func isUnreadValueDidChange() {
        isUnreadDotVisible = pillBarItem.isUnread
        setNeedsLayout()
    }

    private func updateUnreadDot() {
        isUnreadDotVisible = pillBarItem.isUnread
        if isUnreadDotVisible {
            let anchor = self.titleLabel?.frame ?? .zero
            let xPos: CGFloat
            if effectiveUserInterfaceLayoutDirection == .leftToRight {
                xPos = round(anchor.maxX + tokens.unreadDotOffsetX)
            } else {
                xPos = round(anchor.minX - tokens.unreadDotOffsetX - tokens.unreadDotSize)
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + tokens.unreadDotOffsetY)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private func updateAppearance() {
        if isSelected {
            if isEnabled {
                if let customSelectedBackgroundColor = customSelectedBackgroundColor {
                    backgroundColor = customSelectedBackgroundColor
                } else {
                    backgroundColor = isHighlighted
                    ? UIColor(dynamicColor: tokens.backgroundColor.selectedHighlighted)
                    : UIColor(dynamicColor: tokens.backgroundColor.selected)
                }

                setTitleColor(customSelectedTextColor ?? UIColor(dynamicColor: tokens.titleColor.selected), for: .normal)
                setTitleColor(customSelectedTextColor ?? UIColor(dynamicColor: tokens.titleColor.selectedHighlighted), for: .highlighted)
            } else {
                backgroundColor = UIColor(dynamicColor: tokens.backgroundColor.selectedDisabled)
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.selectedDisabled), for: .normal)
            }
        } else {
            if let customBackgroundColor = customBackgroundColor {
                backgroundColor = customBackgroundColor
            } else {
                backgroundColor = isEnabled
                    ? (isHighlighted
                       ? UIColor(dynamicColor: tokens.backgroundColor.highlighted)
                       : UIColor(dynamicColor: tokens.backgroundColor.rest))
                : UIColor(dynamicColor: tokens.backgroundColor.disabled)
            }

            if isEnabled {
                setTitleColor(customTextColor ?? UIColor(dynamicColor: tokens.titleColor.rest), for: .normal)
                setTitleColor(customTextColor ?? UIColor(dynamicColor: tokens.titleColor.highlighted), for: .highlighted)
            } else {
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.disabled), for: .disabled)
            }

            if isEnabled {
                unreadDotColor = customUnreadDotColor ?? UIColor(dynamicColor: tokens.enabledUnreadDotColor)
            } else {
                unreadDotColor = customUnreadDotColor ?? UIColor(dynamicColor: tokens.disabledUnreadDotColor)
            }
        }
    }

    private func updatePillButtonTokens() {
        let tokens = UIControlTokenResolver.tokens(for: self, fluentTheme: fluentTheme)
        self.tokens = tokens
    }
}
