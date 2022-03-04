//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension PersonaButtonCarousel {
    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: PersonaButtonCarouselTokens?) -> PersonaButtonCarousel {
        configuration.overrideTokens = tokens
        return self
    }
}
