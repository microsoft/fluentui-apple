//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class MSDatePickerControllerTests: XCTestCase {
    static let testDateInterval: TimeInterval = 1551903381

    let startDate = Date(timeIntervalSince1970: MSDatePickerControllerTests.testDateInterval)
    let endDate = Date(timeIntervalSince1970: MSDatePickerControllerTests.testDateInterval).adding(days: 1)

    func testDateRangeInit() {
        let datePicker = MSDatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, rangePresentation: .paged, titles: nil)
        XCTAssertEqual(datePicker.startDate, startDate.startOfDay)
        XCTAssertEqual(datePicker.endDate, endDate.startOfDay)
    }

    func testDateRangeStart() {
        let datePicker = MSDatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, rangePresentation: .paged, titles: nil)
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
        let datePicker = MSDatePickerController(startDate: startDate, endDate: endDate, mode: .dateRange, selectionMode: .end, rangePresentation: .paged, titles: nil)
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
        let dataSource = CalendarViewDataSource(styleDataSource: MockMSCalendarViewStyleDataSource())
        let selectionManager = MSDatePickerSelectionManager(
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

// MARK: - MSDatePickerController

class MockMSCalendarViewStyleDataSource: CalendarViewStyleDataSource {
    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, textStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents) -> MSCalendarViewDayCellTextStyle {
        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, backgroundStyleForDayWithStart dayStartDate: Date, end: Date, dayStartComponents: DateComponents, todayComponents: DateComponents
        ) -> MSCalendarViewDayCellBackgroundStyle {
        if dayStartComponents.dateIsTodayOrLater(todayDateComponents: todayComponents) {
            return .primary
        } else {
            return .secondary
        }
    }

    func calendarViewDataSource(_ dataSource: CalendarViewDataSource, selectionStyleForDayWithStart dayStartDate: Date, end: Date) -> MSCalendarViewDayCellSelectionStyle {
        return .normal
    }
}
