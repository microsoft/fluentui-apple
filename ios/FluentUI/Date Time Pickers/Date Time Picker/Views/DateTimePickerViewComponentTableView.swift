//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DateTimePickerViewComponentTableView

/// TableView representing the component view of MSDateTimePickerViewComponent (should be used only by DateTimePickerViewComponent and not instantiated on its own)
class DateTimePickerViewComponentTableView: UITableView {
    override var frame: CGRect {
        didSet {
            // Adjust content inset so that first and last cells can be centered
            let inset = round((frame.height - DateTimePickerViewComponentCell.idealHeight) / 2)
            contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        }
    }

    weak var accessibilityDelegate: AccessibleTableViewDelegate?
    private var accessibilityMiddleIndexPath: IndexPath?

    var middleIndexPath: IndexPath? {
        let middlePoint = CGPoint(x: 0, y: contentOffset.y + bounds.height / 2)

        if let cell = indexPathForRow(at: middlePoint) {
            return cell
        }

        let rowCount = numberOfRows(inSection: 0)
        if rowCount > 0 {
            // Bouncing at start -> First cell
            if middlePoint.y < 0 {
                return IndexPath(row: 0, section: 0)
            }

            // Bouncing at end -> Last cell
            if middlePoint.y > contentSize.height {
                return IndexPath(row: rowCount - 1, section: 0)
            }
        }

        return nil
    }

    init() {
        super.init(frame: .zero, style: .plain)

        backgroundColor = nil
        separatorInset = UIEdgeInsets.zero
        separatorStyle = .none
        showsVerticalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func centerRow(at indexPath: IndexPath, animated: Bool) {
        // Update Content Offset
        let cellHeight = DateTimePickerViewComponentCell.idealHeight
        let viewOffsetY = round((frame.height - cellHeight) / 2)
        let maxOffsetY = contentSize.height - contentInset.top
        let minOffsetY = CGFloat(numberOfRows(inSection: 0)) * cellHeight >= frame.height ? -contentInset.top : -.infinity
        let offsetY = max(min(CGFloat(indexPath.row) * cellHeight - viewOffsetY, maxOffsetY), minOffsetY)
        setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
    }
}

// MARK: - DateTimePickerViewComponentTableView: AccessibleViewDelegate

extension DateTimePickerViewComponentTableView: AccessibleViewDelegate {
    func accessibilityLabelForAccessibleView(_ view: UIView) -> String? {
        return accessibilityDelegate?.accessibilityLabelForAccessibleView?(self)
    }

    func accessibilityValueForAccessibleView(_ accessibleView: UIView) -> String? {
        // Use accessibilityMiddleIndexPath. Because of the animation, middleIndexPath might not be correct
        guard let indexPath = accessibilityMiddleIndexPath ?? middleIndexPath else {
            assertionFailure("accessibilityValue > middle index path not found")
            return nil
        }

        return accessibilityDelegate?.accessibilityValueForRowAtIndexPath?(indexPath, forTableView: self)
    }

    func accessibilityIncrementForAccessibleView(_ accessibleView: UIView) {
        let numberOfRows = self.numberOfRows(inSection: 0)
        guard let currentIndexPath = middleIndexPath, numberOfRows > 0 else {
            return
        }

        let newRow = min(currentIndexPath.row + 1, numberOfRows - 1)
        let newIndexPath = IndexPath(row: newRow, section: 0)
        centerRow(at: newIndexPath, animated: false)
        accessibilityMiddleIndexPath = newIndexPath

        accessibilityDelegate?.accessibilityIncrementForAccessibleView?(accessibleView)
    }

    func accessibilityDecrementForAccessibleView(_ accessibleView: UIView) {
        guard let currentIndexPath = middleIndexPath, numberOfRows(inSection: 0) > 0 else {
            return
        }

        let newRow = max(currentIndexPath.row - 1, 0)
        let newIndexPath = IndexPath(row: newRow, section: 0)
        centerRow(at: newIndexPath, animated: false)
        accessibilityMiddleIndexPath = newIndexPath

        accessibilityDelegate?.accessibilityDecrementForAccessibleView?(accessibleView)
    }
}
