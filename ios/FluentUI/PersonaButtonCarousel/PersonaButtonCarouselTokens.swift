//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Representation of design tokens to controls at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI controls to update its view automatically.
public class PersonaButtonCarouselTokens: ControlTokens {

    // MARK: - Design Tokens

    /// The background color for the `PersonaButtonCarousel`.
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }
}
