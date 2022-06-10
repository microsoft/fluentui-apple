//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarCommandGroupsView: UIView {
    init(itemGroups: [CommandBarItemGroup]? = nil, buttonsPersistSelection: Bool = true, tokens: CommandBarTokens) {
        self.itemGroups = itemGroups ?? []
        self.buttonsPersistSelection = buttonsPersistSelection
        self.tokens = tokens

        buttonGroupsStackView = UIStackView()

        super.init(frame: .zero)

        buttonGroupsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonGroupsStackView.axis = .horizontal
        buttonGroupsStackView.spacing = CommandBarCommandGroupsView.buttonGroupSpacing

        configureHierarchy()
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

    /// Updates the state of all buttons in the group
    public func updateButtonsState() {
        for button in itemsToButtonsMap.values {
            button.updateState()
        }
    }

    var tokens: CommandBarTokens {
        didSet {
            updateButtonGroupViews()
        }
    }

    // MARK: - Private properties

    private var buttonGroupsStackView: UIStackView
    private var buttonGroupViews: [CommandBarButtonGroupView] = []
    private var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = [:]
    private var buttonsPersistSelection: Bool

    // MARK: View Updates

    private func configureHierarchy() {
        addSubview(buttonGroupsStackView)

        NSLayoutConstraint.activate([
            buttonGroupsStackView.topAnchor.constraint(equalTo: topAnchor, constant: CommandBarCommandGroupsView.insets.top),
            bottomAnchor.constraint(equalTo: buttonGroupsStackView.bottomAnchor, constant: CommandBarCommandGroupsView.insets.top),
            buttonGroupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonGroupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    /// Refreshes the buttons shown in the `arrangedSubviews`
    private func updateButtonsShown() {
        for view in buttonGroupsStackView.arrangedSubviews {
            view.removeFromSuperview()
        }

        updateButtonGroupViews()
        for view in buttonGroupViews {
            buttonGroupsStackView.addArrangedSubview(view)
        }
    }

    /// Refreshes the `buttonGroupViews` array of `CommandBarButtonGroupView`s that are displayed in the view
    private func updateButtonGroupViews() {
        updateItemsToButtonsMap()
        buttonGroupViews = itemGroups.map { items in
                CommandBarButtonGroupView(buttons: items.compactMap { item in
                    guard let button = itemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in map")
                    }
                    item.propertyChangedUpdateBlock = { _ in
                        button.updateState()
                    }
                    return button
                }, commandBarTokens: tokens)
        }
    }

    /// Refreshes the `itemsToButtonsMap` of `CommandBarItem`s to their corresponding `CommandBarButton`
    private func updateItemsToButtonsMap() {
        let allButtons = itemGroups.flatMap({ $0 }).map({ createButton(forItem: $0, isPersistSelection: buttonsPersistSelection) })
        itemsToButtonsMap = Dictionary(uniqueKeysWithValues: allButtons.map { ($0.item, $0) })
    }

    private func createButton(forItem item: CommandBarItem, isPersistSelection: Bool = true) -> CommandBarButton {
        let button = CommandBarButton(item: item, isPersistSelection: isPersistSelection, commandBarTokens: tokens)
        button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    @objc private func handleCommandButtonTapped(_ sender: CommandBarButton) {
        sender.item.handleTapped(sender)
        sender.updateState()
    }

    private static let buttonGroupSpacing: CGFloat = 16
    private static let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
}
