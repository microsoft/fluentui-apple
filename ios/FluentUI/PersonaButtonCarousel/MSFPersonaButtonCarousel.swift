//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButtonCarousel implementation
@objc public class MSFPersonaButtonCarousel: ControlHostingContainer {

    /// Creates a new MSFPersonaButtonCarousel instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButtonCarousel.
    @objc public init(size: MSFPersonaButtonSize = .large) {
        let personaButtonCarousel = PersonaButtonCarousel(size: size)
        configuration = personaButtonCarousel.configuration
        super.init(AnyView(personaButtonCarousel))
    }

    /// The object that groups properties that allow control over the PersonaButtonCarousel appearance.
    @objc public let configuration: MSFPersonaButtonCarouselConfiguration
}
