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

    @objc public init(itemGroups: [CommandBarItemGroup], leadingItem: CommandBarItem? = nil, trailingItem: CommandBarItem? = nil) {
        self.itemGroups = itemGroups

        super.init(frame: .zero)

        if let leadingItem = leadingItem {
            self.leadingButton = button(forItem: leadingItem, isPersistSelection: false)
        }
        if let trailingItem = trailingItem {
            self.trailingButton = button(forItem: trailingItem, isPersistSelection: false)
        }

        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
        updateButtonsState()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    // MARK: - Private properties

    private let itemGroups: [CommandBarItemGroup]

    private lazy var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = {
        let allButtons = itemGroups.flatMap({ $0 }).map({ button(forItem: $0) }) +
            [leadingButton, trailingButton].compactMap({ $0 })

        return Dictionary(uniqueKeysWithValues: allButtons.map { ($0.item, $0) })
    }()

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
            left: leadingButton == nil ? CommandBar.insets.left : CommandBar.fixedButtonSpacing,
            bottom: 0,
            right: trailingButton == nil ? CommandBar.insets.right : CommandBar.fixedButtonSpacing
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

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttonGroupViews)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = CommandBar.buttonGroupSpacing

        return stackView
    }()

    private lazy var buttonGroupViews: [CommandBarButtonGroupView] = {
        itemGroups.map { items in
            CommandBarButtonGroupView(buttons: items.compactMap { item in
                guard let button = itemsToButtonsMap[item] else {
                    fatalError("Button is not initialized in commandsToButtons")
                }

                return button
            })
        }
    }()

    private var leadingButton: CommandBarButton?
    private var trailingButton: CommandBarButton?

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

        // Left and right button layout constraints
        if let leadingButton = leadingButton {
            addSubview(leadingButton)
            NSLayoutConstraint.activate([
                leadingButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                leadingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommandBar.fixedButtonSpacing),
                containerView.bottomAnchor.constraint(equalTo: leadingButton.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: leadingButton.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            ])
        } else {
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
        }

        if let trailingButton = trailingButton {
            addSubview(trailingButton)
            NSLayoutConstraint.activate([
                trailingButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                trailingButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: CommandBar.fixedButtonSpacing),
                containerView.bottomAnchor.constraint(equalTo: trailingButton.bottomAnchor),
                trailingAnchor.constraint(equalTo: trailingButton.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            ])
        } else {
            NSLayoutConstraint.activate([
                trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        }

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

    private func button(forItem item: CommandBarItem, isPersistSelection: Bool = true) -> CommandBarButton {
        let button = CommandBarButton(item: item, isPersistSelection: isPersistSelection)
        button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    private func updateShadow() {
        var locations: [CGFloat] = [0, 0, 1]

        if leadingButton != nil {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        if trailingButton != nil {
            let trailingOffset = max(0, stackView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
    }

    @objc private func handleCommandButtonTapped(_ sender: CommandBarButton) {
        sender.item.handleTapped()
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
