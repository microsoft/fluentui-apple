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
    @objc open var avatarView: AvatarView? {
        willSet {
            if let gestureRecognizer = avatarViewGestureRecognizer {
                avatarView?.removeGestureRecognizer(gestureRecognizer)
                avatarViewGestureRecognizer = nil
            }

            avatarView?.removeFromSuperview()
        }
        didSet {
            if let view = avatarView {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAvatarViewTapped))
                avatarViewGestureRecognizer = tapGesture;
                view.addGestureRecognizer(tapGesture)
            }

            setupLayoutConstraints()
        }
    }

    /// Tab bar iems to display in the top section of the side tab bar.
    @objc open var topItems: [TabBarItem] = [] {
        willSet {
            willSetItems(in: .top)
        }
        didSet {
            didSetItems(in: .top)
        }
    }

    /// Tab bar iems to display in the bottom section of the side tab bar.
    /// These items do not have a selected state.
    @objc open var bottomItems: [TabBarItem] = [] {
        willSet {
            willSetItems(in: .bottom)
        }
        didSet {
            didSetItems(in: .bottom)
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

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Helper method to insert the view in a superview.
    @objc public func insert(in superView: UIView) {
        superView.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            topAnchor.constraint(equalTo: superView.topAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }

    private enum Section: Int {
        case top
        case bottom
    }

    private struct Constants {
        static let maxTabCount: Int = 5
        static let viewWidth: CGFloat = 62.0
        static let avatarViewSize: CGFloat = 30.0
        static let avatarViewTopPadding: CGFloat = 18.0
        static let topStackViewTopPadding: CGFloat = 30.0
        static let avatarViewTopStackViewPadding: CGFloat = 34.0
        static let bottomStackViewBottomPadding: CGFloat = 10.0
        static let topItemSpacing: CGFloat = 38.0
        static let bottomItemSpacing: CGFloat = 28.0
        static let itemHeight: CGFloat = 24.0
    }

    private var layoutConstraints: [NSLayoutConstraint] = []
    private var avatarViewGestureRecognizer: UITapGestureRecognizer?
    private let borderLine = Separator(style: .shadow, orientation: .vertical)

    private let backgroundView: UIVisualEffectView = {
        var style = UIBlurEffect.Style.regular
        if #available(iOS 13, *) {
            style = .systemChromeMaterial
        }

        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    private let topStackView: UIStackView = {
        let topStackView = UIStackView(frame: .zero)
        topStackView.axis = .vertical
        topStackView.distribution = .fillEqually
        topStackView.alignment = .fill
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.spacing = Constants.topItemSpacing

        return topStackView
    }()

    private let bottomStackView: UIStackView = {
        let bottomStackView = UIStackView(frame: .zero)
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fillEqually
        bottomStackView.alignment = .fill
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.spacing = Constants.bottomItemSpacing

        return bottomStackView
    }()

    private func initialize() {
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

    private func setupLayoutConstraints() {
        if layoutConstraints.count > 0 {
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints.removeAll()
        }

        if let avatarView = self.avatarView {
            layoutConstraints.append(contentsOf: [
                avatarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.avatarViewTopPadding),
                avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
                avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarViewSize),
                avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarViewSize),
                topStackView.topAnchor.constraint(equalTo:avatarView.bottomAnchor , constant: Constants.avatarViewTopStackViewPadding)
            ])
        } else {
            layoutConstraints.append(topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topStackViewTopPadding))
        }

        layoutConstraints.append(contentsOf: [
            topStackView.widthAnchor.constraint(equalTo: widthAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: stackViewHeight(topStackView)),
            bottomStackView.widthAnchor.constraint(equalTo: widthAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: stackViewHeight(bottomStackView)),
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomStackViewBottomPadding)
        ])

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func willSetItems(in section: Section) {
        for subview in stackView(in: section).arrangedSubviews {
            subview.removeFromSuperview()
        }
    }

    private func didSetItems(in section: Section) {
        let allItems = items(in: section)
        let numberOfItems = allItems.count
        if numberOfItems > Constants.maxTabCount {
            preconditionFailure("tab bar items can't be more than \(Constants.maxTabCount)")
        }

        let stackView = self.stackView(in: section)

        for item in allItems {
            let tabBarItemView = TabBarItemView(item: item, showsTitle: false)
            let tapGesture = UITapGestureRecognizer(target: self, action: (section == .top) ? #selector(handleTopItemTapped(_:)) : #selector(handleBottomItemTapped(_:)))
            tabBarItemView.addGestureRecognizer(tapGesture)

            stackView.addArrangedSubview(tabBarItemView)
        }

        if (section == .top) {
            selectedTopItem = allItems.first
        }

        setupLayoutConstraints()
    }

    private func stackViewHeight(_ stackView: UIStackView) -> CGFloat {
        let itemCount: CGFloat = CGFloat(stackView.arrangedSubviews.count)
        var height: CGFloat = Constants.itemHeight * itemCount

        if (itemCount > 0) {
            height += stackView.spacing * (itemCount - 1)
        }

        return height
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
            if let tabBarItemView = stackView(in: section).arrangedSubviews[index] as? TabBarItemView {
                return tabBarItemView
            }
        }

        return nil
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
