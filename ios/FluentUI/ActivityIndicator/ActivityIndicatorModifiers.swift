//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension ActivityIndicator {

    /// Sets the accessibility label for the Activity Indicator.
    /// - Parameter accessibilityLabel: Accessibility label string.
    /// - Returns: The modified Activity Indicator with the property set.
    func accessibilityLabel(_ accessibilityLabel: String?) -> ActivityIndicator {
        state.accessibilityLabel = accessibilityLabel
        return self
    }

    /// Sets the color of the Activity Indicator.
    /// - Parameter color: UIColor instance to be set.
    /// - Returns: The modified Activity Indicator with the property set.
    func color(_ color: UIColor?) -> ActivityIndicator {
        state.color = color
        return self
    }

    /// Defines whether the Activity Indicator is animating or stopped.
    /// - Parameter isAnimating: Boolean value to set the property.
    /// - Returns: The modified Activity Indicator with the property set.
    func isAnimating(_ isAnimating: Bool) -> ActivityIndicator {
        state.isAnimating = isAnimating
        return self
    }

    /// Defines whether the Activity Indicator is visible when its animation stops.
    /// - Parameter hidesWhenStopped: Boolean value to set the property.
    /// - Returns: The modified Activity Indicator with the property set.
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> ActivityIndicator {
        state.hidesWhenStopped = hidesWhenStopped
        return self
    }
}
