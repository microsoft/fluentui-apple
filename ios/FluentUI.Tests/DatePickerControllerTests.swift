//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class DatePickerControllerTests: XCTestCase {
    static let testDateInterval: TimeInterval = 1551903381

    let startDate = Date(timeIntervalSince1970: DatePickerControllerTests.testDateInterval)
    let endDate = Date(timeIntervalSince1970: DatePickerControllerTests.testDateInterval).adding(days: 1)

    func testDateRangeInit() {
        let datePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, rangePresentation: .paged, titles: nil)
        XCTAssertEqual(datePicker.startDate, startDate.startOfDay)
        XCTAssertEqual(datePicker.endDate, endDate.startOfDay)
    }

    func testDateRangeStart() {
        let datePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, rangePresentation: .paged, titles: nil)
        guard case .range(let startIndex, _) = datePicker.selectionManager.selectionState else {
            XCTFail()
            return
        }
        let indexPath = IndexPath(item: startIndex.item + 1, section: startIndex.section)
        datePicker.didTapItem(at: indexPath)
        XCTAssertEqual(datePicker.startDate, startDate.adding(days: 1).startOfDay)
        XCTAssertEqual(datePicker.endDate, endDate.adding(days: 1).startOfDay)
    }

    func testDateRangeEnd() {
        let datePicker = DatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, selectionMode: .end, rangePresentation: .paged, titles: nil)
        guard case .range(_, let endIndex) = datePicker.selectionManager.selectionState else {
            XCTFail()
            return
        }
        let indexPath = IndexPath(item: endIndex.item + 1, section: endIndex.section)
        datePicker.didTapItem(at: indexPath)
        XCTAssertEqual(datePicker.startDate, startDate.startOfDay)
        XCTAssertEqual(datePicker.endDate, endDate.adding(days: 1).startOfDay)
    }

    func testSelectionManagerEnd() {
        let dataSource = CalendarViewDataSource(styleDataSource: MockCalendarViewStyleDataSource())
        let selectionManager = DatePickerSelectionManager(
            dataSource: dataSource,
            startDate: startDate,
            endDate: endDate,
            selectionMode: .end
        )

        guard case .range(_, let endIndex) = selectionManager.selectionState else {
            XCTFail()
            return
        }

        let nextIndexPath = IndexPath(item: endIndex.item + 1, section: endIndex.section)
        selectionManager.setSelectedIndexPath(nextIndexPath)

        XCTAssertEqual(selectionManager.endDate, endDate.adding(days: 1).startOfDay)

        guard case .range = selectionManager.selectionState else {
            XCTFail()
            return
        }

        // Test transition from ranged to single date and back
        let previousIndexPath = IndexPath(item: endIndex.item - 1, section: endIndex.section)
        selectionManager.setSelectedIndexPath(previousIndexPath)

        XCTAssertEqual(selectionManager.endDate, startDate.startOfDay)

        guard case .single = selectionManager.selectionState else {
            XCTFail()
            return
        }

        selectionManager.setSelectedIndexPath(nextIndexPath)

        XCTAssertEqual(selectionManager.endDate, endDate.adding(days: 1).startOfDay)

        guard case .range = selectionManager.selectionState else {
            XCTFail()
            return
        }
    }
}

// MARK: - DatePickerController

class MockCalendarViewStyleDataSource: CalendarViewStyleDataSource {
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, textStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> CalendarViewDayCellTextStyle {
        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, backgroundStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents
    ) -> CalendarViewDayCellBackgroundStyle {
        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, selectionStyleForDayWithStart dayStartDate: Date, end: Date) -> CalendarViewDayCellSelectionStyle {
        return .normal
    }
}
