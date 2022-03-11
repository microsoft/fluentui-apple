//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc open class MSFPersonaButton: ControlHostingContainer {

    /// Creates a new MSFPersonaButton instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButton.
    @objc public init(size: MSFPersonaButtonSize = .large) {
        let personaButton = PersonaButton(size: size)
        state = personaButton.state
        super.init(AnyView(personaButton))
    }

    /// The object that groups properties that allow control over the PersonaButton appearance.
    @objc public let state: MSFPersonaButtonState
}
