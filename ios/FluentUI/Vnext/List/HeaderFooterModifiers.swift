//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

extension Header {
    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: MSFHeaderFooterTokens?) -> Header {
        state.overrideTokens = tokens
        return self
    }
}
