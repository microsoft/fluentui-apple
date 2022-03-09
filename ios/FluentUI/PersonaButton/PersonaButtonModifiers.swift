//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension PersonaButton {
    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: PersonaButtonTokens?) -> PersonaButton {
        state.overrideTokens = tokens
        return self
    }
}
