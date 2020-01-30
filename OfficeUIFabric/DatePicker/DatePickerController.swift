//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
	
	static let calendarGridDayCount = 42
	
	private init() {}
}

@objc(MSFDatePickerController)
open class DatePickerController: NSViewController {
	
	/// Initializes the date picker controller with starting date, calendar, and style.
	///
	/// - Parameters:
	///   - date: The initial date selection.
	///   - calendar: The calendar that will be used as the data source.
	///   - style: The date picker style.
	@objc public init(date: Date? = nil, calendar: Calendar? = nil, style: DatePickerStyle) {
		self.calendar = calendar ?? Calendar.current
		selectedDateTime = date ?? Date()
		datePicker = DatePickerView(style: style)
		visibleRange = (first: self.calendar.startOfMonth(for: selectedDateTime), last: self.calendar.endOfMonth(for: selectedDateTime))
		super.init(nibName: nil, bundle: nil)
		
		datePicker.delegate = self
		datePicker.dataSource = self
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func loadView() {
		view = datePicker
	}
	
	/// The currently selected date and time
	@objc public var date: Date {
		get {
			return selectedDateTime
		}
		set {
			handleDateTimeSelection(of: newValue, shouldNotifyDelegate: false)
		}
	}
	
	/// The date picker controller's delegate
	@objc public weak var delegate: DatePickerControllerDelegate?
	
	/// A custom color override for the selected date of this date picker
	/// - note: Setting this to nil results in using a default color
	@objc public var customSelectionColor: NSColor? {
		didSet {
			datePicker.customSelectionColor = customSelectionColor
		}
	}
	
	/// When enabled, a day is automatically selected every time the user pages to a new month.
	///	The day number will be the same as the previously selected day.
	/// In case the day does not exist in the visible month, the last day of the visible month is selected instead.
	@objc public var autoSelectWhenPaging: Bool = true {
		didSet {
			guard autoSelectWhenPaging && !isInVisibleRange(date: selectedDate) else {
				return
			}
			
			let newDate = generateDateInVisibleRange(from: selectedDate)
			handleDateOnlySelection(of: newDate)
		}
	}
	
	/// When enabled, padding will be added to the edges of the date picker view.
	/// Should be used when the date picker is presented in a way that doesn't allow for modification of insets, like in NSPopover.
	@objc public var hasEdgePadding: Bool {
		get {
			return datePicker.hasEdgePadding
		}
		set {
			datePicker.hasEdgePadding = newValue
		}
	}
	
	/// Indicates whether the text input field is displayed
	@objc public var hasTextField: Bool {
		get {
			return datePicker.hasTextField
		}
		set {
			datePicker.hasTextField = newValue
		}
	}
	
	/// Currently selected date
	var selectedDate: Date {
		return calendar.startOfDay(for: selectedDateTime)
	}
	
	/// Internal storage of the currently selected date and time
	private(set) var selectedDateTime: Date
	
	/// First and last day of the month that is currently visible.
	private(set) var visibleRange: (first: Date, last: Date) {
		didSet {
			assert(
				visibleRange.first == calendar.startOfMonth(for: visibleRange.first),
				"First date of visible range is not set to start of month.")
			assert(
				visibleRange.last == calendar.endOfMonth(for: visibleRange.last),
				"Last date of visible range is not set to end of month")
		}
	}
	
	/// Internal storage of the date picker view.
	private let datePicker: DatePickerView
	
	/// Internal storage of the current calendar
	let calendar: Calendar
	
	/// Storage of the secondary calendar
	public var secondaryCalendar: Calendar? {
		didSet {
			secondaryDayFormatter = secondaryCalendar.map { dayFormatter(for: $0) }
			datePicker.refresh()
		}
	}
	
	/// Checks if the given date is in the currently visible range
	private func isInVisibleRange(date: Date) -> Bool {
		let startOfDay = calendar.startOfDay(for: date)
		return startOfDay.isBetween(visibleRange.first, and: visibleRange.last)
	}
	
	/// Updates the visible range using the given date.
	///
	/// - Parameter date: The given date.
	private func updateVisibleRange(with date: Date) {
		guard !isInVisibleRange(date: date) else {
			return
		}
		
		visibleRange = (first: calendar.startOfMonth(for: date), last: calendar.endOfMonth(for: date))
	}
	
	/// Handles date selection while preserving the currently selected time.
	///
	/// - Parameter date: The selected date.
	private func handleDateOnlySelection(of date: Date) {
		let startOfDate = calendar.startOfDay(for: date)
		let combinedDate = startOfDate.combine(withTime: selectedDateTime, using: calendar) ?? startOfDate
		
		handleDateTimeSelection(of: combinedDate, shouldNotifyDelegate: true)
	}
	
	/// Handles date and time selection.
	///
	/// - Parameter date: The selected date.
	/// - Parameter shouldNotifyDelegate: Indicates whether the delegate should be notified of this change.
	private func handleDateTimeSelection(of date: Date, shouldNotifyDelegate: Bool) {
		selectedDateTime = date
		
		if (isInVisibleRange(date: date)) {
			datePicker.updateSelection()
		} else {
			handleOutOfRangeSelection(of : date)
		}
		
		if shouldNotifyDelegate {
			delegate?.datePickerController?(self, didSelectDate: selectedDateTime)
		}
	}
	
	/// Handles selection of date that is out of the visible range.
	/// This could result in a scroll, if the date is in the next/previous month,
	/// or a refresh of the date picker if the date is further in the past/future.
	///
	/// - Parameter date: The selected date.
	private func handleOutOfRangeSelection(of date : Date) {
		let nextMonthStart = calendar.startOfMonth(for: calendar.date(byAdding: .month, value: 1, to: visibleRange.first) ?? visibleRange.first)
		let prevMonthStart = calendar.startOfMonth(for: calendar.date(byAdding: .month, value: -1, to: visibleRange.first) ?? visibleRange.first)
		
		let nextMonthEnd = calendar.endOfMonth(for: nextMonthStart)
		let prevMonthEnd = calendar.endOfMonth(for: prevMonthStart)
		
		updateVisibleRange(with: date)
		
		let startOfDay = calendar.startOfDay(for: date)
		
		if (startOfDay.isBetween(nextMonthStart, and: nextMonthEnd)) {
			datePicker.scrollToTrailing()
		} else if (startOfDay.isBetween(prevMonthStart, and: prevMonthEnd)) {
			datePicker.scrollToLeading()
		} else {
			datePicker.refresh()
		}
	}
	
	/// Generates a new date in currently visible range from the given date
	/// Tries to find a date with the same day number as the given date. If this is
	/// not available, it will find the closest one.
	/// - Parameter date: The date that the desired day is taken from.
	private func generateDateInVisibleRange(from date: Date) -> Date {
		let day = calendar.component(.day, from: date)
		var returnDate = calendar.date(bySetting: .day, value: day, of: visibleRange.first) ?? date
		
		if calendar.component(.day, from: returnDate) != day || calendar.component(.month, from: returnDate) != calendar.component(.month, from: visibleRange.first) {
			// It must be the case that the desired day exceeds the currently visible range.
			returnDate = visibleRange.last
		}
		
		return returnDate
	}
	
	/// Generates a DateFormatter for day labels.
	/// - Parameter calendar: The calendar that the DateFormatter should use
	private func dayFormatter(for calendar: Calendar) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.calendar = calendar
		formatter.locale = calendar.locale
		
		// In this case, we want to use Chinese numerals instead of western
		// Setting dateStyle to .long before setting the dateFormat will achieve this
		if calendar.identifier == .chinese && calendar.locale?.languageCode == "zh" {
			formatter.dateStyle = .long
		}
		
		formatter.dateFormat = "d"
		
		return formatter
	}
	
