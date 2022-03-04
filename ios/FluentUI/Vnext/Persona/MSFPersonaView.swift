//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PersonaView implementation
@objc public class MSFPersonaView: ControlHostingContainer {

    @objc public init() {
        let personaView = PersonaView()
        configuration = personaView.configuration
        super.init(AnyView(personaView))
    }

    @objc public let configuration: MSFPersonaViewConfiguration
}
