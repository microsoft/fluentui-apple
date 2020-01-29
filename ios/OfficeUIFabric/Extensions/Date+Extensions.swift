//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: Calculations

extension Date {
    private static var _has24HourFormat: Bool?

    static func has24HourFormat() -> Bool {
        if _has24HourFormat == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short

            let timeString = dateFormatter.string(from: Date())
            let amRange = timeString.range(of: dateFormatter.amSymbol)
            let pmRange = timeString.range(of: dateFormatter.pmSymbol)
            _has24HourFormat = amRange?.lowerBound == nil && pmRange?.lowerBound == nil
        }

        return _has24HourFormat!
    }

    func combine(withTime time: Date) -> Date? {
        let calendar = Calendar.current

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = timeComponents.second

        return calendar.date(from: dateComponents)
    }

    /**
     * Derive a new date from `self` by going back in time until the first moment of that day
     *
     * The date is also known as the "midnight" date or a date where hours, minutes, and seconds are all set to zero.
     *
     * This will not change the date if `self` is already at midnight. The time zone used is equal to the `Calendar.current.timeZone`.
     */
    var startOfDay: Date { return Calendar.current.startOfDay(for: self) }

    /**
     * Derive a new date from `self` by adding any combination of years, months, days, hours, minutes, seconds
     *
     * Positive or negative values are allowed. The time zone used is equal to the `Calendar.current.timeZone`.
     *
     * Returns the original date by default if the calculation fails.
     */
    func adding(years: Int? = 0, months: Int? = 0, days: Int? = 0, hours: Int? = 0, minutes: Int? = 0, seconds: Int? = 0) -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds), to: self) ?? self
    }

    /**
     *  Derive the number of days until a given date
     *
     *  Returns the number of days
     */
    func days(until date: Date, timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let firstMidnightDate = calendar.startOfDay(for: self)
        let secondMidnightDate = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: firstMidnightDate, to: secondMidnightDate).day ?? 0
    }

    func rounded(toCalendarUnits units: Set<Calendar.Component>, timeZone: TimeZone? = nil) -> Date {
        let calendar = Calendar.sharedCalendarWithTimeZone(timeZone)
        let components = calendar.dateComponents(units, from: self)

        if let date = calendar.date(from: components) {
            return date
        }

        assertionFailure("dateRoundedToCalendarUnits > couldn't build date from components")

        // Return the original date in case of error
        return self
    }

    func rounded(toNearestMinutes nearestMinutes: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let minutes = dateComponents.minute else {
            return nil
        }
        let nearestMinutes = Double(nearestMinutes)
        dateComponents.minute = Int(ceil(Double(minutes) / nearestMinutes) * nearestMinutes)
        return calendar.date(from: dateComponents)
    }
}

// MARK: - Components

extension Date {
    /// The `year` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// The `month` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// The `day` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// The `hour` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// The `minute` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    /// The `second` date component of `self`. The time zone used is equal to the `Calendar.current.timeZone`.
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
}
