//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PersonaCell

@available(*, deprecated, renamed: "PersonaCell")
public typealias MSPersonaCell = PersonaCell

@objc(MSFPersonaCell)
open class PersonaCell: TableViewCell {
    private struct Constants {
        static let avatarSize: AvatarSize = .large
    }

    open override var customViewSize: TableViewCell.CustomViewSize { get { return .medium } set { } }

    private let avatarView: AvatarView = {
        let avatarView = AvatarView(avatarSize: Constants.avatarSize)
        avatarView.accessibilityElementsHidden = true
        return avatarView
    }()

    /// Sets up the cell with an Persona and an accessory
    ///
    /// - Parameters:
    ///   - persona: The Persona to set up the cell with
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc open func setup(persona: Persona, accessoryType: TableViewCellAccessoryType = .none) {
        avatarView.setup(avatar: persona)
        // Attempt to use email if name is empty
        let title = !persona.name.isEmpty ? persona.name : persona.email
        setup(title: title, subtitle: persona.subtitle, customView: avatarView, accessoryType: accessoryType)
    }
}
