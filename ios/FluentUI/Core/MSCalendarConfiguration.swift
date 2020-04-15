//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: MSCalendarConfiguration

open class MSCalendarConfiguration: NSObject {
    private struct Constants {
        static let baseReferenceStartTimestamp: TimeInterval = 1420416000 // January 3 2015
        static let baseReferenceEndTimestamp: TimeInterval = 1736035200 // January 5 2025
        static let startYearsAgo: Int = -3
        static let endYearsInterval: Int = 10
    }

    // swiftlint:disable:next explicit_type_interface
    @objc public static let `default` = MSCalendarConfiguration()

    @objc open var firstWeekday: Int = Calendar.current.firstWeekday

    let referenceStartDate: Date
    let referenceEndDate: Date

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
