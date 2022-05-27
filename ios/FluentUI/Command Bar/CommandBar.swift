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
    // commandBarContainerStackView
    // |--leadingCommandGroupsView
    // |--|--buttons
    // |--containerView
    // |--|--layer.mask -> containerMaskLayer (fill containerView)
    // |--|--subviews
    // |--|  |--scrollView (fill containerView)
    // |--|  |  |--subviews
    // |--|  |  |  |--stackView
    // |--|  |  |  |  |--buttons (fill scrollView content)
    // |--trailingCommandGroupsView
    // |--|--buttons

    // MARK: - Public methods

    @available(*, renamed: "init(itemGroups:leadingItemGroups:trailingItemGroups:)")
    @objc public convenience init(itemGroups: [CommandBarItemGroup], leadingItem: CommandBarItem? = nil, trailingItem: CommandBarItem? = nil) {
        var leadingItems: [CommandBarItemGroup]?
        var trailingItems: [CommandBarItemGroup]?

        if let leadingItem = leadingItem {
            leadingItems = [[leadingItem]]
        }

        if let trailingItem = trailingItem {
            trailingItems = [[trailingItem]]
        }

        self.init(itemGroups: itemGroups, leadingItemGroups: leadingItems, trailingItemGroups: trailingItems)
    }

    @objc public init(itemGroups: [CommandBarItemGroup], leadingItemGroups: [CommandBarItemGroup]? = nil, trailingItemGroups: [CommandBarItemGroup]? = nil) {
        self.itemGroups = itemGroups
        self.leadingItemGroups = leadingItemGroups
        self.trailingItemGroups = trailingItemGroups

        leadingCommandGroupsView = CommandBarCommandGroupsView(itemGroups: self.leadingItemGroups, buttonsPersistSelection: false)
        leadingCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false
        mainCommandGroupsView = CommandBarCommandGroupsView(itemGroups: self.itemGroups)
        mainCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false
        trailingCommandGroupsView = CommandBarCommandGroupsView(itemGroups: self.trailingItemGroups, buttonsPersistSelection: false)
        trailingCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false

        commandBarContainerStackView = UIStackView()
        commandBarContainerStackView.axis = .horizontal
        commandBarContainerStackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        configureHierarchy()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Apply `isEnabled` and `isSelected` state from `CommandBarItem` to the buttons
    @available(*, message: "Changes on CommandBarItem objects will automatically trigger updates to their corresponding CommandBarButtons. Calls to this method are no longer necessary.")
    @objc public func updateButtonsState() {
        leadingCommandGroupsView.updateButtonsState()
        mainCommandGroupsView.updateButtonsState()
        trailingCommandGroupsView.updateButtonsState()
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        commandBarContainerStackView.layoutIfNeeded()

        containerMaskLayer.frame = containerView.bounds
        updateShadow()
    }

    /// Scrollable items shown in the center of the CommandBar
    public var itemGroups: [CommandBarItemGroup] {
        didSet {
            mainCommandGroupsView.itemGroups = itemGroups
        }
    }

    /// Items pinned to the leading end of the CommandBar
    public var leadingItemGroups: [CommandBarItemGroup]? {
        didSet {
            guard let leadingItemGroups = leadingItemGroups else {
                return
            }

            leadingCommandGroupsView.itemGroups = leadingItemGroups
            leadingCommandGroupsView.isHidden = leadingItemGroups.isEmpty
            scrollView.contentInset = scrollViewContentInset()
        }
    }

    /// Items pinned to the trailing end of the CommandBar
    public var trailingItemGroups: [CommandBarItemGroup]? {
        didSet {
            guard let trailingItemGroups = trailingItemGroups else {
                return
            }

            trailingCommandGroupsView.itemGroups = trailingItemGroups
            trailingCommandGroupsView.isHidden = trailingItemGroups.isEmpty
            scrollView.contentInset = scrollViewContentInset()
        }
    }

    // MARK: - Private properties

    /// Container UIStackView that holds the leading, main and trailing views
    private var commandBarContainerStackView: UIStackView

    /// View holding the items pinned to the leading end of the CommandBar
    private var leadingCommandGroupsView: CommandBarCommandGroupsView

    /// View holding the items in the middle of the CommandBar
    private var mainCommandGroupsView: CommandBarCommandGroupsView

    /// View holding the items pinned to the trailing end of the CommandBar
    private var trailingCommandGroupsView: CommandBarCommandGroupsView

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

        scrollView.addSubview(mainCommandGroupsView)
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            mainCommandGroupsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainCommandGroupsView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: mainCommandGroupsView.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: mainCommandGroupsView.trailingAnchor)
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
        leadingCommandGroupsView.isHidden = leadingCommandGroupsView.itemGroups.isEmpty
        trailingCommandGroupsView.isHidden = trailingCommandGroupsView.itemGroups.isEmpty

        addSubview(commandBarContainerStackView)

        commandBarContainerStackView.addArrangedSubview(leadingCommandGroupsView)
        commandBarContainerStackView.addArrangedSubview(containerView)
        commandBarContainerStackView.addArrangedSubview(trailingCommandGroupsView)

        NSLayoutConstraint.activate([
            commandBarContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commandBarContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commandBarContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            commandBarContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            // Flip the scroll view to invert scrolling direction. Flip its content back because it's already in RTL.
            let flipTransform = CGAffineTransform(scaleX: -1, y: 1)
            scrollView.transform = flipTransform
            leadingCommandGroupsView.transform = flipTransform
            mainCommandGroupsView.transform = flipTransform
            trailingCommandGroupsView.transform = flipTransform
            containerMaskLayer.setAffineTransform(flipTransform)
        }

        scrollView.contentInset = scrollViewContentInset()
    }

    private func scrollViewContentInset() -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: leadingCommandGroupsView.isHidden ? CommandBar.insets.left : CommandBar.fixedButtonSpacing,
            bottom: 0,
            right: trailingCommandGroupsView.isHidden ? CommandBar.insets.right : CommandBar.fixedButtonSpacing
        )
    }

    private func updateShadow() {
        var locations: [CGFloat] = [0, 0, 1]

        if !leadingCommandGroupsView.isHidden {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        if !trailingCommandGroupsView.isHidden {
            let trailingOffset = max(0, mainCommandGroupsView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - CommandBar.fadeViewWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
    }

    private static let fadeViewWidth: CGFloat = 16.0
    private static let fixedButtonSpacing: CGFloat = 2.0
    private static let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
}

// MARK: - Scroll view delegate

extension CommandBar: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShadow()
    }
}
