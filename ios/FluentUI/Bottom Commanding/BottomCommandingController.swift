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
open class BottomCommandingController: UIViewController, TokenizedControlInternal {

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
    /// Up to 5 hero items will be displayed  in the bottom bar, the rest will be displayed with the items from
    /// the `expandedListSections`.
    @objc open var heroItems: [CommandingItem] = [] {
        willSet {
            heroItems.forEach { removeBinding(for: $0) }
        }
        didSet {
            updateVisibleHeroItems()
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

            updateVisibleExpandedListSections()
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
            if isViewLoaded {
                reloadHeroCommandStack()
            }
        }
    }

    /// Indicates if the sheet should always fill the available width. The default value is true.
    @objc open var sheetShouldAlwaysFillWidth: Bool = true {
        didSet {
            bottomSheetController?.shouldAlwaysFillWidth = sheetShouldAlwaysFillWidth
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

        setupCommandingLayout(traitCollection: traitCollection)

        if let contentViewController = contentViewController {
            addChildContentViewController(contentViewController)
        }

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: view) { [weak self] in
            self?.updateAppearance()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            updateSheetPreferredExpandedContentHeight()
        }
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        // Make sure we only reset our commanding style on iPad. On iPhone we only use the sheet style, so there's no need for unnecessary work.
        if newCollection.horizontalSizeClass != traitCollection.horizontalSizeClass && newCollection.userInterfaceIdiom == .pad {
            dismissPresentedPopoverIfNeeded(with: .noUserAction, animated: false)

            // On a horizontal size class change the top level sheet / bar surfaces get recreated,
            // but the item views, containers and bindings persist and are reused during the individual setup functions.
            if let bottomSheetController = bottomSheetController {
                _isHidden = bottomSheetController.isHidden
                bottomSheetController.willMove(toParent: nil)
                bottomSheetController.removeFromParent()
                bottomSheetController.view.removeFromSuperview()
                self.bottomSheetController = nil
            }

            if bottomBarView != nil {
                completeBottomBarAnimationsIfNeeded(skipToEnd: true)
                bottomBarView?.removeFromSuperview()
                bottomBarView = nil
            }

            // Force a layout pass after we set up the new layout to give the commanding surface a sane initial frame.
            // We do this to avoid a jarring animation during screen rotation.
            setupCommandingLayout(traitCollection: newCollection, forceLayoutPass: false)
        }
    }

