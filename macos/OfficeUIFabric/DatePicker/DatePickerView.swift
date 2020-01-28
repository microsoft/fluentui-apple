//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
	
	/// Width of the view
	static let width: CGFloat = 250
	
	/// Height of the view
	static let height: CGFloat = 310
	
	/// Bottom margin of the header view
	static let headerBottomMargin: CGFloat = 5.0
	
	/// Bottom margin of the calendar view
	static let calendarBottomMargin: CGFloat = 10.0
	
	/// Default background color of the view
	static let backgroundColor: NSColor = NSColor.white
	
	/// Duration of one page scroll animation
	static let pageScrollAnimationDuration: Double = 0.15
	
	/// Background color of the text date picker
	static var textDatePickerBackgroundColor: NSColor {
		return NSColor.systemGray.withAlphaComponent(0.3)
	}
	
	/// Corner radius of the text date picker
	static let textDatePickerCornerRadius: CGFloat = 2.0
	
	/// Date formatter template for the header month-year label
	static let headerDateFormatterTemplate = "MMMM yyyy"
	
	private init() {}
}

class DatePickerView: NSView {
	
	/// Initializes the date picker view using the given style.
	///
	/// - Parameter style: Style of the date picker (date only or date + time)
	init(style: DatePickerStyle) {
		self.style = style
		
		super.init(frame: .zero)
		
		wantsLayer = true
		translatesAutoresizingMaskIntoConstraints = false
		
		let containerStackView = NSStackView()
		containerStackView.translatesAutoresizingMaskIntoConstraints = false
		containerStackView.orientation = .vertical
		containerStackView.distribution = .gravityAreas
		containerStackView.spacing = 0
		containerStackView.wantsLayer = true
		
		self.addSubview(containerStackView)
		containerStackView.addView(headerView, in: .top)
		containerStackView.addView(monthClipView, in: .top)
		containerStackView.addView(textDatePicker, in: .center)
		
		calendarStackView.translatesAutoresizingMaskIntoConstraints = false
		calendarStackView.detachesHiddenViews = false
		calendarStackView.orientation = .horizontal
		calendarStackView.distribution = .fillEqually
		calendarStackView.spacing = 0
		calendarStackView.wantsLayer = true
		calendarStackView.setViews([calendarViews.leading, calendarViews.center, calendarViews.trailing], in: .center)
		
		monthClipView.translatesAutoresizingMaskIntoConstraints = false
		monthClipView.addSubview(calendarStackView)
		
		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(equalToConstant: Constants.width),
			self.heightAnchor.constraint(equalToConstant: Constants.height),
			
			containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
			containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			headerView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
			headerView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
			headerView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
			headerView.bottomAnchor.constraint(equalTo: monthClipView.topAnchor, constant: -Constants.headerBottomMargin),
			
			monthClipView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
			monthClipView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
			monthClipView.bottomAnchor.constraint(equalTo: textDatePicker.topAnchor, constant: -Constants.calendarBottomMargin),
			
			calendarStackView.bottomAnchor.constraint(equalTo: monthClipView.bottomAnchor),
			calendarStackView.topAnchor.constraint(equalTo: monthClipView.topAnchor),
			calendarStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: -Constants.width),
			
