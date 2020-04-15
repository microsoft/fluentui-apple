//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSPersonaBadgeViewDataSource

open class MSPersonaBadgeViewDataSource: MSBadgeViewDataSource {
    @objc open var persona: MSPersona

    @objc public init(persona: MSPersona, style: MSBadgeView.Style = .default, size: MSBadgeView.Size = .medium) {
        self.persona = persona
        super.init(text: persona.name, style: style, size: size)
    }
}
