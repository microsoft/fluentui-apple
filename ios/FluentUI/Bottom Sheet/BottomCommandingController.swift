//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class BottomCommandingController: UIViewController {

    public var heroItems: [CommandingItem] = [] {
        willSet {
            clearAllItemViews(in: .heroSet)
        }
        didSet {
            if heroItems.count > 5 {
                assertionFailure("At most 5 hero commands are supported. Only the first 5 items will be used.")
                heroItems = Array(heroItems.prefix(5))
            }

            if isHeroCommandStackLoaded {
                let newViews = heroItems.map { createAndBindHeroCommandView(with: $0) }
                newViews.forEach { heroCommandStack.addArrangedSubview($0) }
            }

        }
    }

    public var listCommandSections: [CommandingSection] = [] {
        willSet {
            clearAllItemViews(in: .list)
        }
        didSet {
            if isTableViewLoaded {
                // Item views are lazy loaded during UITableView cellForRowAt
                tableView.reloadData()
            }
        }
    }

    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else if traitCollection.horizontalSizeClass == .compact {
            setupBottomSheetLayout()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            if let previousTraits = previousTraitCollection {
                if previousTraits.horizontalSizeClass == .compact {
                    bottomSheetController?.willMove(toParent: nil)
                    bottomSheetController?.removeFromParent()
                    bottomSheetController?.view.removeFromSuperview()
                    bottomSheetController = nil
                } else if previousTraits.horizontalSizeClass == .regular {
                    bottomBarView?.removeFromSuperview()
                    bottomBarView = nil
                }
            }

            switch traitCollection.horizontalSizeClass {
            case .compact:
                setupBottomSheetLayout()
            case .regular:
                setupBottomBarLayout()
            default:
                break
            }
        }
    }

    private func setupBottomBarLayout() {
        let heroCommandWidthConstraints = heroItems.compactMap { itemToBindingMap[$0]?.heroCommandWidthConstraint }
        NSLayoutConstraint.activate(heroCommandWidthConstraints)

        let bottomBarView = BottomBarView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)

        let commandContainer = UIStackView()
        commandContainer.axis = .horizontal
        commandContainer.translatesAutoresizingMaskIntoConstraints = false
        commandContainer.addArrangedSubview(heroCommandStack)

        let moreButtonItem = TabBarItem(title: "More", image: UIImage.staticImageNamed("more-24x24")!)
        let moreButtonView = TabBarItemView(item: moreButtonItem, showsTitle: true)
        moreButtonView.alwaysShowTitleBelowImage = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoreButtonTap(_:)))
        moreButtonView.addGestureRecognizer(tapGesture)

        commandContainer.addArrangedSubview(moreButtonView)

        bottomBarView.contentView.addSubview(commandContainer)
        self.bottomBarView = bottomBarView

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31),
            commandContainer.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 8),
            commandContainer.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -8),
            commandContainer.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 16),
            commandContainer.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor, constant: -16),
            moreButtonView.widthAnchor.constraint(equalToConstant: 96),
            moreButtonView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupBottomSheetLayout() {
        let heroCommandWidthConstraints = heroItems.compactMap { itemToBindingMap[$0]?.heroCommandWidthConstraint }
        NSLayoutConstraint.deactivate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .fillEqually

        let commandStackContainer = UIView()
        commandStackContainer.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(contentView: BottomSheetSplitContentView(headerView: commandStackContainer, contentView: tableView))
        sheetController.hostedScrollView = tableView

        NSLayoutConstraint.activate([
            heroCommandStack.leadingAnchor.constraint(equalTo: commandStackContainer.leadingAnchor, constant: 8),
            heroCommandStack.trailingAnchor.constraint(equalTo: commandStackContainer.trailingAnchor, constant: -8),
            heroCommandStack.topAnchor.constraint(equalTo: commandStackContainer.topAnchor),
            heroCommandStack.bottomAnchor.constraint(equalTo: commandStackContainer.bottomAnchor, constant: -16)
        ])

        sheetController.collapsedContentHeight = commandStackContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor)

        ])

        bottomSheetController = sheetController
    }

    private lazy var heroCommandStack: UIStackView = {
        let itemViews = heroItems.map { createAndBindHeroCommandView(with: $0) }
        let stackView = UIStackView(arrangedSubviews: itemViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        isHeroCommandStackLoaded = true
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = Colors.Table.background
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        isTableViewLoaded = true
        return tableView
    }()

    private var isHeroCommandStackLoaded: Bool = false

    private var isTableViewLoaded: Bool = false

    @objc private func handleHeroCommandTap(_ sender: UITapGestureRecognizer) {
        guard let tabBarItemView = sender.view as? TabBarItemView else {
            return
        }

        tabBarItemView.isSelected.toggle()
    }

    @objc private func handleMoreButtonTap(_ sender: UITapGestureRecognizer) {
        let popoverContentVC = UIViewController()
        popoverContentVC.view.addSubview(tableView)
        popoverContentVC.modalPresentationStyle = .popover
        popoverContentVC.popoverPresentationController?.sourceView = sender.view

        NSLayoutConstraint.activate([
            popoverContentVC.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            popoverContentVC.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            popoverContentVC.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            popoverContentVC.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])

        present(popoverContentVC, animated: true)
    }

    private func clearAllItemViews(in location: ItemLocation) {
        switch location {
        case .heroSet:
            heroItems.forEach {
                if let binding = itemToBindingMap[$0] {
                    removeBinding(binding)
                }
            }
            heroCommandStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        case .list:
            listCommandSections.forEach {
                $0.items.forEach {
                    if let binding = itemToBindingMap[$0] {
                        removeBinding(binding)
                    }
                }
            }
        }
    }

    private func removeBinding(_ binding: ItemBinding) {
        itemToBindingMap.removeValue(forKey: binding.item)
        viewToBindingMap.removeValue(forKey: binding.view)
    }

    private func addBinding(_ binding: ItemBinding) {
        itemToBindingMap[binding.item] = binding
        viewToBindingMap[binding.view] = binding
    }

    private func createAndBindHeroCommandView(with item: CommandingItem) -> UIView {
        let tabItem = TabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
        let itemView = TabBarItemView(item: tabItem, showsTitle: true)
        itemView.alwaysShowTitleBelowImage = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
        itemView.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: 48)
        ])
        let widthConstraint = itemView.widthAnchor.constraint(equalToConstant: 96)

        item.delegate = self
        let binding = ItemBinding(item: item, view: itemView, location: .heroSet, heroCommandWidthConstraint: widthConstraint)
        addBinding(binding)

        return itemView
    }

    private func reloadView(for item: CommandingItem) {
        guard let binding = itemToBindingMap[item] else {
            return
        }
        let staleView = binding.view

        switch binding.location {
        case .heroSet:
            if let stackIndex = heroCommandStack.arrangedSubviews.firstIndex(of: staleView) {
                // TODO: remove width constraint

                let newView = createAndBindHeroCommandView(with: item)
                staleView.removeFromSuperview()
                heroCommandStack.insertArrangedSubview(newView, at: stackIndex)
            }
        case .list:
            break // TODO implement
        }
    }

    private var itemToBindingMap: [CommandingItem: ItemBinding] = [:]

    private var viewToBindingMap: [UIView: ItemBinding] = [:]

    private var bottomBarView: BottomBarView?

    private var bottomSheetController: BottomSheetController?

    private enum ItemLocation {
        case heroSet
        case list
    }

    private struct ItemBinding {
        let item: CommandingItem
        let view: UIView
        let location: ItemLocation
        let heroCommandWidthConstraint: NSLayoutConstraint?
    }
}

