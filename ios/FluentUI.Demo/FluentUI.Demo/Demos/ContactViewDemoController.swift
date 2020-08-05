//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ContactViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray

        // ContactView with picture
        let contactView = ContactView(title: "Christopher", subtitle: "Mendelson")
        contactView.avatarImage = UIImage(named: "avatar_kat_larsson")
        contactView.translatesAutoresizingMaskIntoConstraints = false

        // ContactView with initials
        let noImageContactView = ContactView(title: "John", subtitle: "Smith")
        noImageContactView.translatesAutoresizingMaskIntoConstraints = false

        // ContactView with first name
        let firstNameContactView = ContactView(identifier: "Christopher")
        firstNameContactView.translatesAutoresizingMaskIntoConstraints = false

        // ContactView with email
        let emailContactView = ContactView(identifier: "elatk@contoso.com")
        emailContactView.translatesAutoresizingMaskIntoConstraints = false

        // ContactView with phone number
        let phoneNumberContactView = ContactView(identifier: "+1 (425) 123 4567")
        phoneNumberContactView.translatesAutoresizingMaskIntoConstraints = false

        // ContactView with no title, subtitle or identifier
        let emptyContactView = ContactView(title: "", subtitle: "")
        emptyContactView.translatesAutoresizingMaskIntoConstraints = false

        addRow(text: "ContactView with image", items: [contactView], textWidth: 200)
        addRow(text: "ContactView with initials", items: [noImageContactView], textWidth: 200)
        addRow(text: "ContactView with first name", items: [firstNameContactView], textWidth: 200)
        addRow(text: "ContactView with email", items: [emailContactView], textWidth: 200)
        addRow(text: "ContactView with phone number", items: [phoneNumberContactView], textWidth: 200)
        addRow(text: "ContactView with nothing", items: [emptyContactView], textWidth: 200)
    }

    private func createAvatarView(size: AvatarSize, name: String, image: UIImage? = nil, style: AvatarStyle) -> AvatarView {
        let avatarView = AvatarView(avatarSize: size, withBorder: false, style: style)
        avatarView.setup(primaryText: name, secondaryText: "", image: image)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        return avatarView
    }
}
