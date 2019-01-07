//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSAvatarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "avatar_kat_larsson")
        addTitle(text: "Avatar with Image")
        for size in MSAvatarSize.allCases {
            addAvatar(size: size, image: image)
        }
        container.addArrangedSubview(UIView())

        addTitle(text: "Avatar with Initials")
        for size in MSAvatarSize.allCases {
            addAvatar(size: size, image: nil)
        }
        container.addArrangedSubview(UIView())
    }

    func addAvatar(size: MSAvatarSize, image: UIImage?) {
        let avatarContainerView = UIStackView()
        avatarContainerView.axis = .vertical
        avatarContainerView.alignment = .leading

        let avatarHorizontalDescriptionView = UIStackView()
        avatarHorizontalDescriptionView.axis = .horizontal
        avatarHorizontalDescriptionView.alignment = .center
        avatarHorizontalDescriptionView.spacing = 40

        let avatar = MSAvatarView(avatarSize: size, withBorder: true)
        avatar.setup(withName: "Kat Larsson", email: "kat.larsson@contoso.com", image: image)

        let label = MSLabel(style: .subhead, colorStyle: .regular)
        label.text = size.description
        label.widthAnchor.constraint(equalToConstant: 65).isActive = true

        avatarHorizontalDescriptionView.addArrangedSubview(label)
        avatarHorizontalDescriptionView.addArrangedSubview(avatar)
        avatarContainerView.addArrangedSubview(avatarHorizontalDescriptionView)
        container.addArrangedSubview(avatarContainerView)
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