	/// Formatter used to generate primary calendar day strings
	private lazy var primaryDayFormatter = self.dayFormatter(for: calendar)
	
	/// Formatter used to generate day strings used in accessibility scenarios like VoiceOver
	private lazy var accessibilityDayFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = calendar
		dateFormatter.locale = calendar.locale
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		
		return dateFormatter
	}()
	
	/// Formatter used to generate secondary calendar day strings
	private var secondaryDayFormatter: DateFormatter?
}

extension DatePickerController: DatePickerViewDelegate {
	
	/// Decides whether a given button should be highlighted.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - button: The calendar day button.
	/// - Returns: True if the button should highlight.
	func datePicker(_ datePicker: DatePickerView, shouldHighlightButton button: CalendarDayButton) -> Bool {
		return button.day.date == selectedDate
	}
	
	/// Handles date only selection coming from the date picker view.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - date: The selected date. The time components will be discarded.
	func datePicker(_ datePicker: DatePickerView, didSelectDate date: Date) {
		handleDateOnlySelection(of: date)
	}
	
	/// Handles date + time selection coming from the date picker view.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - date: The selected date.
	func datePicker(_ datePicker: DatePickerView, didSelectDateTime date: Date) {
		handleDateTimeSelection(of: date, shouldNotifyDelegate: true)
	}
	
