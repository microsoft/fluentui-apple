//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

extension Locale {
    /// Checks if month or day comes first in a standard date format for this Locale.
    ///
    /// - Returns: True if order is Day-Month, or false if order is Month-Day
    func dateOrderIsDayMonth() -> Bool {
        return DateFormatter.dateFormat(fromTemplate: "MMMMd", options: 0, locale: self)?.hasPrefix("d") == true
    }
}
