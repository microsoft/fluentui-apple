//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestLinkViewController: NSViewController {
	override func loadView() {
		let linkWithNoHover = Link(title: "Bing", url: NSURL(string: "https://wwww.bing.com")!)
		
		let linkWithHover = Link(title: "Bing with hover", url: NSURL(string: "https://wwww.bing.com")!)
		linkWithHover.showsUnderlineWhileMouseInside = true
		
		let containerView = NSStackView(views: [linkWithNoHover, linkWithHover])
		containerView.edgeInsets = NSEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		view = containerView
	}
}