	/// Advances the displayed month by 1.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - button: The button that was pressed.
	func datePicker(_ datePicker: DatePickerView, didPressNext button: NSButton) {
		advanceMonth(by: 1)
	}
	
	/// Advances the displayed month by -1.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - button: The button that was pressed.
	func datePicker(_ datePicker: DatePickerView, didPressPrevious button: NSButton) {
		advanceMonth(by: -1)
	}
	
	/// Advances the date picker by the given number of months.
	/// - Parameter months: The number of months.
	private func advanceMonth(by months: Int) {
		let newDate = calendar.date(byAdding: .month, value: months, to: visibleRange.first) ?? visibleRange.first
		
		updateVisibleRange(with: newDate)
		
		switch months {
		case 1:
			datePicker.scrollToTrailing()
		case -1:
			datePicker.scrollToLeading()
		default:
			datePicker.refresh()
		}
		
		if autoSelectWhenPaging && !isInVisibleRange(date: selectedDate) {
			let newDate = generateDateInVisibleRange(from: selectedDate)
			handleDateOnlySelection(of: newDate)
		}
	}
}

extension DatePickerController: DatePickerViewDataSource {
	
	/// Returns all dates that should be displayed in a calendar view for a single month.
	/// This includes some days from the previous and next month to ensure that the days
	/// are correctly aligned with the weekday columns.
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - date: The given date, only month and year are considered.
	/// - Returns: All dates in the month of the given date, padded by days from previous and next month.
	func datePicker(_ datePicker : DatePickerView, paddedDaysFor date : Date) -> PaddedCalendarDays {
		var dateComponents = calendar.dateComponents([.month, .year], from: date)
		dateComponents.weekday = calendar.firstWeekday
		dateComponents.weekdayOrdinal = 1
		
		// First day displayed in the calendar. This could be in the previous month and depends on the locale (first weekday)
		var firstDay = calendar.startOfDay(for: calendar.date(from: dateComponents)!)
		
		// Make sure first displayed week contains the first day of the current month
		if (calendar.component(.day, from: firstDay) > 1) {
			firstDay = calendar.date(byAdding: .weekOfMonth, value: -1, to: firstDay) ?? firstDay
		}
		
		let allDates = (0..<Constants.calendarGridDayCount).map {
			calendar.date(byAdding: .day, value: $0, to: firstDay)!
		}
		
		let currentMonthComponent = calendar.component(.month, from: date)
		let nextMonthComponent = calendar.component(.month, from: calendar.date(byAdding: .month, value:1, to: date)!)
		
		let firstIndexOfCurrentMonth = allDates.firstIndex {
			calendar.component(.month, from: $0) == currentMonthComponent
			} ?? allDates.startIndex
		
		let firstIndexOfNextMonth = allDates.firstIndex {
			calendar.component(.month, from: $0) == nextMonthComponent
			} ?? allDates.endIndex
		
		let prevMonthDays = allDates[allDates.startIndex..<firstIndexOfCurrentMonth].map { calendarDay(for: $0) }
		let currentMonthDays = allDates[firstIndexOfCurrentMonth..<firstIndexOfNextMonth].map { calendarDay(for: $0) }
		let nextMonthDays = allDates[firstIndexOfNextMonth..<allDates.endIndex].map { calendarDay(for: $0) }
		
		return PaddedCalendarDays(previousMonthDays: prevMonthDays, currentMonthDays: currentMonthDays, nextMonthDays: nextMonthDays)
	}
	
	/// Returns a date that is one month in the past from the given date.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - date: The given date.
	/// - Returns: A date one month in the past from the given date.
	func datePicker(_ datePicker: DatePickerView, previousMonthFor date: Date) -> Date? {
		return calendar.date(byAdding: .month, value: -1, to: date)
	}
	
