//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

@available(OSX 10.14, *)
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
	"underPageBackground": .underPageBackground,
]

@available(OSX 10.14, *)
let backgroundColors: [String: NSColor] = [
	"textBackgroundColor": .textBackgroundColor,
	"selectedTextBackgroundColor": .selectedTextBackgroundColor,
	"unemphasizedSelectedTextBackgroundColor": .unemphasizedSelectedTextBackgroundColor,
	"windowBackgroundColor": .windowBackgroundColor,
	"controlBackgroundColor": .controlBackgroundColor,
	"underPageBackgroundColor": .underPageBackgroundColor,
	"selectedContentBackgroundColor": .selectedContentBackgroundColor,
	"unemphasizedSelectedContentBackgroundColor": .unemphasizedSelectedContentBackgroundColor,
]

@available(OSX 10.14, *)
let colorSystemEffects: [String: NSColor.SystemEffect] = [
	"none": .none,
	"rollover": .rollover,
	"pressed": .pressed,
	"deepPressed": .deepPressed,
	"disabled": .disabled,
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

@available(OSX 10.14, *)
class TestButton: Button {
	public var effect: NSColor.SystemEffect = .none {
		didSet {
			// Reset color to original values indicated by style
			style = style
			// Apply system effect to each of the colors individually
			contentTintColorRest = contentTintColorRest?.withSystemEffect(effect)
			contentTintColorPressed = contentTintColorPressed?.withSystemEffect(effect)
			contentTintColorDisabled = contentTintColorDisabled?.withSystemEffect(effect)
			backgroundColorRest = backgroundColorRest?.withSystemEffect(effect)
			backgroundColorPressed = backgroundColorPressed?.withSystemEffect(effect)
			backgroundColorDisabled = backgroundColorDisabled?.withSystemEffect(effect)
			borderColorRest = borderColorRest?.withSystemEffect(effect)
			borderColorPressed = borderColorPressed?.withSystemEffect(effect)
			borderColorDisabled = borderColorDisabled?.withSystemEffect(effect)
			// Redraw the button
			needsDisplay = true
		}
	}
}

@available(OSX 10.14, *)
class TestButtonViewController: NSViewController, NSMenuDelegate {
	let materialsPopup = NSPopUpButton(frame: NSZeroRect, pullsDown: false)
	let backgroundColorsPopup = NSPopUpButton(frame: NSZeroRect, pullsDown: false)
	let systemEffectsPopup = NSPopUpButton(frame: NSZeroRect, pullsDown: false)
	let scrollView = VibrantScrollView()
	let materialPane = NSVisualEffectView()
	var fluentButtons: [TestButton] = []

	override func loadView() {
		materialsPopup.addItems(withTitles: effectViewMaterials.keys.sorted())
		materialsPopup.selectItem(withTitle: "contentBackground")
		materialsPopup.menu?.delegate = self
		materialsPopup.target = self
		materialsPopup.action = #selector(TestButtonViewController.materialChanged)

		backgroundColorsPopup.addItems(withTitles: backgroundColors.keys.sorted())
		backgroundColorsPopup.selectItem(withTitle: "controlBackgroundColor")
		backgroundColorsPopup.menu?.delegate = self
		backgroundColorsPopup.target = self
		backgroundColorsPopup.action = #selector(TestButtonViewController.backgroundColorChanged)

		systemEffectsPopup.addItems(withTitles: colorSystemEffects.keys.sorted())
		systemEffectsPopup.selectItem(withTitle: "none")
		systemEffectsPopup.menu?.delegate = self
		systemEffectsPopup.target = self
		systemEffectsPopup.action = #selector(TestButtonViewController.effectChanged)

		let tools = [
			[NSTextField(labelWithString: "Pane Material:"), materialsPopup],
			[NSTextField(labelWithString: "Pane Color:"), backgroundColorsPopup],
			[NSTextField(labelWithString: "Button Color Effect:"), systemEffectsPopup],
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

		let rowLabels: [NSView] = [
			NSTextField(labelWithString: "Large Primary"),
			NSTextField(labelWithString: "Large Secondary"),
			NSTextField(labelWithString: "Large Acrylic"),
			NSTextField(labelWithString: "Large Borderless"),
			NSTextField(labelWithString: "Small Primary"),
			NSTextField(labelWithString: "Small Secondary"),
			NSTextField(labelWithString: "Small Acrylic"),
			NSTextField(labelWithString: "Small Borderless"),
		]

		let buttonsWithTitle: () -> [TestButton] = {
			return [
				TestButton(title: "FluentUI Button", format: largePrimary),
				TestButton(title: "FluentUI Button", format: largeSecondary),
				TestButton(title: "FluentUI Button", format: largeAcrylic),
				TestButton(title: "FluentUI Button", format: largeBorderless),
				TestButton(title: "FluentUI Button", format: smallPrimary),
				TestButton(title: "FluentUI Button", format: smallSecondary),
				TestButton(title: "FluentUI Button", format: smallAcrylic),
				TestButton(title: "FluentUI Button", format: smallBorderless),
			]
		}

		let stopImage = NSImage(named: NSImage.stopProgressTemplateName)!

		let buttonsWithImage: () -> [TestButton] = {
			return [
				TestButton(image: stopImage, format: largePrimary),
				TestButton(image: stopImage, format: largeSecondary),
				TestButton(image: stopImage, format: largeAcrylic),
				TestButton(image: stopImage, format: largeBorderless),
				TestButton(image: stopImage, format: smallPrimary),
				TestButton(image: stopImage, format: smallSecondary),
				TestButton(image: stopImage, format: smallAcrylic),
				TestButton(image: stopImage, format: smallBorderless),
			]
		}

		let leadingArrowImage = NSImage(named: TestButtonViewController.leadingArrow)!
		let trailingArrowImage = NSImage(named: TestButtonViewController.trailingArrow)!

		let buttonsWithTitleAndImageHorizontal: () -> [TestButton] = {
			return [
				TestButton(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, format: largePrimary),
				TestButton(title: "Skip", image: trailingArrowImage, imagePosition: .imageTrailing, format: largeSecondary),
				TestButton(title: "Back", image: leadingArrowImage, imagePosition: .imageLeft, format: largeAcrylic),
				TestButton(title: "Skip", image: trailingArrowImage, imagePosition: .imageRight, format: largeBorderless),
				TestButton(title: "Skip", image: trailingArrowImage, imagePosition: .imageTrailing, format: smallPrimary),
				TestButton(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, format: smallSecondary),
				TestButton(title: "Skip", image: trailingArrowImage, imagePosition: .imageRight, format: smallAcrylic),
				TestButton(title: "Back", image: leadingArrowImage, imagePosition: .imageLeft, format: smallBorderless),
			]
		}

		let disabledButtonsWithTitleAndImageHorizontal = buttonsWithTitleAndImageHorizontal().map { button -> TestButton in
			button.isEnabled = false
			return button
		}

		let buttonsWithTitleAndImageVertical: () -> [TestButton] = {
			return [
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageAbove, format: largePrimary),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageBelow, format: largeSecondary),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageAbove, format: largeAcrylic),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageOverlaps, format: largeBorderless),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageOverlaps, format: smallPrimary),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageAbove, format: smallSecondary),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageBelow, format: smallAcrylic),
				TestButton(title: "Nope", image: stopImage, imagePosition: .imageAbove, format: smallBorderless),
			]
		}

		let fluentButtonsGrid = NSGridView(frame: .zero)
		fluentButtonsGrid.translatesAutoresizingMaskIntoConstraints = false
		fluentButtonsGrid.rowSpacing = TestButtonViewController.gridViewRowSpacing
		fluentButtonsGrid.columnSpacing = TestButtonViewController.gridViewColumnSpacing

		fluentButtonsGrid.addColumn(with: rowLabels)
		let buttonColumns = [
			buttonsWithTitle(),
			buttonsWithImage(),
			buttonsWithTitleAndImageHorizontal(),
			disabledButtonsWithTitleAndImageHorizontal,
			buttonsWithTitleAndImageVertical(),
		]
		for newColumn in buttonColumns {
			var nearestPrimary: Button? = nil
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

		// Insert column headers atop the grid of sample controls
		let columnLabels: [NSView] = [
			NSGridCell.emptyContentView,
			NSTextField(labelWithString: "Title"),
			NSTextField(labelWithString: "Image"),
			NSTextField(labelWithString: "Title & Image"),
			NSTextField(labelWithString: "Title & Image (Disabled)"),
			NSTextField(labelWithString: "Title & Image (Vertical)")
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
			fluentButtonsGrid.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor),
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

	@objc func effectChanged() {
		let effect = colorSystemEffects[systemEffectsPopup.titleOfSelectedItem!]!
		for button in fluentButtons {
			button.effect = effect
		}
	}

	private static let leadingArrow = "ic_fluent_chevron_left_16_filled"
	private static let trailingArrow = "ic_fluent_chevron_right_16_filled"

	private static let gridViewRowSpacing: CGFloat = 20
	private static let gridViewColumnSpacing: CGFloat = 20
}
