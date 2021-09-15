//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension IndeterminateProgressBar {

    /// Defines whether the Indeterminate Progress Barr is animating or stopped.
    /// - Parameter isAnimating: Boolean value to set the property.
    /// - Returns: The modified Indeterminate Progress Bar with the property set.
    func isAnimating(_ isAnimating: Bool) -> IndeterminateProgressBar {
        state.isAnimating = isAnimating
        return self
    }

    /// Defines whether the Indeterminate Progress Bar is visible when its animation stops.
    /// - Parameter hidesWhenStopped: Boolean value to set the property.
    /// - Returns: The modified Indeterminate Progress Bar with the property set.
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> IndeterminateProgressBar {
        state.hidesWhenStopped = hidesWhenStopped
        return self
    }
}
