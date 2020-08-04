//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

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

    private func reloadAvatarViews() {
        for view in container.arrangedSubviews {
            view.removeFromSuperview()
        }

        let settingsTitle = Label(style: .headline, colorStyle: .regular)
        settingsTitle.text = "Settings"
        container.addArrangedSubview(settingsTitle)

        addRow(text: "Avatar count", items: [incrementBadgeButton, decrementBadgeButton], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        let backgroundColorSwitch = UISwitch()
        backgroundColorSwitch.isOn = isUsingAlternateBackgroundColor
        backgroundColorSwitch.addTarget(self, action: #selector(toggleAlternateBackground(switchView:)), for: .valueChanged)

        addRow(text: "Use alternate background color", items: [backgroundColorSwitch], textStyle: .footnote, textWidth: Constants.settingsTextWidth)

        insertLabel(text: "Avatar stack without borders")
        insertAvatarViews(style: .stack, showBorder: false)

        insertLabel(text: "Avatar stack with borders")
        insertAvatarViews(style: .stack, showBorder: true)

        insertLabel(text: "Avatar pile without borders")
        insertAvatarViews(style: .pile, showBorder: false)

        insertLabel(text: "Avatar pile with borders")
        insertAvatarViews(style: .pile, showBorder: true)

        updateBackgroundColor()
    }

    private struct Constants {
        static let settingsTextWidth: CGFloat = 200
        static let avatarsTextWidth: CGFloat = 100
    }

    private var avatarCount: Int = 4 {
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

    private func insertAvatarViews(style: AvatarGroupViewStyle, showBorder: Bool) {
        var constraints: [NSLayoutConstraint] = []

        for size in AvatarSize.allCases.reversed() {
            let containerView = UIView(frame: .zero)

            let avatarGroupView = AvatarGroupView(with: Array(samplePersonas.prefix(avatarCount)), size: size, style: style, displaysBorders: showBorder)
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
