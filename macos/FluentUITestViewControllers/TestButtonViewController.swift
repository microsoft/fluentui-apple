//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

let effectViewMaterials: [String: NSVisualEffectView.Material] = [
	"titlebar": .titlebar,
	"selection": .selection,
	"menu": .menu,
	"popover": .popover,
	"sidebar": .sidebar,
	"headerView": .headerView,
	"sheet": .sheet,
	"windowBackground": .windowBackground,
	"hudWindow": .hudWindow,
	"fullScreenUI": .fullScreenUI,
	"toolTip": .toolTip,
	"contentBackground": .contentBackground,
	"underWindowBackground": .underWindowBackground,
	"underPageBackground": .underPageBackground
]

let backgroundColors: [String: NSColor] = [
	"textBackgroundColor": .textBackgroundColor,
	"selectedTextBackgroundColor": .selectedTextBackgroundColor,
	"unemphasizedSelectedTextBackgroundColor": .unemphasizedSelectedTextBackgroundColor,
	"windowBackgroundColor": .windowBackgroundColor,
	"controlBackgroundColor": .controlBackgroundColor,
	"underPageBackgroundColor": .underPageBackgroundColor,
	"selectedContentBackgroundColor": .selectedContentBackgroundColor,
	"unemphasizedSelectedContentBackgroundColor": .unemphasizedSelectedContentBackgroundColor
]

let imagePositions: [String: NSControl.ImagePosition] = [
	"imageAbove": .imageAbove,
	"imageBelow": .imageBelow,
	"imageLeading": .imageLeading,
	"imageLeft": .imageLeft,
	"imageOnly": .imageOnly,
	"imageOverlaps": .imageOverlaps,
	"imageRight": .imageRight,
	"imageTrailing": .imageTrailing,
	"noImage": .noImage
]
let defaultImagePosition = "imageLeading"

let buttonStates: [String] = [
	"rest",
	"pressed",
	"disabled"
]

let widths: [String: CGFloat] = [
	"natural": 0,
	"oversized (180)": 180,
	"undersized (30)": 30
]

let heights: [String: CGFloat] = [
	"natural": 0,
	"oversized (100)": 100,
	"undersized (10)": 10
]

class VibrantScrollView: NSScrollView {
	override var allowsVibrancy: Bool {
		// Allow view to pick up effect of NSVisualEffectView material
		return true
	}
}

class TopClipView: NSClipView {
	override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
		var bounds = super.constrainBoundsRect(proposedBounds)

		// Place content smaller than the scroll area at top left rather than the default bottom left
		if let height = documentView?.frame.height {
			if height < proposedBounds.height {
				bounds.origin.y = height - proposedBounds.height
			}
		}

		return bounds
	}
}

class TestButtonViewController: NSViewController, NSMenuDelegate {
	let materialsPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let backgroundColorsPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let imagePositionsPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let buttonStatesPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let widthPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	var widthConstraints: [NSLayoutConstraint] = []
	let heightPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	var heightConstraints: [NSLayoutConstraint] = []
	let scrollView = VibrantScrollView()
	let materialPane = NSVisualEffectView()
	var fluentButtons: [Button] = []

