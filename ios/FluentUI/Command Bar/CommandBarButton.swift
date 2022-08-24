//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButton: UIButton {
    let item: CommandBarItem

    unowned let tokenSet: CommandBarTokenSet

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

    init(item: CommandBarItem, isPersistSelection: Bool = true, tokenSet: CommandBarTokenSet) {
        self.item = item
        self.isPersistSelection = isPersistSelection
        self.tokenSet = tokenSet

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

        isPointerInteractionEnabled = true
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
            configuration?.title = title

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

    private func updateStyle() {
        // TODO: Once iOS 14 support is dropped, this should be converted to a constant (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        tintColor = UIColor(dynamicColor: isSelected ? tokenSet[.itemIconColor].buttonDynamicColors.selected : tokenSet[.itemIconColor].buttonDynamicColors.rest)

        if isPersistSelection {
            if isSelected {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.selected)
            } else if isHighlighted {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.pressed)
            } else {
                resolvedBackgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.rest)
            }
        }

        if #available(iOS 15.0, *) {
            configuration?.baseForegroundColor = tintColor
            configuration?.background.backgroundColor = resolvedBackgroundColor
        } else {
            backgroundColor = resolvedBackgroundColor
            setTitleColor(tintColor, for: .normal)
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

// MARK: CommandBarButton UIPointerInteractionDelegate

extension CommandBarButton: UIPointerInteractionDelegate {
    @available(iOS 13.4, *)
    public func pointerInteraction(_ interaction: UIPointerInteraction, willEnter region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        backgroundColor = UIColor(dynamicColor: isSelected ? tokenSet[.itemBackgroundColor].buttonDynamicColors.selected : tokenSet[.itemBackgroundColor].buttonDynamicColors.hover)
        tintColor = UIColor(dynamicColor: isSelected ? tokenSet[.itemIconColor].buttonDynamicColors.selected : tokenSet[.itemIconColor].buttonDynamicColors.hover)
    }

    @available(iOS 13.4, *)
    public func pointerInteraction(_ interaction: UIPointerInteraction, willExit region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        updateStyle()
    }
}
