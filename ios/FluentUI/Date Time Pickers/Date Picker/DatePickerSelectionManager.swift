//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: DatePickerSelectionManager

/// Manages the selected date range based on the selectionMode
class DatePickerSelectionManager {
    /// The selection mode of the picker to indicate whether the start or end date of the selected range is updated on cell selection.
    public enum SelectionMode {
        case start, end
    }

    enum SelectionState {
        case single(IndexPath)
        case range(IndexPath, IndexPath)
    }

    private(set) var selectionState: SelectionState
    var selectionMode: SelectionMode

    var startDateIndexPath: IndexPath {
        switch selectionState {
        case let .single(selectedIndexPath):
            return selectedIndexPath
        case let .range(startIndexPath, _):
            return startIndexPath
        }
    }

    var endDateIndexPath: IndexPath {
        switch selectionState {
        case let .single(selectedIndexPath):
            return selectedIndexPath
        case let .range(_, endIndexPath):
            return endIndexPath
        }
    }

    var startDate: Date {
        get {
            return dataSource.dayStart(forDayAt: selectedIndexPaths.startIndexPath)
        }
        set {
            setSelectedIndexPath(dataSource.indexPath(forDayWithStart: newValue), mode: .start)
        }
    }
    var endDate: Date {
        get {
            return dataSource.dayStart(forDayAt: selectedIndexPaths.endIndexPath)
        }
        set {
            setSelectedIndexPath(dataSource.indexPath(forDayWithStart: newValue), mode: .end)
        }
    }

    private let dataSource: CalendarViewDataSource

    private var selectedIndexPaths: (startIndexPath: IndexPath, endIndexPath: IndexPath) {
        switch selectionState {
        case let .single(selectedIndexPath):
            return (selectedIndexPath, selectedIndexPath)
        case let .range(startIndexPath, endIndexPath):
            return (startIndexPath, endIndexPath)
        }
    }

    init(dataSource: CalendarViewDataSource, startDate: Date, endDate: Date, selectionMode: SelectionMode) {
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

    func getNextIndexPath(indexPath: IndexPath) -> IndexPath {
        // if the indexPath in is a Saturday (Sunday is 0th day of the week, Saturday is the 6th)
        if indexPath.item == 6 {
            // return an IndexPath representing Sunday of the next week (indexPath's section is the week)
            return IndexPath(item: 0, section: indexPath.section + 1)
        }
        // otherwise, increment the day
        return IndexPath(item: indexPath.item + 1, section: indexPath.section)
    }

    func getPreviousIndexPath(indexPath: IndexPath) -> IndexPath {
        // if the indexPath in is a Sunday
        if indexPath.item == 0 {
            // return an IndexPath representing Saturday of the previous week
            return IndexPath(item: 6, section: indexPath.section - 1)
        }
        // otherwise, decrement the day
        return IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }

    func setSelectedIndexPath(_ indexPath: IndexPath, mode: SelectionMode? = nil) {
        selectionState = selectionState(for: indexPath, mode: mode)
    }

    func selectionState(for indexPath: IndexPath, mode: SelectionMode? = nil) -> SelectionState {
        let mode = mode ?? selectionMode
        if mode == .start {
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

    func selectionType(for indexPath: IndexPath) -> CalendarViewDayCellSelectionType? {
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
