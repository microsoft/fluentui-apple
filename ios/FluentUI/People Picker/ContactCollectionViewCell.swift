//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {

    // TODO: Need to disable user interaction to allow gestures to fall through? (look at CalendaryViewDayCell.swift)
    static var identifier: String { return "ContactCollectionViewCell" }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setup(contact persona: PersonaData) {
        var contactView: ContactView
//        if persona.name != "" {
//            contactView = ContactView(identifier: persona.name)
//        } else {
//            contactView = ContactView(identifier: persona.email)
//        }
        contactView = ContactView(identifier: persona.name)

        contactView.translatesAutoresizingMaskIntoConstraints = false
        if let avatarImage = persona.avatarImage {
            contactView.avatarImage = avatarImage
        }

        contentView.addSubview(contactView)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
