//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

/**
 `MSPopupMenuController` is used to present a popup menu that slides from top or bottom depending on `presentationDirection`. Use `presentationOrigin` to specify the vertical offset (in screen coordinates) from which to show popup menu. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.

 When presented as a slide over, `MSPopupMenuController` will have a resizing handle that provides a user an alternative way to dismiss it.

 `MSPopupMenuController` will be presented as a popover on iPad and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.
 */
open class MSPopupMenuController: MSDrawerController {
    private struct Constants {
        static let minimumContentWidth: CGFloat = 250
    }

    open override var contentView: UIView? { get { return super.contentView } set { } }

    open override var resizingBehavior: MSDrawerResizingBehavior { get { return .dismiss } set { } }

    open override var preferredContentSize: CGSize { get { return super.preferredContentSize } set { } }
    override var preferredContentWidth: CGFloat {
        var width = Constants.minimumContentWidth
        for section in sections {
            width = max(width, MSPopupMenuSectionHeaderView.preferredWidth(for: section))
            for item in section.items {
                width = max(width, MSPopupMenuItemCell.preferredWidth(for: item, preservingSpaceForImage: itemsHaveImages))
            }
        }
        return width
    }
    override var preferredContentHeight: CGFloat {
        var height: CGFloat = 0
        for section in sections {
            height += MSPopupMenuSectionHeaderView.preferredHeight(for: section)
            for item in section.items {
                height += MSPopupMenuItemCell.preferredHeight(for: item)
            }
        }
        return height
    }

    /// Use `selectedItemIndexPath` to get or set the selected menu item instead of doing this via `MSPopupMenuItem` directly
    @objc open var selectedItemIndexPath: IndexPath? {
        get {
            for (sectionIndex, section) in sections.enumerated() {
                for (itemIndex, item) in section.items.enumerated() {
                    if item.isSelected {
                        return IndexPath(item: itemIndex, section: sectionIndex)
                    }
                }
            }
            return nil
        }
        set {
            for (sectionIndex, section) in sections.enumerated() {
                for (itemIndex, item) in section.items.enumerated() {
                    item.isSelected = sectionIndex == newValue?.section && itemIndex == newValue?.item
                }
            }
        }
    }
    /// Set `showsFirstItemAsHeader` to `true` to make the first menu item look & feel like a header. This menu item will not be interactable.
    @objc open var showsFirstItemAsHeader: Bool = false

    private var sections: [MSPopupMenuSection] = []

    private let tableView = UITableView()

    private var itemsHaveImages: Bool {
        return sections.contains(where: { $0.items.contains(where: { $0.image != nil }) })
    }
    private var needsScrolling: Bool {
        return tableView.contentSize.height > tableView.bounds.height
    }

    /// Append new items to the last section of the menu
    /// - note: If there is no section in the menu, create a new one without header and append the items to it
    @objc public func addItems(_ items: [MSPopupMenuItem]) {
        if let section = sections.last {
            section.items.append(contentsOf: items)
        } else {
            let section = MSPopupMenuSection(title: nil, items: items)
            sections.append(section)
        }
    }

    /// Append a new section to the end of menu
    @objc public func addSection(_ section: MSPopupMenuSection) {
        sections.append(section)
    }

    /// Append new sections to the end of menu
    @objc public func addSections(_ sections: [MSPopupMenuSection]) {
        self.sections.append(contentsOf: sections)
    }

    open override func initialize() {
        super.initialize()
        initTableView()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        super.contentView = tableView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: selectedItemIndexPath, animated: false, scrollPosition: .none)
    }

    private func initTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        // Prevent automatic insetting of this non-scrollable content
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true

        // Prevent tap delay when selecting a menu item
        tableView.delaysContentTouches = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer)

        tableView.register(MSPopupMenuItemCell.self, forCellReuseIdentifier: MSPopupMenuItemCell.identifier)
        tableView.register(MSPopupMenuSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MSPopupMenuSectionHeaderView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func handlePanGesture(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)

        switch gestureRecognizer.state {
        case .began, .changed:
            // Warm up all the visible cell feedback generators
            // Each cell has its own generator to allow each to fire perfectly on time when highlight changes
            for case let cell as MSPopupMenuItemCell in tableView.visibleCells {
                if cell.isHeader {
                    continue
                }
                if cell.feedbackGenerator == nil {
                    cell.feedbackGenerator = UISelectionFeedbackGenerator()
                }
                cell.feedbackGenerator?.prepare()
            }

            var cell: MSPopupMenuItemCell?
            if let indexPath = tableView.indexPathForRow(at: point) {
                cell = tableView.cellForRow(at: indexPath) as? MSPopupMenuItemCell
                if cell?.isHeader == true {
                    cell = nil
                }
            }

            for visibleCell in tableView.visibleCells {
                visibleCell.isHighlighted = visibleCell == cell
            }

        case .ended, .cancelled, .failed:
            guard let indexPath = tableView.indexPathForRow(at: point) else {
                // Gesture did not finish on a highlighted cell, dismiss the dropdown
                presentingViewController?.dismiss(animated: true)
                return
            }

            if let cell = tableView.cellForRow(at: indexPath) as? MSPopupMenuItemCell, cell.isHeader {
                return
            }
            let item = sections[indexPath.section].items[indexPath.row]
            if !item.isEnabled {
                return
            }

            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: indexPath)

        default:
            return
        }
    }
}

// MARK: - MSPopupMenuController: UITableViewDataSource

extension MSPopupMenuController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = sections[section].items[row]

        let cell = tableView.dequeueReusableCell(withIdentifier: MSPopupMenuItemCell.identifier) as! MSPopupMenuItemCell
        cell.setup(item: item)
        cell.isHeader = showsFirstItemAsHeader && section == 0 && row == 0
        cell.preservesSpaceForImage = itemsHaveImages
        cell.showsSeparator = section != tableView.numberOfSections - 1 || row != tableView.numberOfRows(inSection: section) - 1

        return cell
    }
}

// MARK: - MSPopupMenuController: UITableViewDelegate

extension MSPopupMenuController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MSPopupMenuSectionHeaderView.preferredHeight(for: sections[section])
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        return MSPopupMenuItemCell.preferredHeight(for: item)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        if !MSPopupMenuSectionHeaderView.isHeaderVisible(for: section) {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MSPopupMenuSectionHeaderView.identifier) as! MSPopupMenuSectionHeaderView
        headerView.setup(section: section)
        return headerView
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let item = sections[indexPath.section].items[indexPath.row]
        return item.isEnabled ? indexPath : nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemIndexPath = indexPath
        sections[indexPath.section].items[indexPath.row].onSelected?()
        if !isBeingDismissed {
            presentingViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - MSPopupMenuController: UIGestureRecognizerDelegate

extension MSPopupMenuController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? MSPopupMenuItemCell, cell.isHeader {
            return false
        }

        return !needsScrolling
    }
}
