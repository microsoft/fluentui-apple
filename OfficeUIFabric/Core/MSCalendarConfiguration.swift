//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSCalendarConfiguration

open class MSCalendarConfiguration: NSObject {
    // swiftlint:disable:next explicit_type_interface
    @objc public static let `default` = MSCalendarConfiguration()

    private struct DateConstants {
        static let referenceStartTimestamp: TimeInterval = 1262476800 // January 3 2010
        static let referenceEndTimestamp: TimeInterval = 1578182400 // January 5 2020
    }

    @objc open var referenceStartDate: Date {
        return Date(timeIntervalSince1970: DateConstants.referenceStartTimestamp)
    }

    @objc open var referenceEndDate: Date {
        return Date(timeIntervalSince1970: DateConstants.referenceEndTimestamp)
    }

    @objc open var accessibilityShouldAnnounceIndicatorLevel: Bool {
        return true
    }
}
