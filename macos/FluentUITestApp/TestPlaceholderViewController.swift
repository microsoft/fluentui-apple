//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

class TestPlaceholderViewController: NSViewController {
	override func loadView() {
		let placeholderTitleView = NSTextField(labelWithString: "FluentUI macOS")
		placeholderTitleView.setContentCompressionResistancePriority(.required, for: .horizontal)
		placeholderTitleView.translatesAutoresizingMaskIntoConstraints = false
		
		let containerView = NSStackView(frame: .zero)
		if let image = NSImage(named: NSImage.bonjourName) {
			containerView.addView(NSImageView(image: image), in: .center)
		}
		containerView.addView(placeholderTitleView, in: .center)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
