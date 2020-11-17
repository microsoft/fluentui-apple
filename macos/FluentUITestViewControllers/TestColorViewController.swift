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
			colorsStackView.addArrangedSubview(createColorRowStackView(name: color.name, color: color.color))
		}
		
		/// Excel primary colors
		Colors.primary = (NSColor(named: "Colors/DemoPrimaryColor"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primary", color: Colors.primary))
		Colors.primaryShade10 = (NSColor(named: "Colors/DemoPrimaryShade10Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade10", color: Colors.primaryShade10))
		Colors.primaryShade20 = (NSColor(named: "Colors/DemoPrimaryShade20Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade20", color: Colors.primaryShade20))
		Colors.primaryShade30 = (NSColor(named: "Colors/DemoPrimaryShade30Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade30", color: Colors.primaryShade30))
		Colors.primaryTint10 = (NSColor(named: "Colors/DemoPrimaryTint10Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint10", color: Colors.primaryTint10))
		Colors.primaryTint20 = (NSColor(named: "Colors/DemoPrimaryTint20Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint20", color: Colors.primaryTint20))
		Colors.primaryTint30 = (NSColor(named: "Colors/DemoPrimaryTint30Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint30", color: Colors.primaryTint30))
		Colors.primaryTint40 = (NSColor(named: "Colors/DemoPrimaryTint40Color"))!
		colorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint40", color: Colors.primaryTint40))
		
		let documentView = NSView()
		documentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.documentView = documentView
		documentView.addSubview(colorsStackView)
		
		NSLayoutConstraint.activate([
			containerView.heightAnchor.constraint(equalTo:scrollView.heightAnchor),
			containerView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
			
			colorsStackView.topAnchor.constraint(equalTo: documentView.topAnchor, constant: colorRowSpacing),
			colorsStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: colorRowSpacing),
			colorsStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
			colorsStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor, constant: -colorRowSpacing)
		])
		
		view = containerView
	}

	private func createColorRowStackView(name: String?, color: NSColor?) -> NSStackView {
		let rowStackView = NSStackView()
		let textView = NSTextField(labelWithString: name!)
		let primaryColorView = ColorRectView(color: color!)
		textView.font = .systemFont(ofSize: 18)
		rowStackView.orientation = .horizontal
		rowStackView.spacing = 20.0
		rowStackView.addArrangedSubview(primaryColorView)
		rowStackView.addArrangedSubview(textView)
		return rowStackView
	}
}

class ColorRectView: NSView {
	
	let color: NSColor
	
	init(color: NSColor) {
		self.color = color
		super.init(frame: .zero)
	}
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 40, height: 40)
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	override func draw(_ dirtyRect: NSRect) {
		color.setFill()
		bounds.fill()
	}
}

fileprivate let colorRowSpacing: CGFloat = 10.0
