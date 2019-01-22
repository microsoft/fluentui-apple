//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSDayOfMonth

public struct MSDayOfMonth {
    public let weekOfMonth: MSWeekOfMonth
    public let dayOfWeek: MSDayOfWeek

    public init(weekOfMonth: MSWeekOfMonth? = nil, dayOfWeek: MSDayOfWeek? = nil) {
        self.weekOfMonth = weekOfMonth ?? .first
        self.dayOfWeek = dayOfWeek ?? MSDayOfWeek.allCases.first!
    }
}

// MARK: - MSWeekOfMonth

public enum MSWeekOfMonth: Int, CaseIterable {
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

// MARK: - MSDayOfWeek

public enum MSDayOfWeek: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    static var allCases: [MSDayOfWeek] {
        var daysOfWeek: [MSDayOfWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        for _ in 0..<Calendar.current.firstWeekday - 1 {
            daysOfWeek.append(daysOfWeek.removeFirst())
        }
        return daysOfWeek
    }

    private static let weekdaySymbols = Calendar.sharedCalendarWithTimeZone(nil).weekdaySymbols

    public var label: String {
        return MSDayOfWeek.weekdaySymbols[rawValue]
    }

    var weekday: Int { return rawValue + 1 }
}
