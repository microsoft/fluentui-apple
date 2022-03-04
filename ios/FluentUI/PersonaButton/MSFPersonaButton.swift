//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc public class MSFPersonaButton: ControlHostingContainer {

    /// Creates a new MSFPersonaButton instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButton.
    @objc public init(size: MSFPersonaButtonSize = .large) {
        let personaButton = PersonaButton(size: size)
        configuration = personaButton.configuration
        super.init(AnyView(personaButton))
    }

    /// The object that groups properties that allow control over the PersonaButton appearance.
    @objc public let configuration: MSFPersonaButtonConfiguration
}
