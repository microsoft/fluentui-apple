//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: CalendarConfiguration

@available(*, deprecated, renamed: "CalendarConfiguration")
public typealias MSCalendarConfiguration = CalendarConfiguration

@objc(MSFCalendarConfiguration)
open class CalendarConfiguration: NSObject {
    private struct Constants {
        static let startYearsAgo: Int = -3
        static let endYearsInterval: Int = 10
    }

    // swiftlint:disable:next explicit_type_interface
    @objc public static let `default` = CalendarConfiguration()

    @objc open var firstWeekday: Int = Calendar.current.firstWeekday

    /// By default, this is today minus 3 years. If overridden, make sure it's before (less than) the 'referenceEndDate'
    @objc open var referenceStartDate: Date

    /// By default, this is the default 'referenceStartDate' plus 10 years.  If overridden, make sure it's after (greater than) the 'referenceStartDate'
    @objc open var referenceEndDate: Date

    @objc init(calendar: Calendar = .current) {
        // Compute a start date (January 1st on a year a default number of years ago)
        let yearsAgo = calendar.dateByAdding(years: Constants.startYearsAgo, to: Date())
        var components = calendar.dateComponents([.year, .month, .day], from: yearsAgo)
        components.month = 1
        components.day = 1

        guard let slidingStartDate = calendar.date(from: components) else {
            preconditionFailure("Cannot construct date from years ago components")
        }

        referenceStartDate = slidingStartDate
        referenceEndDate = calendar.dateByAdding(years: Constants.endYearsInterval, to: slidingStartDate)
        super.init()
    }
}
