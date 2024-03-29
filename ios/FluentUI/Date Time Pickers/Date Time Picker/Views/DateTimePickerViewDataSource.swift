//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: DateTimePickerViewDataSourceConstants

struct DateTimePickerViewDataSourceConstants {
    // Do not change this number (1200). This should be an even multiple of 24 and 60 (50 is even and is the multiple of 24)
    static let infiniteRowCount: Int = 1200
    static let indexPathOffset: Int = infiniteRowCount / 2
    static let minuteInterval: Int = 5
}

// MARK: - DateTimePickerViewComponentType

enum DateTimePickerViewComponentType {
    case date
    case month
    case day
    case year
    case timeHour
    case timeMinute
    case timeAMPM
    case weekOfMonth
    case dayOfWeek
}

// MARK: - DateTimePickerViewAMPM

enum DateTimePickerViewAMPM {
    case am
    case pm
}

// MARK: - DateTimePickerViewDataSource

/**
 * DataSource of a component of DateTimePickerView. All dataSources must follow this protocol and be private to this file.
 * Use the factory to instantiate the specific dataSources based on a type. (should be used only by DateTimePickerView and not used or instantiated on its own)
 */
protocol DateTimePickerViewDataSource: AnyObject {
    func numberOfItems() -> Int

    // If the item is present multiple times, return the indexPath at the center
    func indexPath(forItem item: Any) -> IndexPath?

    // This is the representing data (Date, Int, ...)
    func item(forRowAtIndex index: Int) -> Any

    // This is to be used as representation of the data in cells
    func itemStringRepresentation(forRowAtIndex index: Int) -> String?
    func accessibilityValue(forRowAtIndex index: Int) -> String?
    func accessibilityLabel() -> String?

    // Date components representing the given row or nil if can't be represented
    func dateComponents(forRowAtIndex index: Int) -> DateComponents?
}

// MARK: - DateTimePickerViewDataSourceWithDate

/// For dataSources that depend on a given date
protocol DateTimePickerViewDataSourceWithDate: DateTimePickerViewDataSource {
    var date: Date? { get set }
}

// MARK: - DateTimePickerViewDataSourceFactory

class DateTimePickerViewDataSourceFactory {
    static func dataSource(withType type: DateTimePickerViewComponentType, mode: DateTimePickerViewMode, calendarConfiguration: CalendarConfiguration) -> DateTimePickerViewDataSource {
        switch type {
        case .date:
            return DateTimePickerViewDateDataSource(calendarConfiguration: calendarConfiguration)
        case .month:
            return DateTimePickerViewMonthDataSource()
        case .day:
            return DateTimePickerViewDayDataSource()
        case .year:
            switch mode {
            case .date:
                return DateTimePickerViewYearDataSource(startYear: calendarConfiguration.referenceStartDate.year, endYear: calendarConfiguration.referenceEndDate.year)
            case .dateTime, .dayOfMonth:
                return DateTimePickerViewYearDataSource(startYear: calendarConfiguration.referenceStartDate.year, endYear: calendarConfiguration.referenceEndDate.year)
            }
        case .timeHour:
            return DateTimePickerViewHourDataSource()
        case .timeMinute:
            return DateTimePickerViewMinuteDataSource()
        case .timeAMPM:
            return DateTimePickerViewAMPMDataSource()
        case .weekOfMonth:
            return DateTimePickerViewWeekOfMonthDataSource()
        case .dayOfWeek:
            return DateTimePickerViewDayOfWeekDataSource()
        }
    }
}

// MARK: - DateTimePickerViewMonthDataSource

private class DateTimePickerViewMonthDataSource: DateTimePickerViewDataSource {
    private let dateFormatter = DateFormatter()

    func numberOfItems() -> Int {
        return DateTimePickerViewDataSourceConstants.infiniteRowCount
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let month = item as? Int else {
            return nil
        }

        let row = DateTimePickerViewDataSourceConstants.indexPathOffset + month

        return IndexPath(row: row - 1, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        return index % 12 + 1
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let num = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        return dateFormatter.monthSymbols[num - 1]
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Month.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let month = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.month = month
        return dateComponents
    }
}

// MARK: - DateTimePickerViewDayDataSource

private class DateTimePickerViewDayDataSource: DateTimePickerViewDataSourceWithDate {
    var date: Date?

    private let calendar = Calendar.sharedCalendarWithTimeZone(nil)

