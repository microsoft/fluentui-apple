//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class AvatarStackDemoController: DemoController {
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

        addRow(text: "Avatar count", items: [incrementBadgeButton, decrementBadgeButton], textStyle: .footnote, textWidth: 100)

        for size in AvatarSize.allCases.reversed() {
            let avatarStack = AvatarStack(with: Array(samplePersonas.prefix(avatarCount)), size: size)
            addRow(text: size.description, items: [avatarStack], textStyle: .footnote, textWidth: 100)
        }
    }

    private var avatarCount: Int = 4 {
        didSet {
            reloadAvatarViews()
        }
    }

    @objc private func incrementBadgeNumbers() {
        avatarCount += 1
    }

    @objc private func decrementBadgeNumbers() {
        if avatarCount > 1 {
            avatarCount -= 1
        }
    }
}
