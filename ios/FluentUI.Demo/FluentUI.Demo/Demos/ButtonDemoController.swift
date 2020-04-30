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

            addRow(items: [button, disabledButton], itemSpacing: 20)
        }

        addTitle(text: "With multi-line title")
        let button = Button(style: .primaryFilled)
        button.setTitle("Longer Text Button", for: .normal)
        button.titleLabel?.numberOfLines = 0
        addRow(items: [button])

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
}
