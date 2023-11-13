//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestBadgeViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas

		containerView.addView(BadgeView(title: "Default"), in: .center)

		// Set our Test Color Provider singleton
		Colors.colorProvider = TestColorProvider.shared

		containerView.addView(BadgeView(title: "Primary", style: .primary), in: .center)

		let customBadge = BadgeView(title: "Custom")
		customBadge.backgroundColor = DynamicColor(light: Colors.Palette.blueMagenta20.color, dark: Colors.Palette.gray50.color)
		customBadge.textColor = DynamicColor(light: Colors.Palette.gray50.color, dark: Colors.Palette.blueMagenta20.color)
		containerView.addView(customBadge, in: .center)

		view = containerView
	}
}
