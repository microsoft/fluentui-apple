//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSPersonaCell

open class MSPersonaCell: MSTableViewCell {
    private struct Constants {
        static let avatarSize: MSAvatarSize = .xLarge
    }

    public static var defaultHeight: CGFloat { return MSTableViewCell.mediumHeight }

    open override var customViewSize: MSTableViewCell.CustomViewSize { return .medium }

    private let avatarView: MSAvatarView = {
        let avatarView = MSAvatarView(avatarSize: Constants.avatarSize)
        avatarView.accessibilityElementsHidden = true
        return avatarView
    }()

    /// Sets up the cell with an MSPersona and an accessory
    ///
    /// - Parameters:
    ///   - persona: The MSPersona to set up the cell with
    ///   - accessoryType: The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    open func setup(persona: MSPersona, accessoryType: MSTableViewCellAccessoryType = .none) {
        avatarView.setup(primaryText: persona.name, secondaryText: persona.email, image: persona.avatarImage)
        // Attempt to use email if name is empty
        let title = !persona.name.isEmpty ? persona.name : persona.email
        setup(title: title, subtitle: persona.subtitle, customView: avatarView, accessoryType: accessoryType)
    }
}
