//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Representation of design tokens to controls at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI controls to update its view automatically.
public class PersonaButtonCarouselTokens: ControlTokens {

    /// Creates an instance of `PersonaButtonCarouselTokens` with optional token value overrides.
    /// - Parameters:
    ///   - size: `MSFPersonaButtonSize` enumeration value that will define pre-defined values for fonts and spacing.
    ///   - backgroundColor: The background color for the `PersonaButtonCarousel`.
    public init(size: MSFPersonaButtonSize,
                backgroundColor: DynamicColor? = nil) {
        self.size = size
        super.init()

        // Overrides

        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }

    var size: MSFPersonaButtonSize

    // MARK: - Design Tokens

    lazy var backgroundColor: DynamicColor = aliasTokens.backgroundColors[.neutral1]
}
