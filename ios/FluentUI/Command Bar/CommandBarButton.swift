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

    private var selectedTintColor: UIColor {
        return commandBarTokens.pressedIconColor
    }

    private var selectedBackgroundColor: UIColor {
        return commandBarTokens.pressedBackgroundColor
    }

    private var normalTintColor: UIColor {
        return commandBarTokens.defaultIconColor
    }

    private var normalBackgroundColor: UIColor {
        return commandBarTokens.defaultBackgroundColor
    }

    private func updateStyle() {
        tintColor = isSelected ? selectedTintColor : normalTintColor
        setTitleColor(tintColor, for: .normal)

        if !isPersistSelection {
            backgroundColor = commandBarTokens.dismissBackgroundColor
            tintColor = commandBarTokens.dismissIconColor
        } else {
            if isSelected {
                backgroundColor = selectedBackgroundColor
            } else if isHighlighted {
                backgroundColor = CommandBarButton.highlightedBackgroundColor
            } else {
                backgroundColor = normalBackgroundColor
            }
        }
    }

    private static let contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 10.0)
    private static let highlightedBackgroundColor = UIColor(light: Colors.gray100, dark: Colors.gray900)
}
