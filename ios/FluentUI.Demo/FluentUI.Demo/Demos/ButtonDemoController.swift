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

        for style in MSFButtonStyle.allCases {
            addTitle(text: style.description)

            let button = MSFButton(style: style)
            button.setTitle("Button", for: .normal)

            let disabledButton = MSFButton(style: style)
            disabledButton.isEnabled = false
            disabledButton.setTitle("Button", for: .normal)

            addRow(items: [button, disabledButton], itemSpacing: 20)

            if let image = style.image {
                let iconButton = MSFButton(style: style)
                iconButton.setTitle("Button", for: .normal)
                iconButton.image = image

                let disabledIconButton = MSFButton(style: style)
                disabledIconButton.isEnabled = false
                disabledIconButton.setTitle("Button", for: .normal)
                disabledIconButton.image = image

                addRow(items: [iconButton, disabledIconButton], itemSpacing: 20)

                let iconOnlyButton = MSFButton(style: style)
                iconOnlyButton.image = image

                let disabledIconOnlyButton = MSFButton(style: style)
                disabledIconOnlyButton.isEnabled = false
                disabledIconOnlyButton.image = image

                addRow(items: [iconOnlyButton, disabledIconOnlyButton], itemSpacing: 20)
            }
        }

        addTitle(text: "With multi-line title")
        let button = MSFButton(style: .primaryFilled)
        button.setTitle("Longer Text Button", for: .normal)
        button.titleLabel?.numberOfLines = 0

        let iconButton = MSFButton(style: .primaryFilled)
        iconButton.setTitle("Longer Text Button", for: .normal)
        iconButton.titleLabel?.numberOfLines = 0
        iconButton.image = MSFButtonStyle.primaryFilled.image

        addRow(items: [button])
        addRow(items: [iconButton])

        container.addArrangedSubview(UIView())
    }
}

extension MSFButtonStyle {
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
