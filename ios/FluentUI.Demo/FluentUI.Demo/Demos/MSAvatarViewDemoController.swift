//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MSAvatarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        createSection(withTitle: "Circle style for person", name: "Kat Larrson", image: UIImage(named: "avatar_kat_larsson")!, style: .circle)
        createSection(withTitle: "Square style for group", name: "NorthWind Traders", image: UIImage(named: "site")!, style: .square)
    }

    private func createSection(withTitle title: String, name: String, image: UIImage, style: AvatarStyle) {
        addTitle(text: title)
        for size in AvatarSize.allCases.reversed() {
            let imageAvatar = createAvatarView(size: size, name: name, image: image, style: style)
            let initialsAvatar = createAvatarView(size: size, name: name, style: style)
            addRow(text: size.description, items: [imageAvatar, initialsAvatar], textStyle: .footnote, textWidth: 100)
        }
        container.addArrangedSubview(UIView())
    }

    private func createAvatarView(size: AvatarSize, name: String, image: UIImage? = nil, style: AvatarStyle) -> UIView {
        let avatarView = AvatarView(avatarSize: size, withBorder: true, style: style)
        avatarView.setup(primaryText: name, secondaryText: "", image: image)

        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarView)
        avatarContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: avatarView.frame.height).isActive = true

        return avatarContainer
    }
}

extension AvatarSize {
    var description: String {
        switch self {
        case .extraSmall:
            return "ExtraSmall"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .extraLarge:
            return "ExtraLarge"
        case .extraExtraLarge:
            return "ExtraExtraLarge"
        }
    }
}
