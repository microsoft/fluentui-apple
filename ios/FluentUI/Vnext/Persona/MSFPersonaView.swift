//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PersonaView implementation
@objc open class MSFPersonaView: ControlHostingContainer {

    @objc public init() {
        let personaView = PersonaView()
        state = personaView.state
        super.init(AnyView(personaView))
    }

    @objc public let state: MSFPersonaViewState
}
