//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: - AvatarGroupDemoController

class AvatarGroupDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadAvatarViews()
    }

    private lazy var incrementBadgeButton: MSFButton = {
        return createButton(title: "+", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.avatarCount < samplePersonas.count {
                strongSelf.avatarCount += 1
            }
        })
    }()

    private lazy var decrementBadgeButton: MSFButton = {
        return createButton(title: "-", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.avatarCount > 1 {
                strongSelf.avatarCount -= 1
            }
        })
    }()

    private lazy var maxAvatarButton: MSFButton = {
        let button = createButton(title: "Set", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.maxAvatarsTextField.text, let count = Int(text) {
                strongSelf.maxDisplayedAvatars = count
                strongSelf.maxAvatarButton.state.isDisabled = true
            }

            strongSelf.maxAvatarsTextField.resignFirstResponder()
        })
        button.state.isDisabled = true

        return button
    }()

    private lazy var maxAvatarsTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(maxDisplayedAvatars)"
        textField.isEnabled = true

        return textField
    }()

    private lazy var overflowCountButton: MSFButton = {
        let button = createButton(title: "Set", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            if let text = strongSelf.overflowCountTextField.text, let count = Int(text) {
                strongSelf.overflowCount = count
                strongSelf.overflowCountButton.state.isDisabled = true
            }

            strongSelf.overflowCountTextField.resignFirstResponder()
        })
        button.state.isDisabled = true

        return button
    }()

    private lazy var overflowCountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(overflowCount)"
        textField.isEnabled = true

        return textField
    }()

    private func reloadAvatarViews() {
        avatarGroups.removeAll()

        for view in container.arrangedSubviews {
            view.removeFromSuperview()
        }

        let settingsTitle = Label(style: .headline, colorStyle: .regular)
        settingsTitle.text = "Settings"
        container.addArrangedSubview(settingsTitle)

        let avatarCountButtonsStackView = UIStackView(arrangedSubviews: [incrementBadgeButton.view, decrementBadgeButton.view])
        avatarCountButtonsStackView.spacing = 30
        addRow(text: "Avatar count", items: [avatarCountButtonsStackView], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        let backgroundColorSwitch = UISwitch(frame: .zero)
        backgroundColorSwitch.isOn = isUsingAlternateBackgroundColor
        backgroundColorSwitch.addTarget(self, action: #selector(toggleAlternateBackground(switchView:)), for: .valueChanged)

        addRow(text: "Use alternate background color", items: [backgroundColorSwitch], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        maxAvatarButton.view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addRow(text: "Max displayed avatars", items: [UIStackView(arrangedSubviews: [maxAvatarsTextField, maxAvatarButton.view])], textStyle: .footnote, textWidth: Constants.settingsTextWidth)
        overflowCountButton.view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addRow(text: "Overflow count", items: [UIStackView(arrangedSubviews: [overflowCountTextField, overflowCountButton.view])], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        addTitle(text: "Avatar Stack No Border")
        insertAvatarViews(style: .stack, showBorders: false)
        addTitle(text: "Avatar Stack With Border")
        insertAvatarViews(style: .stack, showBorders: true)
        addTitle(text: "Avatar Stack With Mixed Border")
        insertAvatarViews(style: .stack, showBorders: true, mixed: true)
        addTitle(text: "Avatar Pile No Border")
        insertAvatarViews(style: .pile, showBorders: false)
        addTitle(text: "Avatar Pile With Border")
        insertAvatarViews(style: .pile, showBorders: true)
        addTitle(text: "Avatar Pile With Mixed Border")
        insertAvatarViews(style: .pile, showBorders: true, mixed: true)
    }

    private struct Constants {
        static let settingsTextWidth: CGFloat = 200
        static let avatarsTextWidth: CGFloat = 100
        static let maxTextInputCharCount: Int = 4
    }

    private var avatarGroups: [MSFAvatarGroup] = []

    private var avatarCount: Int = 5 {
        didSet {
            reloadAvatarViews()
        }
    }

    private var isUsingAlternateBackgroundColor: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    private func updateBackgroundColor() {
        view.backgroundColor = isUsingAlternateBackgroundColor ? UIColor(light: Colors.gray100, dark: Colors.gray600) : Colors.surfacePrimary
    }

    @objc private func toggleAlternateBackground(switchView: UISwitch) {
        isUsingAlternateBackgroundColor = switchView.isOn
    }

    private var maxDisplayedAvatars: Int = 4 {
        didSet {
            if oldValue != maxDisplayedAvatars {
                maxAvatarsTextField.text = "\(maxDisplayedAvatars)"

                for avatarGroup in avatarGroups {
                    avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
                }
            }
        }
    }

    private var overflowCount: Int = 0 {
        didSet {
            if oldValue != overflowCount {
                overflowCountTextField.text = "\(overflowCount)"

                for avatarGroup in avatarGroups {
                    avatarGroup.state.overflowCount = overflowCount
                }
            }
        }
    }

    private func insertAvatarViews(style: MSFAvatarGroupStyle, showBorders: Bool, mixed: Bool = false) {
        var constraints: [NSLayoutConstraint] = []

        for size in MSFAvatarSize.allCases.reversed() {
            let containerView = UIView(frame: .zero)

            let avatarGroup = MSFAvatarGroup(style: style, size: size)
            var border = showBorders
            for index in 0...avatarCount - 1 {
                vSamplePersonas[index].isRingVisible = border
                if mixed {
                    border = !border
                }

                let avatarState = avatarGroup.state.createAvatar(style: .default, size: size)
                let samplePersona = vSamplePersonas[index]

                avatarState?.accessibilityLabel = samplePersona.accessibilityLabel
                avatarState?.backgroundColor = samplePersona.backgroundColor
                avatarState?.foregroundColor = samplePersona.foregroundColor
                avatarState?.hasPointerInteraction = samplePersona.hasPointerInteraction
                avatarState?.hasRingInnerGap = samplePersona.hasRingInnerGap
                avatarState?.image = samplePersona.image
                avatarState?.imageBasedRingColor = samplePersona.imageBasedRingColor
                avatarState?.isOutOfOffice = samplePersona.isOutOfOffice
                avatarState?.isRingVisible = border
                avatarState?.isTransparent = samplePersona.isTransparent
                avatarState?.presence = samplePersona.presence
                avatarState?.primaryText = samplePersona.primaryText
                avatarState?.ringColor = samplePersona.ringColor
                avatarState?.secondaryText = samplePersona.secondaryText
            }

            avatarGroup.state.maxDisplayedAvatars = maxDisplayedAvatars
            avatarGroup.state.overflowCount = overflowCount
            avatarGroups.append(avatarGroup)
            let avatarGroupView = avatarGroup.view
            avatarGroupView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(avatarGroupView)

            let trailingConstraint = containerView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            trailingConstraint.priority = .defaultHigh

            constraints.append(contentsOf: [
                avatarGroupView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                avatarGroupView.topAnchor.constraint(equalTo: containerView.topAnchor),
                avatarGroupView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                trailingConstraint
            ])

            addRow(text: size.description, items: [containerView], textStyle: .footnote, textWidth: 100)
        }

        NSLayoutConstraint.activate(constraints)
    }

    private var vSamplePersonas: [MSFAvatarState] = {
        var personas: [MSFAvatarState] = []
        for index in 0...samplePersonas.count - 1 {
            let state = MSFAvatar().state
            state.image = samplePersonas[index].avatarImage
            state.primaryText = samplePersonas[index].primaryText
            state.secondaryText = samplePersonas[index].secondaryText
            personas.append(state)
        }
        return personas
    }()
}

// MARK: - AvatarGroupDemoController: UITextFieldDelegate

extension AvatarGroupDemoController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        guard let stringRange = Range(range, in: text) else {
            return false
        }

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        var shouldChangeCharacters = allowedCharacters.isSuperset(of: characterSet)

        if shouldChangeCharacters {
            text = text.replacingCharacters(in: stringRange, with: string)
            shouldChangeCharacters = text.count <= Constants.maxTextInputCharCount
        }

        let button = textField == maxAvatarsTextField ? maxAvatarButton : overflowCountButton
        if let count = UInt(text) {
            if textField == maxAvatarsTextField {
                button.state.isDisabled = count <= 0 || count == maxDisplayedAvatars
            } else {
                button.state.isDisabled = count == overflowCount
            }
        } else {
            button.state.isDisabled = true
        }

        return shouldChangeCharacters
    }
}
