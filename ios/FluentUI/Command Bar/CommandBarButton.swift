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
        setImage(item.iconImage, for: .normal)

        let accessibilityDescription = item.accessibilityLabel
        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : item.title
        accessibilityHint = item.accessibilityHint
        contentEdgeInsets = LayoutConstants.contentEdgeInsets

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

        // always update icon and title as we only display one; we may alterenate between them, and the icon may also change
        let iconImage = item.iconImage
        let title = item.title
        let accessibilityDescription = item.accessibilityLabel
        setImage(iconImage, for: .normal)
        setTitle(iconImage != nil ? nil : title, for: .normal)
        titleLabel?.isEnabled = isEnabled
        titleLabel?.font = item.titleFont
        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : title
        accessibilityHint = item.accessibilityHint
    }

    private let isPersistSelection: Bool

    func updateStyle() {
        tintColor = UIColor(dynamicColor: isSelected ? tokenSet[.itemIconColor].buttonDynamicColors.selected : tokenSet[.itemIconColor].buttonDynamicColors.rest)
        setTitleColor(tintColor, for: .normal)

        if !isPersistSelection {
            backgroundColor = .clear
            tintColor = UIColor(dynamicColor: tokenSet[.itemFixedIconColor].dynamicColor)
        } else {
            if !isEnabled {
                backgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.disabled)
                tintColor = UIColor(dynamicColor: tokenSet[.itemIconColor].buttonDynamicColors.disabled)
            } else if isSelected {
                backgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.selected)
            } else if isHighlighted {
                backgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.pressed)
                tintColor = UIColor(dynamicColor: tokenSet[.itemIconColor].buttonDynamicColors.pressed)
            } else {
                backgroundColor = UIColor(dynamicColor: tokenSet[.itemBackgroundColor].buttonDynamicColors.rest)
            }
        }
    }

    private struct LayoutConstants {
        static let contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
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
