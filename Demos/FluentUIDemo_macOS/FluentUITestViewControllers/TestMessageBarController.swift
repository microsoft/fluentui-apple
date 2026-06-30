//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

/// Test view controller for the MessageBar class
class TestMessageBarController: NSViewController {
	private let stackingView = MessageBarStackHostingView()

	override func viewDidLoad() {
		stackingView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(stackingView)

		let toggleButton = NSButton(
			title: "Draw top divider",
			target: self,
			action: #selector(toggleDrawsTopDivider(_:))
		)
		toggleButton.setButtonType(.switch)
		toggleButton.state = .on
		toggleButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(toggleButton)

		view.addConstraints([
			view.leadingAnchor.constraint(equalTo: stackingView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: stackingView.trailingAnchor),
			view.topAnchor.constraint(equalTo: stackingView.topAnchor),
			toggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			toggleButton.topAnchor.constraint(equalTo: stackingView.bottomAnchor, constant: 16),
		])

		for ii in 0..<3 {
			let configuration = MessageBarConfigurationObject()
			configuration.title = "Descriptive Title"
			configuration.message = "Message providing information to the user with actionable insights."
			configuration.hasCloseButton = true
			configuration.actionTitles = ["One", "Two"]
			configuration.onAction = { index in
				let alert = NSAlert()
				alert.messageText = "Action button \(index) on the MessageBarView was pressed."
				alert.runModal()
			}
			configuration.onClose = {
				let alert = NSAlert()
				alert.messageText = "Close button on the MessageBarView was pressed."
				alert.runModal()
			}
			stackingView.addBar(barID: ii, configuration: configuration)
			stackingView.showBar(barID: ii)
		}
		stackingView.updateLayout()
	}

	@objc private func toggleDrawsTopDivider(_ sender: NSButton) {
		stackingView.drawsTopDivider = (sender.state == .on)
	}
}
