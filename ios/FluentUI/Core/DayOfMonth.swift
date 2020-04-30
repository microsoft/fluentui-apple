//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: DayOfMonth

@available(*, deprecated, renamed: "DayOfMonth")
public typealias MSDayOfMonth = DayOfMonth

public struct DayOfMonth {
    public let weekOfMonth: WeekOfMonth
    public let dayOfWeek: DayOfWeek

    public init(weekOfMonth: WeekOfMonth? = nil, dayOfWeek: DayOfWeek? = nil) {
        self.weekOfMonth = weekOfMonth ?? .first
        self.dayOfWeek = dayOfWeek ?? DayOfWeek.allCases.first!
    }
}

// MARK: - WeekOfMonth

@available(*, deprecated, renamed: "WeekOfMonth")
public typealias MSWeekOfMonth = WeekOfMonth

@objc(MSFWeekOfMonth)
public enum WeekOfMonth: Int, CaseIterable {
    case first = 1, second, third, fourth, last

    public init?(weekdayOrdinal: Int) {
        self.init(rawValue: weekdayOrdinal)
    }

    public var label: String {
        switch self {
        case .first:
            return "Accessibility.DateTime.Week.First".localized
        case .second:
            return "Accessibility.DateTime.Week.Second".localized
        case .third:
            return "Accessibility.DateTime.Week.Third".localized
        case .fourth:
            return "Accessibility.DateTime.Week.Fourth".localized
        case .last:
            return "Accessibility.DateTime.Week.Last".localized
        }
    }

    public var weekdayOrdinal: Int { return rawValue }
}

// MARK: - DayOfWeek

@available(*, deprecated, renamed: "DayOfWeek")
public typealias MSDayOfWeek = DayOfWeek

@objc(MSFDayOfWeek)
public enum DayOfWeek: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    static var allCases: [DayOfWeek] {
        var daysOfWeek: [DayOfWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        for _ in 0..<Calendar.current.firstWeekday - 1 {
            daysOfWeek.append(daysOfWeek.removeFirst())
        }
        return daysOfWeek
    }

    private static let weekdaySymbols = Calendar.sharedCalendarWithTimeZone(nil).weekdaySymbols

    public var label: String {
        return DayOfWeek.weekdaySymbols[rawValue]
    }

    var weekday: Int { return rawValue + 1 }
}
