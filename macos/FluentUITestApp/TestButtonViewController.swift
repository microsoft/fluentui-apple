//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI


class TestButtonViewController: NSViewController {
	override func loadView() {
		let enabledButtons = testButtons()
		let disabledButtons = testButtons().map { button -> NSButton in
			button.isEnabled = false
			return button
		}
		
		// Create a vertical stack view for each set of buttons
		let stackViews = [enabledButtons, disabledButtons].map { buttons -> NSStackView in
			let stackView = NSStackView(views: buttons)
			stackView.orientation = .vertical
			stackView.alignment = .leading
			let spacing = stackView.spacing
			stackView.edgeInsets = NSEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
			return stackView
		}
		
		// set our view to a horizontal stack view containing the vertical stack views
		let containerView = NSStackView(views: stackViews)
		containerView.alignment = .top
		let spacing = containerView.spacing
		containerView.edgeInsets = NSEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
		containerView.orientation = .horizontal
		
		view = containerView
	}
	
	private func testNSButtons() -> [NSButton] {
		return [
			NSButton(title: "NSButton", target: nil, action: nil),
			NSButton(title: "+", target: nil, action: nil)
		]
	}
	
	private func testFluentButtons() -> [Button] {
		return [
			Button(title: "Primary Filled", style: .primaryFilled),
			Button(title: "+", style: .primaryFilled),
			Button(title: "Primary Outline", style: .primaryOutline),
			Button(title: "+", style: .primaryOutline),
			Button(title: "Borderless", style: .borderless),
			Button(title: "+", style: .borderless),
		]
	}
	
	private func testRedFluentButtons() -> [Button] {
		return testFluentButtons().map{ button -> Button in
			button.primaryColor = NSColor.systemRed
			return button
		}
	}
	
	private func testButtons() -> [NSButton] {
		return testNSButtons() + testFluentButtons() + testRedFluentButtons()
	}
}

