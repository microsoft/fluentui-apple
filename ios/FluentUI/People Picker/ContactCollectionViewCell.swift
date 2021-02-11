//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ContactCollectionViewCell"
    public var contactView: ContactView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func setup(contact persona: PersonaData, size: ContactView.Size) {
        if let name = persona.composedName {
            contactView = ContactView(title: name.0, subtitle: name.1, size: size)
        } else {
            let identifier = (persona.name.count > 0) ? persona.name : persona.email
            contactView = ContactView(identifier: identifier, size: size)
        }

        contactView?.translatesAutoresizingMaskIntoConstraints = false

        if let avatarImage = persona.avatarImage {
            contactView?.avatarImage = avatarImage
        }

        contentView.addSubview(contactView!)
    }

    override func prepareForReuse() {
        contactView?.removeAllSubviews()
        super.prepareForReuse()
    }
}
