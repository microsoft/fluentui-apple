//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return "ContactCollectionViewCell" }
    var contactView: ContactView

    override init(frame: CGRect) {
        contactView = ContactView(title: "", subtitle: "")
        super.init(frame: frame)
    }

    func setup(contact persona: PersonaData) {
        if persona.name != "" {
            contactView = ContactView(identifier: persona.name)
        } else {
            contactView = ContactView(identifier: persona.email)
        }

        contactView.translatesAutoresizingMaskIntoConstraints = false
        if let avatarImage = persona.avatarImage {
            contactView.avatarImage = avatarImage
        }

        contentView.addSubview(contactView)
    }

    override func prepareForReuse() {
        contactView.removeAllSubviews()
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
