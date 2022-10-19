//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

/// An `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton {

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
        updateAppearance()
    }

    @objc public init(pillBarItem: PillButtonBarItem,
                      style: PillButtonStyle = .primary) {
        self.pillBarItem = pillBarItem
        self.style = style
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

    private func setupView() {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(pillBarItem.title)

            // Workaround for Apple bug: when UIButton.Configuration is used with UIControl's isSelected = true, accessibilityLabel doesn't get set automatically
            accessibilityLabel = pillBarItem.title

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
            titleLabel?.font = Constants.font

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

    private let unreadDotLayer: CALayer = {
        let unreadDotLayer = CALayer()
        unreadDotLayer.bounds.size = CGSize(width: Constants.unreadDotSize, height: Constants.unreadDotSize)
        unreadDotLayer.cornerRadius = Constants.unreadDotSize / 2
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
                xPos = round(anchor.maxX + Constants.unreadDotOffset.x)
            } else {
                xPos = round(anchor.minX - Constants.unreadDotOffset.x - Constants.unreadDotSize)
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + Constants.unreadDotOffset.y)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private func updateAppearance() {
        guard let window = window else {
            return
        }

        // TODO: Once iOS 14 support is dropped, these should be converted to constants (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        var resolvedTitleColor: UIColor = .clear

        if isSelected {
            if isEnabled {
                resolvedBackgroundColor = customSelectedBackgroundColor ?? (isHighlighted
                                                                            ? PillButton.selectedHighlightedBackgroundColor(for: window, for: style)
                                                                            : PillButton.selectedBackgroundColor(for: window, for: style))
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = customSelectedTextColor ?? (isHighlighted ? PillButton.selectedHighlightedTitleColor(for: window,
                                                                                                                              for: style)
                                                                     : PillButton.selectedTitleColor(for: window,
                                                                                                     for: style))
                } else {
                    setTitleColor(customSelectedTextColor ?? PillButton.selectedTitleColor(for: window,
                                                                                           for: style),
                                  for: .normal)
                    setTitleColor(customSelectedTextColor ?? PillButton.selectedHighlightedTitleColor(for: window,
                                                                                                      for: style),
                                  for: .highlighted)
                }
            } else {
                resolvedBackgroundColor = PillButton.selectedDisabledBackgroundColor(for: window,
                                                                                     for: style)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = PillButton.selectedDisabledTitleColor(for: window,
                                                                       for: style)
                } else {
                    setTitleColor(PillButton.selectedDisabledTitleColor(for: window,
                                                                        for: style),
                                  for: .normal)
                }
            }
        } else {
            if isEnabled {
                unreadDotColor = customUnreadDotColor ?? PillButton.enabledUnreadDotColor(for: window,
                                                                                          for: style)
                resolvedBackgroundColor = customBackgroundColor ?? (isHighlighted
                                                                    ? PillButton.highlightedBackgroundColor(for: window,
                                                                                                            for: style)
                                                                    : PillButton.normalBackgroundColor(for: window,
                                                                                                       for: style))
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = {
                        guard let customTextColor = customTextColor else {
                            if isHighlighted {
                                return PillButton.highlightedTitleColor(for: window,
                                                                        for: style)
                            }

                            return PillButton.titleColor(for: style)
                        }

                        return customTextColor
                    }()
                } else {
                    setTitleColor(customTextColor ?? PillButton.titleColor(for: style),
                                  for: .normal)
                    setTitleColor(customTextColor ?? PillButton.highlightedTitleColor(for: window,
                                                                                      for: style),
                                  for: .highlighted)
                }
            } else {
                unreadDotColor = customUnreadDotColor ?? PillButton.disabledUnreadDotColor(for: window,
                                                                                           for: style)
                resolvedBackgroundColor = customBackgroundColor ?? PillButton.disabledBackgroundColor(for: window,
                                                                                                      for: style)
                if #available(iOS 15.0, *) {
                    resolvedTitleColor = PillButton.disabledTitleColor(for: window,
                                                               for: style)
                } else {
                    setTitleColor(PillButton.disabledTitleColor(for: window, for: style), for: .disabled)
                }
            }
        }

        if #available(iOS 15.0, *) {
            configuration?.background.backgroundColor = resolvedBackgroundColor
            configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.foregroundColor: resolvedTitleColor,
                                                                              NSAttributedString.Key.font: Constants.font]))
        } else {
            backgroundColor = resolvedBackgroundColor
        }
    }

    private struct Constants {
        static let bottomInset: CGFloat = 6.0
        static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let horizontalInset: CGFloat = 16.0
        static let topInset: CGFloat = 6.0
        static let unreadDotOffset = CGPoint(x: 6.0, y: 3.0)
        static let unreadDotSize: CGFloat = 6.0
    }
}
