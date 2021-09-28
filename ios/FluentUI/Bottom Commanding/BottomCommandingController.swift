//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFBottomCommandingControllerDelegate)
public protocol BottomCommandingControllerDelegate: AnyObject {

    /// Called when `collapsedHeightInSafeArea` changes.
    @objc optional func bottomCommandingControllerCollapsedHeightInSafeAreaDidChange(_ bottomCommandingController: BottomCommandingController)

    /// Called after the bottom sheet expansion state changes.
    ///
    /// External changes to `isHidden` will not trigger this callback.
    /// - Parameters:
    ///   - bottomCommandingController: The caller object.
    ///   - expansionState: The expansion state the sheet moved to.
    ///   - commandingInteraction: If the state change was caused by user interaction, it will be indicated using this enum.
    ///   - sheetInteraction: If `commandingInteraction` is `.sheetInteraction`, this enum will contain more information about what triggered the state change.
    @objc optional func bottomCommandingController(_ bottomCommandingController: BottomCommandingController,
                                                   sheetDidMoveTo expansionState: BottomSheetExpansionState,
                                                   commandingInteraction: BottomCommandingInteraction,
                                                   sheetInteraction: BottomSheetInteraction)

    /// Called after the bottom bar popover is presented.
    /// - Parameters:
    ///   - bottomCommandingController: The caller object.
    ///   - commandingInteraction: The user interaction that caused the popover to show.
    @objc optional func bottomCommandingController(_ bottomCommandingController: BottomCommandingController,
                                                   didPresentPopoverWith commandingInteraction: BottomCommandingInteraction)

    /// Called after the bottom bar popover is dismissed.
    /// - Parameters:
    ///   - bottomCommandingController: The caller object.
    ///   - commandingInteraction: The user interaction that caused the popover to dismiss.
    @objc optional func bottomCommandingController(_ bottomCommandingController: BottomCommandingController,
                                                   didDismissPopoverWith commandingInteraction: BottomCommandingInteraction)
}