	/// Returns a date that is one month in the future from the given date.
	///
	/// - Parameters:
	///   - datePicker: The date picker view.
	///   - date: The given date.
	/// - Returns: A date one month in the future from the given date.
	func datePicker(_ datePicker: DatePickerView, nextMonthFor date: Date) -> Date? {
		return calendar.date(byAdding: .month, value: 1, to: date)
	}
	
	/// List of short weekday labels, correctly ordered and localized.
	var shortWeekdays: [String] {
		get {
			let weekdaySymbols = calendar.shortWeekdaySymbols
			return rotateWeekdays(weekdaySymbols)
		}
	}
	
	/// List of long weekday labels, correctly ordered and localized.
	var longWeekdays: [String] {
		get {
			let weekdaySymbols = calendar.standaloneWeekdaySymbols
			return rotateWeekdays(weekdaySymbols)
		}
	}
	
	/// Rotates the given ordered array of weekdays that starts on a Sunday to
	/// start on the correct first weekday according to the calendar.
	///
	/// - Parameter weekdays: The given weekday array.
	/// - Returns: The rotated weekday array.
	private func rotateWeekdays(_ weekdays: [String]) -> [String] {
		let firstWeekday = calendar.firstWeekday
		
		// We don't always start at index 0, first weekday depends on the locale
		return (0..<weekdays.count).map { day -> String in
			let dayIndex = (firstWeekday - 1 + day) % weekdays.count
			return weekdays[dayIndex]
		}
	}
	
	/// Creates a CalendarDay given a date. Identifiers are generated using the available calendars.
	/// - Parameter date: The given date.
	private func calendarDay(for date: Date) -> CalendarDay {
		return CalendarDay(
			date: date,
			primaryLabel: primaryDayFormatter.string(from: date),
			accessibilityLabel: accessibilityDayFormatter.string(from: date),
			secondaryLabel: secondaryDayFormatter?.string(from: date))
	}
}

extension Date {
	
	/// Check if the date is between date1 and date2 (inclusive).
	///
	/// - Parameters:
	///   - date1: The first date.
	///   - date2: The second date.
	/// - Returns: True if the date is in the given interval.
	func isBetween(_ date1: Date, and date2: Date) -> Bool {
		return (min(date1, date2) ... max(date1, date2)).contains(self)
	}
	
	/// Combines the year/month/day components from the date this was called on,
	/// with hour/minute/second components from the given date.
	///
	/// - Parameters:
	///   - time: The date that the hour/minute/second components will be used from.
	///   - calendar: The calendar that should be used for the date operations.
	/// - Returns: The combined date.
	func combine(withTime time: Date, using calendar: Calendar?) -> Date? {
		let calendar = calendar ?? Calendar.current
		
		var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
		let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
		
		dateComponents.hour = timeComponents.hour
		dateComponents.minute = timeComponents.minute
		dateComponents.second = timeComponents.second
		
		return calendar.date(from: dateComponents)
	}
}

extension Calendar {
	
	/// Calculates end of the day that the given date is in.
	///
	/// - Parameter date: The given date.
	/// - Returns: End of the day that the given date is in.
	func endOfDay(for date: Date) -> Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		
		let start = startOfDay(for: date)
		
		return self.date(byAdding: components, to: start)!
	}
	
	/// Calculates start of the month that the given date is in.
	///
	/// - Parameter date: The given date.
	/// - Returns: Start of the month that the given date is in.
	func startOfMonth(for date: Date) -> Date {
		let components = dateComponents([.month, .year], from: date)
		
		return self.date(from: components)!
	}
	
	/// Calculates end of the month that the given date is in.
	///
	/// - Parameter date: The given date.
	/// - Returns: End of the month that the given date is in.
	func endOfMonth(for date: Date) -> Date {
		var components = DateComponents()
		components.month = 1
		components.second = -1
		
		let start = startOfMonth(for: date)
		
		return self.date(byAdding: components, to: start)!
	}
}

@objc(MSFDatePickerControllerDelegate)
public protocol DatePickerControllerDelegate : class {
	
	/// Tells the delegate that a new date was selected.
	///
	/// - Parameters:
	///   - controller: The date picker controller.
	///   - didSelectDate: The new date.
	@objc optional func datePickerController(_ controller : DatePickerController, didSelectDate : Date)
}

@objc(MSFDatePickerStyle)
public enum DatePickerStyle: Int {
	case date
	case dateTime
}