			calendarViews.leading.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
			calendarViews.center.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
			calendarViews.trailing.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
		])
		
		headerView.delegate = self
		
		calendarViews.leading.delegate = self
		calendarViews.center.delegate = self
		calendarViews.trailing.delegate = self
		
		calendarViews.leading.isHidden = true
		calendarViews.trailing.isHidden = true
		
		textDatePicker.target = self
		textDatePicker.action = #selector(onTextDatePickerChange)
		
		// Accessibility
		setAccessibilityElement(!DatePickerView.accessibilityTemporarilyRestricted)
		setAccessibilityRole(.group)
		setAccessibilityLabel(NSLocalizedString(
			"DATEPICKER_ACCESSIBILITY_DATEPICKER_LABEL",
			tableName: "OfficeUIFabric",
			bundle: Bundle(for: DatePickerView.self),
			comment: ""
		))
		
		updateTextDatePicker()
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var intrinsicContentSize: NSSize {
		return NSSize(width: Constants.width, height: Constants.height)
	}
	
	/// Animates a scroll to the leading calendar view
	func scrollToLeading() {
		calendarViews.leading.isHidden = false
		
		if userInterfaceLayoutDirection == .leftToRight {
			scrollLeft()
		} else {
			scrollRight()
		}
	}
	
	/// Animates a scroll to the trailing calendar view
	func scrollToTrailing() {
		calendarViews.trailing.isHidden = false
		
		if userInterfaceLayoutDirection == .leftToRight {
			scrollRight()
		} else {
			scrollLeft()
		}
	}
	
	/// Refreshes the date picker using the latest data from the dataSource
	func refresh() {
		updateHeader()
		updateCalendarViews()
		updateHighlights()
		updateTextDatePicker()
	}
	
	/// Updates the displayed selection without doing a full refresh
	func updateSelection() {
		updateHighlights()
		
		if let dataSource = dataSource {
			textDatePicker.dateValue = dataSource.selectedDateTime
		}
	}
	
	/// The date picker view's delegate
	weak var delegate: DatePickerViewDelegate?
	
	/// The object that provides the calendar data
	weak var dataSource: DatePickerViewDataSource? {
		didSet {
			if let dataSource = dataSource {
				dateFormatter.calendar = dataSource.calendar
				dateFormatter.locale = dataSource.calendar.locale
				dateFormatter.setLocalizedDateFormatFromTemplate(Constants.headerDateFormatterTemplate)
			}
			refresh()
		}
	}
	
	/// Current style of the date picker (date/date+time)
	var style: DatePickerStyle {
		didSet {
			updateTextDatePicker()
		}
	}
	
	/// True if currently animating to a new month
	var isAnimating: Bool = false
	
	/// The custom color of the selected buttons of the CalendarView
	/// - note: Setting this to nil results in using a default color
	var customSelectionColor: NSColor? {
		didSet {
			[calendarViews.leading, calendarViews.center, calendarViews.trailing].forEach {
				$0.customSelectionColor = customSelectionColor
			}
		}
	}
	
	/// DateFormatter used to generate strings for the header label
	private let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .none
		dateFormatter.setLocalizedDateFormatFromTemplate(Constants.headerDateFormatterTemplate)
		
		return dateFormatter
	}()
	
	/// Internal storage of the CalendarHeaderView
	private let headerView: CalendarHeaderView = CalendarHeaderView()
	
	/// Internal storage of the view that clips calendarStackView to only show one month
	private let monthClipView = NSView()
	
	/// Internal storage of the calendarViews
	private var calendarViews = CalendarViewBuffer(leading: CalendarView(), center: CalendarView(), trailing: CalendarView()) {
		didSet {
			calendarViews.leading.isHidden = true
			calendarViews.trailing.isHidden = true
			calendarStackView.setViews([calendarViews.leading, calendarViews.center, calendarViews.trailing], in: .center)
		}
	}
	
	/// Internal storage of the stack view that holds the calendar views
	private let calendarStackView = NSStackView()
	
	/// Internal storage of the textual NSDatePicker
	private let textDatePicker: NSDatePicker = {
		let textDatePicker = NSDatePicker()
		textDatePicker.wantsLayer = true
		textDatePicker.datePickerStyle = .textField
		textDatePicker.drawsBackground = false
		textDatePicker.isBordered = false
		textDatePicker.layer?.backgroundColor = Constants.textDatePickerBackgroundColor.cgColor
		textDatePicker.layer?.cornerRadius = Constants.textDatePickerCornerRadius
		return textDatePicker
	}()
	
	/// Notifies the delegate of the new date/dateTime selection
	/// Called on any change to the textual date picker
	///
	/// - Parameter sender: NSDatePicker that triggered the change
	@objc private func onTextDatePickerChange(sender: NSDatePicker) {
		switch style {
		case .date:
			delegate?.datePicker(self, didSelectDate: sender.dateValue)
		case .dateTime:
			delegate?.datePicker(self, didSelectDateTime: sender.dateValue)
		}
	}
	
	/// Updates the header view using the data source
	private func updateHeader() {
		guard let dataSource = dataSource else {
			return
		}
		
		headerView.weekdayStrings = Array(zip(dataSource.shortWeekdays, dataSource.longWeekdays))
		headerView.monthYearLabel.stringValue = dateFormatter.string(from: dataSource.visibleRange.first)
	}
	
	/// Uses the data source to retrieve all the dates for the calendar views and displays them
	private func updateCalendarViews() {
		guard
			let dataSource = dataSource,
			let previousMonthDate = dataSource.datePicker(self, previousMonthFor: dataSource.visibleRange.first),
			let nextMonthDate = dataSource.datePicker(self, nextMonthFor: dataSource.visibleRange.first)
			else {
				return
		}
		
		let prevMonthPaddedDates = dataSource.datePicker(self, paddedDaysFor: previousMonthDate)
		calendarViews.leading.update(with: prevMonthPaddedDates)
		
		let currentMonthDayPaddedDates = dataSource.datePicker(self, paddedDaysFor: dataSource.visibleRange.first)
		calendarViews.center.update(with: currentMonthDayPaddedDates)
		
		let nextMonthPaddedDates = dataSource.datePicker(self, paddedDaysFor: nextMonthDate)
		calendarViews.trailing.update(with: nextMonthPaddedDates)
	}
	
	/// Updates the highlighted button in the center calendar view using the delegate
	private func updateHighlights() {
		let buttonViews = calendarViews.center.buttonViews
		
		for button in buttonViews {
			button.state = delegate?.datePicker(self, shouldHighlightButton: button) ?? false ? .on : .off
		}
	}
	
	/// Updates the text date picker using the current style and data source
	private func updateTextDatePicker() {
		switch style {
		case .date:
			textDatePicker.datePickerElements = [.yearMonthDay]
		case .dateTime:
			textDatePicker.datePickerElements = [.yearMonthDay, .hourMinute]
		}
		
		guard let dataSource = dataSource else {
			return
		}
		
		textDatePicker.calendar = dataSource.calendar
		textDatePicker.locale = dataSource.calendar.locale
		textDatePicker.dateValue = dataSource.selectedDateTime
	}
	
	/// Animates a scroll to the calendar view on the right
	private func scrollRight() {
		let newOrigin = NSPoint(x: monthClipView.bounds.minX + monthClipView.bounds.width, y: 0)
		scrollToPointAndRecenter(point: newOrigin, completionHandler: userInterfaceLayoutDirection == .leftToRight ? shiftToNextMonth : shiftToPreviousMonth)
	}
	
	/// Animates a scroll to the calendar view on the left
	private func scrollLeft() {
		let newOrigin = NSPoint(x: monthClipView.bounds.minX - monthClipView.bounds.width, y: 0)
		scrollToPointAndRecenter(point: newOrigin, completionHandler: userInterfaceLayoutDirection == .leftToRight ? shiftToPreviousMonth : shiftToNextMonth)
	}
	
	/// Scrolls the monthClipView bounds rectangle to the given point, resets its origin to .zero immediately afterwards, and calls the completion handler
	/// - Parameters:
	///   - point: The point that the clip view will animate to.
	///   - completionHandler: The handler that is called after the clip view recenters.
	private func scrollToPointAndRecenter(point: NSPoint, completionHandler: @escaping () -> ()) {
		isAnimating = true
		
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = Constants.pageScrollAnimationDuration
			monthClipView.animator().setBoundsOrigin(point)
		}, completionHandler: {
			self.isAnimating = false
			self.monthClipView.bounds.origin = .zero
			completionHandler()
		})
	}
	
	/// Rearranges the calendar views and reinitializes one of them to display the next month
	private func shiftToNextMonth() {
		guard let dataSource = dataSource else {
			return
		}
		
		// Shift center view to leading, trailing to center, and reuse the leading as the new trailing
		calendarViews = CalendarViewBuffer(leading: calendarViews.center, center: calendarViews.trailing, trailing: calendarViews.leading)
		
		let nextMonth = dataSource.datePicker(self, nextMonthFor: dataSource.visibleRange.first) ?? dataSource.visibleRange.first
		let paddedDates = dataSource.datePicker(self, paddedDaysFor: nextMonth)
		
		calendarViews.trailing.update(with: paddedDates)
		updateHeader()
		updateSelection()
	}
	
	/// Rearranges the calendar views and reinitializes one of them to display the previous month
	private func shiftToPreviousMonth() {
		guard let dataSource = dataSource else {
			return
		}
		
		// Shift leading calendar view to center, center to trailing, and reuse the trailing as the new leading
		calendarViews = CalendarViewBuffer(leading: calendarViews.trailing, center: calendarViews.leading, trailing: calendarViews.center)
		
		let prevMonth = dataSource.datePicker(self, previousMonthFor: dataSource.visibleRange.first) ?? dataSource.visibleRange.first
		let paddedDates = dataSource.datePicker(self, paddedDaysFor: prevMonth)
		
		calendarViews.leading.update(with: paddedDates)
		updateHeader()
		updateSelection()
	}
	
	private struct CalendarViewBuffer {
		var leading: CalendarView
		var center: CalendarView
		var trailing: CalendarView
	}
	
	// Undo this restriction after localization pipeline is set up.
	static let accessibilityTemporarilyRestricted = true
}

