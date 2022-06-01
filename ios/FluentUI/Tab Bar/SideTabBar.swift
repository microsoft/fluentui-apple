//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Delegate protocol to handle user events inside the side tab bar.
@objc(MSFSideTabBarDelegate)
public protocol SideTabBarDelegate {
    /// Called after the view representing `TabBarItem` is selected.
    /// - Parameter sideTabBar: The side tab bar.
    /// - Parameter item: The selected tab bar item.
    /// - Parameter fromTop: true if the item was in the top section, false if it was in the bottom section.
    @objc optional func sideTabBar(_ sideTabBar: SideTabBar, didSelect item: TabBarItem, fromTop: Bool)

    /// Called after the avatar view is tapped in the side tab bar.
    /// - Parameter sideTabBar: The side tab bar.
    /// - Parameter avatarView: The avatar view.
    @objc optional func sideTabBar(_ sideTabBar: SideTabBar, didActivate avatarView: MSFAvatar)
}

/// View for a vertical side tab bar that can be used for app navigation.
/// Optimized for horizontal regular + vertical regular size class configuration. Prefer using TabBarView for other size class configurations.
@objc(MSFSideTabBar)
open class SideTabBar: UIView, TokenizedControlInternal {
    /// Delegate to handle user interactions in the side tab bar.
    @objc public weak var delegate: SideTabBarDelegate? {
        didSet {
            if let avatar = avatar {
                avatar.state.hasButtonAccessibilityTrait = delegate != nil
            }
        }
    }

    /// The avatar view that displays above the top tab bar items.
    /// The avatar view's size class should be AvatarSize.medium.
    /// Remember to enable pointer interactions on the avatar view if it handles pointer interactions.
    @objc open var avatar: MSFAvatar? {
        willSet {
            avatar?.removeGestureRecognizer(avatarViewGestureRecognizer)
            avatar?.removeFromSuperview()
        }
        didSet {
            if let avatar = avatar {
                let avatarState = avatar.state
                avatarState.size = .medium
                avatarState.accessibilityLabel = "Accessibility.LargeTitle.ProfileView".localized
                avatarState.hasButtonAccessibilityTrait = delegate != nil

                let avatarView = avatar
                avatarView.translatesAutoresizingMaskIntoConstraints = false
                avatarView.showsLargeContentViewer = true
                avatarView.largeContentTitle = avatarState.accessibilityLabel
                addSubview(avatarView)

                avatarView.addGestureRecognizer(avatarViewGestureRecognizer)
            }

            updateAccessibilityIndex()
            setupLayoutConstraints()
        }
    }

    /// Tab bar iems to display in the top section of the side tab bar.
    /// These TabBarItems should have 28x28 images and don't need landscape images.
    @objc open var topItems: [TabBarItem] = [] {
        didSet {
            didUpdateItems(in: .top)
        }
    }

    /// Tab bar iems to display in the bottom section of the side tab bar.
    /// These items do not have a selected state.
    /// These TabBarItems should have 24x24 images and don't need landscape images.
    @objc open var bottomItems: [TabBarItem] = [] {
        didSet {
            didUpdateItems(in: .bottom)
        }
    }

    /// Selected tab bar item in the top section of the side tab bar.
    @objc open var selectedTopItem: TabBarItem? {
        willSet {
            if let item = selectedTopItem {
                itemView(with: item, in: .top)?.isSelected = false
            }
        }
        didSet {
            if let item = selectedTopItem {
                itemView(with: item, in: .top)?.isSelected = true
            }
        }
    }

    @objc public var showTopItemTitles: Bool = false {
        didSet {
            if oldValue != showTopItemTitles {
                didUpdateItems(in: .top)
            }
        }
    }

    @objc public var showBottomItemTitles: Bool = false {
        didSet {
            if oldValue != showBottomItemTitles {
                didUpdateItems(in: .bottom)
            }
        }
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contain(view: backgroundView)

        borderLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderLine)

        addSubview(topStackView)
        addSubview(bottomStackView)

        addInteraction(UILargeContentViewerInteraction())