    func numberOfItems() -> Int {
        return DateTimePickerViewDataSourceConstants.infiniteRowCount
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let day = item as? Int else {
            return nil
        }

        guard let date = date else {
            assertionFailure("indexPath(forItem:) date required")
            return nil
        }

        guard let numDays = calendar.range(of: .day, in: .month, for: date)?.count else {
            assertionFailure("range calculation must be valid, will only fail if components changed")
            return nil
        }

        guard day <= numDays else {
            return nil
        }

        let row = numDays * ((DateTimePickerViewDataSourceConstants.infiniteRowCount / numDays) / 2) + day

        return IndexPath(row: row - 1, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        guard let date = date else {
            assertionFailure("item(forRowAtIndex:) date required")
            return 0
        }

        guard let numDays = calendar.range(of: .day, in: .month, for: date)?.count else {
            assertionFailure("range calculation must be valid, will only fail if components changed")
            return 0
        }

        return index % numDays + 1
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let num = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        return String(num)
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Day.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let day = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.day = day
        return dateComponents
    }
}

// MARK: - DateTimePickerViewYearDataSource

private class DateTimePickerViewYearDataSource: DateTimePickerViewDataSource {
    private let startYear: Int
    private let endYear: Int

    init(startYear: Int, endYear: Int) {
        self.startYear = startYear
        self.endYear = endYear
    }

    func numberOfItems() -> Int {
        return endYear - startYear + 1
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let year = item as? Int else {
            return nil
        }

        return IndexPath(row: year - startYear, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        return startYear + index
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let year = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        return String(year)
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Year.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let year = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.year = year
        return dateComponents
    }
}

// MARK: - DateTimePickerViewDateDataSource

private class DateTimePickerViewDateDataSource: DateTimePickerViewDataSource {
    private var numberOfDates: Int
    private let today = Calendar.sharedCalendarWithTimeZone(nil).startOfDay(for: Date())
    private let referenceStartDate: Date
    private var dateComponents = DateComponents()
    private let calendar = Calendar.sharedCalendarWithTimeZone(nil)

    init(calendarConfiguration: CalendarConfiguration? = nil) {
        referenceStartDate = Calendar.sharedCalendarWithTimeZone(nil).startOfDay(for: calendarConfiguration?.referenceStartDate ?? CalendarConfiguration.default.referenceStartDate)

        let end = calendar.startOfDay(for: calendarConfiguration?.referenceEndDate ?? CalendarConfiguration.default.referenceEndDate)

        numberOfDates = referenceStartDate.days(until: end)
    }

    func numberOfItems() -> Int {
        return numberOfDates
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let date = item as? Date else {
            assertionFailure("indexPath(forItem:) > wrong argument type")
            return nil
        }

        let midnightDate = calendar.startOfDay(for: date)
        let dateIndex = calendar.dateComponents([.day], from: referenceStartDate, to: midnightDate).day!

        assert(dateIndex >= 0 && dateIndex < numberOfDates, "index out of bound")
        return IndexPath(row: dateIndex, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        dateComponents.day = index
        let date = calendar.date(byAdding: dateComponents, to: referenceStartDate)
        assert(date != nil, "item(forRowAtIndex:) > date could not be computed")
        return date ?? Date()
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let date = item(forRowAtIndex: index) as? Date else {
            return nil
        }

        let numberOfDaySinceNow = Calendar.current.numberOfDays(from: today, to: date)
        if numberOfDaySinceNow == -1 || numberOfDaySinceNow == 0 || numberOfDaySinceNow == 1 {
            return String.relativeDayString(forNumberOfDaysSinceNow: numberOfDaySinceNow)
        } else {
            return String.dateString(from: date, compactness: .shortDaynameShortMonthnameDay)
        }
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Date.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let date = item(forRowAtIndex: index) as? Date else {
            return nil
        }

        return calendar.dateComponents([.year, .month, .day], from: date)
    }
}

// MARK: - DateTimePickerViewHourDataSource

private class DateTimePickerViewHourDataSource: DateTimePickerViewDataSource {
    func numberOfItems() -> Int {
        return DateTimePickerViewDataSourceConstants.infiniteRowCount
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let hour = item as? Int, hour >= 0 && hour < 24 else {
            assertionFailure("indexPathForItem > invalid argument")
            return nil
        }

        return IndexPath(row: DateTimePickerViewDataSourceConstants.infiniteRowCount / 2 + hour, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        if Date.has24HourFormat() {
            return index % 24
        }

        let hour = index % 12
        return hour == 0 ? 12 : hour
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let value = item(forRowAtIndex: index) as? Int else {
            assertionFailure("itemStringRepresentation(forRowAtIndex:) > item not found")
            return nil
        }

        return String(format: "%ld", arguments: [value])
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        guard let item = item(forRowAtIndex: index) as? Int else {
            assertionFailure("accessibilityValue > item not found")
            return nil
        }

        let translation = "Accessibility.DateTime.Hour.Value".localized
        return String(format: translation, arguments: [item])
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Hour.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let hour = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        return dateComponents
    }
}

// MARK: - DateTimePickerViewMinuteDataSource

private class DateTimePickerViewMinuteDataSource: DateTimePickerViewDataSource {
    func numberOfItems() -> Int {
        return DateTimePickerViewDataSourceConstants.infiniteRowCount
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let minute = item as? Int, minute >= 0 && minute < 60 else {
            assertionFailure("indexPath(forItem:) > invalid argument")
            return nil
        }

        let offset = minute / DateTimePickerViewDataSourceConstants.minuteInterval
        let index = DateTimePickerViewDataSourceConstants.infiniteRowCount / 2 + offset
        return IndexPath(row: index, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        let interval = DateTimePickerViewDataSourceConstants.minuteInterval
        let numberOfIntervalsInHour = 60 / interval
        return (index % numberOfIntervalsInHour) * interval
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let value = item(forRowAtIndex: index) as? Int else {
            assertionFailure("itemStringRepresentation(forRowAtIndex:) > item not found")
            return nil
        }

        return String(format: "%02ld", arguments: [value])
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        guard let item = item(forRowAtIndex: index) as? Int else {
            assertionFailure("accessibilityValue > item not found")
            return nil
        }

        let translation = "Accessibility.DateTime.Minute.Value".localized
        return String(format: translation, arguments: [item])
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.Minute.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let minute = item(forRowAtIndex: index) as? Int else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.minute = minute
        return dateComponents
    }
}

// MARK: - DateTimePickerViewAMPMDataSource

private class DateTimePickerViewAMPMDataSource: DateTimePickerViewDataSource {
    private let dateFormatter = DateFormatter()

