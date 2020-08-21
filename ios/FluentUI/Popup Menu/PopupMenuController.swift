//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PopupMenu Colors

public extension Colors {
    struct PopupMenu {
        public static var description: UIColor = textSecondary
    }
}

// MARK: - PopupMenuController Colors

@available(*, deprecated, renamed: "PopupMenuController")
public typealias MSPopupMenuController = PopupMenuController

/**
 `PopupMenuController` is used to present a popup menu that slides from top or bottom depending on `presentationDirection`. Use `presentationOrigin` to specify the vertical offset (in screen coordinates) from which to show popup menu. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.

 When presented as a slide over, `PopupMenuController` will have a resizing handle that provides a user an alternative way to dismiss it.

 `PopupMenuController` will be presented as a popover on iPad and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.
 */
@objc(MSFPopupMenuController)
open class PopupMenuController: DrawerController {
    private struct Constants {
        static let minimumContentWidth: CGFloat = 250

        static let descriptionHorizontalMargin: CGFloat = 16
        static let descriptionVerticalMargin: CGFloat = 12
    }

    open override var contentView: UIView? { get { return super.contentView } set { } }

    open override var presentationStyle: DrawerPresentationStyle { get { return .automatic } set { } }
    open override var resizingBehavior: DrawerResizingBehavior { get { return .dismiss } set { } }

