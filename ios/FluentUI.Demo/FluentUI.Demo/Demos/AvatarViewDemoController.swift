//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarViewDemoController: DemoController {
    enum BorderStyle: Int {
    case noBorder
    case defaultBorder
    case colorfulBorder
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let showPresenceSettingView = createLabelAndSwitchRow(labelText: "Show presence",
                                                              switchAction: #selector(toggleShowPresence(switchView:)),
                                                              isOn: isShowingPresence)

        let backgroundSettingView = createLabelAndSwitchRow(labelText: "Use alternate background color",
                                                            switchAction: #selector(toggleAlternateBackground(switchView:)),
                                                            isOn: isUsingAlternateBackgroundColor)

        addRow(items: [backgroundSettingView])
        addRow(items: [showPresenceSettingView])
        addRow(items: [opaquePresenceBorderSettingView])

        createSection(withTitle: "Circle style for person",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle)

        createSection(withTitle: "Square style for group",
                      name: "NorthWind Traders",
                      image: UIImage(named: "site")!,
                      style: .square)

        createSection(withTitle: "Circle style with image-based border",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle,
                      borderStyle: .colorfulBorder)

        createSection(withTitle: "Circle style with border",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .circle,
                      borderStyle: .defaultBorder)
    }

    private var isUsingAlternateBackgroundColor: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    private var isShowingPresence: Bool = false {
        didSet {
            if oldValue != isShowingPresence {
                for avatarView in avatarViewsWithImages {
                    avatarView.presence = isShowingPresence ? avatarView.avatarSize.presenceWithImage : .none
                }

                for avatarView in avatarViewsWithInitials {
                    avatarView.presence = isShowingPresence ? avatarView.avatarSize.presenceWithInitials : .none
                }

                opaquePresenceBorderSettingView.isHidden = !isShowingPresence
            }
        }
    }

    private lazy var opaquePresenceBorderSettingView: UIView = {
        let view = createLabelAndSwitchRow(labelText: "Use opaque presence border",
                                           switchAction: #selector(toggleUseOpaquePresenceBorder(switchView:)),
                                           isOn: isUsingOpaquePresenceBorder)

        view.isHidden = !isShowingPresence

        return view
    }()

    private var isUsingOpaquePresenceBorder: Bool = false {
        didSet {
            if oldValue != isUsingOpaquePresenceBorder {
                for avatarView in avatarViewsWithImages {
                    avatarView.useOpaquePresenceBorder = isUsingOpaquePresenceBorder
                }

                for avatarView in avatarViewsWithInitials {
                    avatarView.useOpaquePresenceBorder = isUsingOpaquePresenceBorder
                }
            }
        }
    }

    @objc private func toggleShowPresence(switchView: UISwitch) {
        isShowingPresence = switchView.isOn
    }

    @objc private func toggleUseOpaquePresenceBorder(switchView: UISwitch) {
        isUsingOpaquePresenceBorder = switchView.isOn
    }

    @objc private func toggleAlternateBackground(switchView: UISwitch) {
        isUsingAlternateBackgroundColor = switchView.isOn
    }

    private func updateBackgroundColor() {
        view.backgroundColor = isUsingAlternateBackgroundColor ? UIColor(light: Colors.gray100, dark: Colors.gray600) : Colors.surfacePrimary
    }

    private var avatarViewsWithImages: [AvatarView] = []
    private var avatarViewsWithInitials: [AvatarView] = []

    private func createSection(withTitle title: String, name: String, image: UIImage, style: AvatarStyle, borderStyle: BorderStyle = .noBorder, withPresence: Bool = false) {
        addTitle(text: title)

        for size in AvatarSize.allCases.reversed() {
            let presenceWithImage = withPresence ? size.presenceWithImage : .none
            let imageAvatar = createAvatarView(size: size, name: name, image: image, style: style, borderStyle: borderStyle, presence: presenceWithImage)
            avatarViewsWithImages.append(imageAvatar.1)

            let presenceWithInitials = withPresence ? size.presenceWithInitials : .none
            let initialsAvatar = createAvatarView(size: size, name: name, style: style, borderStyle: borderStyle, presence: presenceWithInitials)
            avatarViewsWithInitials.append(initialsAvatar.1)

            addRow(text: size.description, items: [imageAvatar.0, initialsAvatar.0], textStyle: .footnote, textWidth: 100)
        }

        container.addArrangedSubview(UIView())
    }

    private func createAvatarView(size: AvatarSize, name: String, image: UIImage? = nil, style: AvatarStyle, borderStyle: BorderStyle = .noBorder, presence: Presence = .none) -> (UIView, AvatarView) {
        let avatarView = AvatarView(avatarSize: size, withBorder: borderStyle != .noBorder, style: style)
        if borderStyle == .colorfulBorder, let customBorderImage = colorfulImageForFrame() {
            avatarView.customBorderImage = customBorderImage
        }

        avatarView.setup(primaryText: name, secondaryText: "", image: image, presence: presence)

        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarView)
        avatarContainer.widthAnchor.constraint(equalToConstant: AvatarSize.extraExtraLarge.size.width).isActive = true
        avatarContainer.heightAnchor.constraint(equalToConstant: avatarView.frame.height).isActive = true

        return (avatarContainer, avatarView)
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

    var presenceWithImage: Presence {
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

    var presenceWithInitials: Presence {
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
