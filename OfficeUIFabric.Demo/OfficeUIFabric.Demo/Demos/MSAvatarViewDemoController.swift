//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSAvatarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let personaImage = UIImage(named: "avatar_kat_larsson")
        let siteImage = UIImage(named: "site")
        addTitle(text: "Avatar with Image")
        for size in MSAvatarSize.allCases {
            setupAvatarDetails(size: size, circleImage: personaImage, squareImage: siteImage, circleName: "Kat Larrson", squareName: "NorthWind Traders")
        }
        container.addArrangedSubview(UIView())

        addTitle(text: "Avatar with Initials")
        for size in MSAvatarSize.allCases {
            setupAvatarDetails(size: size, circleName: "Kat Larrson", squareName: "NorthWind Traders")
        }
        container.addArrangedSubview(UIView())
    }

    func setupAvatarDetails(size: MSAvatarSize, circleImage: UIImage? = nil, squareImage: UIImage? = nil, circleName: String = "", squareName: String = "") {
        let avatarContainerView = UIStackView()
        avatarContainerView.axis = .vertical
        avatarContainerView.alignment = .leading

        let avatarHorizontalDescriptionView = UIStackView()
        avatarHorizontalDescriptionView.axis = .horizontal
        avatarHorizontalDescriptionView.alignment = .center
        avatarHorizontalDescriptionView.spacing = 40

        let label = MSLabel(style: .subhead, colorStyle: .regular)
        label.text = size.description
        label.widthAnchor.constraint(equalToConstant: 65).isActive = true

        let circleAvatar = createAvatarView(size: size, name: circleName, image: circleImage)
        let squareAvatar = createAvatarView(size: size, name: squareName, image: squareImage, style: .square)

        avatarHorizontalDescriptionView.addArrangedSubview(label)
        avatarHorizontalDescriptionView.addArrangedSubview(circleAvatar)
        avatarHorizontalDescriptionView.addArrangedSubview(squareAvatar)
        avatarContainerView.addArrangedSubview(avatarHorizontalDescriptionView)
        container.addArrangedSubview(avatarContainerView)
    }

    private func createAvatarView(size: MSAvatarSize, name: String, image: UIImage?, style: MSAvatarStyle = .circle) -> UIView {
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
