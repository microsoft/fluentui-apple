//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarCommandGroupsStackView: UIStackView {
    init(itemGroups: [CommandBarItemGroup]? = nil) {
        if let itemGroups = itemGroups {
            self.itemGroups = itemGroups
        } else {
            self.itemGroups = []
        }

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = CommandBarCommandGroupsStackView.buttonGroupSpacing

        updateButtonsShown()
    }

    required init(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public var itemGroups: [CommandBarItemGroup] {
        didSet {
            if itemGroups != oldValue {
                updateButtonsShown()
            }
        }
    }

    // MARK: - Private properties

    private var buttonGroupViews: [CommandBarButtonGroupView] = []
    private var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = [:]

    // MARK: View Updates

    /// Refreshes the buttons shown in the `arrangedSubviews`
    private func updateButtonsShown() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }

        updateButtonGroupViews()
        for view in buttonGroupViews {
            addArrangedSubview(view)
        }
    }

    /// Refreshes the `buttonGroupViews` array of `CommandBarButtonGroupView`s that are displayed in the view
    private func updateButtonGroupViews() {
        updateItemsToButtonsMap()
        buttonGroupViews = itemGroups.map { items in
                CommandBarButtonGroupView(buttons: items.compactMap { item in
                    guard let button = itemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in commandsToButtons")
                    }
                    item.propertyChangedUpdateBlock = { _ in
                        button.updateState()
                    }
                    return button
                })
        }
    }

    /// Refreshes the `itemsToButtonsMap` of `CommandBarItem`s to their corresponding `CommandBarButton`
    private func updateItemsToButtonsMap() {
        let allButtons = itemGroups.flatMap({ $0 }).map({ button(forItem: $0) })
        itemsToButtonsMap = Dictionary(uniqueKeysWithValues: allButtons.map { ($0.item, $0) })
    }

    private func button(forItem item: CommandBarItem, isPersistSelection: Bool = true) -> CommandBarButton {
        let button = CommandBarButton(item: item, isPersistSelection: isPersistSelection)
        button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    @objc private func handleCommandButtonTapped(_ sender: CommandBarButton) {
        sender.item.handleTapped(sender)
        sender.updateState()
    }

    private static let buttonGroupSpacing: CGFloat = 16
}
