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

        tokenSet.update(fluentTheme)
        updateAppearance()
    }

    @objc public init(pillBarItem: PillButtonBarItem,
                      style: PillButtonStyle = .primary) {
        self.pillBarItem = pillBarItem
        self.style = style
        self.tokenSet = PillButtonTokenSet(style: { style })
        super.init(frame: .zero)
        setupView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: PillButtonBarItem.isUnreadValueDidChangeNotification,
                                               object: pillBarItem)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.objectWillChange.sink { [weak self] _ in
            // Values will be updated on the next run loop iteration.
            DispatchQueue.main.async {
                self?.updateAppearance()
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUnreadDot()
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
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(pillBarItem.title)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: Constants.topInset,
                                                                  leading: Constants.horizontalInset,
                                                                  bottom: Constants.bottomInset,
                                                                  trailing: Constants.horizontalInset)
            self.configuration = configuration

            configurationUpdateHandler = { [weak self] _ in
                self?.updateAppearance()
            }
        } else {
            setTitle(pillBarItem.title, for: .normal)
            titleLabel?.font = UIFont.fluent(tokenSet[.font].fontInfo, shouldScale: false)

            contentEdgeInsets = UIEdgeInsets(top: Constants.topInset,
                                             left: Constants.horizontalInset,
                                             bottom: Constants.bottomInset,
                                             right: Constants.horizontalInset)
        }

        layer.cornerRadius = PillButton.cornerRadius
        clipsToBounds = true

        layer.cornerCurve = .continuous
        largeContentTitle = titleLabel?.text
        showsLargeContentViewer = true
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

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        tokenSet.update(window.fluentTheme)
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

    private lazy var unreadDotLayer: CALayer = {
        let unreadDotLayer = CALayer()
        let unreadDotSize = tokenSet[.unreadDotSize].float
        unreadDotLayer.bounds.size = CGSize(width: unreadDotSize, height: unreadDotSize)
        unreadDotLayer.cornerRadius = unreadDotSize / 2
        return unreadDotLayer
    }()

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

    private func updateAppearance() {
        // TODO: Once iOS 14 support is dropped, these should be converted to constants (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        var resolvedTitleColor: UIColor = .clear

        if isSelected {
            if isEnabled {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.selected)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selected)
                } else {
                    setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selected), for: .normal)
                }
            } else {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.selectedDisabled)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selectedDisabled)
                } else {
                    setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.selectedDisabled), for: .normal)
                }
            }
        } else {
            unreadDotColor = isEnabled
                        ? UIColor(dynamicColor: tokenSet[.enabledUnreadDotColor].dynamicColor)
                        : UIColor(dynamicColor: tokenSet[.disabledUnreadDotColor].dynamicColor)
            if isEnabled {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.rest)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.rest)
                } else {
                    setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.rest), for: .normal)
                }
            } else {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].pillButtonDynamicColors.disabled)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.disabled)
                } else {
                    setTitleColor(UIColor(dynamicColor: tokenSet[.titleColor].pillButtonDynamicColors.disabled), for: .disabled)
                }
            }
        }

        if #available(iOS 15.0, *) {
            configuration?.background.backgroundColor = resolvedBackgroundColor
            configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.foregroundColor: resolvedTitleColor,
                                                                              NSAttributedString.Key.font: UIFont.fluent(tokenSet[.font].fontInfo, shouldScale: false)]))
        } else {
            backgroundColor = resolvedBackgroundColor
        }
    }

    private struct Constants {
        static let bottomInset: CGFloat = 6.0
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 6.0
    }
}
