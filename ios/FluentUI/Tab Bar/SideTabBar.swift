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
    @objc optional func sideTabBar(_ sideTabBar: SideTabBar, didActivate avatarView: AvatarView)
}

/// View for a vertical side tab bar that can be used for app navigation.
/// Optimized for horizontal regular + vertical regular size class configuration. Prefer using TabBarView for other size class configurations.
@objc(MSFSideTabBar)
open class SideTabBar: UIView {
    /// Delegate to handle user interactions in the side tab bar.
    @objc public weak var delegate: SideTabBarDelegate?

    /// The avatar view that displays above the top tab bar items.
    /// The avatar view's size class should be AvatarSize.medium.
    @objc open var avatarView: AvatarView? {
        willSet {
            avatarView?.removeGestureRecognizer(avatarViewGestureRecognizer)
            avatarView?.removeFromSuperview()
        }
        didSet {
            if let avatarView = avatarView {
                avatarView.avatarSize = .medium
                avatarView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(avatarView)

                avatarView.addGestureRecognizer(avatarViewGestureRecognizer)
            }

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

        if #available(iOS 13, *) {
            addInteraction(UILargeContentViewerInteraction())
        }

        accessibilityTraits = .tabBar

        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: Constants.viewWidth),
                                     borderLine.leadingAnchor.constraint(equalTo: trailingAnchor),
                                     borderLine.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     borderLine.topAnchor.constraint(equalTo: topAnchor)])
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private enum Section: Int {
        case top
        case bottom
    }

    private struct Constants {
        static let maxTabCount: Int = 5
        static let viewWidth: CGFloat = 62.0
        static let avatarViewTopPadding: CGFloat = 18.0
        static let avatarViewTopStackViewPadding: CGFloat = 34.0
        static let bottomStackViewBottomPadding: CGFloat = 14.0
        static let topItemSpacing: CGFloat = 32.0
        static let bottomItemSpacing: CGFloat = 24.0
        static let topItemSize: CGFloat = 28.0
        static let bottomItemSize: CGFloat = 24.0
        static let badgeTopSectionPadding: CGFloat = 2.0
        static let badgeBottomSectionPadding: CGFloat = 4.0
    }

    private var layoutConstraints: [NSLayoutConstraint] = []
    private let borderLine = Separator(style: .shadow, orientation: .vertical)

    private let backgroundView: UIVisualEffectView = {
        var style = UIBlurEffect.Style.regular
        if #available(iOS 13, *) {
            style = .systemChromeMaterial
        }

        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    private let topStackView: UIStackView = {
        return createStackView(spacing: Constants.topItemSpacing)
    }()

    private let bottomStackView: UIStackView = {
        return createStackView(spacing: Constants.bottomItemSpacing)
    }()

    private let avatarViewGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped))
    }()

    private func setupLayoutConstraints() {
        if layoutConstraints.count > 0 {
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints.removeAll()
        }

        if let avatarView = avatarView {
            layoutConstraints.append(contentsOf: [
                avatarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.avatarViewTopPadding),
                avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
                topStackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.avatarViewTopStackViewPadding)
            ])
        } else {
            layoutConstraints.append(topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topItemSpacing))
        }

        layoutConstraints.append(contentsOf: [
            topStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            bottomStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomStackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomStackViewBottomPadding)
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
        let badgePadding = section == .top ? Constants.badgeTopSectionPadding : Constants.badgeBottomSectionPadding
        let showItemTitles = section == .top ? showTopItemTitles : showBottomItemTitles
        var didRestoreSelection = false

        for item in allItems {
            let tabBarItemView = TabBarItemView(item: item, showsTitle: showItemTitles, canResizeImage: false)
            tabBarItemView.translatesAutoresizingMaskIntoConstraints = false
            tabBarItemView.alwaysShowTitleBelowImage = true
            tabBarItemView.maxBadgeWidth = Constants.viewWidth / 2 - badgePadding

            if itemView(with: item, in: section) != nil && section == .top && item == selectedTopItem {
                tabBarItemView.isSelected = true
                didRestoreSelection = true
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: (section == .top) ? #selector(handleTopItemTapped(_:)) : #selector(handleBottomItemTapped(_:)))
            tabBarItemView.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(tabBarItemView)
        }

        NSLayoutConstraint.activate(constraints)

        if section == .top && !didRestoreSelection {
            selectedTopItem = allItems.first
        }

        setupLayoutConstraints()
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
        delegate?.sideTabBar?(self, didActivate: avatarView!)
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
}