        accessibilityTraits = .tabBar
        shouldGroupAccessibilityChildren = true

        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: tokens.sideTabBarWidth),
                                     borderLine.leadingAnchor.constraint(equalTo: trailingAnchor),
                                     borderLine.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     borderLine.topAnchor.constraint(equalTo: topAnchor)])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private enum Section: Int, CaseIterable {
        case top
        case bottom
    }

    private struct Constants {
        static let maxTabCount: Int = 5
        static let numberOfTitleLines: Int = 2
    }

    private var layoutConstraints: [NSLayoutConstraint] = []
    private let borderLine = MSFDivider(orientation: .vertical)

    private let backgroundView: UIVisualEffectView = {
        var style = UIBlurEffect.Style.regular
        style = .systemChromeMaterial

        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    private lazy var topStackView: UIStackView = {
        return SideTabBar.createStackView(spacing: tokens.topTabBarItemSpacing)
    }()

    private lazy var bottomStackView: UIStackView = {
        return SideTabBar.createStackView(spacing: tokens.bottomTabBarItemSpacing)
    }()

    private lazy var avatarViewGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped))
    }()

    private func setupLayoutConstraints() {
        if layoutConstraints.count > 0 {
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints.removeAll()
        }

        if let avatar = avatar {
            // The avatar view's distance from the top of the side tab bar depends on safe layout guides.
            // There is a minimum spacing. If the layout guide spacing is larger than the minimum spacing,
            // then the spacing will be layoutGuideSpacing + safeTopSpacing.
            let avatarView = avatar
            let topSafeConstraint = avatarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: tokens.avatarViewSafeTopSpacing)
            topSafeConstraint.priority = .defaultHigh

            layoutConstraints.append(contentsOf: [
                topSafeConstraint,
                avatarView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: tokens.avatarViewMinTopSpacing),
                avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
                topStackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: tokens.avatarViewTopStackViewSpacing)
            ])
        } else {
            layoutConstraints.append(topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: tokens.topTabBarItemSpacing))
        }

        let bottomSafeConstraint = bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -tokens.bottomStackViewSafeSpacing)
        bottomSafeConstraint.priority = .defaultHigh

        layoutConstraints.append(contentsOf: [
            topStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            bottomStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            bottomSafeConstraint,
            bottomStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -tokens.bottomStackViewMinSpacing)
        ])

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func didUpdateItems(in section: Section) {
        for subview in stackView(in: section).arrangedSubviews {
            subview.removeFromSuperview()
        }

        let allItems = items(in: section)
        let numberOfItems = allItems.count
        if numberOfItems > Constants.maxTabCount {
            preconditionFailure("tab bar items can't be more than \(Constants.maxTabCount)")
        }

        let stackView = self.stackView(in: section)
        let badgePadding = section == .top ? tokens.badgeTopSectionPadding : tokens.badgeBottomSectionPadding
        let showItemTitles = section == .top ? showTopItemTitles : showBottomItemTitles
        var didRestoreSelection = false

        for item in allItems {
            let tabBarItemView = TabBarItemView(item: item, showsTitle: showItemTitles, canResizeImage: false)
            tabBarItemView.translatesAutoresizingMaskIntoConstraints = false
            tabBarItemView.alwaysShowTitleBelowImage = true
            tabBarItemView.maxBadgeWidth = tokens.sideTabBarWidth / 2 - badgePadding
            tabBarItemView.numberOfTitleLines = Constants.numberOfTitleLines

            if itemView(with: item, in: section) != nil && section == .top && item == selectedTopItem {
                tabBarItemView.isSelected = true
                didRestoreSelection = true
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: (section == .top) ? #selector(handleTopItemTapped(_:)) : #selector(handleBottomItemTapped(_:)))
            tabBarItemView.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(tabBarItemView)
        }

        if section == .top && !didRestoreSelection {
            selectedTopItem = allItems.first
        }

        updateAccessibilityIndex()
        setupLayoutConstraints()
    }

    private func updateAccessibilityIndex() {
        // iOS 14.0 - 14.5 `.tabBar` accessibilityTrait does not read out the index automatically
        if #available(iOS 14.6, *) {} else {
            var totalCount: Int = 0
            for section in Section.allCases {
                let currentStackView = stackView(in: section)
                totalCount += currentStackView.arrangedSubviews.count
            }

            var previousSectionCount: Int = 0
            if let avatar = avatar, !avatar.isHidden {
                totalCount += 1
                previousSectionCount += 1
            }

            for section in Section.allCases {
                let currentStackView = stackView(in: section)

                for (index, itemView) in currentStackView.arrangedSubviews.enumerated() {
                    let accessibilityIndex = index + 1 + previousSectionCount
                    itemView.accessibilityHint = String.localizedStringWithFormat( "Accessibility.TabBarItemView.Hint".localized, accessibilityIndex, totalCount)
                }
                previousSectionCount += currentStackView.arrangedSubviews.count
            }
        }
    }

    private func items(in section: Section) -> [TabBarItem] {
        switch section {
        case .top:
            return topItems
        case .bottom:
            return bottomItems
        }
    }

    private func stackView(in section: Section) -> UIStackView {
        switch section {
        case .top:
            return topStackView
        case .bottom:
            return bottomStackView
        }
    }

    private func itemView(with item: TabBarItem, in section: Section) -> TabBarItemView? {
        if let index = items(in: section).firstIndex(of: item) {
            let stack = stackView(in: section)
            let arrangedSubviews = stack.arrangedSubviews

            if arrangedSubviews.count > index {
                if let tabBarItemView = stack.arrangedSubviews[index] as? TabBarItemView {
                    return tabBarItemView
                }
            }
        }

        return nil
    }

    /// Returns the first match of an optional view for a given tab bar item.
    /// Searches for the view in the top and bottom sections in that order of priority. Returns nil if the view is not found in either section.
    @objc public func itemView(with item: TabBarItem) -> UIView? {
        if let view = itemView(with: item, in: .top) {
            return view
        }

        return itemView(with: item, in: .bottom)
    }

    private class func createStackView(spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = spacing

        return stackView
    }

    @objc private func handleAvatarViewTapped(_ recognizer: UITapGestureRecognizer) {
        guard let avatar = avatar else {
            return
        }

        delegate?.sideTabBar?(self, didActivate: avatar)
    }

    @objc private func handleTopItemTapped(_ recognizer: UITapGestureRecognizer) {
        if let item = (recognizer.view as? TabBarItemView)?.item {
            selectedTopItem = item

            delegate?.sideTabBar?(self, didSelect: item, fromTop: true)
        }
    }

    @objc private func handleBottomItemTapped(_ recognizer: UITapGestureRecognizer) {
        if let item = (recognizer.view as? TabBarItemView)?.item {
            delegate?.sideTabBar?(self, didSelect: item, fromTop: false)
        }
    }

    public func overrideTokens(_ tokens: SideTabBarTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    var defaultTokens: SideTabBarTokens = .init()
    var tokens: SideTabBarTokens = .init()
    var overrideTokens: SideTabBarTokens? {
        didSet {
            updateSideTabBarTokens()
        }
    }

    // This custom tokens class is used to override only the four TabBarItemToken values
    // that we want to expose publicly to consumers of the SideTabBar.
    private class CustomSideTabBarItemTokens: TabBarItemTokens {
        @available(*, unavailable)
        required init() {
            preconditionFailure("init() has not been implemented")
        }

        init (sideTabBarTokens: SideTabBarTokens) {
            self.sideTabBarTokens = sideTabBarTokens
            super.init()
        }

        override var selectedColor: DynamicColor {
            sideTabBarTokens.tabBarItemSelectedColor ?? super.selectedColor
        }

        override var unselectedColor: DynamicColor {
            sideTabBarTokens.tabBarItemUnselectedColor ?? super.unselectedColor
        }

        override var titleLabelFontPortrait: FontInfo {
            sideTabBarTokens.tabBarItemTitleLabelFontPortrait ?? super.titleLabelFontPortrait
        }

        override var titleLabelFontLandscape: FontInfo {
            sideTabBarTokens.tabBarItemTitleLabelFontLandscape ?? super.titleLabelFontLandscape
        }

        var sideTabBarTokens: SideTabBarTokens
    }

    private func updateSideTabBarTokens() {
        tokens = resolvedTokens
        updateSideTabBarTokensForSection(in: .top)
        updateSideTabBarTokensForSection(in: .bottom)
    }

    private func updateSideTabBarTokensForSection(in section: Section) {
        let customSideTabBarItemTokens = CustomSideTabBarItemTokens.init(sideTabBarTokens: tokens)
        for subview in stackView(in: section).arrangedSubviews {
            if let tabBarItemView = subview as? TabBarItemView {
                tabBarItemView.overrideTokens = customSideTabBarItemTokens
            }
        }
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateSideTabBarTokens()
    }
}
