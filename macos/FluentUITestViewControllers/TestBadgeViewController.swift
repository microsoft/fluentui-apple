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

		// Load Excel app color as primary to distinguish .primary and .communicationBlue accentColors
		Colors.primary = (NSColor(named: "Colors/DemoPrimaryColor"))!
		Colors.primaryTint40 = (NSColor(named: "Colors/DemoPrimaryTint40Color"))!
		Colors.primaryTint30 = (NSColor(named: "Colors/DemoPrimaryTint30Color"))!
		Colors.primaryShade20 = (NSColor(named: "Colors/DemoPrimaryShade20Color"))!
		containerView.addView(BadgeView(title: "Primary", style: .primary), in: .center)

		let customBadge = BadgeView(title: "Custom")
		customBadge.backgroundColor = DynamicColor(light: Colors.Palette.blueMagenta20.color, dark: Colors.Palette.gray50.color)
		customBadge.textColor = DynamicColor(light: Colors.Palette.gray50.color, dark: Colors.Palette.blueMagenta20.color)
		containerView.addView(customBadge, in: .center)

		view = containerView
	}
}
