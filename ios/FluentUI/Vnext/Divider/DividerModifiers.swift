//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension FluentDivider {

    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: DividerTokens?) -> FluentDivider {
        configuration.overrideTokens = tokens
        return self
    }
}
