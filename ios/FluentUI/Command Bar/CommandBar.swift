//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `CommandBar` is a horizontal scrollable list of icon buttons divided by groups.
 Provide `itemGroups` in `init` to set the buttons in the scrollable area. Optional `leadingItem` and `trailingItem` add fixed buttons in leading and trailing positions. Each `CommandBarItem` will be represented as a button.
 Set the `delegate` property to determine whether a button can be selected and deselected, and listen to selection changes.
 */
@objc(MSFCommandBar)
open class CommandBar: UIView {
    // Hierarchy:
    //
    // leadingButton
    // containerView
    // |--layer.mask -> containerMaskLayer (fill containerView)
    // |--subviews
    // |  |--scrollView (fill containerView)
    // |  |  |--subviews
    // |  |  |  |--stackView
    // |  |  |  |  |--buttons (fill scrollView content)
    // trailingButton

    // MARK: - Public methods

    @available(*, deprecated, renamed: "init(itemGroups:leadingItemGroups:trailingItemGroups:)")
    @objc public init(itemGroups: [CommandBarItemGroup], leadingItem: CommandBarItem? = nil, trailingItem: CommandBarItem? = nil) {
        self.itemGroups = itemGroups

        self.leadingItemGroups = leadingItem != nil ? [[leadingItem!]] : []

        self.trailingItemGroups = trailingItem != nil ? [[trailingItem!]] : []

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
        updateButtonsState()
    }

