//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

fileprivate struct Constants {
	
	/// Number of rows in the calendar view (# of weeks)
	static let rows = 6
	
	/// Number of columns in the calendar view (# of weekdays)
	static let columns = 7
	
	/// Size of the underlying CalendarDayButton views
	static let calendarDayButtonSize: CGFloat = 32.0
	
	/// Spacing between the calendar rows
	static let rowSpacing: CGFloat = 5.0
	
	/// Spacing between the calendar columns
	static let columnSpacing: CGFloat = 5.0
	
	private init() {}
}

/// A fixed grid of CalendarDayButton views
class CalendarView: NSView {
	
	init() {
		super.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
		
		let buttonViewMatrix: [[NSView]] = (0..<Constants.rows).map { row in
			Array(buttonViews[row * Constants.columns..<row * Constants.columns + Constants.columns])
		}
		
		let gridView = NSGridView(views: buttonViewMatrix)
		gridView.translatesAutoresizingMaskIntoConstraints = false
		gridView.rowSpacing = Constants.rowSpacing
		gridView.columnSpacing = Constants.columnSpacing
		gridView.setContentHuggingPriority(.required, for: .vertical)
		gridView.setContentHuggingPriority(.required, for: .horizontal)
		addSubview(gridView)
		
		NSLayoutConstraint.activate([
			gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
			gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
			gridView.topAnchor.constraint(equalTo: topAnchor),
			gridView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
		
		buttonViews.forEach {
			$0.target = self
			$0.action = #selector(dayButtonWasPressed)
		}
		
		// Accessibility
		setAccessibilityElement(!DatePickerView.accessibilityTemporarilyRestricted)
		setAccessibilityLabel(NSLocalizedString(
			"DATEPICKER_ACCESSIBILITY_CALENDAR_VIEW_LABEL",
			tableName: "FluentUI",
			bundle: Bundle(for: CalendarView.self),
			comment: ""
		))
	}
	
	required init?(coder decoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	/// Updates the underlying button views with given days using the correct font colors
	///
	/// - Parameter paddedDays: day to be displayed in the calendar view
	func update(with paddedDays : PaddedCalendarDays) {
		var buttonIndex = 0
		for day in paddedDays.previousMonthDays {
			buttonViews[buttonIndex].day = day
			buttonViews[buttonIndex].state = .off
			buttonViews[buttonIndex].type = .secondary
			buttonIndex += 1
			
			if buttonIndex >= buttonViews.count {
				return
			}
		}
		
		for day in paddedDays.currentMonthDays {
			buttonViews[buttonIndex].day = day
			buttonViews[buttonIndex].state = .off
			buttonViews[buttonIndex].type = .primary
			
			buttonIndex += 1
			
			if buttonIndex >= buttonViews.count {
				return
			}
		}
		
		for day in paddedDays.nextMonthDays {
			buttonViews[buttonIndex].day = day
			buttonViews[buttonIndex].state = .off
			buttonViews[buttonIndex].type = .secondary
			
			buttonIndex += 1
			
			if buttonIndex >= buttonViews.count {
				return
			}
		}
	}
	
	weak var delegate: CalendarViewDelegate?
	
	/// The custom color of the CalendarDayButtons when selected
	/// - note: Setting this to nil results in using a default color
	var customSelectionColor: NSColor? {
		didSet {
			buttonViews.forEach {
				$0.customSelectionColor = customSelectionColor
			}
		}
	}
	
	let buttonViews: [CalendarDayButton] = {
		var buttonViews: [CalendarDayButton] = []
		for _ in 0..<Constants.rows * Constants.columns {
			buttonViews.append(CalendarDayButton(size: Constants.calendarDayButtonSize, day: nil))
		}
		
		return buttonViews
	}()
	
	@objc private func dayButtonWasPressed(_ sender: CalendarDayButton) {
		delegate?.calendarView(self, didSelectDate: sender.day.date)
	}
}

protocol CalendarViewDelegate: class {
	
	/// Tells the delegate that a date was selected.
	///
	/// - Parameters:
	///   - calendarView: The calendar on which a date was selected.
	///   - date: The date that was selected.
	func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
}

/// Default delegate implementation
extension CalendarViewDelegate {
	func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {}
}

/// All days belonging to a single month, padded by days from previous and next month
/// to correctly line up with the weekday columns
struct PaddedCalendarDays {
	var previousMonthDays : [CalendarDay] = []
	var currentMonthDays : [CalendarDay] = []
	var nextMonthDays : [CalendarDay] = []
}

struct CalendarDay {
	
	/// Date of the calendar day
	let date: Date
	
	/// Primary String representation of the day
	let primaryLabel: String
	
	/// String used for accessibility scenarios, like VoiceOver
	let accessibilityLabel: String
	
	/// Secondary String representation of the day
	let secondaryLabel: String?
}
