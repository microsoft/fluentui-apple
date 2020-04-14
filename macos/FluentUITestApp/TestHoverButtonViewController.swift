//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

class TestHoverButtonViewController: NSViewController {
	override func loadView() {		
		let containerView = NSStackView(frame: .zero)
		// TODO: Actually add a hover button
		containerView.addView(NSButton(title: "Button", target: nil, action: nil), in: .center)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
