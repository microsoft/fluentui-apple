//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

extension DateComponents {
    /// Determines if a set of date components including day, month, and year is equal to or later than today's date.
    ///
    /// - Parameter todayDateComponents: A set of date components including day, month, and year
    /// - Returns: A bool describing if self is equal to or later than today's date.
    func dateIsTodayOrLater(todayDateComponents: DateComponents) -> Bool {
        guard let year = self.year,
            let month = self.month,
            let day = self.day,
            let todayYear = todayDateComponents.year,
            let todayMonth = todayDateComponents.month,
            let today = todayDateComponents.day else {
            assertionFailure("Date and today's date requires year, month, and day components")
            return false
        }

        if year > todayYear ||
            (year == todayYear && month > todayMonth) ||
            (year == todayYear && month == todayMonth && day >= today) {
            // Present or future
            return true
        }
        // Past
        return false
    }
}
