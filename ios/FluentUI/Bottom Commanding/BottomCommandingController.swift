//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Persistent commanding surface displayed at the bottom of the available area.
///
/// The presentation style automatically varies depending on the current horizontal `UIUserInterfaceSizeClass`:
///
/// `.unspecified` and `.compact` - the surface is displayed as an expandable bottom sheet.
///
/// `.regular` -  the surface is displayed as a floating bottom bar.
///
/// In both styles, `heroItems` are always presented in a horizontal stack.
/// Items from the `expandedListSections` are either presented in an expanded sheet or a popover, depending on the current style.
///
@objc(MSFBottomCommandingController)
open class BottomCommandingController: UIViewController {

    /// Items to be displayed in an area that's always visible. This is either the top of the the sheet,
    /// or the main bottom bar area, depending on current horizontal UIUserInterfaceSizeClass.
    ///
    /// At most 5 hero items are supported.
    @objc open var heroItems: [CommandingItem] = [] {
        willSet {
            clearAllItemViews(in: .heroSet)
        }
        didSet {
            precondition(heroItems.count <= 5, "At most 5 hero commands are supported.")

            if isHeroCommandStackLoaded {
                heroItems.forEach { heroCommandStack.addArrangedSubview(createAndBindHeroCommandView(with: $0)) }
            }
        }
    }

    /// Sections with items to be displayed in the list area.
    @objc open var expandedListSections: [CommandingSection] = [] {
        willSet {
            clearAllItemViews(in: .list)
        }
        didSet {
            expandedListSections.forEach { section in
                section.items.forEach { $0.delegate = self }
            }
            if isTableViewLoaded {
                // Item views and bindings will be lazily created during UITableView cellForRowAt
                tableView.reloadData()
            }
            updateExpandability()
        }
    }

