//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension MSFButtonView {

    /// Sets the accessibility label for the Button.
    /// - Parameter accessibilityLabel: Accessibility label string.
    /// - Returns: The modified Button with the property set.
    func accessibilityLabel(_ accessibilityLabel: String?) -> MSFButtonView {
        state.accessibilityLabel = accessibilityLabel
        return self
    }

    /// Controls whether the button is available for user interaction, renders the control accordingly.
    /// - Parameter isDisabled: Boolean value to set the property.
    /// - Returns: The modified Button with the property set.
    func isDisabled(_ isDisabled: Bool) -> MSFButtonView {
        state.isDisabled = isDisabled
        return self
    }
}