    func numberOfItems() -> Int {
        return 2
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let value = item as? DateTimePickerViewAMPM else {
            assertionFailure("indexPath(forItem:) > wrong argument type")
            return nil
        }

        switch value {
        case .am:
            return IndexPath(row: 0, section: 0)
        case .pm:
            return IndexPath(row: 1, section: 0)
        }
    }

    func item(forRowAtIndex index: Int) -> Any {
        return index == 0 ? DateTimePickerViewAMPM.am : DateTimePickerViewAMPM.pm
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        guard let item = item(forRowAtIndex: index) as? DateTimePickerViewAMPM else {
            assertionFailure("itemStringRepresentation(forRowAtIndex:) > item not found")
            return nil
        }

        switch item {
        case .am:
            return dateFormatter.amSymbol
        case .pm:
            return dateFormatter.pmSymbol
        }
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.AMPM.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        // Hack for am/pm which doesn't have a component. We need to say what it is so let's use era to give 0 or 1
        guard let item = item(forRowAtIndex: index) as? DateTimePickerViewAMPM else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.era = item == .am ? 0 : 1
        return dateComponents
    }
}

// MARK: - DateTimePickerViewWeekOfMonthDataSource

private class DateTimePickerViewWeekOfMonthDataSource: DateTimePickerViewDataSource {
    let weeksOfMonth: [WeekOfMonth] = WeekOfMonth.allCases

    func numberOfItems() -> Int {
        return weeksOfMonth.count
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let weekOfMonth = item as? WeekOfMonth, let weekOfMonthIndex = weeksOfMonth.firstIndex(of: weekOfMonth) else {
            return nil
        }

        return IndexPath(row: weekOfMonthIndex, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        return weeksOfMonth[index]
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        return weeksOfMonth[index].label
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.WeekOfMonth.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let weekOfMonth = item(forRowAtIndex: index) as? WeekOfMonth else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.weekdayOrdinal = weekOfMonth.weekdayOrdinal
        return dateComponents
    }
}

// MARK: - DateTimePickerViewDayOfWeekDataSource

private class DateTimePickerViewDayOfWeekDataSource: DateTimePickerViewDataSource {
    let weekdays: [DayOfWeek] = DayOfWeek.allCases

    func numberOfItems() -> Int {
        return weekdays.count
    }

    func indexPath(forItem item: Any) -> IndexPath? {
        guard let item = item as? DayOfWeek, let index = weekdays.firstIndex(of: item) else {
            return nil
        }

        return IndexPath(row: index, section: 0)
    }

    func item(forRowAtIndex index: Int) -> Any {
        return weekdays[index]
    }

    func itemStringRepresentation(forRowAtIndex index: Int) -> String? {
        return weekdays[index].label
    }

    func accessibilityValue(forRowAtIndex index: Int) -> String? {
        return itemStringRepresentation(forRowAtIndex: index)
    }

    func accessibilityLabel() -> String? {
        return "Accessibility.DateTime.DayOfWeek.Label".localized
    }

    func dateComponents(forRowAtIndex index: Int) -> DateComponents? {
        guard let dayOfWeek = item(forRowAtIndex: index) as? DayOfWeek else {
            return nil
        }

        var dateComponents = DateComponents()
        dateComponents.weekday = dayOfWeek.weekday
        return dateComponents
    }
}
