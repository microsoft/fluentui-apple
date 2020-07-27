//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        for style in ButtonStyle.allCases {
            addTitle(text: style.description)

            let button = Button(style: style)
            button.setTitle("Button", for: .normal)

            let disabledButton = Button(style: style)
            disabledButton.isEnabled = false
            disabledButton.setTitle("Button", for: .normal)

            var buttons: [Button] = [button, disabledButton]

            if let image = style.image {
                let iconButton = Button(style: style)
                iconButton.setTitle("Button", for: .normal)
                iconButton.image = image

                let disabledIconButton = Button(style: style)
                disabledIconButton.isEnabled = false
                disabledIconButton.setTitle("Button", for: .normal)
                disabledIconButton.image = image

                buttons.append(contentsOf: [iconButton, disabledIconButton])
            }

            addRow(items: buttons, itemSpacing: 20)
        }

        addTitle(text: "With multi-line title")
        let button = Button(style: .primaryFilled)
        button.setTitle("Longer Text Button", for: .normal)
        button.titleLabel?.numberOfLines = 0

        let iconButton = Button(style: .primaryFilled)
        iconButton.setTitle("Longer Text Button", for: .normal)
        iconButton.titleLabel?.numberOfLines = 0
        iconButton.image = ButtonStyle.primaryFilled.image

        addRow(items: [button, iconButton])

        container.addArrangedSubview(UIView())
    }
}

extension ButtonStyle {
    var description: String {
        switch self {
        case .primaryFilled:
            return "Primary filled"
        case .primaryOutline:
            return "Primary outline"
        case .secondaryOutline:
            return "Secondary outline"
        case .tertiaryOutline:
            return "Tertiary outline"
        case .borderless:
            return "Borderless"
        }
    }

    var image: UIImage? {
        switch self {
        case .primaryFilled, .primaryOutline:
            return UIImage(named: "Placeholder_24")!
        case .secondaryOutline:
            return UIImage(named: "Placeholder_20")!
        case .tertiaryOutline, .borderless:
            return nil
        }
    }
}
