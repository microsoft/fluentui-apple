//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: - AvatarGroupViewDemoController

class AvatarGroupViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadAvatarViews()
    }

    private lazy var incrementBadgeButton: Button = {
        return createButton(title: "+", action: #selector(incrementBadgeNumbers))
    }()

    private lazy var decrementBadgeButton: Button = {
        return createButton(title: "-", action: #selector(decrementBadgeNumbers))
    }()

    private lazy var maxAvatarButton: Button = {
        let button = createButton(title: "Set", action: #selector(maxAvatarButtonWasPressed))
        button.isEnabled = false

        return button
    }()

    private lazy var maxAvatarsTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.text = "\(maxDisplayedAvatars)"
        textField.isEnabled = true

        return textField
    }()

    private lazy var overflowCountButton: Button = {
        let button = createButton(title: "Set", action: #selector(overflowCountButtonWasPressed))
        button.isEnabled = false

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

        addRow(text: "Avatar count", items: [incrementBadgeButton, decrementBadgeButton], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        let backgroundColorSwitch = UISwitch(frame: .zero)
        backgroundColorSwitch.isOn = isUsingAlternateBackgroundColor
        backgroundColorSwitch.addTarget(self, action: #selector(toggleAlternateBackground(switchView:)), for: .valueChanged)

        addRow(text: "Use alternate background color", items: [backgroundColorSwitch], textStyle: .footnote, textWidth: Constants.settingsTextWidth)
        addRow(text: "Max displayed avatars", items: [maxAvatarsTextField, maxAvatarButton], textStyle: .footnote, textWidth: Constants.settingsTextWidth)
        addRow(text: "Overflow count", items: [overflowCountTextField, overflowCountButton], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        insertLabel(text: "Avatar stack without borders")
        insertAvatarViews(style: .stack, showBorders: false)

        insertLabel(text: "Avatar stack with borders")
        insertAvatarViews(style: .stack, showBorders: true)

        insertLabel(text: "Avatar pile without borders")
        insertAvatarViews(style: .pile, showBorders: false)

        insertLabel(text: "Avatar pile with borders")
        insertAvatarViews(style: .pile, showBorders: true)

        updateBackgroundColor()
    }

    private struct Constants {
        static let settingsTextWidth: CGFloat = 200
        static let avatarsTextWidth: CGFloat = 100
        static let maxTextInputCharCount: Int = 4
    }

    private var avatarGroups: [AvatarGroupView] = []

    private var avatarCount: Int = 5 {
        didSet {
            reloadAvatarViews()
        }
    }

    @objc private func incrementBadgeNumbers() {
        if avatarCount < samplePersonas.count {
            avatarCount += 1
        }
    }

    @objc private func decrementBadgeNumbers() {
        if avatarCount > 1 {
            avatarCount -= 1
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

    private var maxDisplayedAvatars: UInt = 3 {
        didSet {
            if oldValue != maxDisplayedAvatars {
                maxAvatarsTextField.text = "\(maxDisplayedAvatars)"

                for avatarGroup in avatarGroups {
                    avatarGroup.maxDisplayedAvatars = maxDisplayedAvatars
                }
            }
        }
    }

    @objc private func maxAvatarButtonWasPressed() {
        if let text = maxAvatarsTextField.text, let count = UInt(text) {
            maxDisplayedAvatars = count
            maxAvatarButton.isEnabled = false
        }

        maxAvatarsTextField.resignFirstResponder()
    }

    private var overflowCount: UInt = 0 {
        didSet {
            if oldValue != overflowCount {
                overflowCountTextField.text = "\(overflowCount)"

                for avatarGroup in avatarGroups {
                    avatarGroup.overflowCount = overflowCount
                }
            }
        }
    }

    @objc private func overflowCountButtonWasPressed() {
        if let text = overflowCountTextField.text, let count = UInt(text) {
            overflowCount = count
            overflowCountButton.isEnabled = false
        }

        overflowCountTextField.resignFirstResponder()
    }

    private func insertAvatarViews(style: AvatarGroupViewStyle, showBorders: Bool) {
        var constraints: [NSLayoutConstraint] = []

        for size in AvatarLegacySize.allCases.reversed() {
            let containerView = UIView(frame: .zero)

            let avatarGroupView = AvatarGroupView(avatars: Array(samplePersonas.prefix(avatarCount)),
                                                  size: size,
                                                  style: style,
                                                  showBorders: showBorders,
                                                  maxDisplayedAvatars: maxDisplayedAvatars,
                                                  overflowCount: overflowCount)
            avatarGroupView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(avatarGroupView)
            avatarGroups.append(avatarGroupView)

            let trailingConstraint = containerView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            trailingConstraint.priority = .defaultHigh

            constraints.append(contentsOf: [
                avatarGroupView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                avatarGroupView.topAnchor.constraint(equalTo: containerView.topAnchor),
                avatarGroupView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                trailingConstraint
            ])

            addRow(text: size.description, items: [containerView], textStyle: .footnote, textWidth: Constants.avatarsTextWidth)
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func insertLabel(text: String) {
        let label = Label(style: .headline, colorStyle: .regular)
        label.text = text

        container.addArrangedSubview(UIView())
        container.addArrangedSubview(label)
    }
}

// MARK: - AvatarGroupViewDemoController: UITextFieldDelegate

extension AvatarGroupViewDemoController: UITextFieldDelegate {
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
                button.isEnabled = count > 0 && count != maxDisplayedAvatars
            } else {
                button.isEnabled = count != overflowCount
            }
        } else {
            button.isEnabled = false
        }

        return shouldChangeCharacters
    }
}
