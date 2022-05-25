//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `CommandBar` is a horizontal scrollable list of icon buttons divided by groups.
 Set the `delegate` property to determine whether a button can be selected and deselected, and listen to selection changes.
 Provide `itemGroups` in `init` to set the buttons in the scrollable area. Optional `leadingItemGroups` and `trailingItemGroups` add buttons in leading and trailing positions. Each `CommandBarItem` will be represented as a button.
 */
@objc(MSFCommandBar)
open class CommandBar: UIView {
    // Hierarchy:
    //
    // leadingCommandGroupsStackView
    // |--buttons
    // containerView
    // |--layer.mask -> containerMaskLayer (fill containerView)
    // |--subviews
    // |  |--scrollView (fill containerView)
    // |  |  |--subviews
    // |  |  |  |--stackView
    // |  |  |  |  |--buttons (fill scrollView content)
    // trailingCommandGroupsStackView
    // |--buttons

    // MARK: - Public methods

    @available(*, renamed: "init(itemGroups:leadingItemGroups:trailingItemGroups:)")
    @objc public convenience init(itemGroups: [CommandBarItemGroup], leadingItem: CommandBarItem? = nil, trailingItem: CommandBarItem? = nil) {
        var leadingItems: [CommandBarItemGroup] = []
        var trailingItems: [CommandBarItemGroup] = []

        if let leadingItem = leadingItem {
            leadingItems = [[leadingItem]]
        }

        if let trailingItem = trailingItem {
            trailingItems = [[trailingItem]]
        }

        self.init(itemGroups: itemGroups, leadingItemGroups: leadingItems.isEmpty ? nil : leadingItems, trailingItemGroups: trailingItems.isEmpty ? nil : trailingItems)
    }