extension BottomCommandingController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return listCommandSections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section < listCommandSections.count)

        return listCommandSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        let section = listCommandSections[indexPath.section]
        let item = section.items[indexPath.row]
        let iconView = UIImageView(image: item.image)
        iconView.tintColor = Colors.textSecondary
        cell.setup(title: item.title, subtitle: "", footer: "", customView: iconView, customAccessoryView: nil, accessoryType: .none)
        cell.bottomSeparatorType = .none
        cell.isEnabled = item.isEnabled

        let binding = ItemBinding(item: item, view: cell, location: .list, heroCommandWidthConstraint: nil)
        addBinding(binding)
        return cell
    }
}

extension BottomCommandingController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView else {
            return nil
        }
        let section = listCommandSections[section]

        if let sectionTitle = section.title {
            header.setup(style: .header, title: sectionTitle)
        } else {
            return nil
        }

        return header
    }
}

extension BottomCommandingController: CommandingItemDelegate {
    func commandingItem(_ item: CommandingItem, didChangeTitleFrom oldValue: String) {
        reloadView(for: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeImageFrom oldValue: UIImage) {
        reloadView(for: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeSelectedImageFrom oldValue: UIImage?) {
        reloadView(for: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeCommandTypeFrom oldValue: CommandingItem.CommandType) {
        reloadView(for: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeEnabledFrom oldValue: Bool) {
        if oldValue != item.isEnabled {
            guard let view = itemToBindingMap[item]?.view else {
                return
            }
            let newValue = item.isEnabled

            switch view {
            case let tabBarItemView as TabBarItemView:
                if tabBarItemView.isEnabled != newValue {
                    tabBarItemView.isEnabled = newValue
                }
            case let cell as TableViewCell:
                if cell.isEnabled != newValue {
                    cell.isEnabled = item.isEnabled
                }
            default:
                break
            }
        }
    }

    func commandingItem(_ item: CommandingItem, didChangeOnFrom oldValue: Bool) {
        if oldValue != item.isOn {
            guard let view = itemToBindingMap[item]?.view else {
                return
            }
            let newValue = item.isOn

            switch view {
            case let tabBarItemView as TabBarItemView:
                if tabBarItemView.isSelected != newValue {
                    tabBarItemView.isSelected = newValue
                }
            case let booleanCell as BooleanCell:
                if booleanCell.isOn != newValue {
                    booleanCell.isOn = newValue
                }
            default:
                break
            }
        }
    }
}

private class BottomSheetSplitContentView: UIView {
    public init(headerView: UIView, contentView: UIView) {
        self.headerView = headerView
        self.contentView = contentView

        super.init(frame: .zero)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        addSubview(contentView)
        addSubview(separator)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private let headerView: UIView
    private let contentView: UIView
}
