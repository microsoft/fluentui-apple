//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonVNextDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading

        for style in ButtonVnextStyle.allCases {
            addTitle(text: style.description)

			let vnextButton = ButtonVnext(style: style, action: {
				print("Button Vnext Clicked...")})
			vnextButton.buttonTitle = "Button"
			let vnextButtonView = vnextButton.view ?? UIView()

			let disabledVnextButton = ButtonVnext(style: style, action: { print("Button Vnext Clicked...")})
			disabledVnextButton.buttonTitle = "Button"
			disabledVnextButton.isDisabled = true
			let disabledVnextButtonView = disabledVnextButton.view ?? UIView()

			addRow(items: [vnextButtonView, disabledVnextButtonView], itemSpacing: 20)
		}

		addTitle(text: "Switch Themes")
		let vnextButtonFluent = ButtonVnext(style: .primaryFilled, action: {
            StylesheetManager.default.theme = .fluentUI
		})
		vnextButtonFluent.buttonTitle = "Set FluentUI Theme"

		let vnextButtonTeams = ButtonVnext(style: .primaryFilled, action: {
            StylesheetManager.default.theme = .teams
		})
		vnextButtonTeams.buttonTitle = "Set Teams Theme"
		if let vnextButtonFluentView = vnextButtonFluent.view, let vnextButtonTeamsView = vnextButtonTeams.view {
			addRow(items: [vnextButtonFluentView, vnextButtonTeamsView])
		}

		addTitle(text: "___________________________")
		addTitle(text: "Current FluentUI Buttons")
		for style in MSFButtonStyle.allCases {
			addTitle(text: style.description)

			let button = MSFButton(style: style)
			button.setTitle("Button", for: .normal)

			let disabledButton = MSFButton(style: style)
			disabledButton.isEnabled = false
			disabledButton.setTitle("Button", for: .normal)

			addRow(items: [button, disabledButton], itemSpacing: 20)
		}

		container.addArrangedSubview(UIView())
	}
}

extension ButtonVnextStyle {
    var description: String {
        switch self {
        case .primaryFilled:
            return "Primary filled (SwiftUI)"
        case .primaryOutline:
            return "Primary outline (SwiftUI)"
        case .secondaryOutline:
            return "Secondary outline (SwiftUI)"
        case .tertiaryOutline:
            return "Tertiary outline (SwiftUI)"
        case .borderless:
            return "Borderless (SwiftUI)"
        }
    }
}