    open override var preferredContentSize: CGSize { get { return super.preferredContentSize } set { } }
    open override var preferredContentWidth: CGFloat {
        var width = Constants.minimumContentWidth
        if let headerItem = headerItem {
            if !descriptionView.isHidden {
                let size = descriptionView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                width = max(width, size.width)
            } else {
                width = max(width, headerItem.cellClass.preferredWidth(for: headerItem, preservingSpaceForImage: false))
            }
        }
        for section in sections {
            width = max(width, PopupMenuSectionHeaderView.preferredWidth(for: section))
            for item in section.items {
                width = max(width, item.cellClass.preferredWidth(for: item, preservingSpaceForImage: itemsHaveImages))
            }
        }
        return width
    }
    open override var preferredContentHeight: CGFloat {
        var height: CGFloat = 0
        if let headerItem = headerItem {
            if !descriptionView.isHidden {
                let size = descriptionView.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: .infinity), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
                height += size.height
            } else {
                height += headerItem.cellClass.preferredHeight(for: headerItem)
            }
        }
        for section in sections {
            height += PopupMenuSectionHeaderView.preferredHeight(for: section)
            for item in section.items {
                height += item.cellClass.preferredHeight(for: item)
            }
        }
        return height
    }

    /// Set `backgroundColor` to customize background color of controller' view and its tableView
    open override var backgroundColor: UIColor {
        didSet {
            tableView.backgroundColor = backgroundColor
        }
    }

    override var tracksContentHeight: Bool { return false }

    /**
     Set `headerItem` to show a menu header. If `subtitle` is present then a 2-line header will be shown. If only `title` is provided then a 1-line description will be presented. In this case a multi-line text is supported.

     Header is not interactable and does not scroll.
     */
    @objc open var headerItem: PopupMenuItem? {
        didSet {
            descriptionView.isHidden = true
            headerView.isHidden = true
            if let headerItem = headerItem {
                if headerItem.subtitle == nil {
                    descriptionView.isHidden = false
                    descriptionLabel.text = headerItem.title
                    descriptionView.accessibilityLabel = headerItem.title
                } else {
                    headerView.isHidden = false
                    headerView.setup(item: headerItem)
                }
            }
        }
    }
    /// Use `selectedItemIndexPath` to get or set the selected menu item instead of doing this via `PopupMenuItem` directly
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

    /// set `separatorColor` to customize separator colors of  PopupMenuItem cells and the drawer
    @objc open var separatorColor: UIColor = Colors.Separator.default {
        didSet {
            separator?.backgroundColor = separatorColor
        }
    }

    private var sections: [PopupMenuSection] = []
    private var itemForExecutionAfterPopupMenuDismissal: PopupMenuTemplateItem?
    private var itemsHaveImages: Bool {
        return sections.contains(where: { $0.items.contains(where: {
            let item = $0 as? PopupMenuItem
            return item?.image != nil
        })
        })
    }

    private lazy var containerView: UIView = {
        let view = UIStackView()
        view.axis = .vertical
        view.addArrangedSubview(descriptionView)
        view.addArrangedSubview(headerView)
        view.addArrangedSubview(tableView)
        return view
    }()

    private var separator: Separator?
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.isAccessibilityElement = true
        view.accessibilityTraits.insert(.header)
        view.isHidden = true

        view.addSubview(descriptionLabel)
        descriptionLabel.fitIntoSuperview(
            usingConstraints: true,
            margins: UIEdgeInsets(
                top: Constants.descriptionVerticalMargin,
                left: Constants.descriptionHorizontalMargin,
                bottom: Constants.descriptionVerticalMargin,
                right: Constants.descriptionHorizontalMargin
            )
        )

        separator = Separator()
        if let separator = separator {
            separator.backgroundColor = separatorColor
            view.addSubview(separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        return view
    }()
    private let descriptionLabel: Label = {
        let label = Label(style: .footnote)
        label.textColor = Colors.PopupMenu.description
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let headerView: PopupMenuItemCell = {
        let view = PopupMenuItemCell(frame: .zero)
        view.isHeader = true
        view.isHidden = true
        return view
    }()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    /// Append new items to the last section of the menu
    /// - note: If there is no section in the menu, create a new one without header and append the items to it
    @objc public func addItems(_ items: [PopupMenuTemplateItem]) {
        if let section = sections.last {
            section.items.append(contentsOf: items)
        } else {
            let section = PopupMenuSection(title: nil, items: items)
            sections.append(section)
        }
    }

    /// Append a new section to the end of menu
    @objc public func addSection(_ section: PopupMenuSection) {
        sections.append(section)
    }

    /// Append new sections to the end of menu
    @objc public func addSections(_ sections: [PopupMenuSection]) {
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
        tableView.backgroundColor = backgroundColor
        tableView.separatorStyle = .none
        // Helps reduce the delay between touch and action due to a bug in iOS 11
        if #available(iOS 12.0, *) { } else {
            tableView.delaysContentTouches = false
        }
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true

        tableView.register(PopupMenuItemCell.self, forCellReuseIdentifier: PopupMenuItemCell.identifier)
        tableView.register(PopupMenuSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: PopupMenuSectionHeaderView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func didSelectItem(_ item: PopupMenuTemplateItem) {
        switch item.executionMode {
        case .onSelection:
            item.onSelected?()
        case .afterPopupMenuDismissal, .afterPopupMenuDismissalCompleted:
            itemForExecutionAfterPopupMenuDismissal = item
        case .onSelectionWithoutDismissal:
            return
        }
        if !isBeingDismissed {
            presentingViewController?.dismiss(animated: true)
        }
    }

    private func item(at indexPath: IndexPath) -> PopupMenuTemplateItem {
        return sections[indexPath.section].items[indexPath.item]
    }
}

// MARK: - PopupMenuController: UITableViewDataSource

extension PopupMenuController: UITableViewDataSource {
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

        let cellClass = item.cellClass
        let identifier = String(describing: cellClass)
        tableView.register(cellClass, forCellReuseIdentifier: identifier)

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PopupMenuItemTemplateCell
        cell.setup(item: item)
        cell.preservesSpaceForImage = itemsHaveImages

        let isLastInSection = row == tableView.numberOfRows(inSection: section) - 1
        if section == tableView.numberOfSections - 1 && isLastInSection {
            cell.bottomSeparatorType = .none
        } else {
            cell.customSeparatorColor = separatorColor
            cell.bottomSeparatorType = isLastInSection ? .full : .inset
        }

        return cell
    }
}

// MARK: - PopupMenuController: UITableViewDelegate

extension PopupMenuController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PopupMenuSectionHeaderView.preferredHeight(for: sections[section])
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        if !PopupMenuSectionHeaderView.isHeaderVisible(for: section) {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PopupMenuSectionHeaderView.identifier) as! PopupMenuSectionHeaderView
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
