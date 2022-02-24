//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

/// A `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton, TokenizedControlInternal {

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        updatePillButtonTokens()
        updateAppearance()
    }

    @objc public init(pillBarItem: PillButtonBarItem, style: PillButtonStyle = .primary) {
        self.pillBarItem = pillBarItem
        self.style = style
        super.init(frame: .zero)
        setupView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: PillButtonBarItem.isUnreadValueDidChangeNotification,
                                               object: pillBarItem)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUnreadDot()
    }

    public func overrideTokens(_ tokens: PillButtonTokens?) -> Self {
        overrideTokens = tokens
        return self
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

    @objc public static let cornerRadius: CGFloat = 16.0

    @objc public let pillBarItem: PillButtonBarItem

    @objc public let style: PillButtonStyle

    let defaultTokens: PillButtonTokens = .init()
    var tokens: PillButtonTokens = .init()
    var overrideTokens: PillButtonTokens? {
        didSet {
            updatePillButtonTokens()
            updateAppearance()
        }
    }

    var unreadDotColor: UIColor = Colors.gray100

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
                backgroundColor = UIColor(dynamicColor: tokens.backgroundColor.selected)
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.selected), for: .normal)
            } else {
                backgroundColor = UIColor(dynamicColor: tokens.backgroundColor.selectedDisabled)
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.selectedDisabled), for: .normal)
            }
        } else {
            backgroundColor = isEnabled
            ? UIColor(dynamicColor: tokens.backgroundColor.rest)
            : UIColor(dynamicColor: tokens.backgroundColor.disabled)

            if isEnabled {
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.rest), for: .normal)
            } else {
                setTitleColor(UIColor(dynamicColor: tokens.titleColor.disabled), for: .disabled)
            }

            unreadDotColor = isEnabled
            ? UIColor(dynamicColor: tokens.enabledUnreadDotColor)
            : UIColor(dynamicColor: tokens.disabledUnreadDotColor)
        }
    }

    private func updatePillButtonTokens() {
        let tokens = resolvedTokens()
        tokens.style = style
        self.tokens = tokens
    }

    private lazy var unreadDotLayer: CALayer = initUnreadDotLayer()

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
}
