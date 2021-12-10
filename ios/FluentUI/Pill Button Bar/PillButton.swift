//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

/// A `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton, FluentUIWindowProvider {

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

        pillButtonTokens.updateForCurrentTheme()
        updateAppearance()
    }

    @objc public init(pillBarItem: PillButtonBarItem, style: PillButtonStyle = .primary) {
        self.pillBarItem = pillBarItem
        self.style = style
        self.pillButtonTokens = MSFPillButtonTokens(style: style)
        super.init(frame: .zero)
        pillButtonTokens.windowProvider = self
        setupView()

        pillButtonTokens.themeDidUpdate = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateAppearance()
        }

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

    private func setupView() {
        setTitle(pillBarItem.title, for: .normal)
        titleLabel?.font = pillButtonTokens.font
        layer.cornerRadius = PillButton.cornerRadius
        clipsToBounds = true

        layer.cornerCurve = .continuous
        largeContentTitle = titleLabel?.text
        showsLargeContentViewer = true

        contentEdgeInsets = UIEdgeInsets(top: pillButtonTokens.topInset,
                                         left: pillButtonTokens.horizontalInset,
                                         bottom: pillButtonTokens.bottomInset,
                                         right: pillButtonTokens.horizontalInset)

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

    private lazy var unreadDotLayer: CALayer = {
            let unreadDotLayer = CALayer()

            unreadDotLayer.bounds.size = CGSize(width: pillButtonTokens.unreadDotSize, height: pillButtonTokens.unreadDotSize)
            unreadDotLayer.cornerRadius = pillButtonTokens.unreadDotSize / 2

            return unreadDotLayer
        }()

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
                xPos = round(anchor.maxX + pillButtonTokens.unreadDotOffsetX)
            } else {
                xPos = round(anchor.minX - pillButtonTokens.unreadDotOffsetX - pillButtonTokens.unreadDotSize)
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + pillButtonTokens.unreadDotOffsetY)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private func updateAppearance() {
        if window != nil {
            if isSelected {
                if isEnabled {
                    if let customSelectedBackgroundColor = customSelectedBackgroundColor {
                        backgroundColor = customSelectedBackgroundColor
                    } else {
                        backgroundColor = isHighlighted
                            ? pillButtonTokens.selectedHighlightedBackgroundColor
                            : pillButtonTokens.selectedBackgroundColor
                    }

                    setTitleColor(customSelectedTextColor ?? pillButtonTokens.selectedTitleColor, for: .normal)
                    setTitleColor(customSelectedTextColor ?? pillButtonTokens.selectedHighlightedTitleColor, for: .highlighted)
                } else {
                    backgroundColor = pillButtonTokens.selectedDisabledBackgroundColor
                    setTitleColor(pillButtonTokens.selectedDisabledTitleColor, for: .normal)
                }
            } else {
                if let customBackgroundColor = customBackgroundColor {
                    backgroundColor = customBackgroundColor
                } else {
                    backgroundColor = isEnabled
                        ? (isHighlighted
                            ? pillButtonTokens.highlightedBackgroundColor
                            : pillButtonTokens.backgroundColor)
                        : pillButtonTokens.disabledBackgroundColor
                }

                if isEnabled {
                    setTitleColor(customTextColor ?? pillButtonTokens.titleColor, for: .normal)
                    setTitleColor(customTextColor ?? pillButtonTokens.highlightedTitleColor, for: .highlighted)
                } else {
                    setTitleColor(pillButtonTokens.disabledTitleColor, for: .disabled)
                }

                if isEnabled {
                    unreadDotColor = customUnreadDotColor ?? pillButtonTokens.enabledUnreadDotColor
                } else {
                    unreadDotColor = customUnreadDotColor ?? pillButtonTokens.disabledUnreadDotColor
                }
            }
        }
    }

    private var pillButtonTokens: MSFPillButtonTokens
}
