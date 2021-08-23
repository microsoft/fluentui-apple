//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension Locale {
    /// Determines if layout direction of current language is `.rightToLeft`.
    /// - Returns: True if layout direction is right to left, false otherwise.
    func isRightToLeftLayoutDirection() -> Bool {
        guard let language = Locale.current.languageCode else {
            // Default to LTR if no language code is found
            return false
        }
        let direction = Locale.characterDirection(forLanguage: language)
        return direction == .rightToLeft
    }
}
