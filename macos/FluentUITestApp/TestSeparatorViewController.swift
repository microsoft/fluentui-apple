//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestSeparatorViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.addView(Separator(), in: .center)
		containerView.addView(NSTextField(labelWithString: "Outside separators are style \"default\""), in: .center)
		
		containerView.addView(Separator(style: .shadow, orientation: .horizontal), in: .center)

		containerView.addView(NSStackView(views: [
			Separator(orientation: .vertical),
			NSTextField(labelWithString: "Left"),
			Separator(style: .shadow, orientation: .vertical),
			NSTextField(labelWithString: "Middle"),
			Separator(style: .shadow, orientation: .vertical),
			NSTextField(labelWithString: "Right"),
			Separator(orientation: .vertical)
		]), in: .center)

		containerView.addView(Separator(style: .shadow, orientation: .horizontal), in: .center)
		
		containerView.addView(NSTextField(labelWithString: "Inside Separators are style \"shadow\""), in: .center)

		containerView.addView(Separator(), in: .center)
		
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
