//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Representation of design tokens to controls at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI controls to update its view automatically.
public class PersonaButtonCarouselTokens: ControlTokens {

    /// Creates an instance of `PersonaButtonCarouselTokens` with optional token value overrides.
    public convenience init(size: MSFPersonaButtonSize,
                            backgroundColor: DynamicColor? = nil) {
        self.init(size: size)

        // Overrides

        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }

    init(size: MSFPersonaButtonSize) {
        self.size = size
        super.init()
    }

    var size: MSFPersonaButtonSize

    // MARK: - Design Tokens

    lazy var backgroundColor: DynamicColor = aliasTokens.backgroundColors[.neutral1]
}
