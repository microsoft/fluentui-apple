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
        addTitle(text: "Avatar Pile")
        insertAvatarViews(style: .default, showBorders: false)
    }

    private func insertAvatarViews(style: MSFAvatarStyle, showBorders: Bool) {
        var constraints: [NSLayoutConstraint] = []

        for size in MSFAvatarSize.allCases.reversed() {
            let containerView = UIView(frame: .zero)

            let avatarGroup = MSFAvatarGroup()
            avatarGroup.state.size = size
            for index in 0...2 {
                avatarGroup.state.avatars.append(convertAvatar(persona: samplePersonas[index]))
            }
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

    func convertAvatar(persona: PersonaData) -> MSFAvatarStateImpl {
        let state = MSFAvatarStateImpl()
        state.image = persona.avatarImage
        state.primaryText = persona.primaryText
        state.secondaryText = persona.secondaryText
        return state
    }
}
