//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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

    open override var presentationStyle: MSDrawerPresentationStyle { get { return .automatic } set { } }
    open override var resizingBehavior: MSDrawerResizingBehavior { get { return .dismiss } set { } }

    open override var preferredContentSize: CGSize { get { return super.preferredContentSize } set { } }
    override var preferredContentWidth: CGFloat {
        var width = Constants.minimumContentWidth
        if let headerItem = headerItem {
            width = max(width, MSPopupMenuItemCell.preferredWidth(for: headerItem, preservingSpaceForImage: false))
        }
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
        if let headerItem = headerItem {
            height += MSPopupMenuItemCell.preferredHeight(for: headerItem)
        }
        for section in sections {
            height += MSPopupMenuSectionHeaderView.preferredHeight(for: section)
            for item in section.items {
                height += MSPopupMenuItemCell.preferredHeight(for: item)
            }
        }
        return height
    }
    override var tracksContentHeight: Bool { return false }

    /// Set `headerItem` to show a menu header. Header is not interactable and does not scroll.
    @objc open var headerItem: MSPopupMenuItem? {
        didSet {
            if let headerItem = headerItem {
                headerView.setup(item: headerItem)
            }
            headerView.isHidden = headerItem == nil
        }
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

    private var sections: [MSPopupMenuSection] = []
    private var itemForExecutionAfterPopupMenuDismissal: MSPopupMenuItem?
    private var itemsHaveImages: Bool {
        return sections.contains(where: { $0.items.contains(where: { $0.image != nil }) })
    }

    private lazy var containerView: UIView = {
        let view = UIStackView()
        view.axis = .vertical
        view.addArrangedSubview(headerView)
        view.addArrangedSubview(tableView)
        return view
    }()
    private let headerView: MSPopupMenuItemCell = {
        let view = MSPopupMenuItemCell(frame: .zero)
        view.isHeader = true
        view.isHidden = true
        return view
    }()
    private let tableView = UITableView(frame: .zero, style: .grouped)

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

    open override func didDismiss() {
        if itemForExecutionAfterPopupMenuDismissal?.executionMode == .afterPopupMenuDismissal {
            itemForExecutionAfterPopupMenuDismissal?.onSelected?()
            itemForExecutionAfterPopupMenuDismissal = nil
        }
        super.didDismiss()
        if itemForExecutionAfterPopupMenuDismissal?.executionMode == .afterPopupMenuDismissalCompleted {
            itemForExecutionAfterPopupMenuDismissal?.onSelected?()
            itemForExecutionAfterPopupMenuDismissal = nil
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        super.contentView = containerView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: selectedItemIndexPath, animated: false, scrollPosition: .none)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        tableView.scrollToNearestSelectedRow(at: .none, animated: false)
    }

    private func initTableView() {
        tableView.backgroundColor = MSColors.Table.background
        tableView.separatorStyle = .none
        // Helps reduce the delay between touch and action due to a bug in iOS 11
        if #available(iOS 12.0, *) { } else {
            tableView.delaysContentTouches = false
        }
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true

        tableView.register(MSPopupMenuItemCell.self, forCellReuseIdentifier: MSPopupMenuItemCell.identifier)
        tableView.register(MSPopupMenuSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MSPopupMenuSectionHeaderView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func didSelectItem(_ item: MSPopupMenuItem) {
        switch item.executionMode {
        case .onSelection:
            item.onSelected?()
        case .afterPopupMenuDismissal, .afterPopupMenuDismissalCompleted:
            itemForExecutionAfterPopupMenuDismissal = item
        }
        if !isBeingDismissed {
            presentingViewController?.dismiss(animated: true)
        }
    }

    private func item(at indexPath: IndexPath) -> MSPopupMenuItem {
        return sections[indexPath.section].items[indexPath.item]
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
        cell.preservesSpaceForImage = itemsHaveImages
        let isLastInSection = row == tableView.numberOfRows(inSection: section) - 1
        let isLast = section == tableView.numberOfSections - 1 && isLastInSection
        cell.bottomSeparatorType = isLast ? .none : (isLastInSection ? .full : .inset)

        return cell
    }
}

// MARK: - MSPopupMenuController: UITableViewDelegate

extension MSPopupMenuController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MSPopupMenuSectionHeaderView.preferredHeight(for: sections[section])
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemIndexPath = indexPath
        didSelectItem(item(at: indexPath))
    }
}
