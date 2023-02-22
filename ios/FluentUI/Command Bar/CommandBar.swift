//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

/// `CommandBarDelegate` is used to notify consumers of the `CommandBar` of certain events occurring within the `CommandBar`
public protocol CommandBarDelegate: AnyObject {
    /// Called when a scroll occurs in the `CommandBar`
    /// - Parameter commandBar: the instance of `CommandBar` that received the scroll
    func commandBarDidScroll(_ commandBar: CommandBar)
}

/**
 `CommandBar` is a horizontal scrollable list of icon buttons divided by groups.
 Set the `delegate` property to receive callbacks when scroll events occur.
 Provide `itemGroups` in `init` to set the buttons in the scrollable area. Optional `leadingItemGroups` and `trailingItemGroups` add buttons in leading and trailing positions. Each `CommandBarItem` will be represented as a button.
 */
@objc(MSFCommandBar)
public class CommandBar: UIView, TokenizedControlInternal {
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
    @objc public convenience init(itemGroups: [CommandBarItemGroup],
                                  leadingItem: CommandBarItem? = nil,
                                  trailingItem: CommandBarItem? = nil) {
        let leadingItems: [CommandBarItemGroup]? = {
            guard let leadingItem = leadingItem else {
                return nil
            }

            return [[leadingItem]]
        }()

        let trailingItems: [CommandBarItemGroup]? = {
            guard let trailingItem = trailingItem else {
                return nil
            }

            return [[trailingItem]]
        }()

        self.init(itemGroups: itemGroups,
                  leadingItemGroups: leadingItems,
                  trailingItemGroups: trailingItems)
    }

    @objc public init(itemGroups: [CommandBarItemGroup],
                      leadingItemGroups: [CommandBarItemGroup]? = nil,
                      trailingItemGroups: [CommandBarItemGroup]? = nil) {
        self.tokenSet = CommandBarTokenSet()

        leadingCommandGroupsView = CommandBarCommandGroupsView(itemGroups: leadingItemGroups,
                                                               buttonsPersistSelection: false,
                                                               tokenSet: tokenSet)
        leadingCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false
        mainCommandGroupsView = CommandBarCommandGroupsView(itemGroups: itemGroups,
                                                            tokenSet: tokenSet)
        mainCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false
        trailingCommandGroupsView = CommandBarCommandGroupsView(itemGroups: trailingItemGroups,
                                                                buttonsPersistSelection: false,
                                                                tokenSet: tokenSet)
        trailingCommandGroupsView.translatesAutoresizingMaskIntoConstraints = false

        commandBarContainerStackView = UIStackView()
        commandBarContainerStackView.axis = .horizontal
        commandBarContainerStackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
        configureHierarchy()

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.objectWillChange.sink { [weak self] _ in
            // Values will be updated on the next run loop iteration.
            DispatchQueue.main.async {
                self?.updateButtonTokens()
            }
        }
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateButtonTokens()
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

    /// Sets the scoll position  to the start of the scroll view
    @objc public func resetScrollPosition(_ animated: Bool = false) {
        /// A `CGRect` with a `width` and `height` both greater than `0` is required for the scrolling to occur
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updateShadow()
    }

#if DEBUG
    public override var accessibilityIdentifier: String? {
        get {
            var identifier: String = "Command Bar"

            if leadingItemGroups != nil {
                let count: Int = leadingItemGroups?.count ?? 0
                identifier += " with \(count) \(count == 1 ? "leading button" : "leading buttons")"
            }

            if trailingItemGroups != nil {
                let count: Int = trailingItemGroups?.count ?? 0
                identifier += " and \(count) \(count == 1 ? "trailing button" : "trailing buttons")"
            }

            return identifier
        }
        set { }
    }
#endif

    // MARK: - TokenizedControl

    public typealias TokenSetKeyType = CommandBarTokenSet.Tokens
    public var tokenSet: CommandBarTokenSet

    /// Scrollable items shown in the center of the CommandBar
    public var itemGroups: [CommandBarItemGroup] {
        get {
            mainCommandGroupsView.itemGroups
        }
        set {
            mainCommandGroupsView.itemGroups = newValue
        }
    }

    /// Items pinned to the leading end of the CommandBar
    public var leadingItemGroups: [CommandBarItemGroup]? {
        get {
            leadingCommandGroupsView.itemGroups
        }
        set {
            setupGroupsView(leadingCommandGroupsView, with: newValue)
        }
    }

    /// Items pinned to the trailing end of the CommandBar
    public var trailingItemGroups: [CommandBarItemGroup]? {
        get {
            trailingCommandGroupsView.itemGroups
        }
        set {
            setupGroupsView(trailingCommandGroupsView, with: newValue)
        }
    }

    /// Delegate object that notifies consumers of events occuring inside the `CommandBar`
    public weak var delegate: CommandBarDelegate?

    // MARK: - Private properties

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(fluentTheme)
    }

    private var tokenSetSink: AnyCancellable?

    /// Container UIStackView that holds the leading, main and trailing views
    private var commandBarContainerStackView: UIStackView

    /// View holding the items pinned to the leading end of the CommandBar
    private var leadingCommandGroupsView: CommandBarCommandGroupsView

    /// View holding the items in the middle of the CommandBar
    private var mainCommandGroupsView: CommandBarCommandGroupsView

    /// View holding the items pinned to the trailing end of the CommandBar
    private var trailingCommandGroupsView: CommandBarCommandGroupsView

    // MARK: Views and Layers

    private lazy var containerView: CommandBarContainerView = {
        let containerView = CommandBarContainerView()
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
            mainCommandGroupsView.transform = flipTransform
            containerMaskLayer.setAffineTransform(flipTransform)
        }

        scrollView.contentInset = scrollViewContentInset()
    }

    private func scrollViewContentInset() -> UIEdgeInsets {
        let fixedButtonSpacing = CommandBarTokenSet.itemInterspace
        return UIEdgeInsets(top: 0,
                            left: leadingCommandGroupsView.isHidden ? CommandBarTokenSet.barInsets : fixedButtonSpacing,
                            bottom: 0,
                            right: trailingCommandGroupsView.isHidden ? CommandBarTokenSet.barInsets : fixedButtonSpacing
        )
    }

    private func updateShadow() {
        var locations: [CGFloat] = [0, 0, 1]

        if !leadingCommandGroupsView.isHidden {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = CommandBarTokenSet.dismissGradientWidth / containerView.frame.width * percentage
        }

        if !trailingCommandGroupsView.isHidden {
            let trailingOffset = max(0, mainCommandGroupsView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - CommandBarTokenSet.dismissGradientWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
    }

    private func updateButtonTokens() {
        leadingCommandGroupsView.updateButtonsShown()
        mainCommandGroupsView.updateButtonsShown()
        trailingCommandGroupsView.updateButtonsShown()
    }

    /// Updates the provided `CommandBarCommandGroupsView` with the `items` array and marks the view as needing a layout
    private func setupGroupsView(_ commandGroupsView: CommandBarCommandGroupsView, with items: [CommandBarItemGroup]?) {
        commandGroupsView.itemGroups = items ?? []

        commandGroupsView.isHidden = commandGroupsView.itemGroups.isEmpty
        scrollView.contentInset = scrollViewContentInset()
    }
}

// MARK: - Scroll view delegate

extension CommandBar: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateShadow()

        delegate?.commandBarDidScroll(self)
    }
}

/// A UIView subclass that updates its mask frame during layoutSubviews. By default, the layer mask
/// is not hooked into auto-layout and will not update its frame if its parent frame changes size. This implementation
/// fixes that.
private class CommandBarContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask?.frame = bounds
    }
}
