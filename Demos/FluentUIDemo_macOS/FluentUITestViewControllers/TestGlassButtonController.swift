//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

/// Test view controller for the GlassButton class
class TestGlassButtonController: NSViewController {

	// Create various styles of GlassButton
	let displayedGlassButtons: [[NSView]] = glassButtons().map { glassButtons in
		glassButtons.map { glassButton in
			if #available(macOS 26.0, *) {
				let glassView = NSGlassEffectView()
				glassView.cornerRadius = .greatestFiniteMagnitude
				glassView.contentView = glassButton
				return glassView
			} else {
				return glassButton
			}
		}
	}

	override func loadView() {

		// Create a vertical stack view for each of our test identities
		let stackViews = displayedGlassButtons.map { glassButtons -> NSStackView in
			let stackView = NSStackView(views: glassButtons)
			stackView.orientation = .vertical
			let spacing = stackView.spacing
			stackView.edgeInsets = NSEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
			return stackView
		}

		// set our view to a horizontal stack view containing the vertical stack views
		let glassButtonContentView = NSStackView(views: stackViews)
		glassButtonContentView.alignment = .top

		let spacing = glassButtonContentView.spacing
		glassButtonContentView.edgeInsets = NSEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)

		let containerView = NSStackView(views: [
			glassButtonContentView,
			NSButton(checkboxWithTitle: "Use brand background", target: self, action: #selector(toggleBackgroundColor(_:)))
		])

		containerView.orientation = .vertical

		view = containerView
	}

	private static func glassButtons() -> [[GlassButton]] {
		let title = "Text"
		return [ButtonStyle.primary, ButtonStyle.secondary].map { buttonStyle in
			return [
				GlassButton(title: title, style: buttonStyle),
				GlassButton(title: title, image: templateImage(), style: buttonStyle),
				GlassButton(title: title, image: templateImage(), imagePosition: .imageOnly, style: buttonStyle)
			]
		}
	}

	private static func templateImage() -> NSImage {
		let image = NSImage(named: "Placeholder_20")!
		image.isTemplate = true
		return image
	}

	@objc func toggleBackgroundColor(_ sender: NSButton) {
		if (sender.state == .on) {
			view.layer?.backgroundColor = view.fluentTheme.nsColor(.brandBackground1).cgColor
		} else {
			view.layer?.backgroundColor = nil
		}
	}
}
