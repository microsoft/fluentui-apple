//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

fileprivate struct Constants {
	
	/// Bottom margin of the header view
	static let headerBottomMargin: CGFloat = 5.0
	
	/// Bottom margin of the calendar view
	static let calendarBottomMargin: CGFloat = 10.0
	
	/// Default background color of the view
	static let backgroundColor: NSColor = NSColor.white
	
	/// Duration of one page scroll animation
	static let pageScrollAnimationDuration: Double = 0.2
	
	/// Background color of the text date picker
	static var textDatePickerBackgroundColor: NSColor {
		return NSColor.systemGray.withAlphaComponent(0.3)
	}
	
	/// Corner radius of the text date picker
	static let textDatePickerCornerRadius: CGFloat = 2.0
	
	/// Date formatter template for the header month-year label
	static let headerDateFormatterTemplate = "MMMM yyyy"
	
	/// The padding that's used when hasEdgePadding is true
	static let edgePadding: CGFloat = 10.0
	
	private init() {}
}

class DatePickerView: NSView {
	
	/// Initializes the date picker view using the given style.
	///
	/// - Parameter style: Style of the date picker (date only or date + time)
	init(style: DatePickerStyle) {
		self.style = style
		
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		
		containerStackView.translatesAutoresizingMaskIntoConstraints = false
		containerStackView.orientation = .vertical
		containerStackView.distribution = .gravityAreas
		containerStackView.spacing = 0
		containerStackView.setHuggingPriority(.required, for: .vertical)
		
		// lower than .required to ensure that the text date picker does not get stretched
		containerStackView.setHuggingPriority(.defaultHigh, for: .horizontal)
		
		self.addSubview(containerStackView)
		containerStackView.addView(headerView, in: .center)
		containerStackView.addView(monthClipView, in: .center)
		containerStackView.addView(textDatePicker, in: .center)
		
		monthClipView.translatesAutoresizingMaskIntoConstraints = false
		monthClipView.wantsLayer = true
		monthClipView.addSubview(calendarView)
		
		let padding = hasEdgePadding ? Constants.edgePadding : 0.0
		containerStackView.edgeInsets = NSEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		
		containerStackView.setCustomSpacing(Constants.headerBottomMargin, after: headerView)
		containerStackView.setCustomSpacing(Constants.calendarBottomMargin, after: monthClipView)
		
		NSLayoutConstraint.activate([
			containerStackView.topAnchor.constraint(equalTo: topAnchor),
			containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			headerView.widthAnchor.constraint(equalTo: monthClipView.widthAnchor),
			monthClipView.widthAnchor.constraint(equalTo: calendarView.widthAnchor),
			monthClipView.heightAnchor.constraint(equalTo: calendarView.heightAnchor),
		])
		
		headerView.delegate = self
		calendarView.delegate = self
		
		textDatePicker.target = self
		textDatePicker.action = #selector(onTextDatePickerChange)
		textDatePicker.setContentHuggingPriority(.required, for: .horizontal)
		
		// Accessibility
		setAccessibilityElement(!DatePickerView.accessibilityTemporarilyRestricted)
		setAccessibilityRole(.group)
		setAccessibilityLabel(NSLocalizedString(
			"DATEPICKER_ACCESSIBILITY_DATEPICKER_LABEL",
			tableName: "FluentUI",
			bundle: Bundle(for: DatePickerView.self),
			comment: ""
		))
		
		updateTextDatePicker()
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Scrolls in the leading direction
	func scrollToLeading() {
		if userInterfaceLayoutDirection == .leftToRight {
			animateInDirection(.left)
		} else {
			animateInDirection(.right)
		}
	}
	
	/// Scrolls in the trailing direction
	func scrollToTrailing() {
		if userInterfaceLayoutDirection == .leftToRight {
			animateInDirection(.right)
		} else {
			animateInDirection(.left)
		}
	}
	
	/// Refreshes the date picker using the latest data from the dataSource
	func refresh() {
		updateHeader()
		updateCalendarView()
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
			calendarView.customSelectionColor = customSelectionColor
		}
	}
	
	/// Enables padding around the date picker view.
	var hasEdgePadding: Bool = false {
		didSet {
			guard oldValue != hasEdgePadding else {
				return
			}
			let padding = hasEdgePadding ? Constants.edgePadding : 0.0
			containerStackView.edgeInsets = NSEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		}
	}
	
