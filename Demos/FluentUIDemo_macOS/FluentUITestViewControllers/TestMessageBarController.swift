//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

/// Test view controller for the MessageBar class
class TestMessageBarController: NSViewController {
	override func viewDidLoad() {
		let stackingView = MessageBarStackHostingView()
		stackingView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(stackingView)

		view.addConstraints([
			view.leadingAnchor.constraint(equalTo: stackingView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: stackingView.trailingAnchor),
			view.topAnchor.constraint(equalTo: stackingView.topAnchor),
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
}