/// Interactions that can trigger a state change.
@objc public enum BottomCommandingInteraction: Int {
    case noUserAction // No user action, used for events not triggered by users
    case otherUserAction // Any other user action not listed below
    case sheetInteraction // General sheet interaction
    case moreButtonTap // Tap on the more hero command
    case commandTap // Tap on any command
}

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

    /// View controller that will be displayed below the bottom commanding UI.
    @objc public var contentViewController: UIViewController? {
        didSet {
            guard isViewLoaded, oldValue != contentViewController else {
                return
            }

            if let oldViewController = oldValue {
                oldViewController.willMove(toParent: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
            }

            if let newContentViewController = contentViewController {
                addChildContentViewController(newContentViewController)
            }
        }
    }

    /// Items to be displayed in an area that's always visible. This is either the top of the the sheet,
    /// or the main bottom bar area, depending on current horizontal UIUserInterfaceSizeClass.
    ///
    /// At most 5 hero items are supported.
    @objc open var heroItems: [CommandingItem] = [] {
        willSet {
            heroItems.forEach { removeBinding(for: $0) }
        }
        didSet {
            precondition(heroItems.count <= 5, "At most 5 hero commands are supported.")

            if isViewLoaded {
                reloadHeroCommandStack()
                updateSheetHeaderSizingParameters()
            }
        }
    }

    /// Sections with items to be displayed in the list area.
    @objc open var expandedListSections: [CommandingSection] = [] {
        willSet {
            expandedListSections.forEach { section in
                section.items.forEach { item in removeBinding(for: item) }
            }
        }
        didSet {
            expandedListSections.forEach { section in
                section.items.forEach { $0.delegate = self }
            }
            if isTableViewLoaded {
                // Item views and bindings will be lazily created during UITableView cellForRowAt
                tableView.reloadData()
            }
            if isViewLoaded {
                reloadHeroCommandStack()
                updateSheetHeaderSizingParameters()
                updateSheetPreferredExpandedContentHeight()
            }
        }
    }

    /// Indicates if the bottom commanding UI is hidden
    ///
    /// Changes to this property are animated.
    @objc open var isHidden: Bool {
        get {
            return bottomSheetController?.isHidden ?? _isHidden
        }
        set {
            setIsHidden(newValue)
        }
    }

    /// When in sheet layout, `BottomSheetController` holds it's own `isHidden` state which is the main
    /// source of truth and the public getter will return that instead of this backing variable.
    private var _isHidden: Bool = false

    /// Indicates whether a more button is visible in the sheet style when `expandedListSections` is non-empty.
    /// Tapping the button will expand or collapse the sheet.
    @objc open var prefersSheetMoreButtonVisible: Bool = true {
        didSet {
            reloadHeroCommandStack()
        }
    }

    /// A layout guide that covers the on-screen portion of the current commanding view.
    @objc public let commandingLayoutGuide = UILayoutGuide()

    /// Height of the portion of the collapsed commanding UI that's in the safe area.
    /// When using the bottom bar style, this will include the entire height of the bottom bar.
    ///
    /// Valid after the root view is loaded.
    ///
    /// Use this to adjust `contentInsets` on your scroll views. This height won't change when the commanding UI is hidden or expanded.
    @objc public var collapsedHeightInSafeArea: CGFloat {
        var height: CGFloat
        if isInSheetMode, let bottomSheetController = bottomSheetController {
            height = bottomSheetController.collapsedHeightInSafeArea
        } else {
            height = Constants.BottomBar.height + Constants.BottomBar.bottomOffset
        }
        return height
    }

    /// The object that acts as the delegate of this controller.
    @objc open weak var delegate: BottomCommandingControllerDelegate?

    /// Sets the `isHidden` property with a completion handler.
    /// - Parameters:
    ///   - isHidden: The new value.
    ///   - animated: Indicates if the change should be animated. The default value is `true`.
    ///   - completion: Closure to be called when the state change completes.
    @objc public func setIsHidden(_ isHidden: Bool, animated: Bool = true, completion: ((_ isFinished: Bool) -> Void)? = nil) {
        if isInSheetMode {
            bottomSheetController?.setIsHidden(isHidden, animated: animated, completion: completion)
        } else {
            if isViewLoaded {
                completeBottomBarAnimationsIfNeeded()

                if let animator = bottomBarHidingAnimator(to: isHidden) {
                    animator.addCompletion { finalPosition in
                        completion?(finalPosition == .end)
                    }

                    if animated {
                        bottomBarHidingAnimator = animator
                        animator.addCompletion { [weak self] _ in
                            self?.bottomBarHidingAnimator = nil
                        }
                        animator.startAnimation()
                    } else {
                        animator.stopAnimation(false)
                        animator.finishAnimation(at: .end)
                    }
                }
            } else {
                _isHidden = isHidden
                completion?(true)
            }
        }
    }

    /// Initiates an interactive `isHidden` state change driven by the returned `UIViewPropertyAnimator`.
    ///
    /// For usage details, see `BottomSheetController.prepareInteractiveIsHiddenChange`.
    /// - Parameters:
    ///   - isHidden: The target state.
    ///   - completion: Closure to be called when the state change completes.
    /// - Returns: A `UIViewPropertyAnimator`. The associated animations start in a paused state.
    @objc public func prepareInteractiveIsHiddenChange(_ isHidden: Bool, completion: ((_ finalPosition: UIViewAnimatingPosition) -> Void)? = nil) -> UIViewPropertyAnimator? {
        guard isViewLoaded else {
            return nil
        }

        var animator: UIViewPropertyAnimator?

        if isInSheetMode {
            animator = bottomSheetController?.prepareInteractiveIsHiddenChange(isHidden, completion: completion)
        } else {
            completeBottomBarAnimationsIfNeeded(skipToEnd: true)
            if isHidden != self.isHidden, let hidingAnimator = bottomBarHidingAnimator(to: isHidden) {
                bottomBarHidingAnimator = hidingAnimator
                hidingAnimator.addCompletion { [weak self] finalPosition in
                    self?.bottomBarHidingAnimator = nil
                    completion?(finalPosition)
                }
                animator = hidingAnimator
            }
        }

        return animator
    }

    /// Initializes the bottom commanding controller with a given content view controller.
    /// - Parameter contentViewController: View controller that will be displayed below the bottom commanding UI.
    @objc public init(with contentViewController: UIViewController?) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Current rectangle of the view that represents the given hero item.
    ///
    /// - Parameter heroItem: A `CommandingItem` contained in `heroItems`.
    /// - Returns: The current rectangle in the coordinate system of the receiver.
    @objc public func rectFor(heroItem: CommandingItem) -> CGRect {
        guard isViewLoaded,
              let bindingInfo = itemToBindingMap[heroItem],
              bindingInfo.location == .heroSet else {
            return .null
        }
        let itemView = bindingInfo.view
        return itemView.convert(itemView.bounds, to: view)
    }

    // MARK: - View building and layout

    public override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addLayoutGuide(commandingLayoutGuide)

        setupCommandingLayout()

        if let contentViewController = contentViewController {
            addChildContentViewController(contentViewController)
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
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

            setupCommandingLayout()
        }

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            updateSheetPreferredExpandedContentHeight()
        }
    }

    public override func viewSafeAreaInsetsDidChange() {
        updateSheetHeaderSizingParameters()
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if presentedViewController != nil {
            dismiss(animated: false) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.bottomCommandingController?(strongSelf, didDismissPopoverWith: .noUserAction)
            }
        }
    }

    private func setupCommandingLayout() {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.userInterfaceIdiom == .pad {
            setupBottomBarLayout()
        } else {
            setupBottomSheetLayout()
        }
    }

    private func setupBottomBarLayout() {
        NSLayoutConstraint.deactivate(layoutGuideConstraints)
        NSLayoutConstraint.activate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .equalSpacing

        let bottomBarView = makeBottomBarByEmbedding(contentView: heroCommandStack)
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.isHidden = isHidden
        view.addSubview(bottomBarView)

        let bottomConstraint = bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: isHidden ? -Constants.BottomBar.hiddenBottomOffset : -Constants.BottomBar.bottomOffset)

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomConstraint
        ])

        layoutGuideConstraints = makeBottomBarLayoutGuideConstraints(with: bottomBarView)
        NSLayoutConstraint.activate(layoutGuideConstraints)

        bottomBarViewBottomConstraint = bottomConstraint
        self.bottomBarView = bottomBarView
        reloadHeroCommandStack()

        delegate?.bottomCommandingControllerCollapsedHeightInSafeAreaDidChange?(self)
    }

    private func setupBottomSheetLayout() {
        NSLayoutConstraint.deactivate(layoutGuideConstraints)
        NSLayoutConstraint.deactivate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .fillEqually

        let headerView = UIView()
        headerView.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(headerContentView: headerView, expandedContentView: makeSheetExpandedContent(with: tableView))
        sheetController.hostedScrollView = tableView
        sheetController.isHidden = isHidden
        sheetController.delegate = self

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        // We need to keep a reference to this because the margin changes based on expandability
        let heroStackTopConstraint = heroCommandStack.topAnchor.constraint(equalTo: headerView.topAnchor)
        bottomSheetHeroStackTopConstraint = heroStackTopConstraint

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            heroCommandStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.BottomSheet.headerLeadingTrailingMargin),
            heroCommandStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.BottomSheet.headerLeadingTrailingMargin),
            headerView.heightAnchor.constraint(equalToConstant: Constants.BottomSheet.headerHeight),
            heroStackTopConstraint
        ])

        layoutGuideConstraints = [
            commandingLayoutGuide.leadingAnchor.constraint(equalTo: sheetController.sheetLayoutGuide.leadingAnchor),
            commandingLayoutGuide.topAnchor.constraint(equalTo: sheetController.sheetLayoutGuide.topAnchor),
            commandingLayoutGuide.trailingAnchor.constraint(equalTo: sheetController.sheetLayoutGuide.trailingAnchor),
            commandingLayoutGuide.bottomAnchor.constraint(equalTo: sheetController.sheetLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(layoutGuideConstraints)

        bottomSheetController = sheetController

        reloadHeroCommandStack()
        updateSheetHeaderSizingParameters()
        updateSheetPreferredExpandedContentHeight()
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
            bottomBarView.heightAnchor.constraint(equalToConstant: Constants.BottomBar.height),
            roundedCornerView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor),
            roundedCornerView.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor),
            roundedCornerView.topAnchor.constraint(equalTo: bottomBarView.topAnchor),
            roundedCornerView.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: Constants.BottomBar.heroStackLeadingTrailingMargin),
            contentView.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -Constants.BottomBar.heroStackLeadingTrailingMargin),
            contentView.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: Constants.BottomBar.heroStackTopMargin)
        ])

        return bottomBarView
    }

    private func makeSheetExpandedContent(with tableView: UITableView) -> UIView {
        let view = UIView()
        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(separator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separator.topAnchor.constraint(equalTo: tableView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }

    private func addChildContentViewController(_ contentViewController: UIViewController) {
        guard let rootCommandingView = rootCommandingView else {
            return
        }

        addChild(contentViewController)
        let newContentView: UIView = contentViewController.view
        view.insertSubview(newContentView, belowSubview: rootCommandingView)
        contentViewController.didMove(toParent: self)

        newContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newContentView.topAnchor.constraint(equalTo: view.topAnchor),
            newContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func reloadHeroCommandStack() {
        let heroViews = extendedHeroItems.map { createAndBindHeroCommandView(with: $0) }
        heroCommandStack.removeAllSubviews()
        heroViews.forEach {heroCommandStack.addArrangedSubview($0) }
    }

    private lazy var moreHeroItem: CommandingItem = CommandingItem(title: Constants.BottomBar.moreButtonTitle, image: Constants.BottomBar.moreButtonIcon ?? UIImage(), action: handleMoreCommandTap)

    private lazy var heroCommandStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addInteraction(UILargeContentViewerInteraction())
        stackView.alignment = .top
        return stackView
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
        } else if item != moreHeroItem { // The more button handles sheet expanding in its own action closure.
            setSheetIsExpanded(to: false, commandingInteraction: .commandTap)
        }
        item.action?(binding.item)
    }

    @objc private func handleMoreCommandTap(_ sender: CommandingItem) {
        if let sheetController = bottomSheetController {
            setSheetIsExpanded(to: !sheetController.isExpanded, commandingInteraction: .moreButtonTap)
        } else if let binding = itemToBindingMap[sender] {
            let moreButtonView = binding.view
            let popoverContentViewController = UIViewController()
            popoverContentViewController.view.addSubview(tableView)
            popoverContentViewController.modalPresentationStyle = .popover
            popoverContentViewController.popoverPresentationController?.sourceView = moreButtonView
            popoverContentViewController.popoverPresentationController?.delegate = self
            popoverContentViewController.preferredContentSize.height = estimatedTableViewHeight

            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: popoverContentViewController.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: popoverContentViewController.view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: popoverContentViewController.view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: popoverContentViewController.view.bottomAnchor)
            ])
            present(popoverContentViewController, animated: true) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.bottomCommandingController?(strongSelf, didPresentPopoverWith: .moreButtonTap)
            }
        }
    }

    private func setSheetIsExpanded(to isExpanded: Bool, commandingInteraction: BottomCommandingInteraction) {
        let targetState: BottomSheetExpansionState = isExpanded ? .expanded : .collapsed
        bottomSheetController?.setIsExpanded(isExpanded) { [weak self] isFinished in
            guard let strongSelf = self else {
                return
            }
            if isFinished {
                strongSelf.delegate?.bottomCommandingController?(strongSelf, sheetDidMoveTo: targetState, commandingInteraction: commandingInteraction, sheetInteraction: .noUserAction)
            }
        }
    }

    // MARK: - Item <-> View Binding

    private func addBinding(_ binding: ItemBindingInfo) {
        let item = binding.item
        if itemToBindingMap[item] != nil {
            removeBinding(for: item)
        }
        itemToBindingMap[item] = binding
        viewToBindingMap[binding.view] = binding
    }

    private func removeBinding(_ binding: ItemBindingInfo) {
        itemToBindingMap.removeValue(forKey: binding.item)
        viewToBindingMap.removeValue(forKey: binding.view)
    }

    private func removeBinding(for item: CommandingItem) {
        if let binding = itemToBindingMap[item] {
            removeBinding(binding)
        }
    }

    private func createAndBindHeroCommandView(with item: CommandingItem) -> UIView {
        let itemImage = item.image ?? UIImage()
        let itemTitle = item.title ?? ""
        let tabItem = TabBarItem(title: itemTitle, image: itemImage, selectedImage: item.selectedImage, largeContentImage: item.largeImage)
        let itemView = TabBarItemView(item: tabItem, showsTitle: itemTitle != "")

        itemView.alwaysShowTitleBelowImage = true
        itemView.numberOfTitleLines = Constants.heroButtonMaxTitleLines
        itemView.isSelected = item.isOn
        itemView.isEnabled = item.isEnabled
        itemView.accessibilityTraits.insert(.button)
        itemView.preferredLabelMaxLayoutWidth = Constants.heroButtonLabelMaxWidth
        itemView.setContentCompressionResistancePriority(.required, for: .vertical)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
        itemView.addGestureRecognizer(tapGesture)

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
            booleanCell.setup(title: item.title ?? "", customView: iconView, isOn: item.isOn)
            booleanCell.onValueChanged = {
                item.isOn = booleanCell.isOn
                item.action?(item)
            }
        } else {
            cell.setup(title: item.title ?? "", customView: iconView)
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

    /// Recalculates header top margin constraint and updates the `collapsedContentHeight` and `isExpandable` properties of the sheet controller.
    private func updateSheetHeaderSizingParameters() {
        guard let bottomSheetController = bottomSheetController else {
            return
        }
        bottomSheetController.isExpandable = isExpandable

        let maxHeroItemHeight = heroCommandStack.arrangedSubviews.map { $0.intrinsicContentSize.height }.max() ?? Constants.defaultHeroButtonHeight
        let headerHeightWithoutBottomWhitespace = Constants.BottomSheet.headerTopMargin + maxHeroItemHeight

        // How much more whitespace is required at the bottom of the sheet header
        let requiredBottomWhitespace = max(0, Constants.BottomSheet.headerHeight - headerHeightWithoutBottomWhitespace)

        // The safe area inset can fulfill some or all of our bottom whitespace requirement.
        // This is how much more we need, taking the inset into account.
        let reducedBottomWhitespace = max(0, requiredBottomWhitespace - view.safeAreaInsets.bottom)

        // We need additional top margin to account for missing resizing handle when isExpandable is false
        let addedHeaderTopMargin = !isExpandable
            ? BottomSheetController.resizingHandleHeight
            : 0
        bottomSheetHeroStackTopConstraint?.constant = Constants.BottomSheet.headerTopMargin + addedHeaderTopMargin

        let oldCollapsedContentHeight = bottomSheetController.collapsedContentHeight
        let newCollapsedContentHeight = headerHeightWithoutBottomWhitespace + reducedBottomWhitespace + addedHeaderTopMargin

        if newCollapsedContentHeight != oldCollapsedContentHeight {
            bottomSheetController.collapsedContentHeight = newCollapsedContentHeight
        }
    }

    private func updateSheetPreferredExpandedContentHeight() {
        bottomSheetController?.preferredExpandedContentHeight = estimatedTableViewHeight
    }

    private func makeBottomBarLayoutGuideConstraints(with bottomBarView: UIView) -> [NSLayoutConstraint] {
        let requiredConstraints = [
            commandingLayoutGuide.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor),
            commandingLayoutGuide.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor),
            commandingLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            commandingLayoutGuide.topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ]

        // bottomBarView will go off-screen when it's hidden, so this constraint is not always required.
        let breakableTopConstraint = commandingLayoutGuide.topAnchor.constraint(equalTo: bottomBarView.topAnchor)
        breakableTopConstraint.priority = .defaultHigh

        return requiredConstraints + [breakableTopConstraint]
    }

    // MARK: - Bottom bar animation

    private func bottomBarHidingAnimator(to isHidden: Bool) -> UIViewPropertyAnimator? {
        guard let bottomBarView = bottomBarView, let bottomConstraint = bottomBarViewBottomConstraint else {
            return nil
        }

        let springParams = UISpringTimingParameters(dampingRatio: Constants.BottomBar.hidingSpringDamping)
        let animator = UIViewPropertyAnimator(duration: Constants.BottomBar.hidingSpringDuration, timingParameters: springParams)

        let initialBottomConstant = bottomConstraint.constant
        let initialHiddenState = bottomBarView.isHidden

        bottomConstraint.constant = isHidden ? -Constants.BottomBar.hiddenBottomOffset : -Constants.BottomBar.bottomOffset
        bottomBarView.isHidden = false
        _isHidden = false

        animator.addAnimations { [weak self] in
            self?.view.layoutIfNeeded()
        }

        animator.addCompletion { [weak self] finalPosition in
            guard let strongSelf = self else {
                return
            }

            if finalPosition == .end {
                bottomBarView.isHidden = isHidden
                strongSelf._isHidden = isHidden
            } else if finalPosition == .start {
                bottomBarView.isHidden = initialHiddenState
                strongSelf._isHidden = initialHiddenState
                bottomConstraint.constant = initialBottomConstant
            }
        }

        animator.pauseAnimation()
        return animator
    }

    private func completeBottomBarAnimationsIfNeeded(skipToEnd: Bool = false) {
        if let currentAnimator = bottomBarHidingAnimator {
            let endPosition: UIViewAnimatingPosition = currentAnimator.isReversed ? .start : .end
            currentAnimator.stopAnimation(false)
            currentAnimator.finishAnimation(at: skipToEnd ? endPosition : .current)
            bottomBarHidingAnimator = nil
        }
    }

    // Estimated fitting height of `tableView`.
    private var estimatedTableViewHeight: CGFloat {
        var totalHeight: CGFloat = 0
        for section in expandedListSections {
            totalHeight += TableViewHeaderFooterView.height(style: .header, title: section.title ?? "")
            for item in section.items {
                totalHeight += TableViewCell.height(title: item.title ?? "")
            }
        }
        return totalHeight
    }

    private var itemToBindingMap: [CommandingItem: ItemBindingInfo] = [:]

    private var viewToBindingMap: [UIView: ItemBindingInfo] = [:]

    private var bottomBarView: UIView?

    private var bottomBarViewBottomConstraint: NSLayoutConstraint?

    private var bottomSheetController: BottomSheetController?

    private var rootCommandingView: UIView? {
        isInSheetMode ? bottomSheetController?.view : bottomBarView
    }

    private var isTableViewLoaded: Bool = false

    private var isInSheetMode: Bool { bottomSheetController != nil }

    private var isExpandable: Bool { expandedListSections.count > 0 }

    private var bottomSheetHeroStackTopConstraint: NSLayoutConstraint?

    // Hero items that include the more button if it should be shown
    private var extendedHeroItems: [CommandingItem] {
        let shouldShowMoreButton = isExpandable && (prefersSheetMoreButtonVisible || !isInSheetMode)
        return heroItems + (shouldShowMoreButton ? [moreHeroItem] : [])
    }

    private var heroCommandWidthConstraints: [NSLayoutConstraint] {
        extendedHeroItems.compactMap { (itemToBindingMap[$0] as? HeroItemBindingInfo)?.widthConstraint }
    }

    private var bottomBarHidingAnimator: UIViewPropertyAnimator?

    // Constraints attaching self.layoutGuide to the current commanding surface (bar or a sheet)
    private var layoutGuideConstraints = [NSLayoutConstraint]()

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
        static let defaultHeroButtonHeight: CGFloat = 40
        static let heroButtonWidth: CGFloat = 96
        static let heroButtonLabelMaxWidth: CGFloat = 72
        static let heroButtonMaxTitleLines: Int = 2

        static let tableViewIconTintColor: UIColor = Colors.textSecondary
        static let tableViewBackgroundColor: UIColor = Colors.NavigationBar.background

        struct BottomBar {
            static let height: CGFloat = 80
            static let cornerRadius: CGFloat = 14
            static let backgroundColor: UIColor = Colors.NavigationBar.background

            static let bottomOffset: CGFloat = 10
            static let hiddenBottomOffset: CGFloat = -110
            static let heroStackLeadingTrailingMargin: CGFloat = 8
            static let heroStackTopMargin: CGFloat = 20

            static let hidingSpringDuration: TimeInterval = 0.4
            static let hidingSpringDamping: CGFloat = 1.0

            static let moreButtonIcon: UIImage? = UIImage.staticImageNamed("more-24x24")
            static let moreButtonTitle: String = "CommandingBottomBar.More".localized

            struct Shadow {
                static let color: CGColor = UIColor.black.cgColor
                static let opacity: Float = 0.14
                static let radius: CGFloat = 8
            }
        }

        struct BottomSheet {
            static let headerHeight: CGFloat = 64
            static let headerTopMargin: CGFloat = 4
            static let headerLeadingTrailingMargin: CGFloat = 8
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
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // This gets rid of a 20pt margin after the last section which UITableView adds automatically.
        return CGFloat.leastNormalMagnitude
    }

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
                dismiss(animated: true) { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.delegate?.bottomCommandingController?(strongSelf, didDismissPopoverWith: .commandTap)
                }
            }
            setSheetIsExpanded(to: false, commandingInteraction: .commandTap)
            binding.item.action?(binding.item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BottomCommandingController: CommandingItemDelegate {
    func commandingItem(_ item: CommandingItem, didChangeTitleTo value: String?) {
        reloadView(from: item)

        if let binding = itemToBindingMap[item], binding.location == .heroSet {
            // A title change in the hero set can cause a sheet size change, so we need to recalculate
            updateSheetHeaderSizingParameters()
        }
    }

    func commandingItem(_ item: CommandingItem, didChangeImageTo value: UIImage?) {
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

extension BottomCommandingController: BottomSheetControllerDelegate {
    public func bottomSheetControllerCollapsedHeightInSafeAreaDidChange(_ bottomSheetController: BottomSheetController) {
        delegate?.bottomCommandingControllerCollapsedHeightInSafeAreaDidChange?(self)
    }

    public func bottomSheetController(_ bottomSheetController: BottomSheetController, didMoveTo expansionState: BottomSheetExpansionState, interaction: BottomSheetInteraction) {
        let commandingInteraction: BottomCommandingInteraction = interaction == .noUserAction ? .noUserAction : .sheetInteraction
        delegate?.bottomCommandingController?(self, sheetDidMoveTo: expansionState, commandingInteraction: commandingInteraction, sheetInteraction: interaction)
    }
}

extension BottomCommandingController: UIPopoverPresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.bottomCommandingController?(self, didDismissPopoverWith: .otherUserAction)
    }
}
