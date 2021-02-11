//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestLinkViewController: NSViewController {
	let disabledLink = Link(title: "Disabled link with hover effects")

	override func loadView() {
		let url = NSURL(string: "https://github.com/microsoft/fluentui-apple")

		let linkWithNoUnderline = Link(title: "Link", url: url)

		let linkWithHover = Link(title: "Link with hover effects", url: url)
		linkWithHover.showsUnderlineWhileMouseInside = true

		let linkWithHoverAndNoURL = Link(title: "Link with hover effects and no URL")
		linkWithHoverAndNoURL.showsUnderlineWhileMouseInside = true

		let linkWithOverridenTargetAction = Link(title: "Link with overridden Target/Action")
		linkWithOverridenTargetAction.showsUnderlineWhileMouseInside = true
		linkWithOverridenTargetAction.target = self
		linkWithOverridenTargetAction.action = #selector(displayAlert)

		let customLink = Link(title: "Link with custom font, color and image", url: url)
		customLink.font = NSFont.systemFont(ofSize: 12.0, weight: NSFont.Weight.semibold)
		customLink.contentTintColor = .textColor
		customLink.image = NSImage(named: NSImage.goRightTemplateName)!
		customLink.imagePosition = .imageTrailing

		disabledLink.showsUnderlineWhileMouseInside = true
		disabledLink.isEnabled = false
		disabledLink.target = self
		disabledLink.action = #selector(toggleLink)

		let toggleDisabledLink = Link(title: "Toggle disabled link")
		toggleDisabledLink.showsUnderlineWhileMouseInside = true
		toggleDisabledLink.target = self
		toggleDisabledLink.action = #selector(toggleLink)

		let containerView = NSStackView(views: [
			linkWithNoUnderline,
			linkWithHover,
			linkWithHoverAndNoURL,
			linkWithOverridenTargetAction,
			customLink,
			disabledLink,
			toggleDisabledLink
		])
		containerView.edgeInsets = NSEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}

	@objc private func toggleLink() {
		disabledLink.isEnabled = !disabledLink.isEnabled
	}

	@objc private func displayAlert() {
		let alert = NSAlert()
		alert.messageText = "Alert"
		alert.informativeText = "This is an alert generated by a Link with an overridden Target/Action"
		alert.runModal()
	}
}
