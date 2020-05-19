//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestLinkViewController: NSViewController {
	override func loadView() {		
		let containerView = NSStackView(frame: .zero)
		containerView.addView(Link(content: "Bing", url: NSURL(string: "https://wwww.bing.com")!), in: .center)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
