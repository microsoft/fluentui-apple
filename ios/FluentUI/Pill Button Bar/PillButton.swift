//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PillButton

/// A `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
@objc(MSFPillButton)
open class PillButton: UIButton, TokenizedControlInternal {

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard self == context.nextFocusedView || self == context.previouslyFocusedView else {
            return
        }

        focusRing.isHidden = !isFocused
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateAppearance()
    }

    @objc convenience public init(pillBarItem: PillButtonBarItem,
                                  style: PillButtonStyle = .primary) {
        self.init(pillBarItem: pillBarItem, style: style, tokenOverrides: nil)
    }

    /// Internal init used by the `PillButtonBar` to initialized buttons with overrides.
    init(pillBarItem: PillButtonBarItem,
         style: PillButtonStyle = .primary,
         tokenOverrides: [PillButtonTokenSet.Tokens: ControlTokenValue]?) {
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
                                               selector: #selector(titleValueDidChange),
                                               name: PillButtonBarItem.titleValueDidChangeNotification,
                                               object: pillBarItem)

        if let tokenOverrides {
            tokenSet.replaceAllOverrides(with: tokenOverrides)
        }
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateAppearance()
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

    lazy var unreadDotColor: UIColor = {
        tokenSet[.enabledUnreadDotColor].uiColor
    }()

    private func setupView() {
        var configuration = UIButton.Configuration.plain()

        configuration.contentInsets = NSDirectionalEdgeInsets(top: PillButtonTokenSet.topInset,
                                                              leading: PillButtonTokenSet.horizontalInset,
                                                              bottom: PillButtonTokenSet.bottomInset,
                                                              trailing: PillButtonTokenSet.horizontalInset)
        self.configuration = configuration

        // This updates the attributed title stored in self.configuration,
        // so it needs to be called after we set the configuration.
        updateAttributedTitle()

        configurationUpdateHandler = { [weak self] _ in
            self?.updateAppearance()
        }

#if os(iOS)
        // On vision, let the parent set the radius because the pill button height is not self-determined. 
        // The proper solution may be to keep the corner radius updated to current height * 0.5 in layoutSubviews.
        layer.cornerRadius = PillButton.cornerRadius
#endif // os(iOS)
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

    private func initUnreadDotLayer() -> CALayer {
        let unreadDotLayer = CALayer()

        unreadDotLayer.bounds.size = CGSize(width: PillButtonTokenSet.unreadDotSize, height: PillButtonTokenSet.unreadDotSize)
        unreadDotLayer.cornerRadius = PillButtonTokenSet.unreadDotSize / 2

        return unreadDotLayer
    }

    @objc private func isUnreadValueDidChange() {
        isUnreadDotVisible = pillBarItem.isUnread
        setNeedsLayout()
    }

    private lazy var unreadDotLayer: CALayer = {
        let unreadDotLayer = CALayer()
        let unreadDotSize = PillButtonTokenSet.unreadDotSize
        unreadDotLayer.bounds.size = CGSize(width: unreadDotSize, height: unreadDotSize)
        unreadDotLayer.cornerRadius = unreadDotSize / 2
        return unreadDotLayer
    }()

    @objc private func titleValueDidChange() {
        updateAttributedTitle()
    }

    @available(iOS 15, *)
    private func updateAttributedTitle() {
        let itemTitle = pillBarItem.title
        var attributedTitle = AttributedString(itemTitle)
        attributedTitle.font = tokenSet[.font].uiFont
        configuration?.attributedTitle = attributedTitle

        let attributedTitleTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            var outgoing = incoming
            outgoing.font = self?.tokenSet[.font].uiFont
            return outgoing
        }
        configuration?.titleTextAttributesTransformer = attributedTitleTransformer

        // Workaround for Apple bug: when UIButton.Configuration is used with UIControl's isSelected = true, accessibilityLabel doesn't get set automatically
        accessibilityLabel = itemTitle

        // This sets colors on the attributed string, so it must run whenever we recreate it.
        updateAppearance()
    }

    private func updateUnreadDot() {
        isUnreadDotVisible = pillBarItem.isUnread
        if isUnreadDotVisible {
            let anchor = self.titleLabel?.frame ?? .zero
            let xPos: CGFloat
            if effectiveUserInterfaceLayoutDirection == .leftToRight {
                xPos = round(anchor.maxX + PillButtonTokenSet.unreadDotOffsetX)
            } else {
                xPos = round(anchor.minX - PillButtonTokenSet.unreadDotOffsetX - PillButtonTokenSet.unreadDotSize)
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + PillButtonTokenSet.unreadDotOffsetY)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private var isUnreadDotVisible: Bool = false {
        didSet {
            if oldValue != isUnreadDotVisible {
                if isUnreadDotVisible {
                    layer.addSublayer(unreadDotLayer)
                    accessibilityLabel = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, pillBarItem.title)
                } else {
                    unreadDotLayer.removeFromSuperlayer()
                    accessibilityLabel = pillBarItem.title
                }
            }
        }
    }

    private lazy var focusRing: FocusRingView = {
        let ringView = FocusRingView()
        ringView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(ringView)
        ringView.drawFocusRing(over: self)

        return ringView
    }()

    private func updateAppearance() {
        // TODO: Once iOS 14 support is dropped, these should be converted to constants (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        var resolvedTitleColor: UIColor = .clear

        if isSelected {
            if isEnabled {
                resolvedBackgroundColor = tokenSet[.backgroundColorSelected].uiColor
                resolvedTitleColor = tokenSet[.titleColorSelected].uiColor
            } else {
                resolvedBackgroundColor = tokenSet[.backgroundColorSelectedDisabled].uiColor
                resolvedTitleColor = tokenSet[.titleColorSelectedDisabled].uiColor
            }
        } else {
            unreadDotColor = isEnabled
                        ? tokenSet[.enabledUnreadDotColor].uiColor
                        : tokenSet[.disabledUnreadDotColor].uiColor
            if isEnabled {
                resolvedBackgroundColor = tokenSet[.backgroundColor].uiColor
                resolvedTitleColor = tokenSet[.titleColor].uiColor
            } else {
                resolvedBackgroundColor = tokenSet[.backgroundColorDisabled].uiColor
                resolvedTitleColor = tokenSet[.titleColorDisabled].uiColor
            }
        }

        configuration?.background.backgroundColor = resolvedBackgroundColor
        configuration?.attributedTitle?.foregroundColor = resolvedTitleColor
    }
}
