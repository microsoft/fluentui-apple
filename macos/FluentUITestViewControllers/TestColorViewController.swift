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
		
		let colorsStackView = NSStackView()
		colorsStackView.translatesAutoresizingMaskIntoConstraints = false
		colorsStackView.orientation = .vertical
		colorsStackView.alignment = .leading
		
		for color in Colors.Palette.allCases {
			let colorView = ColorRectView(color: color.color)
			colorView.invalidateIntrinsicContentSize()
			let textView = NSTextField(labelWithString: color.name)
			textView.font = .systemFont(ofSize: 18)
			let rowStackView = NSStackView()
			rowStackView.orientation = .horizontal
			rowStackView.spacing = 20.0
			rowStackView.addArrangedSubview(colorView)
			rowStackView.addArrangedSubview(textView)
			colorsStackView.addArrangedSubview(rowStackView)
		}
		
		let documentView = NSView()
		documentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.documentView = documentView
		documentView.addSubview(colorsStackView)
		
		NSLayoutConstraint.activate([
			containerView.heightAnchor.constraint(equalTo:scrollView.heightAnchor),
			containerView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),

			colorsStackView.topAnchor.constraint(equalTo: documentView.topAnchor, constant: 10.0),
			colorsStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: 10.0),
			colorsStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
			colorsStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor, constant: -10.0)
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
		return CGSize(width: 40, height: 40)
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
