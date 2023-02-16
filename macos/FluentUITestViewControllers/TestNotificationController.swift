//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

class TestNotificationController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical

		let leadingImage = NSImage(named: NSImage.touchBarPlayTemplateName)!
		let notificationList = [
			Notification(style: .primaryToast, message: "Mail Archived", actionButtonTitle: "Undo", actionButtonAction: buttonPressed),
			Notification(style: .primaryToast, message: "Listen to Emails • 7 mins", title: "Kat's iPhoneX", image: leadingImage, actionButtonAction: buttonPressed),
			Notification(style: .neutralToast, message: "Some items require you to sign in to view them", actionButtonTitle: "Sign in", actionButtonAction: buttonPressed),
			Notification(style: .dangerToast, message: "There was a problem, and your recent changes may not have saved", actionButtonTitle: "Retry", actionButtonAction: buttonPressed),
			Notification(style: .warningToast, message: "Read Only", actionButtonAction: buttonPressed),
			Notification(style: .primaryBar, message: "Updating..."),
			Notification(style: .primaryOutlineBar, message: "Mail Sent"),
			Notification(style: .neutralBar, message: "No internet connection")
		]

		var constraints = [NSLayoutConstraint]()

		for (i, notification) in notificationList.enumerated() {
			let hostingView = NSHostingView(rootView: notification)
			containerView.addView(hostingView, in: .center)
			if i < 5 {
				constraints.append(hostingView.widthAnchor.constraint(equalToConstant: 350))
			} else {
				constraints.append(hostingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor))
			}
		}

		NSLayoutConstraint.activate(constraints)
		view = containerView
	}
}

func buttonPressed() {
	print("Button pressed")
}