	override func loadView() {
		materialsPopup.addItems(withTitles: effectViewMaterials.keys.sorted())
		materialsPopup.menu?.delegate = self
		materialsPopup.target = self
		materialsPopup.action = #selector(TestButtonViewController.materialChanged)

		backgroundColorsPopup.addItems(withTitles: backgroundColors.keys.sorted())
		backgroundColorsPopup.menu?.delegate = self
		backgroundColorsPopup.target = self
		backgroundColorsPopup.action = #selector(TestButtonViewController.backgroundColorChanged)

		imagePositionsPopup.addItems(withTitles: imagePositions.keys.sorted())
		imagePositionsPopup.selectItem(withTitle: defaultImagePosition)
		imagePositionsPopup.menu?.delegate = self
		imagePositionsPopup.target = self
		imagePositionsPopup.action = #selector(TestButtonViewController.imagePositionChanged)

		buttonStatesPopup.addItems(withTitles: buttonStates)
		buttonStatesPopup.menu?.delegate = self
		buttonStatesPopup.target = self
		buttonStatesPopup.action = #selector(TestButtonViewController.stateChanged)

		widthPopup.addItems(withTitles: widths.keys.sorted())
		widthPopup.menu?.delegate = self
		widthPopup.target = self
		widthPopup.action = #selector(TestButtonViewController.widthConstraintsChanged)

		heightPopup.addItems(withTitles: heights.keys.sorted())
		heightPopup.menu?.delegate = self
		heightPopup.target = self
		heightPopup.action = #selector(TestButtonViewController.heightConstraintsChanged)

		let tools = [
			[NSTextField(labelWithString: "Pane Material:"), materialsPopup],
			[NSTextField(labelWithString: "Pane Color:"), backgroundColorsPopup],
			[NSTextField(labelWithString: "Image Position:"), imagePositionsPopup],
			[NSTextField(labelWithString: "Button State:"), buttonStatesPopup],
			[NSTextField(labelWithString: "Button Width:"), widthPopup],
			[NSTextField(labelWithString: "Button Height:"), heightPopup]
		]

		let toolsGrid = NSGridView(views: tools)
		toolsGrid.translatesAutoresizingMaskIntoConstraints = false
		toolsGrid.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		toolsGrid.setContentHuggingPriority(.defaultHigh, for: .vertical)

		// Pad left and right sides using the row/column spacing
		toolsGrid.insertColumn(at: 0, with: [])
		toolsGrid.addColumn(with: [])

		// Load Excel app color as primary to distinguish .primary and .communicationBlue accentColors
		Colors.primary = (NSColor(named: "Colors/DemoPrimaryColor"))!
		let communicationBlue = Colors.Palette.communicationBlue.color

		// ButtonFormats: each will apply to a whole row of sample controls
		let largePrimary = ButtonFormat(size: .large, style: .primary, accentColor: communicationBlue)
		let largeSecondary = ButtonFormat(size: .large, style: .secondary, accentColor: communicationBlue)
		let largeAcrylic = ButtonFormat(size: .large, style: .acrylic, accentColor: communicationBlue)
		let largeBorderless = ButtonFormat(size: .large, style: .borderless, accentColor: communicationBlue)
		let smallPrimary = ButtonFormat(size: .small, style: .primary, accentColor: Colors.primary)
		let smallSecondary = ButtonFormat(size: .small, style: .secondary, accentColor: Colors.primary)
		let smallAcrylic = ButtonFormat(size: .small, style: .acrylic, accentColor: Colors.primary)
		let smallBorderless = ButtonFormat(size: .small, style: .borderless, accentColor: Colors.primary)

		let title = "Stop"
		let image = NSImage(named: NSImage.stopProgressTemplateName)!
		let formats: [ButtonFormat] = [
			largePrimary,
			largeSecondary,
			largeAcrylic,
			largeBorderless,
			smallPrimary,
			smallSecondary,
			smallAcrylic,
			smallBorderless
		]

		let rowLabels: [NSView] = [
			NSTextField(labelWithString: "Custom"),
			NSTextField(labelWithString: "Large Primary"),
			NSTextField(labelWithString: "Large Secondary"),
			NSTextField(labelWithString: "Large Acrylic"),
			NSTextField(labelWithString: "Large Borderless"),
			NSTextField(labelWithString: "Small Primary"),
			NSTextField(labelWithString: "Small Secondary"),
			NSTextField(labelWithString: "Small Acrylic"),
			NSTextField(labelWithString: "Small Borderless")
		]

		// Parameters for buttons in "Custom" row
		let customTitle = "Atom"
		let customImage = NSImage(named: TestButtonViewController.nonTemplateImage)!
		customImage.isTemplate = true
		let customFormat = ButtonFormat(size: .large, style: .primary, accentColor: Colors.Palette.blueMagenta30.color)

		let buttonsWithTitle: () -> [Button] = {
			let customButton = Button()
			customButton.title = customTitle
			customButton.format = customFormat
			return [customButton] + formats.map({ Button(title: title, format: $0) })
		}

		let buttonsWithTitleAndImage: () -> [Button] = {
			let customButton = Button()
			customButton.title = customTitle
			customButton.image = customImage
			customButton.format = customFormat
			return [customButton] + formats.map({ Button(title: title, image: image, format: $0) })
		}

		let buttonsWithImage: () -> [Button] = {
			let customButton = Button()
			customButton.image = customImage
			customButton.format = customFormat
			return [customButton] + formats.map({ Button(image: image, format: $0) })
		}

		let fluentButtonsGrid = NSGridView(frame: .zero)
		fluentButtonsGrid.translatesAutoresizingMaskIntoConstraints = false
		fluentButtonsGrid.rowSpacing = TestButtonViewController.gridViewRowSpacing
		fluentButtonsGrid.columnSpacing = TestButtonViewController.gridViewColumnSpacing

		fluentButtonsGrid.addColumn(with: rowLabels)
		let buttonColumns = [
			buttonsWithTitle(),
			buttonsWithTitleAndImage(),
			buttonsWithImage()
		]
		for newColumn in buttonColumns {
			var nearestPrimary: Button?
			for button in newColumn {
				switch button.style {
				case .primary:
					nearestPrimary = button
				default:
					button.linkedPrimary = nearestPrimary
				}
			}
			fluentButtons.append(contentsOf: newColumn)
			fluentButtonsGrid.addColumn(with: newColumn)
		}

		for button in fluentButtons {
			button.target = self
			button.action = #selector(buttonPressed)
		}

		// Insert column headers atop the grid of sample controls
		let columnLabels: [NSView] = [
			NSGridCell.emptyContentView,
			NSTextField(labelWithString: "Title"),
			NSTextField(labelWithString: "Title & Image"),
			NSTextField(labelWithString: "Image")
		]
		fluentButtonsGrid.insertRow(at: 0, with: columnLabels)

		// Pad around the edges using the row/column spacing
		fluentButtonsGrid.insertRow(at: 0, with: [])
		fluentButtonsGrid.addRow(with: [])
		fluentButtonsGrid.insertColumn(at: 0, with: [])
		fluentButtonsGrid.addColumn(with: [])

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = true
		scrollView.contentView = TopClipView.init(frame: scrollView.contentView.frame)
		scrollView.documentView = fluentButtonsGrid
		if let documentView = scrollView.documentView {
				documentView.scroll(NSPoint(x: 0, y: documentView.bounds.size.height))
		}

		materialPane.translatesAutoresizingMaskIntoConstraints = false
		materialPane.material = .contentBackground
		materialPane.addSubview(scrollView)

		let mainPanel = NSStackView(views: [toolsGrid, materialPane])
		mainPanel.translatesAutoresizingMaskIntoConstraints = false
		mainPanel.orientation = .vertical
		mainPanel.alignment = .left
		mainPanel.edgeInsets = NSEdgeInsets(top: mainPanel.spacing, left: 0, bottom: 0, right: 0)

		NSLayoutConstraint.activate([
			materialPane.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			materialPane.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			materialPane.topAnchor.constraint(equalTo: scrollView.topAnchor),
			materialPane.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			fluentButtonsGrid.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor),
			fluentButtonsGrid.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor)
		])

		view = mainPanel
	}

	override func viewWillAppear() {
		// Scroll to top [left]
		if let documentView = scrollView.documentView {
			documentView.scroll(NSPoint(x: 0, y: documentView.bounds.size.height))
		}
	}

	@objc func materialChanged() {
		if let title = materialsPopup.titleOfSelectedItem {
			if let material = effectViewMaterials[title] {
				materialPane.material = material
				materialPane.needsDisplay = true
			}
		}
	}

	@objc func backgroundColorChanged() {
		let color = backgroundColors[backgroundColorsPopup.titleOfSelectedItem!]!
		scrollView.backgroundColor = color
	}

	@objc func imagePositionChanged() {
		let imagePosition = imagePositions[imagePositionsPopup.titleOfSelectedItem!]!
		for button in fluentButtons {
			// The test app exposed cases where a button with no image has its
			// imagePosition set to .imageOnly or .imageOverlaps, then back to
			// something else.  An invisible 1-pixel image gets assigned to the
			// button, having an NSCustomImageRep with no drawing delegate.  Detect
			// and remove this image so it doesn't offset the title.
			if let image = button.image {
				if let imageRep = image.representations.first as? NSCustomImageRep {
					if imageRep.delegate == nil && image.size == TestButtonViewController.onePointSize {
						button.image = nil
					}
				}
			}

			button.imagePosition = imagePosition
			if let cell = button.cell as? NSButtonCell {
				cell.imagePosition = imagePosition
			}
		}
	}

	@objc func stateChanged() {
		let state = buttonStatesPopup.titleOfSelectedItem
		for button in fluentButtons {
			let originalLinkedPrimary = button.linkedPrimary
			button.linkedPrimary = nil
			switch state {
			case "rest":
				button.isEnabled = true
				button.isPressed = false
			case "pressed":
				button.isEnabled = true
				button.isPressed = true
			case "disabled":
				button.isEnabled = false
			default:
				break
			}
			button.linkedPrimary = originalLinkedPrimary
		}
	}

	@objc func widthConstraintsChanged() {
		guard let title = widthPopup.titleOfSelectedItem else {
			return
		}
		guard let width = widths[title] else {
			return
		}
		NSLayoutConstraint.deactivate(widthConstraints)
		widthConstraints.removeAll()
		guard width != 0 else {
			return
		}
		widthConstraints.append(contentsOf: fluentButtons.map({ ($0 as Button).widthAnchor.constraint(equalToConstant: width) }))
		NSLayoutConstraint.activate(widthConstraints)
	}

	@objc func heightConstraintsChanged() {
		guard let title = heightPopup.titleOfSelectedItem else {
			return
		}
		guard let height = heights[title] else {
			return
		}
		NSLayoutConstraint.deactivate(heightConstraints)
		heightConstraints.removeAll()
		guard height != 0 else {
			return
		}
		heightConstraints.append(contentsOf: fluentButtons.map({ ($0 as Button).heightAnchor.constraint(equalToConstant: height) }))
		NSLayoutConstraint.activate(heightConstraints)
	}

	@objc func buttonPressed() {
		print("Button pressed")
	}

	private static let nonTemplateImage: String = "ic_fluent_non_template_24_filled"

	private static let onePointSize = NSSize(width: 1, height: 1)

	private static let gridViewRowSpacing: CGFloat = 20
	private static let gridViewColumnSpacing: CGFloat = 20
}