    @objc public init(itemGroups: [CommandBarItemGroup], leadingItemGroups: [CommandBarItemGroup]? = nil, trailingItemGroups: [CommandBarItemGroup]? = nil) {
        self.itemGroups = itemGroups
        self.leadingItemGroups = leadingItemGroups
        self.trailingItemGroups = trailingItemGroups

        leadingCommandGroupsStackView = CommandBarCommandGroupsStackView(itemGroups: self.leadingItemGroups, buttonsPersistSelection: false)
        leadingCommandGroupsStackView.translatesAutoresizingMaskIntoConstraints = false
        mainCommandGroupsStackView = CommandBarCommandGroupsStackView(itemGroups: self.itemGroups)
        mainCommandGroupsStackView.translatesAutoresizingMaskIntoConstraints = false
        trailingCommandGroupsStackView = CommandBarCommandGroupsStackView(itemGroups: self.trailingItemGroups, buttonsPersistSelection: false)
        trailingCommandGroupsStackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Apply `isEnabled` and `isSelected` state from `CommandBarItem` to the buttons
    @available(*, message: "Changes on CommandBarItem objects will automatically trigger updates to their corresponding CommandBarButtons. Calls to this method are no longer necessary.")
    @objc public func updateButtonsState() {
        leadingCommandGroupsStackView.updateButtonsState()
        mainCommandGroupsStackView.updateButtonsState()
        trailingCommandGroupsStackView.updateButtonsState()
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.contentInset = scrollViewContentInset()

        leadingCommandGroupsStackView.layoutIfNeeded()
        mainCommandGroupsStackView.layoutIfNeeded()
        trailingCommandGroupsStackView.layoutIfNeeded()

        containerMaskLayer.frame = containerView.bounds
        updateShadow()
    }

    /// Scrollable items shown in the center of the CommandBar
    public var itemGroups: [CommandBarItemGroup] {
        didSet {
            mainCommandGroupsStackView.itemGroups = itemGroups
        }
    }

    /// Items pinned to the leading end of the CommandBar
    public var leadingItemGroups: [CommandBarItemGroup]? {
        didSet {
            guard let leadingItemGroups = leadingItemGroups else {
                return
            }

            leadingCommandGroupsStackView.itemGroups = leadingItemGroups
            constrainLeadingCommandGroupsStackView()
        }
    }

    /// Items pinned to the trailing end of the CommandBar
    public var trailingItemGroups: [CommandBarItemGroup]? {
        didSet {
            guard let trailingItemGroups = trailingItemGroups else {
                return
            }

            trailingCommandGroupsStackView.itemGroups = trailingItemGroups
            constrainTrailingCommandGroupsStackView()
        }
    }

    // MARK: - Private properties

    /// UIStackView holding the items pinned to the leading end of the CommandBar
    private var leadingCommandGroupsStackView: CommandBarCommandGroupsStackView

    /// UIStackView holding the items in the middle of the CommandBar
    private var mainCommandGroupsStackView: CommandBarCommandGroupsStackView

    /// UIStackView holding the items pinned to the trailing end of the CommandBar
    private var trailingCommandGroupsStackView: CommandBarCommandGroupsStackView

    /// Leading constraint between the `containerView` and either the `leadingCommandGroupsStackView` or the parent view
    private var leadingConstraint: NSLayoutConstraint?

    /// Trailing constraint between the `containerView` and either the `trailingCommandGroupsStackView` or the parent view
    private var trailingConstraint: NSLayoutConstraint?

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
        scrollView.contentInset = scrollViewContentInset()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self

        scrollView.addSubview(mainCommandGroupsStackView)
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            mainCommandGroupsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainCommandGroupsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: mainCommandGroupsStackView.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: mainCommandGroupsStackView.trailingAnchor)
        ])

        return scrollView
    }()

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
        constrainLeadingCommandGroupsStackView()
        constrainTrailingCommandGroupsStackView()

        scrollView.contentInset = scrollViewContentInset()

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: CommandBar.insets.top),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: CommandBar.insets.bottom)
        ])

        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            // Flip the scroll view to invert scrolling direction. Flip its content back because it's already in RTL.
            let flipTransform = CGAffineTransform(scaleX: -1, y: 1)
            scrollView.transform = flipTransform
            leadingCommandGroupsStackView.transform = flipTransform
            mainCommandGroupsStackView.transform = flipTransform
            trailingCommandGroupsStackView.transform = flipTransform
            containerMaskLayer.setAffineTransform(flipTransform)
        }
    }

    private func constrainLeadingCommandGroupsStackView() {
        if !leadingCommandGroupsStackView.itemGroups.isEmpty {
            addSubview(leadingCommandGroupsStackView)
            self.leadingConstraint?.isActive = false
            let leadingConstraint: NSLayoutConstraint = containerView.leadingAnchor.constraint(equalTo: leadingCommandGroupsStackView.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            NSLayoutConstraint.activate([
                leadingCommandGroupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CommandBar.fixedButtonSpacing),
                leadingCommandGroupsStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                leadingCommandGroupsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                leadingConstraint
            ])
            self.leadingConstraint = leadingConstraint
        } else {
            leadingCommandGroupsStackView.removeFromSuperview()
            self.leadingConstraint?.isActive = false
            let leadingConstraint = containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            NSLayoutConstraint.activate([
                leadingConstraint
            ])
            self.leadingConstraint = leadingConstraint
        }
    }

    private func constrainTrailingCommandGroupsStackView() {
        if !trailingCommandGroupsStackView.itemGroups.isEmpty {
            addSubview(trailingCommandGroupsStackView)
            self.trailingConstraint?.isActive = false
            let trailingConstraint = trailingCommandGroupsStackView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: CommandBar.fixedButtonSpacing)
            NSLayoutConstraint.activate([
                trailingCommandGroupsStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                trailingCommandGroupsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                trailingAnchor.constraint(equalTo: trailingCommandGroupsStackView.trailingAnchor, constant: CommandBar.fixedButtonSpacing),
                trailingConstraint
            ])
            self.trailingConstraint = trailingConstraint
        } else {
            trailingCommandGroupsStackView.removeFromSuperview()
            self.trailingConstraint?.isActive = false
            let trailingConstraint = containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
            NSLayoutConstraint.activate([
                trailingConstraint
            ])
            self.trailingConstraint = trailingConstraint
        }
    }

    private func scrollViewContentInset() -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: leadingCommandGroupsStackView.itemGroups.isEmpty ? CommandBar.insets.left : CommandBar.fixedButtonSpacing,
            bottom: 0,
            right: trailingCommandGroupsStackView.itemGroups.isEmpty ? CommandBar.insets.right : CommandBar.fixedButtonSpacing
        )
    }

    private func updateShadow() {
        var locations: [CGFloat] = [0, 0, 1]

        if !leadingCommandGroupsStackView.itemGroups.isEmpty {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        if !trailingCommandGroupsStackView.itemGroups.isEmpty {
            let trailingOffset = max(0, mainCommandGroupsStackView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
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
