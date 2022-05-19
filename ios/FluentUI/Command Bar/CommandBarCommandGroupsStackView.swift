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

        refreshButtonLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var itemGroups: [CommandBarItemGroup] {
        didSet {
            if itemGroups != oldValue {
                refreshButtonLayout()
            }
        }
    }

    /// Updates the state of all buttons in the group
    public func updateButtonsState() {
        for button in itemsToButtonsMap.values {
            button.updateState()
        }
    }

    // MARK: - Private properties

    private var buttonGroupViews: [CommandBarButtonGroupView] = []
    private var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = [:]

    // MARK: View Updates

    /// Refreshes the buttons shown in the `arrangedSubviews`
    private func refreshButtonLayout() {
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
                    item.delegate = self
                    guard let button = itemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in commandsToButtons")
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

// MARK: - CommandBarItemDelegate

extension CommandBarCommandGroupsStackView: CommandBarItemDelegate {
    func commandBarItem(_ item: CommandBarItem, didChangeEnabledTo value: Bool) {
        itemsToButtonsMap[item]?.updateState()
    }

    func commandBarItem(_ item: CommandBarItem, didChangeSelectedTo value: Bool) {
        itemsToButtonsMap[item]?.updateState()
    }

    func commandBarItem(_ item: CommandBarItem, didChangeTitleTo value: String?) {
        itemsToButtonsMap[item]?.updateState()
    }

    func commandBarItem(_ item: CommandBarItem, didChangeTitleFontTo value: UIFont?) {
        itemsToButtonsMap[item]?.updateState()
    }

    func commandBarItem(_ item: CommandBarItem, didChangeIconImageTo value: UIImage?) {
        itemsToButtonsMap[item]?.updateState()
    }
}
