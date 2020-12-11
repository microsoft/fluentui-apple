//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarVnextDemoController: DemoController {
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

        let opaqueBorderSettingView = createLabelAndSwitchRow(labelText: "Use opaque borders",
                                                            switchAction: #selector(toggleOpaqueBorders(switchView:)),
                                                            isOn: isUsingOpaqueBorders)

        addRow(items: [backgroundSettingView])
        addRow(items: [showPresenceSettingView])
        addRow(items: [opaqueBorderSettingView])

        createSection(withTitle: "Circle style for person",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .noring)

        createSection(withTitle: "Square style for group",
                      name: "NorthWind Traders",
                      image: UIImage(named: "site")!,
                      style: .group)

        createSection(withTitle: "Circle style with border",
                      name: "Kat Larrson",
                      image: UIImage(named: "avatar_kat_larsson")!,
                      style: .default,
                      borderStyle: .defaultBorder)

        addTitle(text: "Fallback Images")
        for size in AvatarVnextSize.allCases.reversed() {
            let phoneNumber = "+1 (425) 123 4567"
            let fallbackImageAvatar = createAvatarView(size: size,
                                                       name: phoneNumber,
                                                       style: .noring)
            addRow(text: size.description, items: [fallbackImageAvatar.1.view], textStyle: .footnote, textWidth: 100)
        }

        addTitle(text: "Unauthenticated")
        for size in AvatarVnextSize.allCases.reversed() {
            let unauthenticatedAvatar = createAvatarView(size: size,
                                                         name: nil,
                                                         style: .unauthenticated)
            addRow(text: size.description, items: [unauthenticatedAvatar.1.view], textStyle: .footnote, textWidth: 100)
        }

        addTitle(text: "Overflow")
        for size in AvatarVnextSize.allCases.reversed() {
            let overflowAvatar = createAvatarView(size: size,
                                                  name: "20",
                                                  style: .overflow)
            addRow(text: size.description, items: [overflowAvatar.1.view], textStyle: .footnote, textWidth: 100)
        }
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
                    avatarView.state.presence = isShowingPresence ? nextPresence() : .none
                }

                for avatarView in avatarViewsWithInitials {
                    avatarView.state.presence = isShowingPresence ? nextPresence()  : .none
                }
            }
        }
    }

    private var isUsingOpaqueBorders: Bool = false {
        didSet {
            if oldValue != isUsingOpaqueBorders {
                for avatarView in avatarViewsWithImages {
                    avatarView.state.shouldUseOpaqueBorders = isUsingOpaqueBorders
                }

                for avatarView in avatarViewsWithInitials {
                    avatarView.state.shouldUseOpaqueBorders = isUsingOpaqueBorders
                }
            }
        }
    }

    private lazy var presenceIterator = AvatarVnextPresence.allCases.makeIterator()

    private func nextPresence() -> AvatarVnextPresence {
        var presence = presenceIterator.next()

        if presence == nil {
            presenceIterator = AvatarVnextPresence.allCases.makeIterator()
            presence = presenceIterator.next()
        }

        if presence! ==  .none {
            presence = presenceIterator.next()
        }

        return presence!
    }

    @objc private func toggleShowPresence(switchView: UISwitch) {
        isShowingPresence = switchView.isOn
    }

    @objc private func toggleAlternateBackground(switchView: UISwitch) {
        isUsingAlternateBackgroundColor = switchView.isOn
    }

    @objc private func toggleOpaqueBorders(switchView: UISwitch) {
        isUsingOpaqueBorders = switchView.isOn
    }

    private func updateBackgroundColor() {
        view.backgroundColor = isUsingAlternateBackgroundColor ? UIColor(light: Colors.gray100, dark: Colors.gray600) : Colors.surfacePrimary
    }

    private var avatarViewsWithImages: [AvatarVnext] = []
    private var avatarViewsWithInitials: [AvatarVnext] = []

    private func createSection(withTitle title: String,
                               name: String,
                               image: UIImage,
                               style: AvatarVnextStyle,
                               borderStyle: BorderStyle = .noBorder) {
        addTitle(text: title)

        for size in AvatarVnextSize.allCases.reversed() {
            let imageAvatar = createAvatarView(size: size,
                                               name: name,
                                               image: image,
                                               style: style)
            avatarViewsWithImages.append(imageAvatar.1)

            let initialsAvatar = createAvatarView(size: size,
                                                  name: name,
                                                  style: style)
            avatarViewsWithInitials.append(initialsAvatar.1)

            addRow(text: size.description, items: [imageAvatar.0, initialsAvatar.0], textStyle: .footnote, textWidth: 100)
        }

        container.addArrangedSubview(UIView())
    }

    private func createAvatarView(size: AvatarVnextSize,
                                  name: String? = nil,
                                  image: UIImage? = nil,
                                  style: AvatarVnextStyle) -> (UIView, AvatarVnext) {
        let avatarView = AvatarVnext(style: style,
                                     size: size)
        avatarView.state.primaryText = name
        avatarView.state.image = image

        return (avatarView.view, avatarView)
    }
}

extension AvatarVnextSize {
    var description: String {
        switch self {
        case .xsmall:
            return "ExtraSmall"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .xlarge:
            return "ExtraLarge"
        case .xxlarge:
            return "ExtraExtraLarge"
        }
    }
}
