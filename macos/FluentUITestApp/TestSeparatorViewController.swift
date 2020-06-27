//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestSeparatorViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.addView(Separator(orientation: .horizontal), in: .center)
		containerView.addView(NSTextField(labelWithString: "Separators are used to divide content"), in: .center)
		
		containerView.addView(Separator(orientation: .horizontal), in: .center)

		containerView.addView(NSStackView(views: [
			Separator(orientation: .vertical),
			NSTextField(labelWithString: "Left"),
			Separator(orientation: .vertical),
			NSTextField(labelWithString: "Middle"),
			Separator(orientation: .vertical),
			NSTextField(labelWithString: "Right"),
			Separator(orientation: .vertical)
		]), in: .center)

		containerView.addView(Separator(orientation: .horizontal), in: .center)
		
		containerView.addView(NSTextField(labelWithString: "They can be created in both orientations"), in: .center)

		containerView.addView(Separator(orientation: .horizontal), in: .center)
		
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
