//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDateTimePickerViewComponentDelegate

protocol MSDateTimePickerViewComponentDelegate: class {
    func dateTimePickerComponentDidScroll(_ component: MSDateTimePickerViewComponent, userInitiated: Bool)
    func dateTimePickerComponent(_ component: MSDateTimePickerViewComponent, didSelectItemAtIndexPath indexPath: IndexPath, userInitiated: Bool)
    func dateTimePickerComponent(_ component: MSDateTimePickerViewComponent, accessibilityValueForDateComponents dateComponents: DateComponents?, originalValue: String?) -> String?
}

// MARK: - MSDateTimePickerViewComponent

/// Component of MSDateTimePickerView (should be used only by MSDateTimePickerView and not instantiated on its own)
class MSDateTimePickerViewComponent: UIViewController {
    let dataSource: MSDateTimePickerViewDataSource
    weak var delegate: MSDateTimePickerViewComponentDelegate?

    var selectedItem: Any? {
        if let selectedIndexPath = selectedIndexPath {
            return dataSource.item(forRowAtIndex: selectedIndexPath.row)
        } else {
            return nil
        }
    }

    private(set) lazy var tableView = MSDateTimePickerViewComponentTableView()
    private(set) var selectedIndexPath: IndexPath?
    private var previousSelectedIndexPath: IndexPath?
    private var isScrollUserInitiated: Bool = false

    init(dataSource: MSDateTimePickerViewDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(indexPath: IndexPath, animated: Bool, userInitiated: Bool) {
        guard selectedIndexPath != indexPath else {
            return
        }
        selectedIndexPath = indexPath
        tableView.centerRow(at: indexPath, animated: animated)
        delegate?.dateTimePickerComponent(self, didSelectItemAtIndexPath: indexPath, userInitiated: userInitiated)
    }

    func select(item: Any?, animated: Bool, userInitiated: Bool) {
        if let item = item, let indexPath = dataSource.indexPath(forItem: item) {
            select(indexPath: indexPath, animated: animated, userInitiated: userInitiated)
        }
    }

    func reloadData() {
        tableView.reloadData()
    }

    override func loadView() {
        view = MSAccessibilityContainerView(delegate: tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MSDateTimePickerViewComponentCell.self, forCellReuseIdentifier: MSDateTimePickerViewComponentCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityDelegate = self
        tableView.rowHeight = MSDateTimePickerViewComponentCell.idealHeight
        // Prevent iOS 11 from adjusting the row heights
        tableView.estimatedRowHeight = 0
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
        if let selectedIndexPath = selectedIndexPath {
            tableView.centerRow(at: selectedIndexPath, animated: false)
        }
    }

    private func updateSelectedCell() {
        // Unemphasized previous cell
        if let indexPath = previousSelectedIndexPath, let cell = tableView.cellForRow(at: indexPath) as? MSDateTimePickerViewComponentCell {
            cell.emphasized = false
            previousSelectedIndexPath = nil
        }

        // Emphasize new cell
        if let indexPath = tableView.middleIndexPath, let cell = tableView.cellForRow(at: indexPath) as? MSDateTimePickerViewComponentCell {
            cell.emphasized = true
            previousSelectedIndexPath = indexPath
        }
    }
}

// MARK: - MSDateTimePickerViewComponent: UITableViewDataSource

extension MSDateTimePickerViewComponent: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.itemStringRepresentation(forRowAtIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: MSDateTimePickerViewComponentCell.identifier) as! MSDateTimePickerViewComponentCell

        cell.textLabel?.text = item
        if indexPath.row == self.tableView.middleIndexPath?.row {
            previousSelectedIndexPath = indexPath
            cell.emphasized = true
        }
        return cell
    }
}

// MARK: - MSDateTimePickerViewComponent: UITableViewDelegate

extension MSDateTimePickerViewComponent: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select(indexPath: indexPath, animated: true, userInitiated: true)
    }
}

// MARK: - MSDateTimePickerViewComponent: UIScrollViewDelegate

extension MSDateTimePickerViewComponent: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollUserInitiated = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSelectedCell()

        delegate?.dateTimePickerComponentDidScroll(self, userInitiated: isScrollUserInitiated)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Snap to the nearest cell
        var targetOffset = targetContentOffset.pointee
        let offsetY = targetOffset.y + scrollView.contentInset.top
        let cellHeight = MSDateTimePickerViewComponentCell.idealHeight

        let prevY = floor(offsetY / cellHeight) * cellHeight - scrollView.contentInset.top
        let nextY = (floor(offsetY / cellHeight) + 1) * cellHeight - scrollView.contentInset.top

        if targetOffset.y < prevY + cellHeight / 2 {
            // Snap Up
            targetOffset = CGPoint(x: 0, y: prevY)
        } else {
            // Snap Down
            targetOffset = CGPoint(x: 0, y: nextY)
        }

        let maxOffset = scrollView.contentSize.height - scrollView.contentInset.top
        let minOffset: CGFloat = -scrollView.contentInset.top
        targetOffset.y = max(min(targetOffset.y, maxOffset), minOffset)
        targetContentOffset.pointee = targetOffset
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let newIndexPath = tableView.middleIndexPath else {
            assertionFailure("scrollViewDidEndDecelerating > middle index path not found")
            return
        }

        select(indexPath: newIndexPath, animated: true, userInitiated: isScrollUserInitiated)

        isScrollUserInitiated = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrollUserInitiated = false
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollUserInitiated = false
    }
}

// MARK: - MSDateTimePickerViewComponent: AccessibleTableViewDelegate

extension MSDateTimePickerViewComponent: AccessibleTableViewDelegate {
    func accessibilityLabelForAccessibleView(_ accessibleView: UIView) -> String? {
        return dataSource.accessibilityLabel()
    }

    func accessibilityValueForRowAtIndexPath(_ indexPath: IndexPath, forTableView: UITableView) -> String? {
        let rowAccessibilityValue = dataSource.accessibilityValue(forRowAtIndex: indexPath.row)
        let rowDateComponents = dataSource.dateComponents(forRowAtIndex: indexPath.row)

        if let accessibilityValue = delegate?.dateTimePickerComponent(self, accessibilityValueForDateComponents: rowDateComponents, originalValue: rowAccessibilityValue) {
            return accessibilityValue
        }

        return rowAccessibilityValue
    }

    func accessibilityIncrementForAccessibleView(_: UIView) {
        guard let indexPath = tableView.middleIndexPath else {
            return
        }

        select(indexPath: indexPath, animated: false, userInitiated: true)
    }

    func accessibilityDecrementForAccessibleView(_: UIView) {
        guard let indexPath = tableView.middleIndexPath else {
            return
        }

        select(indexPath: indexPath, animated: false, userInitiated: true)
    }
}
