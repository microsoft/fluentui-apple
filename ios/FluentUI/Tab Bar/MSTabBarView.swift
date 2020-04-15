//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTabBarViewDelegate

@objc public protocol MSTabBarViewDelegate {
    /// Called after the view representing `MSTabBarItem` is selected.
    @objc optional func tabBarView(_ tabBarView: MSTabBarView, didSelect item: MSTabBarItem)
}

// MARK: - MSTabBarView

/// `MSTabBarView` supports maximum 5 tab bar items
/// Set up `delegate` property to listen to selection changes.
/// Set up `items` array to determine the order of `MSTabBarItems` to show.
/// Use `selectedItem` property to change the selected tab bar item.
open class MSTabBarView: UIView {
    private struct Constants {
        static let maxTabCount: Int = 5
        static let portraitHeight: CGFloat = 49.0
        static let landscapeHeight: CGFloat = 40.0
    }

    /// List of MSTabBarItems in the MSTabBarView. Order of the array is the order of the subviews.
    @objc open var items: [MSTabBarItem] = [] {
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
                let tabBarItemView = MSTabBarItemView(item: item, showsTitle: showsItemTitles)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTabBarItemTapped(_:)))
                tabBarItemView.addGestureRecognizer(tapGesture)
                tabBarItemView.accessibilityHint = String(format: "Accessibility.TabBarItemView.Hint".localized, index + 1, numberOfItems)
                stackView.addArrangedSubview(tabBarItemView)
            }

            selectedItem = items.first
        }
    }

    @objc open var selectedItem: MSTabBarItem? {
        willSet {
            if let item = selectedItem {
                itemView(with: item)?.isSelected = false
            }
        }
        didSet {
            if let item = selectedItem {
                itemView(with: item)?.isSelected = true
            }
        }
    }

    @objc public weak var delegate: MSTabBarViewDelegate?

    private let backgroundView: UIVisualEffectView = {
        var style = UIBlurEffect.Style.regular
        if #available(iOS 13, *) {
            style = .systemMaterial
        }
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

    private let topBorderLine = MSSeparator(style: .shadow, orientation: .horizontal)

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

        heightConstraint = stackView.heightAnchor.constraint(equalToConstant: Constants.portraitHeight)
        NSLayoutConstraint.activate([heightConstraint!,
                                     topBorderLine.bottomAnchor.constraint(equalTo: topAnchor),
                                     topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor)])

        if #available(iOS 13, *) {
            addInteraction(UILargeContentViewerInteraction())
        }

        accessibilityTraits = .tabBar
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

    private func itemView(with item: MSTabBarItem) -> MSTabBarItemView? {
        if let index = items.firstIndex(of: item), let tabBarItemView = stackView.arrangedSubviews[index] as? MSTabBarItemView {
            return tabBarItemView
        }
        return nil
    }

    private func updateHeight() {
        let isPortrait = traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
        heightConstraint?.constant = isPortrait ? Constants.portraitHeight : Constants.landscapeHeight
    }

    @objc private func handleTabBarItemTapped(_ recognizer: UITapGestureRecognizer) {
        if let item = (recognizer.view as? MSTabBarItemView)?.item {
            selectedItem = item
            delegate?.tabBarView?(self, didSelect: item)
        }
    }
}
