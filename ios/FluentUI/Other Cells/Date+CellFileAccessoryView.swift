//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: - String formatting

extension Date {
    func displayString(short: Bool) -> String? {
        let currentDate = Date()
        let calendar = NSCalendar.current
        var dateString: String?

        if timeIntervalSince(currentDate.addingTimeInterval(-60.0 * 2.0)) > 0 {
            // if occurs in past two minutes
            dateString = "Date.Now".localized
        } else if timeIntervalSince(currentDate.addingTimeInterval(-60.0 * 60.0)) > 0 {
            // if occurs in past hour
            let minutes = calendar.dateComponents([.minute], from: self, to: currentDate).minute ?? 0
            dateString = String(format: "Date.FormatMinutes".localized, Int64(minutes))
        } else if calendar.isDateInToday(self) {
            // if occurs today
            let hours = calendar.dateComponents([.hour], from: self, to: currentDate).hour ?? 0
            dateString = String(format: "Date.FormatHours".localized, Int64(hours))
        } else if calendar.isDateInYesterday(self) {
            // if occurs Yesterday
            if short {
                dateString = "Date.Yesterday".localized
            } else {
                let timeString = Date.timeFormatter.string(from: self)
                dateString = String(format: "Date.FormatYesterdayTime".localized, timeString)
            }
        } else {
            let weekDayCount = TimeInterval(calendar.weekdaySymbols.count)
            let thisWeek = currentDate.addingTimeInterval(-60.0 * 60.0 * 24.0 * (weekDayCount - 1.0))

            if timeIntervalSince(thisWeek) > 0 {
                // if occurs last 6 days
                if short {
                    dateString = Date.dayFormatter.string(from: self)
                } else {
                    let timeString = Date.timeFormatter.string(from: self)
                    let dayString = Date.shortDayFormatter.string(from: self)
                    dateString = String(format: "Date.FormatDayTime".localized, dayString, timeString)
                }
            } else if calendar.component(.year, from: self) != calendar.component(.year, from: currentDate) {
                // if occurs a different year
                dateString = Date.dateYearFormatter.string(from: self)
            } else {
                dateString = Date.dateFormatter.string(from: self)
            }
        }

        return dateString
    }

    // MARK: - Cached date formatters. Perf optimization

    private static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return formatter
    }()

    private static var yesterdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    private static var shortYesterdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return yesterdayFormatter
    }()

    private static var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = "EEEE"

        return formatter
    }()

    private static var shortDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = "EEE"

        return formatter
    }()

    private static var dateYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: NSLocale.current)

        return formatter
    }()

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: NSLocale.current)

        return formatter
    }()
}