	/// Indicates whether the text date picker is displayed
	var hasTextField: Bool {
		get {
			return !textDatePicker.isHidden
		}
		set {
			guard newValue != hasTextField else {
				return
			}
			textDatePicker.isHidden = !newValue
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
	
	/// Internal storage of the CalendarView
	private var calendarView = CalendarView()
	
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
	
	/// Internal storage of the main container stack view
	private let containerStackView = NSStackView()
	
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
	
	/// Uses the data source to retrieve all the dates for the calendar view and displays them
	private func updateCalendarView() {
		guard let dataSource = dataSource else {
				return
		}
		calendarView.update(with: dataSource.paddedDays)
	}
	
	/// Updates the highlighted button in the center calendar view using the delegate
	private func updateHighlights() {
		let buttonViews = calendarView.buttonViews
		
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
		
		if textDatePicker.calendar != dataSource.calendar {
			textDatePicker.calendar = dataSource.calendar
			textDatePicker.locale = dataSource.calendar.locale
		}
		
		textDatePicker.dateValue = dataSource.selectedDateTime
	}
	
	/// Animates to the current month in the given direction.
	/// Note: Changing the direction param does not affect what month will be shown in the new CalendarView.
	/// 	This method just gets the days that should currently be visible from the datasource,
	/// 	creates a new CalendarView with these days on the side given by the direction param
	/// 	and animates to it.
	/// - Parameter direction: The direction to animate to.
	private func animateInDirection(_ direction: AnimationDirection) {
		guard let dataSource = dataSource else {
			assertionFailure("dataSource should be non-nil at this point.")
			return
		}
		updateHeader()
		
		isAnimating = true
		let scrollOffset: CGFloat
		switch direction {
		case .left:
			scrollOffset = -calendarView.frame.width
		case .right:
			scrollOffset = calendarView.frame.width
		}
		
		let nextCalendarView = CalendarView()
		nextCalendarView.delegate = self
		nextCalendarView.customSelectionColor = customSelectionColor
		nextCalendarView.frame = calendarView.frame
		nextCalendarView.frame.origin.x += scrollOffset
		nextCalendarView.update(with: dataSource.paddedDays)
		monthClipView.addSubview(nextCalendarView)
		
		NSAnimationContext.runAnimationGroup({ context in
			if NSWorkspace.shared.accessibilityDisplayShouldReduceMotion {
				context.duration = 0.0
			} else {
				context.duration = Constants.pageScrollAnimationDuration
			}
			monthClipView.animator().bounds.origin.x += scrollOffset
		}, completionHandler: {
			self.monthClipView.bounds.origin = .zero
			self.calendarView.removeFromSuperview()
			self.calendarView = nextCalendarView
			self.calendarView.frame.origin.x = .zero
			self.monthClipView.widthAnchor.constraint(equalTo: self.calendarView.widthAnchor).isActive = true
			self.monthClipView.heightAnchor.constraint(equalTo: self.calendarView.heightAnchor).isActive = true
			self.updateSelection()
			self.isAnimating = false
		})
	}
	
	private enum AnimationDirection {
		case left
		case right
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
		if isAnimating {
			completePagingAnimation(completionHandler: {
				self.delegate?.datePickerDidPressPrevious(self)
			})
		} else {
			delegate?.datePickerDidPressPrevious(self)
		}
	}
	
	/// Passes a trailing header button press down to the delegate if the view is not animating
	///
	/// - Parameters:
	///   - calendarHeader: The header view that the button is in.
	///   - button: The button that was pressed.
	func calendarHeaderView(_ calendarHeader: CalendarHeaderView, didPressTrailing button: NSButton) {
		if isAnimating {
			completePagingAnimation(completionHandler: {
				self.delegate?.datePickerDidPressNext(self)
			})
		} else {
			delegate?.datePickerDidPressNext(self)
		}
	}
	
	/// Completes the ongoing paging animation and executes the given completion handler.
	/// - Parameter completionHandler: The closure to be called after the current animation completes.
	private func completePagingAnimation(completionHandler: @escaping () -> Void) {
		// Using a 0-duration animation to cancel the in-flight property animation.
		// See NSAnimatablePropertyContainer docs for details.
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.0
			monthClipView.animator().bounds.origin = .zero
		}, completionHandler: completionHandler)
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
	func datePickerDidPressNext(_ datePicker: DatePickerView)
	
	/// Tells the delegate that the previous month button was pressed.
	///
	/// - Parameters:
	///   - datePicker: The date picker that sent the message.
	func datePickerDidPressPrevious(_ datePicker: DatePickerView)
	
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
	
	func datePickerDidPressNext(_ datePicker: DatePickerView) {}
	
	func datePickerDidPressPrevious(_ datePicker: DatePickerView) {}
	
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
	
	/// All current month days, possibly padded by days from the previous and next month to align with the calendar grid
	var paddedDays: PaddedCalendarDays { get }
	
	/// Calendar that's currently being used
	var calendar: Calendar { get }
	
	/// List of short weekday labels in the order to be displayed
	var shortWeekdays: [String] { get }
	
	/// List of long weekday labels in the order to be displayed
	var longWeekdays: [String] { get }
}
