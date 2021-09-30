//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TabBarViewDelegate

@available(*, deprecated, renamed: "TabBarViewDelegate")
public typealias MSTabBarViewDelegate = TabBarViewDelegate

@objc(MSFTabBarViewDelegate)
public protocol TabBarViewDelegate {
    /// Called after the view representing `TabBarItem` is selected.
    @objc optional func tabBarView(_ tabBarView: TabBarView, didSelect item: TabBarItem)
}

// MARK: - TabBarView

@available(*, deprecated, renamed: "TabBarView")
public typealias MSTabBarView = TabBarView

/// `TabBarView` supports maximum 5 tab bar items
/// Set up `delegate` property to listen to selection changes.
/// Set up `items` array to determine the order of `TabBarItems` to show.
/// Use `selectedItem` property to change the selected tab bar item.
@objc(MSFTabBarView)
open class TabBarView: UIView {
    /// List of TabBarItems in the TabBarView. Order of the array is the order of the subviews.
    @objc open var items: [TabBarItem] = [] {
        willSet {
            for subview in stackView.arrangedSubviews {
                subview.removeFromSuperview()
            }
        }
        didSet {
            let numberOfItems = items.count
            if numberOfItems > Constants.maxTabCount {
                preconditionFailure("tab bar items can't be more than \(Constants.maxTabCount)")
            }

            for (index, item) in items.enumerated() {
                let tabBarItemView = TabBarItemView(item: item, showsTitle: showsItemTitles)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTabBarItemTapped(_:)))
                tabBarItemView.addGestureRecognizer(tapGesture)

                // iOS 14.0 - 14.5 `.tabBar` accessibilityTrait does not read out the index automatically
                if #available(iOS 14.0, *) {
                    if #available(iOS 14.6, *) { } else {
                        tabBarItemView.accessibilityHint = String.localizedStringWithFormat( "Accessibility.TabBarItemView.Hint".localized, index + 1, numberOfItems)
                    }
                }
                stackView.addArrangedSubview(tabBarItemView)
            }

            selectedItem = items.first
        }
    }

    @objc open var selectedItem: TabBarItem? {
        willSet {
            if let item = selectedItem {
               (itemView(with: item) as? TabBarItemView)?.isSelected = false
            }
        }
        didSet {
            if let item = selectedItem {
                (itemView(with: item) as? TabBarItemView)?.isSelected = true
            }
        }
    }

    @objc public weak var delegate: TabBarViewDelegate?

    /// Set the custom spacing after the specified item.
    /// - Parameter spacing The spacing.
    /// - Parameter item The item to add spacing after.
    @objc public func setCustomSpacing(_ spacing: CGFloat, after item: TabBarItem) {
        if let index = items.firstIndex(of: item), index < stackView.arrangedSubviews.count {
            let view = stackView.arrangedSubviews[index]
            stackView.setCustomSpacing(spacing, after: view)
        }
    }

    /// Initializes MSTabBarView
    /// - Parameter showsItemTitles: Determines whether or not to show the titles of the tab ba ritems.
    @objc public init(showsItemTitles: Bool = false) {
        self.showsItemTitles = showsItemTitles
        super.init(frame: .zero)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contain(view: backgroundView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contain(view: stackView, withInsets: .zero, respectingSafeAreaInsets: true)

        topBorderLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorderLine)

        heightConstraint = stackView.heightAnchor.constraint(equalToConstant: traitCollection.userInterfaceIdiom == .phone ? Constants.phonePortraitHeight : Constants.padHeight)
        NSLayoutConstraint.activate([heightConstraint!,
                                     topBorderLine.bottomAnchor.constraint(equalTo: topAnchor),
                                     topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor)])

        addInteraction(UILargeContentViewerInteraction())

        accessibilityTraits = .tabBar
        // add container trait to mimic default OS UITabbar experience
        accessibilityTraits.insert(UIAccessibilityTraits(rawValue: 0x200000000000))
        updateHeight()
    }

    required public init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            updateHeight()
        }
    }

    @objc public func itemView(with item: TabBarItem) -> UIView? {
        if let index = items.firstIndex(of: item) {
            let arrangedSubviews = stackView.arrangedSubviews

            if arrangedSubviews.count > index {
                if let tabBarItemView = arrangedSubviews[index] as? TabBarItemView {
                    return tabBarItemView
                }
            }
        }

        return nil
    }

    private struct Constants {
        static let maxTabCount: Int = 5
        static let phonePortraitHeight: CGFloat = 48.0
        static let phoneLandscapeHeight: CGFloat = 40.0
        static let padHeight: CGFloat = 48.0
    }

    private let backgroundView: UIVisualEffectView = {
        var style = UIBlurEffect.Style.regular
        style = .systemChromeMaterial

        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    private var heightConstraint: NSLayoutConstraint?

    private let showsItemTitles: Bool

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    private let topBorderLine = Separator(style: .shadow, orientation: .horizontal)

    private func updateHeight() {
        if traitCollection.userInterfaceIdiom == .phone {
            let isPortrait = traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
            heightConstraint?.constant = isPortrait ? Constants.phonePortraitHeight : Constants.phoneLandscapeHeight
        }
    }

    @objc private func handleTabBarItemTapped(_ recognizer: UITapGestureRecognizer) {
        if let item = (recognizer.view as? TabBarItemView)?.item {
            selectedItem = item
            delegate?.tabBarView?(self, didSelect: item)
        }
    }
}
