//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarCommandGroupsView: UIView {
    init(itemGroups: [CommandBarItemGroup]? = nil,
         buttonsPersistSelection: Bool = true) {
        self.itemGroups = itemGroups ?? []

        self.buttonsPersistSelection = buttonsPersistSelection

        buttonGroupsStackView = UIStackView()

        super.init(frame: .zero)

        buttonGroupsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonGroupsStackView.axis = .horizontal
        buttonGroupsStackView.spacing = LayoutConstants.buttonGroupSpacing

        addSubview(buttonGroupsStackView)

        NSLayoutConstraint.activate([
            buttonGroupsStackView.topAnchor.constraint(equalTo: topAnchor,
                                                       constant: LayoutConstants.insets.top),
            bottomAnchor.constraint(equalTo: buttonGroupsStackView.bottomAnchor,
                                    constant: LayoutConstants.insets.top),
            buttonGroupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonGroupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        updateButtonsShown()
    }

    @available(*, unavailable)
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

    // MARK: - Private properties

    private var buttonGroupsStackView: UIStackView
    private var buttonGroupViews: [CommandBarButtonGroupView] = []
    private var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = [:]
    private var buttonsPersistSelection: Bool

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
            let buttons: [CommandBarButton] = items.compactMap { item in
                guard let button = itemsToButtonsMap[item] else {
                    preconditionFailure("Button is not initialized in map")
                }
                return button
            }

            let group = CommandBarButtonGroupView(buttons: buttons)

            for item in items {
                if let button = itemsToButtonsMap[item] {
                    item.propertyChangedUpdateBlock = { _, shouldUpdateGroupState in
                        button.updateState()

                        if shouldUpdateGroupState {
                            group.hideGroupIfNeeded()
                        }
                    }
                }
            }

            return group
        }
    }

    /// Refreshes the `itemsToButtonsMap` of `CommandBarItem`s to their corresponding `CommandBarButton`
    private func updateItemsToButtonsMap() {
        let allButtons = itemGroups.flatMap({ $0 }).map({ createButton(forItem: $0, isPersistSelection: buttonsPersistSelection) })
        itemsToButtonsMap = Dictionary(uniqueKeysWithValues: allButtons.map { ($0.item, $0) })
    }

    private func createButton(forItem item: CommandBarItem, isPersistSelection: Bool = true) -> CommandBarButton {
        let button = CommandBarButton(item: item, isPersistSelection: isPersistSelection)

        if item.shouldUseItemTappedHandler {
            button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)
        }

        return button
    }

    @objc private func handleCommandButtonTapped(_ sender: CommandBarButton) {
        sender.item.handleTapped(sender)
        sender.updateState()
    }

    private struct LayoutConstants {
        static let buttonGroupSpacing: CGFloat = 8.0
        static let insets = UIEdgeInsets(top: 8.0,
                                         left: 8.0,
                                         bottom: 8.0,
                                         right: 8.0)
    }
}