    // MARK: - View building and layout

    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else {
            setupBottomSheetLayout()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass else {
            return
        }

        // On a horizontal size class change the top level sheet / bar surfaces get recreated,
        // but the item views, containers and bindings persist and are rearranged during the individual setup functions.
        if let bottomSheetController = bottomSheetController {
            bottomSheetController.willMove(toParent: nil)
            bottomSheetController.removeFromParent()
            bottomSheetController.view.removeFromSuperview()
        }
        bottomSheetController = nil
        bottomBarView?.removeFromSuperview()
        bottomBarView = nil

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else {
            setupBottomSheetLayout()
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if presentedViewController != nil {
            dismiss(animated: false)
        }
    }

    private func setupBottomBarLayout() {
        NSLayoutConstraint.activate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .equalSpacing

        let commandContainer = UIStackView()
        commandContainer.translatesAutoresizingMaskIntoConstraints = false
        commandContainer.addArrangedSubview(heroCommandStack)
        commandContainer.addArrangedSubview(moreButtonView)

        let bottomBarView = makeBottomBarByEmbedding(contentView: commandContainer)
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.BottomBar.bottomOffset)
        ])

        self.bottomBarView = bottomBarView
        updateExpandability()
    }

    private func setupBottomSheetLayout() {
        NSLayoutConstraint.deactivate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .fillEqually

        let commandStackContainer = UIView()
        commandStackContainer.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(headerContentView: commandStackContainer, expandedContentView: expandedContentView)
        sheetController.hostedScrollView = tableView
        sheetController.expandedHeightFraction = Constants.BottomSheet.expandedFraction

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        // We need to keep a reference to this because the margin changes based on expandability
        let heroStackTopConstraint = heroCommandStack.topAnchor.constraint(equalTo: commandStackContainer.topAnchor, constant: bottomSheetHeroStackTopMargin)
        bottomSheetHeroStackTopConstraint = heroStackTopConstraint

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            heroCommandStack.leadingAnchor.constraint(equalTo: commandStackContainer.leadingAnchor, constant: Constants.BottomSheet.heroStackLeadingTrailingMargin),
            heroCommandStack.trailingAnchor.constraint(equalTo: commandStackContainer.trailingAnchor, constant: -Constants.BottomSheet.heroStackLeadingTrailingMargin),
            heroCommandStack.bottomAnchor.constraint(equalTo: commandStackContainer.bottomAnchor),
            heroStackTopConstraint
        ])

        bottomSheetController = sheetController
        updateExpandability()
    }

    private func makeBottomBarByEmbedding(contentView: UIView) -> UIView {
        let bottomBarView = UIView()
        let bottomBarLayer = bottomBarView.layer
        bottomBarLayer.shadowColor = Constants.BottomBar.Shadow.color
        bottomBarLayer.shadowOpacity = Constants.BottomBar.Shadow.opacity
        bottomBarLayer.shadowRadius = Constants.BottomBar.Shadow.radius

        let roundedCornerView = UIView()
        roundedCornerView.backgroundColor = Constants.BottomBar.backgroundColor
        roundedCornerView.translatesAutoresizingMaskIntoConstraints = false
        roundedCornerView.layer.cornerRadius = Constants.BottomBar.cornerRadius
        roundedCornerView.layer.cornerCurve = .continuous
        roundedCornerView.clipsToBounds = true

        bottomBarView.addSubview(roundedCornerView)
        roundedCornerView.addSubview(contentView)

        NSLayoutConstraint.activate([
            roundedCornerView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor),
            roundedCornerView.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor),
            roundedCornerView.topAnchor.constraint(equalTo: bottomBarView.topAnchor),
            roundedCornerView.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: Constants.BottomBar.heroStackLeadingTrailingMargin),
            contentView.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -Constants.BottomBar.heroStackLeadingTrailingMargin),
            contentView.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: Constants.BottomBar.heroStackTopBottomMargin),
            contentView.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor, constant: -Constants.BottomBar.heroStackTopBottomMargin)
        ])

        return bottomBarView
    }

    private func makeBottomSheetContent(headerView: UIView, expandedContentView: UIView) -> UIView {
        let view = UIView()
        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        expandedContentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerView)
        view.addSubview(expandedContentView)
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandedContentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            expandedContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandedContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandedContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separator.topAnchor.constraint(equalTo: expandedContentView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return view
    }

    private func updateExpandability() {
        if isInSheetMode,
           let bottomSheetController = bottomSheetController,
           let heroStackTopConstraint = bottomSheetHeroStackTopConstraint {
            bottomSheetController.isExpandable = isExpandable
            bottomSheetController.collapsedContentHeight = bottomSheetHeroStackHeight
            heroStackTopConstraint.constant = bottomSheetHeroStackTopMargin
        } else {
            moreButtonView.isHidden = !isExpandable
        }
    }

    private lazy var moreButtonView: UIView = {
        let moreButtonItem = TabBarItem(title: Constants.BottomBar.moreButtonTitle, image: Constants.BottomBar.moreButtonIcon ?? UIImage())
        let moreButtonView = TabBarItemView(item: moreButtonItem, showsTitle: true)
        moreButtonView.alwaysShowTitleBelowImage = true
        moreButtonView.accessibilityTraits.insert(.button)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoreButtonTap(_:)))
        moreButtonView.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            moreButtonView.widthAnchor.constraint(equalToConstant: Constants.heroButtonWidth),
            moreButtonView.heightAnchor.constraint(equalToConstant: Constants.heroButtonHeight)
        ])

        return moreButtonView
    }()

    private lazy var heroCommandStack: UIStackView = {
        let itemViews = heroItems.map { createAndBindHeroCommandView(with: $0) }
        let stackView = UIStackView(arrangedSubviews: itemViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addInteraction(UILargeContentViewerInteraction())

        isHeroCommandStackLoaded = true
        return stackView
    }()

    private lazy var expandedContentView: UIView = {
        let view = UIView()
        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.BottomSheet.expandedContentTopMargin),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separator.topAnchor.constraint(equalTo: tableView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = Constants.tableViewBackgroundColor
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        isTableViewLoaded = true
        return tableView
    }()

    // MARK: - Command tap handling

    @objc private func handleHeroCommandTap(_ sender: UITapGestureRecognizer) {
        guard let tabBarItemView = sender.view as? TabBarItemView, let binding = viewToBindingMap[tabBarItemView] else {
            return
        }
        let item = binding.item
        if item.isToggleable {
            tabBarItemView.isSelected.toggle()
            item.isOn = tabBarItemView.isSelected
        }
        item.action(binding.item)
    }

    @objc private func handleMoreButtonTap(_ sender: UITapGestureRecognizer) {
        let popoverContentViewController = UIViewController()
        popoverContentViewController.view = tableView
        popoverContentViewController.modalPresentationStyle = .popover
        popoverContentViewController.popoverPresentationController?.sourceView = sender.view

        present(popoverContentViewController, animated: true)
    }

    // MARK: - Item <-> View Binding

    private func addBinding(_ binding: ItemBindingInfo) {
        itemToBindingMap[binding.item] = binding
        viewToBindingMap[binding.view] = binding
    }

    private func removeBinding(_ binding: ItemBindingInfo) {
        itemToBindingMap.removeValue(forKey: binding.item)
        viewToBindingMap.removeValue(forKey: binding.view)
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
            expandedListSections.forEach {
                $0.items.forEach {
                    if let binding = itemToBindingMap[$0] {
                        removeBinding(binding)
                    }
                }
            }
        }
    }

    private func createAndBindHeroCommandView(with item: CommandingItem) -> UIView {
        let tabItem = TabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage, largeContentImage: item.largeImage)
        let itemView = TabBarItemView(item: tabItem, showsTitle: true)
        itemView.alwaysShowTitleBelowImage = true
        itemView.numberOfTitleLines = 1
        itemView.isSelected = item.isOn
        itemView.accessibilityTraits.insert(.button)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
        itemView.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: Constants.heroButtonHeight)
        ])
        let widthConstraint = itemView.widthAnchor.constraint(equalToConstant: Constants.heroButtonWidth)
        widthConstraint.isActive = !isInSheetMode

        item.delegate = self
        let binding = HeroItemBindingInfo(item: item, view: itemView, location: .heroSet, widthConstraint: widthConstraint)
        addBinding(binding)

        return itemView
    }

    private func setupTableViewCell(_ cell: TableViewCell, with item: CommandingItem) {
        let iconView = UIImageView(image: item.image)
        iconView.tintColor = Constants.tableViewIconTintColor

        if item.isToggleable, let booleanCell = cell as? BooleanCell {
            booleanCell.setup(title: item.title, customView: iconView, isOn: item.isOn)
            booleanCell.onValueChanged = {
                item.isOn = booleanCell.isOn
                item.action(item)
            }
        } else {
            cell.setup(title: item.title, customView: iconView)
        }
        cell.isEnabled = item.isEnabled
        cell.backgroundColor = Constants.tableViewBackgroundColor

        let shouldShowSeparator = expandedListSections
            .prefix(expandedListSections.count - 1)
            .contains(where: { $0.items.last == item })
        cell.bottomSeparatorType = shouldShowSeparator ? .full : .none
    }

    // Reloads view in place from the given item object
    private func reloadView(from item: CommandingItem) {
        guard let binding = itemToBindingMap[item] else {
            return
        }
        let staleView = binding.view

        switch binding.location {
        case .heroSet:
            if let stackIndex = heroCommandStack.arrangedSubviews.firstIndex(of: staleView) {
                removeBinding(binding)
                let newView = createAndBindHeroCommandView(with: item)
                staleView.removeFromSuperview()
                heroCommandStack.insertArrangedSubview(newView, at: stackIndex)
            }
        case .list:
            if let cell = binding.view as? TableViewCell {
                setupTableViewCell(cell, with: item)
            }
        }
    }

    private var itemToBindingMap: [CommandingItem: ItemBindingInfo] = [:]

    private var viewToBindingMap: [UIView: ItemBindingInfo] = [:]

    private var bottomBarView: UIView?

    private var bottomSheetController: BottomSheetController?

    private var isHeroCommandStackLoaded: Bool = false

    private var isTableViewLoaded: Bool = false

    private var isInSheetMode: Bool { bottomSheetController != nil }

    private var isExpandable: Bool { expandedListSections.count > 0 }

    private var bottomSheetHeroStackTopConstraint: NSLayoutConstraint?

    private var bottomSheetHeroStackTopMargin: CGFloat {
        isExpandable ? Constants.BottomSheet.heroStackExpandableTopMargin : Constants.BottomSheet.heroStackNonExpandableTopMargin
    }

    private var bottomSheetHeroStackHeight: CGFloat { Constants.heroButtonHeight + bottomSheetHeroStackTopMargin }

    private var heroCommandWidthConstraints: [NSLayoutConstraint] {
        heroItems.compactMap { (itemToBindingMap[$0] as? HeroItemBindingInfo)?.widthConstraint }
    }

    private enum ItemLocation {
        case heroSet
        case list
    }

    private class ItemBindingInfo {
        let item: CommandingItem
        let view: UIView
        let location: ItemLocation

        init(item: CommandingItem, view: UIView, location: ItemLocation) {
            self.item = item
            self.view = view
            self.location = location
        }
    }

    private class HeroItemBindingInfo: ItemBindingInfo {
        let widthConstraint: NSLayoutConstraint

        init(item: CommandingItem, view: UIView, location: ItemLocation, widthConstraint: NSLayoutConstraint) {
            self.widthConstraint = widthConstraint
            super.init(item: item, view: view, location: location)
        }
    }

    private struct Constants {
        static let heroButtonHeight: CGFloat = 48
        static let heroButtonWidth: CGFloat = 96

        static let tableViewIconTintColor: UIColor = Colors.textSecondary
        static let tableViewBackgroundColor: UIColor = Colors.NavigationBar.background

        struct BottomBar {
            static let cornerRadius: CGFloat = 14
            static let backgroundColor: UIColor = Colors.NavigationBar.background

            static let bottomOffset: CGFloat = 10
            static let heroStackLeadingTrailingMargin: CGFloat = 8
            static let heroStackTopBottomMargin: CGFloat = 16

            static let moreButtonIcon: UIImage? = UIImage.staticImageNamed("more-24x24")
            static let moreButtonTitle: String = "CommandingBottomBar.More".localized

            struct Shadow {
                static let color: CGColor = UIColor.black.cgColor
                static let opacity: Float = 0.14
                static let radius: CGFloat = 8
            }
        }

        struct BottomSheet {
            static let expandedFraction: CGFloat = 0.7 // Probably should be more customizable / based on content
            static let heroStackExpandableTopMargin: CGFloat = 0
            static let heroStackNonExpandableTopMargin: CGFloat = 16
            static let heroStackLeadingTrailingMargin: CGFloat = 8

            static let expandedContentTopMargin: CGFloat = 16
        }
    }
}

