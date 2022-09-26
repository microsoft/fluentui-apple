//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

extension DateComponents {
    /// Determines if a set of date components including month, and year is equal to the current month or not.
    ///
    /// - Parameter todayDateComponents: A set of date components including day, month, and year
    /// - Returns: A bool describing if self is equal to the current month or not.
    func dateIsInCurrentMonth(todayDateComponents: DateComponents) -> Bool {
        guard let year = self.year,
            let month = self.month,
            let todayYear = todayDateComponents.year,
            let todayMonth = todayDateComponents.month else {
                assertionFailure("Date and today's date requires year and month components")
                return false
        }

        if year == todayYear, month == todayMonth {
            // Current month
            return true
        }
        // Past or future months
        return false
    }
}
