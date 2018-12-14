//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

public extension Calendar {
    private static let sharedAutoUpdatingCalendar: Calendar = .autoupdatingCurrent
    private static var sharedTimeZoneCalendars = [Calendar]()

    static func sharedCalendarWithTimeZone(_ timeZone: TimeZone?) -> Calendar {
        if let timeZone = timeZone {
            if let calendar = sharedTimeZoneCalendars.first(where: { $0.timeZone == timeZone }) {
                return calendar
            }

            var calendar = Calendar.current
            calendar.timeZone = timeZone
            sharedTimeZoneCalendars.append(calendar)
            return calendar
        }

        return sharedAutoUpdatingCalendar
    }

    /**
     * Calculate the date for the first day of the week that contains `date` with the given `firstWeekday` preference (Sunday: 1, Monday: 2, ...)
     *
     * The implementation will guarantee the result is a date before `date`. Returns `startOfDay(for: date)` if the calculation fails.
     */
    func startOfWeek(for date: Date, firstWeekday: Int) -> Date {
        let startOfDayDate = startOfDay(for: date)
        let weekdayIndex = self.weekdayIndex(forStartOfDay: startOfDayDate, firstWeekday: firstWeekday)

        // Subtract number of days until week start
        return self.date(byAdding: .day, value: -weekdayIndex, to: startOfDayDate) ?? startOfDayDate
    }

    /**
     * Calculate the date for the last day of the week that contains `date` with the given `firstWeekday` preference (Sunday: 1, Monday: 2, ...)
     *
     * The implementation will guarantee the result is a date after `date`. Returns `startOfDay(for: date)` if the calculation fails.
     */
    func endOfWeek(for date: Date, firstWeekday: Int) -> Date {
        let startOfDayDate = startOfDay(for: date)
        let weekdayIndex = self.weekdayIndex(forStartOfDay: startOfDayDate, firstWeekday: firstWeekday)

        // Add number of days until last day of week
        return self.date(byAdding: .day, value: (6 - weekdayIndex), to: startOfDayDate) ?? startOfDayDate
    }

    private func weekdayIndex(forStartOfDay startOfDayDate: Date, firstWeekday: Int) -> Int {
        let dateWeekday = component(.weekday, from: startOfDayDate)
        return (dateWeekday - firstWeekday + 7) % 7
    }

    /**
     * Calculate the number of full days that elapse when counting time between `from` and `to`
     *
     * The daylight savings is handled based on the time zone set on the calendar. Returns `0` if the calculation fails.
     *
     * See corresponding unit tests for examples.
     */
    func numberOfDays(from: Date, to: Date) -> Int {
        return dateComponents([.day], from: from, to: to).day ?? 0
    }

    /**
     * Calculate the number of midnights that are crossed when counting time between `from` and `to`
     *
     * The midnight is defined as the midnight of the time zone set on the calendar. Returns `0` if the calculation fails.
     *
     * See corresponding unit tests for examples.
     */
    func numberOfMidnights(from: Date, to: Date) -> Int {
        return component(.day, from: to) - component(.day, from: from)
    }

    /**
     * Derive a new date by adding any combination of years, months, days, hours, minutes, seconds
     *
     * Positive or negative values are allowed. The time zone used is equal to the `self.timeZone`.
     *
     * Returns the original date by default if the calculation fails.
     */
    func dateByAdding(years: Int? = 0, months: Int? = 0, days: Int? = 0, hours: Int? = 0, minutes: Int? = 0, seconds: Int? = 0, to date: Date) -> Date {
        return self.date(byAdding: DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds), to: date) ?? date
    }
}
