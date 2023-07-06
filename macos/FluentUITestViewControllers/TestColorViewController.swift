//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestColorViewController: NSViewController {
	var primaryColorsStackView = NSStackView()
	var subviewConstraints = [NSLayoutConstraint]()
	var toggleTextView = NSTextView(frame: NSRect(x: 0, y: 0, width: 100, height: 20))

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

		primaryColorsStackView.translatesAutoresizingMaskIntoConstraints = false
		primaryColorsStackView.orientation = .vertical
		primaryColorsStackView.alignment = .leading

		for color in Colors.Palette.allCases {
			colorsStackView.addArrangedSubview(createColorRowStackView(name: color.name, color: color.color))
		}

		loadPrimaryColors()

		let documentView = NSView()
		documentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.documentView = documentView
		documentView.addSubview(colorsStackView)
		documentView.addSubview(primaryColorsStackView)

		subviewConstraints = [
			containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
			containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			colorsStackView.topAnchor.constraint(equalTo: documentView.topAnchor, constant: colorRowSpacing),
			colorsStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: colorRowSpacing),
			colorsStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
			primaryColorsStackView.topAnchor.constraint(equalTo: colorsStackView.bottomAnchor, constant: colorRowSpacing),
			primaryColorsStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: colorRowSpacing),
			primaryColorsStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor)
		]

		let switchButton = NSSwitch(frame: CGRect(x: 1, y: 1, width: 100, height: 50))
		switchButton.target = self
		switchButton.state = useColorProvider ? .on : .off
		switchButton.action = #selector(toggleClicked)
		toggleTextView.string = "Use ColorProvider"
		toggleTextView.font = .systemFont(ofSize: 20)
		toggleTextView.isEditable = false
		toggleTextView.isSelectable = false
		toggleTextView.backgroundColor = .clear

		let toggleStackView = NSStackView()
		toggleStackView.translatesAutoresizingMaskIntoConstraints = false
		toggleStackView.orientation = .horizontal
		toggleStackView.spacing = 20.0
		toggleStackView.addArrangedSubview(switchButton)
		toggleStackView.addArrangedSubview(toggleTextView)
		documentView.addSubview(toggleStackView)

		subviewConstraints.append(contentsOf: [
			toggleStackView.topAnchor.constraint(equalTo: primaryColorsStackView.bottomAnchor, constant: colorRowSpacing),
			toggleStackView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor, constant: colorRowSpacing),
			toggleStackView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor, constant: colorRowSpacing),
			toggleStackView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor, constant: -colorRowSpacing)
		])

		NSLayoutConstraint.activate(subviewConstraints)
		view = containerView
	}

	// MARK: Private

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

	@objc private func toggleClicked(button: NSSwitch?) {
		primaryColorsStackView.subviews.removeAll()
		useColorProvider = button?.state == .on ? true : false
		loadPrimaryColors()
	}

	private func loadPrimaryColors() {
		if useColorProvider {
			// Set our Test Color Provider singleton
			Colors.colorProvider = TestColorProvider.shared
		} else {
			// Clear Test Color Provider singleton so communication blue defaults will be used
			Colors.colorProvider = nil
		}

		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primary", color: Colors.primary))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade10", color: Colors.primaryShade10))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade20", color: Colors.primaryShade20))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryShade30", color: Colors.primaryShade30))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint10", color: Colors.primaryTint10))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint20", color: Colors.primaryTint20))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint30", color: Colors.primaryTint30))
		primaryColorsStackView.addArrangedSubview(createColorRowStackView(name: "primaryTint40", color: Colors.primaryTint40))
		NSLayoutConstraint.activate(subviewConstraints)
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

private let colorRowSpacing: CGFloat = 10.0

// Default to using the new ColorProvider protocol for fetching the Fluent Primary Colors
private var useColorProvider = true
