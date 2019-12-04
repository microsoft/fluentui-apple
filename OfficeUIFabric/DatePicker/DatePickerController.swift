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
        
        super.init(nibName: nil, bundle: nil)
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        updateVisibleRange(with: selectedDate)
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
            handleDateTimeSelection(of: newValue)
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

    /// Currently selected date
    var selectedDate: Date {
        return calendar.startOfDay(for: selectedDateTime)
    }
    
    /// Internal storage of the currently selected date and time
    private(set) var selectedDateTime: Date
    
    /// Internal storage of the date picker view.
    private let datePicker: DatePickerView
    
    /// First and last day of the month that the currently selected date is in.
    private var visibleRange = (first: Date(), last: Date()) {
        didSet {
            assert(
                visibleRange.first == calendar.startOfMonth(for: visibleRange.first),
                "First date of visible range is not set to start of month.")
            assert(
                visibleRange.last == calendar.endOfMonth(for: visibleRange.last),
                "Last date of visible range is not set to end of month")
        }
    }
    
    /// Internal storage of the current calendar
    private(set) var calendar: Calendar
    
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
        
        handleDateTimeSelection(of: combinedDate)
    }
    
    /// Handles date and time selection.
    ///
    /// - Parameter date: The selected date.
    private func handleDateTimeSelection(of date: Date) {
        selectedDateTime = date
        
        if (isInVisibleRange(date: date)) {
            datePicker.updateSelection()
        } else {
            handleOutOfRangeSelection(of : date)
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
}

extension DatePickerController: DatePickerViewDelegate {
    
    /// Decides whether a given button should be highlighted.
    ///
    /// - Parameters:
    ///   - datePicker: The date picker view.
    ///   - button: The calendar day button.
    /// - Returns: True if the button should highlight.
    func datePicker(_ datePicker: DatePickerView, shouldHighlightButton button: CalendarDayButton) -> Bool {
        return button.date == selectedDate
    }
    
    /// Handles date only selection coming from the date picker view.
    ///
    /// - Parameters:
    ///   - datePicker: The date picker view.
    ///   - date: The selected date. The time components will be discarded.
    func datePicker(_ datePicker: DatePickerView, didSelectDate date: Date) {
        handleDateOnlySelection(of: date)
        delegate?.datePickerController?(self, didSelectDate: selectedDateTime)
    }
    
    /// Handles date + time selection coming from the date picker view.
    ///
    /// - Parameters:
    ///   - datePicker: The date picker view.
    ///   - date: The selected date.
    func datePicker(_ datePicker: DatePickerView, didSelectDateTime date: Date) {
        handleDateTimeSelection(of: date)
        delegate?.datePickerController?(self, didSelectDate: selectedDateTime)
    }
    
    /// Selects date that is one month from the currently selected date.
    ///
    /// - Parameters:
    ///   - datePicker: The date picker view.
    ///   - button: The button that was pressed.
    func datePicker(_ datePicker: DatePickerView, didPressNext button: NSButton) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
    
        handleDateOnlySelection(of: nextMonth)
        delegate?.datePickerController?(self, didSelectDate: selectedDateTime)
    }
    
    /// Selects date that is one month in the past from the currently selected date.
    ///
    /// - Parameters:
    ///   - datePicker: The date picker view.
    ///   - button: The button that was pressed.
    func datePicker(_ datePicker: DatePickerView, didPressPrevious button: NSButton) {
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        
        handleDateOnlySelection(of: previousMonth)
        delegate?.datePickerController?(self, didSelectDate: selectedDateTime)
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
    func datePicker(_ datePicker : DatePickerView, paddedDatesFor date : Date) -> PaddedCalendarDates {
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
        
        let prevMonthDates = Array(allDates[allDates.startIndex..<firstIndexOfCurrentMonth])
        let currentMonthDates = Array(allDates[firstIndexOfCurrentMonth..<firstIndexOfNextMonth])
        let nextMonthDates = Array(allDates[firstIndexOfNextMonth..<allDates.endIndex])
        
        return PaddedCalendarDates(previousMonthDates: prevMonthDates, currentMonthDates: currentMonthDates, nextMonthDates: nextMonthDates)
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
