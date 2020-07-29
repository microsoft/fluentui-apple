//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        createSection(withTitle: "Circle style for person",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle)

        createSection(withTitle: "Square style for group",
                      name: "NorthWind Traders",
                      image: UIImage(named: "site")!,
                      style: .square)

        createSection(withTitle: "With image based frame",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle,
                      withColorfulBorder: true)

        createSection(withTitle: "Circle style for person with presence",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle,
                      withPresence: true)

        createSection(withTitle: "With image based frame with presence",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle,
                      withColorfulBorder: true,
                      withPresence: true)
    }

    private func createSection(withTitle title: String, name: String, image: UIImage, style: AvatarStyle, withColorfulBorder: Bool = false, withPresence: Bool = false) {
        addTitle(text: title)
        for size in AvatarSize.allCases.reversed() {
            let presence1 = withPresence ? size.presence1 : .none
            let imageAvatar = createAvatarView(size: size, name: name, image: image, style: style, withColorfulBorder: withColorfulBorder, presence: presence1)

            let presence2 = withPresence ? size.presence2 : .none
            let initialsAvatar = createAvatarView(size: size, name: name, style: style, withColorfulBorder: withColorfulBorder, presence: presence2)

            addRow(text: size.description, items: [imageAvatar, initialsAvatar], textStyle: .footnote, textWidth: 100)
        }

        container.addArrangedSubview(UIView())
    }

    private func createAvatarView(size: AvatarSize, name: String, image: UIImage? = nil, style: AvatarStyle, withColorfulBorder: Bool = false, presence: AvatarPresence = .none) -> UIView {
        let avatarView = AvatarView(avatarSize: size, withBorder: withColorfulBorder, style: style)
        if withColorfulBorder, let customBorderImage = colorfulImageForFrame() {
            avatarView.customBorderImage = customBorderImage
        }

        avatarView.setup(primaryText: name, secondaryText: "", image: image, presence: presence)

        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarView)
        avatarContainer.widthAnchor.constraint(equalToConstant: AvatarSize.extraExtraLarge.size.width).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: avatarView.frame.height).isActive = true

        return avatarContainer
    }

    private func colorfulImageForFrame() -> UIImage? {
        let gradientColors = [
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor,
            UIColor(red: 0.18, green: 0.45, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.36, green: 0.80, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.72, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.97, green: 0.78, blue: 0.27, alpha: 1).cgColor,
            UIColor(red: 0.94, green: 0.52, blue: 0.20, alpha: 1).cgColor,
            UIColor(red: 0.92, green: 0.26, blue: 0.16, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor]

        let colorfulGradient = CAGradientLayer()
        let size = CGSize(width: 76, height: 76)
        colorfulGradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        colorfulGradient.colors = gradientColors
        colorfulGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        colorfulGradient.endPoint = CGPoint(x: 0.5, y: 0)
        if #available(iOS 12.0, *) {
            colorfulGradient.type = .conic
        }

        var customBorderImage: UIImage?
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            colorfulGradient.render(in: context)
            customBorderImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return customBorderImage
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

    var presence1: AvatarPresence {
        switch self {
        case .extraSmall:
            return .away
        case .small:
            return .doNotDisturb
        case .medium:
            return .available
        case .large:
            return .blocked
        case .extraLarge:
            return .offline
        case .extraExtraLarge:
            return .available
        }
    }

    var presence2: AvatarPresence {
        switch self {
        case .extraSmall:
            return .busy
        case .small:
            return .available
        case .medium:
            return .doNotDisturb
        case .large:
            return .outOfOffice
        case .extraLarge:
            return .busy
        case .extraExtraLarge:
            return .away
        }
    }
}