    @objc public init(itemGroups: [CommandBarItemGroup], leadingItemGroups: [CommandBarItemGroup]? = nil, trailingItemGroups: [CommandBarItemGroup]? = nil) {
        self.itemGroups = itemGroups

        self.leadingItemGroups = leadingItemGroups != nil ? leadingItemGroups! : []

        self.trailingItemGroups = trailingItemGroups != nil ? trailingItemGroups! : []

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
        updateButtonsState()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Apply `isEnabled` and `isSelected` state from `CommandBarItem` to the buttons
    @objc public func updateButtonsState() {
        for button in itemsToButtonsMap.values {
            button.updateState()
        }
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        containerMaskLayer.frame = containerView.bounds
        updateShadow()
    }

    /// Scrollable items shown in the center of the CommandBar
    public var itemGroups: [CommandBarItemGroup] {
        didSet {
            for view in stackView.arrangedSubviews {
                view.removeFromSuperview()
            }

            _buttonGroupViews = nil
            for view in buttonGroupViews {
                stackView.addArrangedSubview(view)
            }
        }
    }

    /// Items pinned to the leading end of the CommandBar
    public var leadingItemGroups: [CommandBarItemGroup] {
        didSet {
            for view in leadingStackView.arrangedSubviews {
                view.removeFromSuperview()
            }

            _leadingButtonGroupViews = nil
            for view in leadingButtonGroupViews {
                leadingStackView.addArrangedSubview(view)
            }
        }
    }

    /// Items pinned to the trailing end of the CommandBar
    public var trailingItemGroups: [CommandBarItemGroup] {
        didSet {
            for view in trailingStackView.arrangedSubviews {
                view.removeFromSuperview()
            }

            _trailingButtonGroupViews = nil
            for view in trailingButtonGroupViews {
                trailingStackView.addArrangedSubview(view)
            }
        }
    }

    // MARK: - Private properties

    private var _itemsToButtonsMap: [CommandBarItem: CommandBarButton]?
    /// Mapping of `CommandBarItem`s to `CommandBarButton`s for items in `itemGroups`. Mapping is
    /// refreshed when `buttonGroupViews` is set.
    private var itemsToButtonsMap: [CommandBarItem: CommandBarButton] {
        if _itemsToButtonsMap == nil {
            let allButtons = itemGroups.flatMap({ $0 }).map({ button(forItem: $0) })

            _itemsToButtonsMap = Dictionary(uniqueKeysWithValues: allButtons.map { ($0.item, $0) })
        }
        return _itemsToButtonsMap!
    }

    private var _trailingItemsToButtonsMap: [CommandBarItem: CommandBarButton]?
    /// Mapping of `CommandBarItem`s to `CommandBarButton`s for items in `trailingItemGroups`. Mapping is
    /// refreshed when `trailingButtonGroupViews` is set.
    private var trailingItemsToButtonsMap: [CommandBarItem: CommandBarButton] {
        if _trailingItemsToButtonsMap == nil {
            let trailingButtons = trailingItemGroups.flatMap({ $0 }).map({ button(forItem: $0) })

            _trailingItemsToButtonsMap = Dictionary(uniqueKeysWithValues: trailingButtons.map { ($0.item, $0) })
        }
        return _trailingItemsToButtonsMap!
    }

    private var _leadingItemsToButtonsMap: [CommandBarItem: CommandBarButton]?
    /// Mapping of `CommandBarItem`s to `CommandBarButton`s for items in `leadingItemGroups`. Mapping is
    /// refreshed when `leadingButtonGroupViews` is set.
    private var leadingItemsToButtonsMap: [CommandBarItem: CommandBarButton] {
        if _leadingItemsToButtonsMap == nil {
            let leadingButtons = leadingItemGroups.flatMap({ $0 }).map({ button(forItem: $0) })

            _leadingItemsToButtonsMap = Dictionary(uniqueKeysWithValues: leadingButtons.map { ($0.item, $0) })
        }
        return _leadingItemsToButtonsMap!
    }

    /// Checks each items-to-buttons map for given item, returns the corresponding button if found.
    private func buttonFromButtonMaps(_ item: CommandBarItem) -> CommandBarButton? {
        if itemsToButtonsMap[item] != nil {
            return itemsToButtonsMap[item]
        } else if leadingItemsToButtonsMap[item] != nil {
            return leadingItemsToButtonsMap[item]
        } else if trailingItemsToButtonsMap[item] != nil {
            return trailingItemsToButtonsMap[item]
        }
        return nil
    }

    // MARK: Views and Layers

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.mask = containerMaskLayer

        containerView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])

        return containerView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: leadingStackView.arrangedSubviews.isEmpty ? CommandBar.insets.left : CommandBar.fixedButtonSpacing,
            bottom: 0,
            right: trailingStackView.arrangedSubviews.isEmpty ? CommandBar.insets.right : CommandBar.fixedButtonSpacing
        )
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])

        return scrollView
    }()

    /// UIStackView for holding `CommandBarButtonGroupView`s shown in the center of the CommandBar
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttonGroupViews)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBar.buttonGroupSpacing

        return stackView
    }()

    /// UIStackView for holding `CommandBarButtonGroupView`s shown at the leading end of the CommandBar
    private lazy var leadingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: leadingButtonGroupViews)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBar.buttonGroupSpacing

        return stackView
    }()

    /// UIStackView for holding `CommandBarButtonGroupView`s shown at the trailing end of the CommandBar
    private lazy var trailingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: trailingButtonGroupViews)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBar.buttonGroupSpacing

        return stackView
    }()

    private var _buttonGroupViews: [CommandBarButtonGroupView]?
    /// Array of `CommandBarButtonGroupView`s for items shown in center of CommandBar. Set
    /// `_buttonGroupViews` to `nil` to update the array on the next call.
    private var buttonGroupViews: [CommandBarButtonGroupView] {
        if _buttonGroupViews == nil {
            _itemsToButtonsMap = nil
            _buttonGroupViews = itemGroups.map { items in
                CommandBarButtonGroupView(buttons: items.compactMap { item in
                    item.delegate = self
                    guard let button = itemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in commandsToButtons")
                    }

                    return button
                })
            }
        }
        return _buttonGroupViews!
    }

    private var _leadingButtonGroupViews: [CommandBarButtonGroupView]?
    /// Array of `CommandBarButtonGroupView`s for items shown at leading end of CommandBar. Set
    /// `_leadingButtonGroupViews` to `nil` to update the array on the next call.
    private var leadingButtonGroupViews: [CommandBarButtonGroupView] {
        if _leadingButtonGroupViews == nil {
            _leadingItemsToButtonsMap = nil
            _leadingButtonGroupViews = leadingItemGroups.map { items in
                CommandBarButtonGroupView(buttons: items.compactMap { item in
                    item.delegate = self
                    guard let button = leadingItemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in commandsToButtons")
                    }

                    return button
                })
            }
        }
        return _leadingButtonGroupViews!
    }

    private var _trailingButtonGroupViews: [CommandBarButtonGroupView]?
    /// Array of `CommandBarButtonGroupView`s for items shown at trailing end of CommandBar. Set
    /// `_trailingButtonGroupViews` to `nil` to update the array on the next call.
    private var trailingButtonGroupViews: [CommandBarButtonGroupView] {
        if _trailingButtonGroupViews == nil {
            _trailingItemsToButtonsMap = nil
            _trailingButtonGroupViews = trailingItemGroups.map { items in
                CommandBarButtonGroupView(buttons: items.compactMap { item in
                    item.delegate = self
                    guard let button = trailingItemsToButtonsMap[item] else {
                        preconditionFailure("Button is not initialized in commandsToButtons")
                    }

                    return button
                })
            }
        }
        return _trailingButtonGroupViews!
    }

    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    private let containerMaskLayer: CAGradientLayer = {
        // A mask layer using alpha color channel.
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear, UIColor.white, UIColor.white, UIColor.clear].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.locations = [0, 0, 1] // Initially the entire layer is white color, so the view is not masked.

        return layer
    }()

    private func configureHierarchy() {
        addSubview(containerView)

        // Constraint left and right item stack views
        constrainLeadingAndTrailingStackViews()

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: CommandBar.insets.top),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: CommandBar.insets.bottom)
        ])

        stackView.layoutIfNeeded()

        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            // Flip the scroll view to invert scrolling direction. Flip its content back because it's already in RTL.
            let flipTransform = CGAffineTransform(scaleX: -1, y: 1)
            scrollView.transform = flipTransform
            stackView.transform = flipTransform
            containerMaskLayer.setAffineTransform(flipTransform)
        }
    }

    private func constrainLeadingAndTrailingStackViews() {
        if !leadingStackView.arrangedSubviews.isEmpty {
            addSubview(leadingStackView)
            leadingConstraint?.isActive = false
            leadingConstraint = containerView.leadingAnchor.constraint(equalTo: leadingStackView.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            NSLayoutConstraint.activate([
                leadingStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommandBar.fixedButtonSpacing),
                leadingStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                leadingStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                leadingConstraint!
            ])
        } else {
            leadingStackView.removeFromSuperview()
            leadingConstraint = containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            NSLayoutConstraint.activate([
                leadingConstraint!
            ])
        }

        if !trailingStackView.arrangedSubviews.isEmpty {
            addSubview(trailingStackView)
            trailingConstraint?.isActive = false
            trailingConstraint = trailingStackView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            NSLayoutConstraint.activate([
                trailingStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                trailingStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                trailingAnchor.constraint(equalTo: trailingStackView.trailingAnchor, constant: CommandBar.fixedButtonSpacing),
                trailingConstraint!
            ])
        } else {
            trailingStackView.removeFromSuperview()
            trailingConstraint = containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            NSLayoutConstraint.activate([
                trailingConstraint!
            ])
        }
    }

    private func button(forItem item: CommandBarItem, isPersistSelection: Bool = true) -> CommandBarButton {
        let button = CommandBarButton(item: item, isPersistSelection: isPersistSelection)
        button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    private func updateShadow() {
        var locations: [CGFloat] = [0, 0, 1]

        if !leadingStackView.arrangedSubviews.isEmpty {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        if !trailingStackView.arrangedSubviews.isEmpty {
            let trailingOffset = max(0, stackView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
    }

    @objc private func handleCommandButtonTapped(_ sender: CommandBarButton) {
        sender.item.handleTapped(sender)
        sender.updateState()
    }

    private static let fadeViewWidth: CGFloat = 16.0
    private static let buttonGroupSpacing: CGFloat = 16.0
    private static let fixedButtonSpacing: CGFloat = 2.0
    private static let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
}

// MARK: - Scroll view delegate

extension CommandBar: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShadow()
    }
}

// MARK: - CommandBarItemDelegate

extension CommandBar: CommandBarItemDelegate {
    func commandBarItem(_ item: CommandBarItem, didChangeEnabledTo value: Bool) {
        if let button: CommandBarButton = buttonFromButtonMaps(item) {
            button.updateState()
        }
    }

    func commandBarItem(_ item: CommandBarItem, didChangeSelectedTo value: Bool) {
        if let button: CommandBarButton = buttonFromButtonMaps(item) {
            button.updateState()
        }
    }

    func commandBarItem(_ item: CommandBarItem, didChangeTitleTo value: String?) {
        if let button: CommandBarButton = buttonFromButtonMaps(item) {
            button.updateState()
        }
    }

    func commandBarItem(_ item: CommandBarItem, didChangeTitleFontTo value: UIFont?) {
        if let button: CommandBarButton = buttonFromButtonMaps(item) {
            button.updateState()
        }
    }

    func commandBarItem(_ item: CommandBarItem, didChangeIconImageTo value: UIImage?) {
        if let button: CommandBarButton = buttonFromButtonMaps(item) {
            button.updateState()
        }
    }

}
