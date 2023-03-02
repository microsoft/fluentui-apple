//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

class TestNotificationBarViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical

		let notificationList = [
			NotificationBarView(style: .accent, message: "Updating..."),
			NotificationBarView(style: .subtle, message: "Mail Sent"),
			NotificationBarView(style: .neutral, message: "No internet connection"),
			NotificationBarView(style: .neutral, message: "This error can be taken action on with the action on the right.", actionButtonTitle: "Action", actionButtonAction: buttonPressed)
		]

		var constraints = [NSLayoutConstraint]()

		for notification in notificationList {
			let hostingView = NSHostingView(rootView: notification)
			containerView.addView(hostingView, in: .center)
			constraints.append(hostingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor))
			constraints.append(hostingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor))
		}

		NSLayoutConstraint.activate(constraints)
		view = containerView
	}
}

func buttonPressed() {
	print("Button pressed")
}
