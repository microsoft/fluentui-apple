//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSPersonaBadgeViewDataSource

open class MSPersonaBadgeViewDataSource: BadgeViewDataSource {
    @objc open var persona: MSPersona

    @objc public init(persona: MSPersona, style: BadgeView.Style = .default, size: BadgeView.Size = .medium) {
        self.persona = persona
        super.init(text: persona.name, style: style, size: size)
    }
}
