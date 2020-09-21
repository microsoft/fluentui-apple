//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestColorViewController: NSViewController {
	override func loadView() {
		let containerView = NSView()
		let scrollView = NSScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.hasVerticalScroller = true
		containerView.addSubview(scrollView)
		var colorViews = [NSView]()
		var textViews = [NSView]()
		
		for color in Colors.Palette.allCases {
			let colorView = ColorRectView(color: color.color)
			colorView.invalidateIntrinsicContentSize()
			colorViews.append(colorView)
			let textView = NSTextField(labelWithString: color.name)
			textViews.append(textView)
		}
		
		let colorStackView = NSStackView(views: colorViews)
		let textStackView = NSStackView(views: textViews)
		colorStackView.translatesAutoresizingMaskIntoConstraints = false
		colorStackView.orientation = .vertical
		textStackView.translatesAutoresizingMaskIntoConstraints = false
		textStackView.orientation = .vertical
		textStackView.alignment = .leading
		
		let documentView = NSView()
		documentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.documentView = documentView
		documentView.addSubview(colorStackView)
		documentView.addSubview(textStackView)
		
		NSLayoutConstraint.activate([
			containerView.heightAnchor.constraint(equalTo:scrollView.heightAnchor),
			containerView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
			colorStackView.topAnchor.constraint(equalTo: documentView.topAnchor),
			colorStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: 20.0),
			colorStackView.trailingAnchor.constraint(equalTo: textStackView.leadingAnchor, constant: -20.0),
			colorStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor),
			
			textStackView.topAnchor.constraint(equalTo: documentView.topAnchor),
			textStackView.leadingAnchor.constraint(equalTo: colorStackView.trailingAnchor),
			textStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
			textStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor)
		])
		
		view = containerView
	}
}

class ColorRectView: NSView {
	
	var color: NSColor = {
		let color = NSColor()
		return color
	}()
	
	init(color: NSColor) {
		super.init(frame: .zero)
		self.color = color
	}
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 17, height: 17)
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		color.setFill()
		bounds.fill()
	}
}
