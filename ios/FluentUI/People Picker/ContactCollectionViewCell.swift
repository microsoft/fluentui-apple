//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ContactCollectionViewCell"
    var contactView: ContactView

    override init(frame: CGRect) {
        contactView = ContactView(title: "", subtitle: "")
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func setup(contact persona: PersonaData) {
        let identifier = (persona.name.count > 0) ? persona.name : persona.email
        contactView = ContactView(identifier: identifier)

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
}
