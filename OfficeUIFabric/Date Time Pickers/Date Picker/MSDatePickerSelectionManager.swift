//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDatePickerSelectionManager

/// Manages the selected date range based on the selectionMode
class MSDatePickerSelectionManager {
    /// The selection mode of the picker to indicate whether the start or end date of the selected range is updated on cell selection.
    public enum SelectionMode {
        case start, end
    }

    enum SelectionState {
        case single(IndexPath)
        case range(IndexPath, IndexPath)
    }

    var selectionState: SelectionState
    let selectionMode: SelectionMode

    var startDateIndexPath: IndexPath {
        switch selectionState {
        case let .single(selectedIndexPath):
            return selectedIndexPath
        case let .range(startIndexPath, _):
            return startIndexPath
        }
    }

    private let dataSource: MSCalendarViewDataSource

    init(dataSource: MSCalendarViewDataSource, startDate: Date, endDate: Date, selectionMode: SelectionMode) {
        self.dataSource = dataSource
        self.selectionMode = selectionMode

        let startIndexPath = dataSource.indexPath(forDayWithStart: startDate)
        let endIndexPath = dataSource.indexPath(forDayWithStart: endDate)

        if startIndexPath == endIndexPath {
            selectionState = .single(startIndexPath)
        } else {
            selectionState = .range(startIndexPath, endIndexPath)
        }
    }

    var selectedDates: (startDate: Date, endDate: Date) {
        let startDate = dataSource.dayStart(forDayAt: selectedIndexPaths.startIndexPath)
        let endDate = dataSource.dayStart(forDayAt: selectedIndexPaths.endIndexPath)

        return (startDate, endDate)
    }

    private var selectedIndexPaths: (startIndexPath: IndexPath, endIndexPath: IndexPath) {
        switch selectionState {
        case let .single(selectedIndexPath): return (selectedIndexPath, selectedIndexPath)
        case let .range(startIndexPath, endIndexPath): return (startIndexPath, endIndexPath)
        }
    }

    func setSelectedIndexPath(_ indexPath: IndexPath) {
        selectionState = selectionState(for: indexPath)
    }

    func selectionState(for indexPath: IndexPath) -> SelectionState {
        if selectionMode == .start {
            switch selectionState {
            case .single:
                return .single(indexPath)
            case let .range(startIndexPath, endIndexPath):
                let startDate = dataSource.dayStart(forDayAt: startIndexPath)
                let endDate = dataSource.dayStart(forDayAt: endIndexPath)

                let rangeLength = startDate.days(until: endDate)

                let newStartDate = dataSource.dayStart(forDayAt: indexPath)
                let newEndIndexPath = dataSource.indexPath(forDayWithStart: newStartDate.adding(days: rangeLength))

                return .range(indexPath, newEndIndexPath)
            }
        } else {
            switch selectionState {
            case let .single(selectedIndexPath):
                if indexPath == selectedIndexPath {
                    return selectionState
                } else if indexPath.compare(selectedIndexPath) == .orderedAscending {
                    return .single(indexPath)
                } else {
                    return .range(selectedIndexPath, indexPath)
                }
            case let .range(startIndexPath, _):
                if indexPath == startIndexPath || indexPath.compare(startIndexPath) == .orderedAscending {
                    return .single(indexPath)
                } else {
                    return .range(startIndexPath, indexPath)
                }
            }
        }
    }

    func selectionType(for indexPath: IndexPath) -> MSCalendarViewDayCellSelectionType? {
        switch selectionState {
        case let .single(selectedIndexPath):
            return indexPath == selectedIndexPath ? .singleSelection : nil
        case let .range(startIndexPath, endIndexPath):
            if indexPath.compare(startIndexPath) == .orderedDescending && indexPath.compare(endIndexPath) == .orderedAscending {
                return .middleOfRangedSelection
            } else if indexPath == startIndexPath {
                return .startOfRangedSelection
            } else if indexPath == endIndexPath {
                return .endOfRangedSelection
            } else {
                return nil
            }
        }
    }
}
