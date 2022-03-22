//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButtonCarousel implementation
@objc open class MSFPersonaButtonCarousel: ControlHostingContainer {

    /// Creates a new MSFPersonaButtonCarousel instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButtonCarousel.
    @objc public init(size: MSFPersonaButtonSize = .large) {
        let personaButtonCarousel = PersonaButtonCarousel(size: size)
        state = personaButtonCarousel.state
        super.init(AnyView(personaButtonCarousel))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the PersonaButtonCarousel appearance.
    @objc public let state: MSFPersonaButtonCarouselState
}
