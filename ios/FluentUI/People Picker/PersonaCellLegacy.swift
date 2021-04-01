//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PersonaCellLegacy

@available(*, deprecated, renamed: "PersonaCellLegacy")
public typealias MSPersonaCellLegacy = PersonaCellLegacy

@objc(MSFPersonaCellLegacy)
open class PersonaCellLegacy: TableViewCell {
    private struct Constants {
        static let avatarSize: MSFAvatarSize = .large
    }

    open override var customViewSize: TableViewCell.CustomViewSize { get { return .medium } set { } }

    /// Sets up the cell with an Persona and an accessory
    ///
    /// - Parameters:
    ///   - persona: The Persona to set up the cell with
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc open func setup(persona: Persona, accessoryType: TableViewCellAccessoryType = .none) {
        let avatar = MSFAvatar(style: .accent, size: Constants.avatarSize)

        avatar.state.primaryText = persona.primaryText
        avatar.state.secondaryText = persona.secondaryText
        if let image = persona.image {
            avatar.state.image = image
        }

        if let color = persona.color {
            avatar.state.backgroundColor = color
            avatar.state.ringColor = color
        }

        let avatarView = avatar.view
        avatarView.accessibilityElementsHidden = true
        // Attempt to use email if name is empty
        let title = !persona.name.isEmpty ? persona.name : persona.email
        setup(title: title, subtitle: persona.subtitle, customView: avatarView, accessoryType: accessoryType)
    }
}