extension DatePickerView: CalendarViewDelegate {
	
	/// Propagates date selection to the delegate if the view isn't animating.
	///
	/// - Parameters:
	///   - calendarView: The calendar on which a date was selected.
	///   - date: The date that was selected.
	func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {
		guard !isAnimating else {
			return
		}
		
		delegate?.datePicker(self, didSelectDate: date)
	}
}

extension DatePickerView: CalendarHeaderViewDelegate {
	
	/// Passes a leading header button press down to the delegate if the view is not animating
	///
	/// - Parameters:
	///   - calendarHeader: The header view that the button is in.
	///   - button: The button that was pressed.
	func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressLeading button: NSButton) {
		guard !isAnimating else {
			return
		}
		
		delegate?.datePicker(self, didPressPrevious: button)
	}
	
	/// Passes a trailing header button press down to the delegate if the view is not animating
	///
	/// - Parameters:
	///   - calendarHeader: The header view that the button is in.
	///   - button: The button that was pressed.
	func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressTrailing button: NSButton) {
		guard !isAnimating else {
			return
		}
		
		delegate?.datePicker(self, didPressNext: button)
	}
}

protocol DatePickerViewDelegate: class {
	
	/// Tells the delegate that a new date was selected.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - date: The date that was selected.
	func datePicker(_ datePicker: DatePickerView, didSelectDate date: Date)
	
