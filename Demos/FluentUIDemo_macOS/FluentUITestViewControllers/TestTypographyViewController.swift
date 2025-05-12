//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestTypographyViewController: NSViewController {
	override func viewDidLoad() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical

		for typographyToken in FluentTheme.TypographyToken.allCases {
			let text = NSTextField(labelWithString: typographyToken.text)
			text.font = NSFont.fluent(fluentTheme.typographyInfo(typographyToken))
			containerView.addArrangedSubview(text)
		}

		view = containerView
	}
}

// MARK: - Private extensions
private let fluentTheme = FluentTheme()

private extension FluentTheme.TypographyToken {
	var text: String {
		switch self {
		case .display:
			return "Display"
		case .largeTitle:
			return "Large Title"
		case .title1:
			return "Title 1"
		case .title2:
			return "Title 2"
		case .title3:
			return "Title 3"
		case .body1Strong:
			return "Body 1 Strong"
		case .body1:
			return "Body 1"
		case .body2Strong:
			return "Body 2 Strong"
		case .body2:
			return "Body 2"
		case .caption1Strong:
			return "Caption 1 Strong"
		case .caption1:
			return "Caption 1"
		case .caption2:
			return "Caption 2"
		}
	}
}

