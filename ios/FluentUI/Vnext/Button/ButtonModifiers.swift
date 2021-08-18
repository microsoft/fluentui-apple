//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension MSFButtonView {

    /// Sets the accessibility label for the Button.
    /// - Parameter accessibilityLabel: Accessibility label string.
    /// - Returns: The modified Button with the property set.
    func accessibilityLabel(_ accessibilityLabel: String?) -> MSFButtonView {
        state.accessibilityLabel = accessibilityLabel
        return self
    }
}