    public override func viewSafeAreaInsetsDidChange() {
        updateSheetHeaderSizingParameters()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let tableHeaderView = tableView.tableHeaderView {
            let fittingSize = tableHeaderView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0))
            tableHeaderView.frame = CGRect(origin: .zero, size: fittingSize)
        }
    }

    /// A string to optionally customize the accessibility label of the bottom sheet handle.
    /// The message should convey the "Expand" action and will be used when the bottom sheet is collapsed.
    @objc public var handleExpandCustomAccessibilityLabel: String? {
        didSet {
            bottomSheetController?.handleExpandCustomAccessibilityLabel = handleExpandCustomAccessibilityLabel
        }
    }

    /// A string to optionally customize the accessibility label of the bottom sheet handle.
    /// The message should convey the "Collapse" action and will be used when the bottom sheet is expanded.
    @objc public var handleCollapseCustomAccessibilityLabel: String? {
        didSet {
            bottomSheetController?.handleCollapseCustomAccessibilityLabel = handleCollapseCustomAccessibilityLabel
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tokenSet.update(fluentTheme)
    }

    public typealias TokenSetKeyType = BottomCommandingTokenSet.Tokens
    public var tokenSet: BottomCommandingTokenSet = .init()

    var fluentTheme: FluentTheme { return view.fluentTheme }

    private func setupCommandingLayout(traitCollection: UITraitCollection, forceLayoutPass: Bool = false) {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.userInterfaceIdiom == .pad {
            setupBottomBarLayout(forceLayoutPass: forceLayoutPass)
        } else {
            setupBottomSheetLayout(forceLayoutPass: forceLayoutPass)
        }
    }

    private func setupBottomBarLayout(forceLayoutPass: Bool = false) {
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

        if forceLayoutPass {
            view.layoutIfNeeded()
        }
        delegate?.bottomCommandingControllerCollapsedHeightInSafeAreaDidChange?(self)
    }

    private func setupBottomSheetLayout(forceLayoutPass: Bool = false) {
        NSLayoutConstraint.deactivate(layoutGuideConstraints)
        NSLayoutConstraint.deactivate(heroCommandWidthConstraints)
        heroCommandStack.distribution = .fillEqually

        let headerView = UIView()
        headerView.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(headerContentView: headerView, expandedContentView: makeSheetExpandedContent(with: tableView))
        sheetController.headerContentHeight = Constants.BottomSheet.headerHeight
        sheetController.hostedScrollView = tableView
        sheetController.isHidden = isHidden
        sheetController.shouldAlwaysFillWidth = sheetShouldAlwaysFillWidth
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
            heroCommandStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            heroCommandStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
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
        updateBottomSheetAppearance()

        reloadHeroCommandStack()
        updateSheetHeaderSizingParameters()
        updateSheetPreferredExpandedContentHeight()

        if forceLayoutPass {
            view.layoutIfNeeded()
        }
    }

    private func makeBottomBarByEmbedding(contentView: UIView) -> UIView {
        let bottomBarView = UIView()

        let roundedCornerView = UIView()
        roundedCornerView.backgroundColor = tokenSet[.backgroundColor].uiColor
        roundedCornerView.translatesAutoresizingMaskIntoConstraints = false
        roundedCornerView.layer.cornerRadius = tokenSet[.cornerRadius].float
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
            contentView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: BottomCommandingTokenSet.bottomBarTopSpacing)
        ])
        bottomBarBackgroundView = roundedCornerView
        return bottomBarView
    }

    private func makeSheetExpandedContent(with tableView: UITableView) -> UIView {
        let view = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.tokenSet.setOverrideValue(tokenSet[.strokeColor], forToken: .color)
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
        sheetHeaderSeparator = separator
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
        heroCommandStack.removeAllSubviews()
        NSLayoutConstraint.deactivate(heroOverflowStackConstraints)
        let featuredHeroCount: Int
        let featuredHeroItems: [CommandingItem]
        if prefersSheetMoreButtonVisible {
            featuredHeroCount = Constants.heroCommandsPerRow - 1
            featuredHeroItems = (visibleHeroItems.prefix(featuredHeroCount) + [moreHeroItem])
        } else {
            featuredHeroCount = Constants.heroCommandsPerRow
            featuredHeroItems = Array(visibleHeroItems.prefix(featuredHeroCount))
        }
        let heroViews = featuredHeroItems.map { createAndBindHeroCommandView(with: $0) }
        heroViews.forEach { heroCommandStack.addArrangedSubview($0) }
        if featuredHeroCount < visibleHeroItems.count {
            reloadHeroCommandOverflowStack()
        } else {
            tableView.tableHeaderView = nil
        }
    }

    private func reloadHeroCommandOverflowStack() {
        let commandsPerRow = Constants.heroCommandsPerRow
        heroCommandOverflowStack.removeAllSubviews()
        let heroOverflowViews = visibleHeroItems.suffix(from: commandsPerRow - (prefersSheetMoreButtonVisible ? 1 : 0)).map { createAndBindHeroCommandView(with: $0, isOverflow: true) }
        for i in 0...(heroOverflowViews.count / commandsPerRow) {
            var rowViews = Array(heroOverflowViews.suffix(from: i * commandsPerRow).prefix(commandsPerRow))
            let heroCount = rowViews.count
            if heroCount == 0 {
                continue
            } else if heroCount != commandsPerRow {
                rowViews.append(contentsOf: Array(1...(commandsPerRow - heroCount)).map { _ in UIView() })
            }
            let rowStack = UIStackView(arrangedSubviews: rowViews)
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            let horizontalMargin = BottomCommandingTokenSet.tabHorizontalPadding
            rowStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: horizontalMargin, bottom: 0, trailing: horizontalMargin)
            rowStack.isLayoutMarginsRelativeArrangement = true
            heroCommandOverflowStack.addArrangedSubview(rowStack)
        }
        tableView.tableHeaderView = heroCommandOverflowStack
        NSLayoutConstraint.activate(heroOverflowStackConstraints)
        if isInSheetMode {
            view.setNeedsLayout()
        }
    }

    private func updateAppearance() {
        guard isViewLoaded else {
            return
        }
        updateBottomSheetAppearance()
        reloadHeroCommandStack()
        updateTableViewAppearance()
        updateSeparatorColor()
        updateBottomBar()
    }

    private func updateBottomSheetAppearance() {
        guard let bottomSheetController else {
            return
        }
        bottomSheetController.tokenSet.setOverrides(from: tokenSet,
                                                    mapping: [.backgroundColor: .backgroundColor,
                                                              .cornerRadius: .cornerRadius,
                                                              .resizingHandleMarkColor: .resizingHandleMarkColor,
                                                              .shadow: .shadow])
    }

    private func updateTableViewAppearance() {
        tableView.backgroundColor = tokenSet[.backgroundColor].uiColor
        tableView.reloadData()
    }

    private func updateSeparatorColor() {
        guard let sheetHeaderSeparator else {
            return
        }
        sheetHeaderSeparator.tokenSet.setOverrideValue(tokenSet[.strokeColor], forToken: .color)
    }

    private func updateBottomBar() {
        guard let bottomBarBackgroundView else {
            return
        }
        bottomBarBackgroundView.backgroundColor = tokenSet[.backgroundColor].uiColor
        bottomBarBackgroundView.layer.cornerRadius = tokenSet[.cornerRadius].float
    }

    private lazy var moreHeroItem: CommandingItem = {
        let moreItem = CommandingItem(title: Constants.BottomBar.moreButtonTitle, image: Constants.BottomBar.moreButtonIcon ?? UIImage(), action: handleMoreCommandTap)
        moreItem.accessibilityIdentifier = "More"
        return moreItem
    }()

    private lazy var heroCommandStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addInteraction(UILargeContentViewerInteraction())
        stackView.alignment = .top
        let horizontalMargin = BottomCommandingTokenSet.tabHorizontalPadding
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: horizontalMargin, bottom: 0, trailing: horizontalMargin)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private var sheetHeaderSeparator: Separator?

    private lazy var heroCommandOverflowStack: UIStackView = {
        let spacing = BottomCommandingTokenSet.gridSpacing
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addInteraction(UILargeContentViewerInteraction())
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = spacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var heroOverflowStackConstraints: [NSLayoutConstraint] = [
        heroCommandOverflowStack.topAnchor.constraint(equalTo: tableView.topAnchor),
        heroCommandOverflowStack.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        heroCommandOverflowStack.widthAnchor.constraint(equalTo: tableView.widthAnchor)
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = tokenSet[.backgroundColor].uiColor
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(BooleanCell.self, forCellReuseIdentifier: BooleanCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        isTableViewLoaded = true
        return tableView
    }()

    private var bottomBarBackgroundView: UIView?

    // MARK: - CommandingItem and CommandingSection filtering

    /// Filters the `heroItems` array for items with that are not hidden
    private func updateVisibleHeroItems() {
        let updatedVisibleHeroItems = heroItems.filter { item in
            return !item.isHidden
        }

        visibleHeroItems = updatedVisibleHeroItems
    }

    /// Filters the `expandedListSections` 2D array for items with that are not hidden
    private func updateVisibleExpandedListSections() {
        /// Filter for all `CommandingSection`  that have at least 1 visible `CommandingItem`
        let updatedVisibleExpandedListSections = expandedListSections.filter { expandedListSection in
            return expandedListSection.items.contains { item in
                return !item.isHidden
            }
        }

        /// Filter all `CommandingItem` that are not hidden and add to a new `CommandingSection` to holds the filtered items
        visibleExpandedListSections = updatedVisibleExpandedListSections.map { expandedListSection in
            return CommandingSection(title: expandedListSection.title,
                                     items: expandedListSection.items.filter { item in return !item.isHidden }
            )
        }
    }

    /// Array of `CommandingItems` in the tab bar view which are visible
    /// This property should be set by calling `updateVisibleHeroItems()`
    private var visibleHeroItems: [CommandingItem] = [] {
        didSet {
            if isViewLoaded {
                reloadHeroCommandStack()
                updateSheetHeaderSizingParameters()
            }
        }
    }

    /// Array of `CommandingItems` in the table view which are visible
    /// This property should be set by calling `updateVisibleExpandedListSections()`
    private var visibleExpandedListSections: [CommandingSection] = [] {
        didSet {
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
            if let tableHeaderView = tableView.tableHeaderView {
                let fittingSize = tableHeaderView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0))
                tableHeaderView.frame = CGRect(origin: .zero, size: fittingSize)
                popoverContentViewController.view.setNeedsLayout()
            }
            present(popoverContentViewController, animated: true) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.bottomCommandingController?(strongSelf, didPresentPopoverWith: .moreButtonTap)
            }
            presentedPopoverContentViewController = popoverContentViewController
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

    private func dismissPresentedPopoverIfNeeded(with interaction: BottomCommandingInteraction, animated: Bool) {
        if let presentedViewController = presentedViewController, presentedViewController == presentedPopoverContentViewController {
            dismiss(animated: animated) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.presentedPopoverContentViewController = nil
                strongSelf.delegate?.bottomCommandingController?(strongSelf, didDismissPopoverWith: interaction)
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

    private func createAndBindHeroCommandView(with item: CommandingItem, isOverflow: Bool = false) -> UIView {
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
        itemView.accessibilityIdentifier = item.accessibilityIdentifier
        itemView.tokenSet.setOverrides(from: tokenSet,
                                       mapping: [.disabledColor: .heroDisabledColor,
                                                 .titleLabelFontLandscape: .heroLabelFont,
                                                 .titleLabelFontPortrait: .heroLabelFont,
                                                 .selectedColor: .heroSelectedColor,
                                                 .unselectedImageColor: .heroRestIconColor,
                                                 .unselectedTextColor: .heroRestLabelColor])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
        itemView.addGestureRecognizer(tapGesture)

        let widthConstraint: NSLayoutConstraint?
        if isOverflow {
            widthConstraint = nil
        } else {
            let constraint = itemView.widthAnchor.constraint(equalToConstant: Constants.heroButtonWidth)
            constraint.isActive = !isInSheetMode
            widthConstraint = constraint
        }

        item.delegate = self
        let binding = HeroItemBindingInfo(item: item, view: itemView, location: .heroSet, widthConstraint: widthConstraint)
        addBinding(binding)

        return itemView
    }

    private func setupTableViewCell(_ cell: TableViewCell, with item: CommandingItem) {
        let iconView = UIImageView(image: item.image)

        if item.isToggleable, let booleanCell = cell as? BooleanCell {
            booleanCell.setup(title: item.title ?? "", customView: iconView, isOn: item.isOn)
            booleanCell.onValueChanged = {
                item.isOn = booleanCell.isOn
                item.action?(item)
            }
        } else {
            if let trailingView = item.trailingView {
                cell.setup(title: item.title ?? "", customView: iconView, customAccessoryView: trailingView)
            } else {
                cell.setup(title: item.title ?? "", customView: iconView)
            }
        }
        cell.isEnabled = item.isEnabled
        cell.isHidden = item.isHidden
        cell.backgroundStyleType = .clear
        cell.accessibilityIdentifier = item.accessibilityIdentifier
        cell.tokenSet.setOverrides(from: tokenSet,
                                   mapping: [.backgroundColor: .backgroundColor,
                                             .imageColor: .listIconColor,
                                             .titleColor: .listLabelColor,
                                             .titleFont: .listLabelFont])

        let shouldShowSeparator = visibleExpandedListSections
            .prefix(visibleExpandedListSections.count - 1)
            .contains(where: { $0.items.last == item })
        cell.bottomSeparatorType = shouldShowSeparator ? .full : .none
        cell.titleNumberOfLines = 0
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
        let headerHeightWithoutBottomWhitespace = BottomCommandingTokenSet.handleHeaderHeight + maxHeroItemHeight

        // How much more whitespace is required at the bottom of the sheet header
        let requiredBottomWhitespace = max(0, Constants.BottomSheet.headerHeight - headerHeightWithoutBottomWhitespace)

        // The safe area inset can fulfill some or all of our bottom whitespace requirement.
        // This is how much more we need, taking the inset into account.
        let reducedBottomWhitespace = max(0, requiredBottomWhitespace - view.safeAreaInsets.bottom)

        // We need additional top margin to account for missing resizing handle when isExpandable is false
        let addedHeaderTopMargin = !isExpandable
            ? BottomSheetController.resizingHandleHeight
            : 0
        bottomSheetHeroStackTopConstraint?.constant = BottomCommandingTokenSet.handleHeaderHeight + addedHeaderTopMargin

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
        if let tableHeaderView = tableView.tableHeaderView {
            let fittingSize = tableHeaderView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0))
            totalHeight += fittingSize.height
        }
        for section in visibleExpandedListSections {
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

    private var presentedPopoverContentViewController: UIViewController?

    private var isTableViewLoaded: Bool = false

    private var isInSheetMode: Bool { bottomSheetController != nil }

    private var isExpandable: Bool { visibleExpandedListSections.count > 0 }

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
        let widthConstraint: NSLayoutConstraint?

        init(item: CommandingItem, view: UIView, location: ItemLocation, widthConstraint: NSLayoutConstraint?) {
            self.widthConstraint = widthConstraint
            super.init(item: item, view: view, location: location)
        }
    }

    private struct Constants {
        static let defaultHeroButtonHeight: CGFloat = 40
        static let heroButtonWidth: CGFloat = 96
        static let heroButtonLabelMaxWidth: CGFloat = 72
        static let heroButtonMaxTitleLines: Int = 2
        static let heroCommandsPerRow: Int = 5

        struct BottomBar {
            static let height: CGFloat = 80

            static let bottomOffset: CGFloat = 8
            static let hiddenBottomOffset: CGFloat = -110

            static let hidingSpringDuration: TimeInterval = 0.4
            static let hidingSpringDamping: CGFloat = 1.0

            static let moreButtonIcon: UIImage? = UIImage.staticImageNamed("more-24x24")
            static let moreButtonTitle: String = "CommandingBottomBar.More".localized
        }

        struct BottomSheet {
            static let headerHeight: CGFloat = 66
        }
    }
}

extension BottomCommandingController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return visibleExpandedListSections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(section < visibleExpandedListSections.count)

        return visibleExpandedListSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = visibleExpandedListSections[indexPath.section]
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
        let section = visibleExpandedListSections[section]

        var configuredHeader: UIView?
        if let sectionTitle = section.title {
            header.setup(style: .header, title: sectionTitle)
            header.tableViewCellStyle = .clear
            header.tokenSet.setOverrides(from: tokenSet,
                                         mapping: [.textFont: .listSectionLabelFont,
                                                   .textColor: .listSectionLabelColor])
            configuredHeader = header
        }

        return configuredHeader
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let binding = viewToBindingMap[cell] else {
            return
        }

        if !binding.item.isToggleable {
            dismissPresentedPopoverIfNeeded(with: .commandTap, animated: true)
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

    func commandingItem(_ item: CommandingItem, didChangeTrailingViewTo value: UIView?) {
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

    func commandingItem(_ item: CommandingItem, didChangeHiddenTo value: Bool) {
        updateVisibleHeroItems()
        updateVisibleExpandedListSections()
    }
}

extension BottomCommandingController: BottomSheetControllerDelegate {
    public func bottomSheetControllerCollapsedHeightInSafeAreaDidChange(_ bottomSheetController: BottomSheetController) {
        delegate?.bottomCommandingControllerCollapsedHeightInSafeAreaDidChange?(self)
    }

    public func bottomSheetController(_ bottomSheetController: BottomSheetController, didMoveTo expansionState: BottomSheetExpansionState, interaction: BottomSheetInteraction) {

        // bottomSheetView is purposefully the sibling of contentViewController's view so that users can interact with UIControls behind the sheet.
        // However, when bottomSheet is expanded and VoiceOver is on, users can still interact with the elements behind the sheet which is confusing
        // because visual users DimmingView blocks the interaction. The work around is to temporarily hide other accessibilityElements outside of bottomSheetController's view.
        if expansionState == .expanded {
            contentViewController?.view.accessibilityElementsHidden = true
            navigationController?.navigationBar.accessibilityElementsHidden = true
        } else {
            contentViewController?.view.accessibilityElementsHidden = false
            navigationController?.navigationBar.accessibilityElementsHidden = false
        }
        UIAccessibility.post(notification: .layoutChanged, argument: nil)

        let commandingInteraction: BottomCommandingInteraction = interaction == .noUserAction ? .noUserAction : .sheetInteraction
        delegate?.bottomCommandingController?(self, sheetDidMoveTo: expansionState, commandingInteraction: commandingInteraction, sheetInteraction: interaction)
    }
}

extension BottomCommandingController: UIPopoverPresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentedPopoverContentViewController = nil
        delegate?.bottomCommandingController?(self, didDismissPopoverWith: .otherUserAction)
    }
}