	/// Tells the delegate that a new date and time was selected.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - date: The date and time that was selected.
	func datePicker(_ datePicker: DatePickerView, didSelectDateTime date: Date)
	
	/// Tells the delegate that the next month button was pressed.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - button: The button that was pressed.
	func datePicker(_ datePicker: DatePickerView, didPressNext button: NSButton)
	
	/// Tells the delegate that the previous month button was pressed.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - button: The button that was pressed.
	func datePicker(_ datePicker: DatePickerView, didPressPrevious button: NSButton)
	
	/// Asks the delegate whether a given calendar day button should be highlighted.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - button: The calendar day button.
	/// - Returns: True if the button should be highlighted, false otherwise.
	func datePicker(_ datePicker: DatePickerView, shouldHighlightButton button: CalendarDayButton) -> Bool
}

/// Default delegate implementation
extension DatePickerViewDelegate {
	
	func datePicker(_ datePicker: DatePickerView, didSelectDate date: Date) {}
	
	func datePicker(_ datePicker: DatePickerView, didSelectDateTime date: Date) {}
	
	func datePicker(_ datePicker: DatePickerView, didPressNext button: NSButton) {}
	
	func datePicker(_ datePicker: DatePickerView, didPressPrevious button: NSButton) {}
	
	func datePicker(_ datePicker: DatePickerView, shouldHighlightButton button: CalendarDayButton) -> Bool {
		return false
	}
}

protocol DatePickerViewDataSource: class {
	
	/// Currently selected date
	var selectedDate: Date { get }
	
	/// Currently selected date and time
	var selectedDateTime: Date { get }
	
	/// Currently visible date range
	var visibleRange: (first: Date, last: Date) { get }
	
	/// Calendar that's currently being used
	var calendar: Calendar { get }
	
	/// List of short weekday labels in the order to be displayed
	var shortWeekdays: [String] { get }
	
	/// List of long weekday labels in the order to be displayed
	var longWeekdays: [String] { get }
	
	/// Asks the data source for the padded dates given a month
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - month: The month.
	/// - Returns: Padded dates for the given month
	func datePicker(_ datePicker: DatePickerView, paddedDaysFor month: Date) -> PaddedCalendarDays
	
	/// Asks the data source for a date that is one month in the past from the given date
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - date: The given date.
	/// - Returns: A date that is one month in the past.
	func datePicker(_ datePicker: DatePickerView, previousMonthFor date: Date) -> Date?
	
	/// Asks the data source for a date that is one month in the future from the given date
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	///   - date: The given date.
	/// - Returns: A date that is one month in the future.
	func datePicker(_ datePicker: DatePickerView, nextMonthFor date: Date) -> Date?
}
