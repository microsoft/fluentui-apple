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

    init(item: CommandBarItem, isPersistSelection: Bool = true, commandBarTokens: MSFCommandBarTokens) {
        self.item = item
        self.isPersistSelection = isPersistSelection
        self.commandBarTokens = commandBarTokens

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        setImage(item.iconImage, for: .normal)

        let accessibilityDescription = item.accessibilityLabel
        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : item.title
        accessibilityHint = item.accessibilityHint
        contentEdgeInsets = CommandBarButton.contentEdgeInsets

        if #available(iOS 14.0, *) {
            menu = item.menu
            showsMenuAsPrimaryAction = item.showsMenuAsPrimaryAction
        }

        updateState()

        if #available(iOS 13.4, *) {
            // Workaround check for beta iOS versions missing the Pointer Interactions API
            if arePointerInteractionAPIsAvailable() {
                isPointerInteractionEnabled = true
            }
        }
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

    private var commandBarTokens: MSFCommandBarTokens

    private let isPersistSelection: Bool

    private var hoverBackgroundColor: UIColor {
        return commandBarTokens.hoverBackgroundColor
    }

    private var hoverIconColor: UIColor {
        return commandBarTokens.hoverIconColor
    }

    private var highlightedBackgroundColor: UIColor {
        return commandBarTokens.pressedBackgroundColor
    }

    private var highlightedIconColor: UIColor {
        return commandBarTokens.pressedIconColor
    }

    private var selectedTintColor: UIColor {
        return commandBarTokens.selectedIconColor
    }

    private var selectedBackgroundColor: UIColor {
        return commandBarTokens.selectedBackgroundColor
    }

    private var disabledBackgroundColor: UIColor {
        return commandBarTokens.disabledBackgroundColor
    }

    private var disabledIconColor: UIColor {
        return commandBarTokens.disabledIconColor
    }

    private var fixedIconColor: UIColor {
        return commandBarTokens.fixedIconColor
    }

    private var normalTintColor: UIColor {
        return commandBarTokens.iconColor
    }

    private var normalBackgroundColor: UIColor {
        return commandBarTokens.backgroundColor
    }

    private func updateStyle() {
        tintColor = isSelected ? selectedTintColor : normalTintColor
        setTitleColor(tintColor, for: .normal)

        if !isPersistSelection {
            backgroundColor = .clear
            tintColor = fixedIconColor
        } else {
            if !isEnabled {
                backgroundColor = disabledBackgroundColor
                tintColor = disabledIconColor
            } else if isSelected {
                backgroundColor = selectedBackgroundColor
            } else if isHighlighted {
                backgroundColor = highlightedBackgroundColor
                tintColor = highlightedIconColor
            } else {
                backgroundColor = normalBackgroundColor
            }
        }
    }

    private static let contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
}

// MARK: CommandBarButton UIPointerInteractionDelegate

extension CommandBarButton: UIPointerInteractionDelegate {
    @available(iOS 13.4, *)
    public func pointerInteraction(_ interaction: UIPointerInteraction, willEnter region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        backgroundColor = isSelected ? selectedBackgroundColor : hoverBackgroundColor
        tintColor = isSelected ? selectedTintColor : hoverIconColor
    }

    @available(iOS 13.4, *)
    public func pointerInteraction(_ interaction: UIPointerInteraction, willExit region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        updateStyle()
    }
}