extension BottomCommandingController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return expandedListSections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(section < expandedListSections.count)

        return expandedListSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = expandedListSections[indexPath.section]
        let item = section.items[indexPath.row]
        var cell: TableViewCell?

        if item.isToggleable {
            if let booleanCell = tableView.dequeueReusableCell(withIdentifier: BooleanCell.identifier) as? BooleanCell {
                setupTableViewCell(booleanCell, with: item)
                cell = booleanCell
            }
        } else {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell {
                setupTableViewCell(tableViewCell, with: item)
                cell = tableViewCell
            }
        }

        if let cell = cell {
            // Cells get reused and we sometimes modify them directly,
            // so it's important to remove old bindings to avoid side effects
            if let oldBinding = viewToBindingMap[cell] {
                removeBinding(oldBinding)
            }
            addBinding(ItemBindingInfo(item: item, view: cell, location: .list))
        }

        return cell ?? UITableViewCell()
    }
}

extension BottomCommandingController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView else {
            return nil
        }
        let section = expandedListSections[section]

        var configuredHeader: UIView?
        if let sectionTitle = section.title {
            header.setup(style: .header, title: sectionTitle)
            configuredHeader = header
        }

        return configuredHeader
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let binding = viewToBindingMap[cell] else {
            return
        }

        if !binding.item.isToggleable {
            if presentedViewController != nil {
                dismiss(animated: true)
            }
            binding.item.action(binding.item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BottomCommandingController: CommandingItemDelegate {
    func commandingItem(_ item: CommandingItem, didChangeTitleTo value: String) {
        reloadView(from: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeImageTo value: UIImage) {
        reloadView(from: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeSelectedImageTo value: UIImage?) {
        reloadView(from: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeLargeImageTo value: UIImage?) {
        reloadView(from: item)
    }

    func commandingItem(_ item: CommandingItem, didChangeEnabledTo value: Bool) {
        guard let view = itemToBindingMap[item]?.view else {
            return
        }

        switch view {
        case let tabBarItemView as TabBarItemView:
            if tabBarItemView.isEnabled != value {
                tabBarItemView.isEnabled = value
            }
        case let cell as TableViewCell:
            if cell.isEnabled != value {
                cell.isEnabled = value
            }
        default:
            break
        }
    }

    func commandingItem(_ item: CommandingItem, didChangeOnTo value: Bool) {
        guard let view = itemToBindingMap[item]?.view else {
            return
        }

        switch view {
        case let tabBarItemView as TabBarItemView:
            if tabBarItemView.isSelected != value {
                tabBarItemView.isSelected = value
            }
        case let booleanCell as BooleanCell:
            if booleanCell.isOn != value {
                booleanCell.isOn = value
            }
        default:
            break
        }
    }
}
