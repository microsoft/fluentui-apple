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
    
    /// Color used for the current month CalendarDayButtons
    static let primaryFontColor: NSColor = NSColor.labelColor
    
    /// Color used for the previous/next month CalendarDayButtons
    static let secondaryFontColor: NSColor = NSColor.secondaryLabelColor
    
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
            constraints.append(weekStackView.leadingAnchor.constraint(equalTo: calendarStackView.leadingAnchor, constant: 0))
            constraints.append(weekStackView.trailingAnchor.constraint(equalTo: calendarStackView.trailingAnchor, constant: 0))
        }
        
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[calendarStackView]|", options: [], metrics: nil, views: ["calendarStackView": calendarStackView])
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[calendarStackView]|", options: [], metrics: nil, views: ["calendarStackView": calendarStackView])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the underlying button views with given dates using the correct font colors
    ///
    /// - Parameter paddedDates: dates to be displayed in the calendar view
    func update(with paddedDates : PaddedCalendarDates) {
        var buttonIndex = 0
        for date in paddedDates.previousMonthDates {
            buttonViews[buttonIndex].date = date
            buttonViews[buttonIndex].fontColor = Constants.secondaryFontColor
            buttonViews[buttonIndex].state = .off
            buttonIndex += 1
            
            if buttonIndex >= buttonViews.count {
                return
            }
        }
        
        for date in paddedDates.currentMonthDates {
            buttonViews[buttonIndex].date = date
            buttonViews[buttonIndex].fontColor = Constants.primaryFontColor
            buttonViews[buttonIndex].state = .off
            
            buttonIndex += 1
            
            if buttonIndex >= buttonViews.count {
                return
            }
        }
        
        for date in paddedDates.nextMonthDates {
            buttonViews[buttonIndex].date = date
            buttonViews[buttonIndex].fontColor = Constants.secondaryFontColor
            buttonViews[buttonIndex].state = .off
            
            buttonIndex += 1
            
            if buttonIndex >= buttonViews.count {
                return
            }
        }
    }
    
    let buttonViews: [CalendarDayButton] = {
        var buttonViews: [CalendarDayButton] = []
        for _ in 0..<Constants.rows * Constants.columns {
            buttonViews.append(CalendarDayButton(size: Constants.calendarDayButtonSize, date: nil, fontSize: nil, fontColor: nil))
        }
        
        return buttonViews
    }()
    
    weak var calendarDayButtonDelegate: CalendarDayButtonDelegate? {
        didSet {
            if let delegate = calendarDayButtonDelegate {
                for button in buttonViews {
                    button.delegate = delegate
                }
            }
        }
    }
}

/// All dates belonging to a single month, padded by days from previous and next month
/// to correctly line up with the weekday columns
struct PaddedCalendarDates {
    var previousMonthDates : [Date] = []
    var currentMonthDates : [Date] = []
    var nextMonthDates : [Date] = []
}
