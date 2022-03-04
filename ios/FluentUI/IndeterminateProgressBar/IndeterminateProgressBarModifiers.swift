//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension IndeterminateProgressBar {

    /// Defines whether the Indeterminate Progress Bar is animating or stopped.
    /// - Parameter isAnimating: Boolean value to set the property.
    /// - Returns: The modified Indeterminate Progress Bar with the property set.
    func isAnimating(_ isAnimating: Bool) -> IndeterminateProgressBar {
        configuration.isAnimating = isAnimating
        return self
    }

    /// Defines whether the Indeterminate Progress Bar is visible when its animation stops.
    /// - Parameter hidesWhenStopped: Boolean value to set the property.
    /// - Returns: The modified Indeterminate Progress Bar with the property set.
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> IndeterminateProgressBar {
        configuration.hidesWhenStopped = hidesWhenStopped
        return self
    }

    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: IndeterminateProgressBarTokens?) -> IndeterminateProgressBar {
        configuration.overrideTokens = tokens
        return self
    }
}
