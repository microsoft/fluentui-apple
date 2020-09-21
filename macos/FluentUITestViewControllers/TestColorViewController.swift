//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestColorViewController: NSViewController {
	override func loadView() {
		let containerView = NSView()
		var textViews = [NSView]()
		
		for color in Colors.Palette.allCases {
			let textField = NSTextField(labelWithString: color.name)
			textField.textColor = color.color
			textViews.append(textField)
		}
		
		let stackView = NSStackView(views: textViews)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.orientation = .vertical
		
		let scrollView = NSScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.hasVerticalScroller = true
		containerView.addSubview(scrollView)
		
		let documentView = NSView()
		documentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.documentView = documentView
		documentView.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			containerView.heightAnchor.constraint(equalTo:scrollView.heightAnchor),
			containerView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
			stackView.topAnchor.constraint(equalTo: documentView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor),
			stackView.widthAnchor.constraint(equalTo: documentView.widthAnchor)
		])
		
		view = containerView
	}
}
