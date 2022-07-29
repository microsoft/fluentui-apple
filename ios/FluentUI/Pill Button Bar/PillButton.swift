//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

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
        self.tokenSet = PillButtonTokenSet(style: { style })
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

    public typealias TokenSetKeyType = PillButtonTokenSet.Tokens
    public var tokenSet: PillButtonTokenSet

    private var tokenSetSink: AnyCancellable?

    var unreadDotColor: UIColor = Colors.gray100

    private func setupView() {
        setTitle(pillBarItem.title, for: .normal)
        titleLabel?.font = UIFont.fluent(tokenSet[.font].fontInfo, shouldScale: false)
        layer.cornerRadius = PillButton.cornerRadius
        clipsToBounds = true

        layer.cornerCurve = .continuous
        largeContentTitle = titleLabel?.text
        showsLargeContentViewer = true

        contentEdgeInsets = UIEdgeInsets(top: tokenSet[.topInset].float,
                                         left: tokenSet[.horizontalInset].float,
                                         bottom: tokenSet[.bottomInset].float,
                                         right: tokenSet[.horizontalInset].float)

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.objectWillChange.sink { [weak self] _ in
           self?.updateAppearance()
        }
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

        unreadDotLayer.bounds.size = CGSize(width: tokenSet[.unreadDotSize].float, height: tokenSet[.unreadDotSize].float)
        unreadDotLayer.cornerRadius = tokenSet[.unreadDotSize].float / 2

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
                xPos = round(anchor.maxX + tokenSet[.unreadDotOffsetX].float)
            } else {
                xPos = round(anchor.minX - tokenSet[.unreadDotOffsetX].float - tokenSet[.unreadDotSize].float)
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + tokenSet[.unreadDotOffsetY].float)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private func updateAppearance() {
        if isSelected {
            if isEnabled {
                backgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.selected)
                setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selected), for: .normal)
            } else {
                backgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.selectedDisabled)
                setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selectedDisabled), for: .normal)
            }
        } else {
            backgroundColor = isEnabled
            ? UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.rest)
            : UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.disabled)

            if isEnabled {
                setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.rest), for: .normal)
            } else {
                setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.disabled), for: .disabled)
            }

            unreadDotColor = isEnabled
            ? UIColor(dynamicColor: tokenSet[.enabledUnreadDotColor].dynamicColor)
            : UIColor(dynamicColor: tokenSet[.disabledUnreadDotColor].dynamicColor)
        }

        titleLabel?.font = UIFont.fluent(tokenSet[.font].fontInfo, shouldScale: false)
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
