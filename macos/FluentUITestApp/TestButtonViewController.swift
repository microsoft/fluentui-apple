//
// Copyright Microsoft Corporation
//

import AppKit
import FluentUI


class TestButtonViewController: NSViewController {
	override func loadView() {
		
		let enabledButtons: [NSButton] = [
			NSButton(title: "NSButton", target: nil, action: nil),
			Button(title: "Primary Filled", style: .primaryFilled),
			Button(title: "Primary Outline", style: .primaryOutline),
			Button(title: "Borderless", style: .borderless),
		]

		let disabledButtons: [NSButton] = [
			NSButton(title: "NSButton", target: nil, action: nil),
			Button(title: "Primary Filled", style: .primaryFilled),
			Button(title: "Primary Outline", style: .primaryOutline),
			Button(title: "Borderless", style: .borderless),
		]
		for button in disabledButtons {
			button.isEnabled = false
		}
		
		// Create a vertical stack view for each set of buttons
		let stackViews = [enabledButtons, disabledButtons].map { buttons -> NSStackView in
			let stackView = NSStackView(views: buttons)
			stackView.orientation = .vertical
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
}

