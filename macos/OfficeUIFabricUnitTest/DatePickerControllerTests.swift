//
//  Copyright Microsoft Corporation
//

import XCTest
@testable import OfficeUIFabric

class DatePickerControllerTests: XCTestCase {
	
	var calendar: Calendar!
	
	var delegateCalled = false
	
	override func setUp() {
		super.setUp()
		
		calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en_US")
	}
	
	func testMonthIncrementing () {
		let controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		guard let datePickerView = controller.view as? DatePickerView else {
			return
		}
		
		// Simple month increment
		var components1 = DateComponents(year: 1994, month: 5, day: 11)
		var components2 = DateComponents(year: 1994, month: 6, day: 11)
		
		var date1 = calendar.date(from: components1)!
		var date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, nextMonthFor: date1), date2)
		
		// First date has a day that doesn't exit in the next month
		components1 = DateComponents(year: 2019, month: 1, day: 31)
		components2 = DateComponents(year: 2019, month: 2, day: 28)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, nextMonthFor: date1), date2)
		
		components1 = DateComponents(year: 2019, month: 3, day: 31)
		components2 = DateComponents(year: 2019, month: 4, day: 30)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, nextMonthFor: date1), date2)
		
		// Edge cases
		components1 = DateComponents(year: 2019, month: 4, day: 30)
		components2 = DateComponents(year: 2019, month: 5, day: 30)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, nextMonthFor: date1), date2)
		
		components1 = DateComponents(year: 2019, month: 1, day: 1)
		components2 = DateComponents(year: 2019, month: 2, day: 1)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, nextMonthFor: date1), date2)
	}
	
	func testMonthDecrementing () {
		let controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		guard let datePickerView = controller.view as? DatePickerView else {
			return
		}
		
		// Simple month decrement
		var components1 = DateComponents(year: 1994, month: 6, day: 11)
		var components2 = DateComponents(year: 1994, month: 5, day: 11)
		
		var date1 = calendar.date(from: components1)!
		var date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, previousMonthFor: date1), date2)
		
		// First date has a day that doesn't exit in the previous month
		components1 = DateComponents(year: 2019, month: 3, day: 31)
		components2 = DateComponents(year: 2019, month: 2, day: 28)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, previousMonthFor: date1), date2)
		
		components1 = DateComponents(year: 2019, month: 5, day: 31)
		components2 = DateComponents(year: 2019, month: 4, day: 30)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, previousMonthFor: date1), date2)
		
		// Edge cases
		components1 = DateComponents(year: 2019, month: 4, day: 30)
		components2 = DateComponents(year: 2019, month: 3, day: 30)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, previousMonthFor: date1), date2)
		
		components1 = DateComponents(year: 2019, month: 2, day: 1)
		components2 = DateComponents(year: 2019, month: 1, day: 1)
		
		date1 = calendar.date(from: components1)!
		date2 = calendar.date(from: components2)!
		
		XCTAssertEqual(controller.datePicker(datePickerView, previousMonthFor: date1), date2)
	}
	
	func testWeekdays () {
		// In Slovak locale, weekdays should be localized and start on a monday ("po")
		calendar.locale = Locale(identifier: "sk_SK")
		
		var controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		var expectedShortWeekdays = ["po", "ut", "st", "št", "pi", "so", "ne"]
		var expectedLongWeekdays = ["pondelok", "utorok", "streda", "štvrtok", "piatok", "sobota", "nedeľa"]
		
		XCTAssertEqual(controller.shortWeekdays, expectedShortWeekdays)
		XCTAssertEqual(controller.longWeekdays, expectedLongWeekdays)
		
		// US English locale, weekdays should be localized and start on a sunday
		calendar.locale = Locale(identifier: "en_US")
		controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		expectedShortWeekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		expectedLongWeekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
		
		XCTAssertEqual(controller.shortWeekdays, expectedShortWeekdays)
		XCTAssertEqual(controller.longWeekdays, expectedLongWeekdays)
	}
	
	func testPaddedDays () {
		var controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		guard let datePickerView = controller.view as? DatePickerView else {
			return
		}
		
		let components = DateComponents(year: 2019, month: 5, day: 11)
		let date = calendar.date(from: components)!
		
		var paddedDays = controller.datePicker(datePickerView, paddedDaysFor: date)
		
		// Date counts for May 2019 should be 3 + 31 + 8 = 42
		XCTAssertEqual(paddedDays.previousMonthDays.count, 3)
		XCTAssertEqual(paddedDays.currentMonthDays.count, 31)
		XCTAssertEqual(paddedDays.nextMonthDays.count, 8)
		
		// First day should be 28th
		var dayComponent = calendar.component(.day, from: paddedDays.previousMonthDays[0].date)
		XCTAssertEqual(dayComponent, 28)
		
		// Months should be correct and consistent within each array
		paddedDays.previousMonthDays.forEach { day in
			let month = calendar.component(.month, from: day.date)
			XCTAssertEqual(month, 4)
		}
		
		paddedDays.currentMonthDays.forEach { day in
			let month = calendar.component(.month, from: day.date)
			XCTAssertEqual(month, 5)
		}
		
		paddedDays.nextMonthDays.forEach { day in
			let month = calendar.component(.month, from: day.date)
			XCTAssertEqual(month, 6)
		}
		
		// Next month should start on the 1st
		let firstDay = calendar.component(.day, from: paddedDays.nextMonthDays[0].date)
		XCTAssertEqual(firstDay, 1)
		
		// Padded dates should change based on the locale (sk_SK week starts on a sunday, so the calendar grid will be shifted)
		calendar.locale = Locale(identifier: "sk_SK")
		controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		paddedDays = controller.datePicker(datePickerView, paddedDaysFor: date)
		
		// Date counts for May 2019 should be 2 + 31 + 9 = 42
		XCTAssertEqual(paddedDays.previousMonthDays.count, 2)
		XCTAssertEqual(paddedDays.currentMonthDays.count, 31)
		XCTAssertEqual(paddedDays.nextMonthDays.count, 9)
		
		// First day should be 29th
		dayComponent = calendar.component(.day, from: paddedDays.previousMonthDays[0].date)
		XCTAssertEqual(dayComponent, 29)
	}
	
	func testDateExtensionInBetween () {
		calendar.locale = Locale(identifier: "en_US")
		
		let components1 = DateComponents(year: 2019, month: 5, day: 3)
		let components2 = DateComponents(year: 2019, month: 5, day: 28)
		
		let date1 = calendar.date(from: components1)!
		let date2 = calendar.date(from: components2)!
		
		let compBetween = DateComponents(year: 2019, month: 5, day: 11)
		let dateBetween = calendar.date(from: compBetween)!
		
		XCTAssertTrue(dateBetween.isBetween(date1, and: date2))
		
		// Order of interval endpoints should not matter
		XCTAssertTrue(dateBetween.isBetween(date2, and: date1))
		
		let compOutside = DateComponents(year: 2020, month: 1, day: 1)
		let dateOutside = calendar.date(from: compOutside)!
		
		XCTAssertFalse(dateOutside.isBetween(date1, and: date2))
		XCTAssertFalse(dateOutside.isBetween(date2, and: date1))
		
		// Date interval should be inclusive on both sides
		XCTAssertTrue(date1.isBetween(date1, and: date2))
		XCTAssertTrue(date2.isBetween(date1, and: date2))
		XCTAssertTrue(date1.isBetween(date2, and: date1))
		XCTAssertTrue(date2.isBetween(date2, and: date1))
		
		// Time of day should be taken into account
		let dateOutByHour = calendar.date(byAdding: .hour, value: 1, to: date2)!
		
		XCTAssertFalse(dateOutByHour.isBetween(date1, and: date2))
		XCTAssertFalse(dateOutByHour.isBetween(date2, and: date1))
		
		let dateOutBySecond = calendar.date(byAdding: .second, value: -1, to: date1)!
		
		XCTAssertFalse(dateOutBySecond.isBetween(date1, and: date2))
		XCTAssertFalse(dateOutBySecond.isBetween(date2, and: date1))
	}
	
	func testDateExtensionCombine () {
		let dateComponents = DateComponents(year: 2019, month: 5, day: 11)
		let timeComponents = DateComponents(hour: 9, minute: 35, second: 42)
		let combinedComponents = DateComponents(year: 2019, month: 5, day: 11, hour: 9, minute: 35, second: 42)
		
		let datePart = calendar.date(from: dateComponents)!
		let timePart = calendar.date(from: timeComponents)!
		let combinedDate = calendar.date(from: combinedComponents)!
		
		XCTAssertEqual(datePart.combine(withTime: timePart, using: calendar), combinedDate)
		
		// Time components in date part should be ignored
		let datePartWithTimeComponents = DateComponents(year: 2019, month: 5, day: 11, hour: 8, minute: 22, second: 22)
		let dateTimePart = calendar.date(from: datePartWithTimeComponents)!
		
		XCTAssertEqual(dateTimePart.combine(withTime: timePart, using: calendar), combinedDate)
		
		// Date components in time part should be ignored
		let timePartWithDateComponents = DateComponents(year: 1994, month: 4, day: 2, hour: 9, minute: 35, second: 42)
		let timeWithDate = calendar.date(from: timePartWithDateComponents)!
		
		XCTAssertEqual(datePart.combine(withTime: timeWithDate, using: calendar), combinedDate)
	}
	
	func testCalendarExtensionEndOfDay () {
		let components = DateComponents(year: 2019, month: 5, day: 11, hour: 9, minute: 24)
		let endOfDayComponents = DateComponents(year: 2019, month: 5, day: 11, hour: 23, minute: 59, second: 59)
		
		let date = calendar.date(from: components)!
		let endOfDayDate = calendar.date(from: endOfDayComponents)!
		
		XCTAssertEqual(calendar.endOfDay(for: date), endOfDayDate)
	}
	
	func testCalendarExtensionStartOfMonth () {
		let components = DateComponents(year: 2019, month: 5, day: 11, hour: 7, minute: 55, second: 24)
		let startComponents = DateComponents(year: 2019, month: 5, day: 1, hour: 0, minute: 0, second: 0)
		
		let date = calendar.date(from: components)!
		let startDate = calendar.date(from: startComponents)!
		
		XCTAssertEqual(calendar.startOfMonth(for: date), startDate)
	}
	
	func testCalendarExtensionEndOfMonth () {
		let components = DateComponents(year: 2019, month: 5, day: 11, hour: 7, minute: 55, second: 24)
		let endComponents = DateComponents(year: 2019, month: 5, day: 31, hour: 23, minute: 59, second: 59)
		
		let date = calendar.date(from: components)!
		let endDate = calendar.date(from: endComponents)!
		
		XCTAssertEqual(calendar.endOfMonth(for: date), endDate)
	}
	
	func testChineseSecondaryCalendar () {
		let controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		guard let datePickerView = controller.view as? DatePickerView else {
			return
		}
				
		// Chinese lunar calendar with zh locale
		var chineseCalendar = Calendar(identifier: .chinese)
		chineseCalendar.locale = Locale(identifier: "zh")
		
		controller.secondaryCalendar = chineseCalendar
		
		let components = DateComponents(year: 2019, month: 5, day: 11)
		let date = calendar.date(from: components)!
		
		let days = controller.datePicker(datePickerView, paddedDaysFor: date)
		
		// All days should have a secondary label
		[days.previousMonthDays, days.currentMonthDays, days.nextMonthDays].joined().forEach {
			XCTAssertNotNil($0.secondaryLabel)
		}
		
		// Secondary labels should use the correct chinese characters
		XCTAssertEqual(days.currentMonthDays[0].secondaryLabel, "廿七")
		XCTAssertEqual(days.currentMonthDays[4].secondaryLabel, "初一")
		XCTAssertEqual(days.currentMonthDays[30].secondaryLabel, "廿七")
		XCTAssertEqual(days.currentMonthDays[29].secondaryLabel, "廿六")
		
		
		// Chinese lunar calendar with en_US locale
		var chineseCalendarUSLocale = Calendar(identifier: .chinese)
		chineseCalendarUSLocale.locale = Locale(identifier: "en_US")
		
		controller.secondaryCalendar = chineseCalendarUSLocale
		
		let days2 = controller.datePicker(datePickerView, paddedDaysFor: date)
		
		// All days should have a secondary label
		[days2.previousMonthDays, days2.currentMonthDays, days2.nextMonthDays].joined().forEach {
			XCTAssertNotNil($0.secondaryLabel)
		}
		
		// Secondary labels should use arabic numerals
		XCTAssertEqual(days2.currentMonthDays[0].secondaryLabel, "27")
		XCTAssertEqual(days2.currentMonthDays[4].secondaryLabel, "1")
		XCTAssertEqual(days2.currentMonthDays[30].secondaryLabel, "27")
		XCTAssertEqual(days2.currentMonthDays[29].secondaryLabel, "26")
	}
	
	func testTextFieldFlag() {
		let controller = DatePickerController(calendar: calendar, style: .dateTime)

		// Text date picker should be present by default
		XCTAssertTrue(controller.hasTextField)
		
		let sizeWithTextPicker = controller.view.fittingSize
		
		controller.hasTextField = false
		let sizeWithoutTextPicker = controller.view.fittingSize
		
		XCTAssertFalse(controller.hasTextField)
		// Height with the text date picker should be higher than without and width should stay the same
		XCTAssertTrue(sizeWithTextPicker.height > sizeWithoutTextPicker.height)
		XCTAssertTrue(sizeWithoutTextPicker.width == sizeWithTextPicker.width)
	}
}

extension DatePickerControllerTests: DatePickerControllerDelegate {
	
	func testSetDate () {
		let controller = DatePickerController(calendar: calendar, style: .dateTime)
		
		controller.delegate = self
		
		let components = DateComponents(year: 2019, month: 5, day: 11, hour: 20, minute: 10, second: 9)
		let date = calendar.date(from: components)!
		
		controller.date = date
		
		// We should have nothing from the delegate, but the correct date should be set.
		XCTAssertFalse(delegateCalled)
		XCTAssertEqual(controller.date, date)
	}
	
	func datePickerController(_ controller: DatePickerController, didSelectDate date: Date) {
		delegateCalled = true
	}
}
