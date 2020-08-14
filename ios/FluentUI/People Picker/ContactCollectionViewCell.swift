//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ContactCollectionViewCell"
    public var contactView: ContactView

    override init(frame: CGRect) {
        contactView = ContactView(title: "", subtitle: "")
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func setup(contact avatar: AvatarData) {
        if avatar.primaryText.count > 0 && avatar.secondaryText.count > 0 {
            contactView = ContactView(title: avatar.primaryText, subtitle: avatar.secondaryText)
        } else {
            contactView = ContactView(identifier: avatar.primaryText)
        }

        contactView.translatesAutoresizingMaskIntoConstraints = false

        if let avatarImage = avatar.image {
            contactView.avatarImage = avatarImage
        }

        contentView.addSubview(contactView)
    }

    override func prepareForReuse() {
        contactView.removeAllSubviews()
        super.prepareForReuse()
    }
}
