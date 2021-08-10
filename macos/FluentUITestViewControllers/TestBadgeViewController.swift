//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestBadgeViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)

		let description = NSTextField(labelWithString: "A simple colored text field, currently only supports\nthe default style and small size\nwith no user interaction")
		description.alignment = .center
		containerView.addView(description, in: .center)
		containerView.addView(BadgeView(title: "Badge"), in: .center)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
