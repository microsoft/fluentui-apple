//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSAvatarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addTitle(text: "Circle style")
        let personaImage = UIImage(named: "avatar_kat_larsson")
        for size in MSAvatarSize.allCases.reversed() {
            let imageAvatar = createAvatarView(size: size, name: "Kat Larrson", image: personaImage)
            let initialsAvatar = createAvatarView(size: size, name: "Kat Larrson")
            addRow(text: size.description, items: [imageAvatar, initialsAvatar])
        }
        container.addArrangedSubview(UIView())

        addTitle(text: "Square style")
        let siteImage = UIImage(named: "site")
        for size in MSAvatarSize.allCases.reversed() {
            let imageAvatar = createAvatarView(size: size, name: "NorthWind Traders", image: siteImage, style: .square)
            let initialsAvatar = createAvatarView(size: size, name: "NorthWind Traders", style: .square)
            addRow(text: size.description, items: [imageAvatar, initialsAvatar])
        }
        container.addArrangedSubview(UIView())
    }

    private func createAvatarView(size: MSAvatarSize, name: String, image: UIImage? = nil, style: MSAvatarStyle = .circle) -> UIView {
        let avatarView = MSAvatarView(avatarSize: size, withBorder: true, style: style)
        avatarView.setup(primaryText: name, secondaryText: "", image: image)

        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarView)
        avatarContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: avatarView.height).isActive = true

        return avatarContainer
    }
}

extension MSAvatarSize {
    var description: String {
        switch self {
        case .xSmall:
            return "XSmall"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .xLarge:
            return "XLarge"
        case .xxLarge:
            return "XXLarge"
        }
    }
}
