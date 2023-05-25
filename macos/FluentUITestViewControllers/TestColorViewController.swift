//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestColorViewController: NSViewController, ColorProviding {
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

	// MARK: ColorProviding Protocol

	var primary: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryColor"))! : Colors.Palette.communicationBlue.color
	var primaryShade10: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryShade10Color"))! : Colors.Palette.communicationBlueShade10.color
	var primaryShade20: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryShade20Color"))! : Colors.Palette.communicationBlueShade20.color
	var primaryShade30: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryShade30Color"))! : Colors.Palette.communicationBlueShade30.color
	var primaryTint10: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryTint10Color"))! : Colors.Palette.communicationBlueTint10.color
	var primaryTint20: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryTint20Color"))! : Colors.Palette.communicationBlueTint20.color
	var primaryTint30: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryTint30Color"))! : Colors.Palette.communicationBlueTint30.color
	var primaryTint40: NSColor = useColorProvider ? (NSColor(named: "Colors/DemoPrimaryTint40Color"))! : Colors.Palette.communicationBlueTint40.color

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
			Colors.colorProvider = self
		} else {
			// If we aren't using the new ColorProvider, clear it and fall back to initializing all the colors at onced
			Colors.colorProvider = nil
			Colors.primary = Colors.Palette.communicationBlue.color
			Colors.primaryShade10 = Colors.Palette.communicationBlueShade10.color
			Colors.primaryShade20 = Colors.Palette.communicationBlueShade20.color
			Colors.primaryShade30 = Colors.Palette.communicationBlueShade30.color
			Colors.primaryTint10 = Colors.Palette.communicationBlueTint10.color
			Colors.primaryTint20 = Colors.Palette.communicationBlueTint20.color
			Colors.primaryTint30 = Colors.Palette.communicationBlueTint30.color
			Colors.primaryTint40 = Colors.Palette.communicationBlueTint40.color
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
private var useColorProvider: Bool = true
