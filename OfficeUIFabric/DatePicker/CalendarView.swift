//
// Copyright Microsoft Corporation
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
	static let columnSpacing: CGFloat = 0.0
	
	private init() {}
}

/// A fixed grid of CalendarDayButton views
class CalendarView: NSView {
	
	init() {
		super.init(frame: .zero)
		
		wantsLayer = true
		translatesAutoresizingMaskIntoConstraints = false
		
		// Main vertical stack view that holds the rows
		let calendarStackView = NSStackView()
		calendarStackView.wantsLayer = true
		calendarStackView.translatesAutoresizingMaskIntoConstraints = false
		calendarStackView.orientation = .vertical
		calendarStackView.distribution = .fillEqually
		calendarStackView.spacing = Constants.rowSpacing
		
		addSubview(calendarStackView)
		
		var constraints: [NSLayoutConstraint] = []
		
		// One horizontal stack view of CalendarDayButtons per each row
		for row in 0..<Constants.rows {
			let weekStackView = NSStackView()
			weekStackView.wantsLayer = true
			weekStackView.translatesAutoresizingMaskIntoConstraints = false
			weekStackView.orientation = .horizontal
			weekStackView.distribution = .equalCentering
			weekStackView.spacing = Constants.columnSpacing
			
			for column in 0..<Constants.columns {
				weekStackView.addView(buttonViews[column + row * Constants.columns], in: .center)
			}
			
			calendarStackView.addView(weekStackView, in: .center)
			constraints.append(weekStackView.leadingAnchor.constraint(equalTo: calendarStackView.leadingAnchor))
			constraints.append(weekStackView.trailingAnchor.constraint(equalTo: calendarStackView.trailingAnchor))
		}
		
		constraints += [
			calendarStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			calendarStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			calendarStackView.topAnchor.constraint(equalTo: self.topAnchor),
			calendarStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		]
		
		NSLayoutConstraint.activate(constraints)
		
		buttonViews.forEach {
			$0.target = self
			$0.action = #selector(dayButtonWasPressed)
		}
		
		// Accessibility
		setAccessibilityElement(true)
		setAccessibilityLabel(NSLocalizedString(
			"DATEPICKER_ACCESSIBILITY_CALENDAR_VIEW_LABEL",
			tableName: "OfficeUIFabric",
			bundle: Bundle(for: CalendarView.self),
			comment: ""
		))
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
			buttonViews.append(CalendarDayButton(size: Constants.calendarDayButtonSize, day: nil, fontSize: nil))
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
