//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButton: UIButton {
    let item: CommandBarItem

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateStyle()
    }

    init(item: CommandBarItem, isPersistSelection: Bool = true) {
        self.item = item
        self.isPersistSelection = isPersistSelection

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            var buttonConfiguration = UIButton.Configuration.plain()
            buttonConfiguration.image = item.iconImage
            buttonConfiguration.contentInsets = LayoutConstants.contentInsets
            buttonConfiguration.background.cornerRadius = 0
            configuration = buttonConfiguration
        } else {
            setImage(item.iconImage, for: .normal)
            contentEdgeInsets = LayoutConstants.contentEdgeInsets
        }

        let accessibilityDescription = item.accessibilityLabel
        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : item.title
        accessibilityHint = item.accessibilityHint

        menu = item.menu
        showsMenuAsPrimaryAction = item.showsMenuAsPrimaryAction

        updateState()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func updateState() {
        isEnabled = item.isEnabled
        isSelected = isPersistSelection && item.isSelected
        isHidden = item.isHidden

        // always update icon and title as we only display one; we may alterenate between them, and the icon may also change
        let iconImage = item.iconImage
        let title = item.title
        let accessibilityDescription = item.accessibilityLabel

        if #available(iOS 15.0, *) {
            configuration?.image = iconImage
            configuration?.title = iconImage != nil ? nil : title

            if let font = item.titleFont {
                let attributeContainer = AttributeContainer([NSAttributedString.Key.font: font])
                configuration?.attributedTitle?.setAttributes(attributeContainer)
            }
        } else {
            setImage(iconImage, for: .normal)
            setTitle(iconImage != nil ? nil : title, for: .normal)
            titleLabel?.font = item.titleFont
        }

        titleLabel?.isEnabled = isEnabled
        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : title
        accessibilityHint = item.accessibilityHint
    }

    private let isPersistSelection: Bool

    private var normalTintColor: UIColor {
        return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
    }

    private var selectedTintColor: UIColor {
        return UIColor(light: UIColor(colorValue: fluentTheme.aliasTokens.colors[.brandForeground4].light),
                       dark: UIColor(colorValue: fluentTheme.aliasTokens.colors[.foreground1].dark!))
    }

    private var selectedBackgroundColor: UIColor {
        return UIColor(light: UIColor(colorValue: fluentTheme.aliasTokens.colors[.brandBackground4].light),
                       dark: UIColor(colorValue: fluentTheme.aliasTokens.colors[.background5Selected].dark!))
    }

    private var normalBackgroundColor: UIColor {
        return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5])
    }

    private var highlightedBackgroundColor: UIColor {
        return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5Pressed])
    }

    private func updateStyle() {
        // TODO: Once iOS 14 support is dropped, this should be converted to a constant (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        let resolvedTintColor: UIColor = isSelected ? selectedTintColor : normalTintColor

        if isPersistSelection {
            if isSelected {
                resolvedBackgroundColor = selectedBackgroundColor
            } else if isHighlighted {
                resolvedBackgroundColor = highlightedBackgroundColor
            } else {
                resolvedBackgroundColor = normalBackgroundColor
            }
        }

        if #available(iOS 15.0, *) {
            configuration?.baseForegroundColor = resolvedTintColor
            configuration?.background.backgroundColor = resolvedBackgroundColor
        } else {
            backgroundColor = resolvedBackgroundColor
            setTitleColor(resolvedTintColor, for: .normal)
        }
    }

    private struct LayoutConstants {
        static let contentInsets = NSDirectionalEdgeInsets(top: 8.0,
                                                           leading: 10.0,
                                                           bottom: 8.0,
                                                           trailing: 10.0)
        static let contentEdgeInsets = UIEdgeInsets(top: 8.0,
                                                    left: 10.0,
                                                    bottom: 8.0,
                                                    right: 10.0)
    }
}
