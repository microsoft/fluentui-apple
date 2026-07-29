//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import UIKit

public extension ProgressBar {

    /// Defines whether the Progress Bar is animating or stopped.
    /// - Parameter isAnimating: Boolean value to set the property.
    /// - Returns: The modified Progress Bar with the property set.
    func isAnimating(_ isAnimating: Bool) -> ProgressBar {
        state.isAnimating = isAnimating
        return self
    }

    /// Defines whether the Progress Bar is visible when its animation stops.
    /// - Parameter hidesWhenStopped: Boolean value to set the property.
    /// - Returns: The modified Progress Bar with the property set.
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> ProgressBar {
        state.hidesWhenStopped = hidesWhenStopped
        return self
    }

    /// Sets a determinate progress value for the Progress Bar.
    /// - Parameter progress: Fractional progress in the range 0.0...1.0, or `nil` to render the
    ///   indeterminate (animated gradient) bar.
    /// - Returns: The modified Progress Bar with the property set.
    func progress(_ progress: Double?) -> ProgressBar {
        state.progress = progress.map { NSNumber(value: $0) }
        return self
    }
}
