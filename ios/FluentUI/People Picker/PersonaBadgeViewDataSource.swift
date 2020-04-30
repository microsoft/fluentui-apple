//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PersonaBadgeViewDataSource

@available(*, deprecated, renamed: "PersonaBadgeViewDataSource")
public typealias MSPersonaBadgeViewDataSource = PersonaBadgeViewDataSource

@objc(MSFPersonaBadgeViewDataSource)
open class PersonaBadgeViewDataSource: BadgeViewDataSource {
    @objc open var persona: Persona

    @objc public init(persona: Persona, style: BadgeView.Style = .default, size: BadgeView.Size = .medium) {
        self.persona = persona
        super.init(text: persona.name, style: style, size: size)
    }
}
