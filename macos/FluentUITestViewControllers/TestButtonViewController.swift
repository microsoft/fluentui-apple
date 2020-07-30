//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI


class TestButtonViewController: NSViewController {

	override func loadView() {
		let columnLabels: [NSView] = [
			NSTextField(labelWithString: "Primary Filled"),
			NSTextField(labelWithString: "Primary Outline"),
			NSTextField(labelWithString: "Borderless"),
		]

		let buttonsWithTitle: () -> [NSButton] = {
			return [
				Button(title: "FluentUI Button", style: .primaryFilled),
				Button(title: "FluentUI Button", style: .primaryOutline),
				Button(title: "FluentUI Button", style: .borderless),
			]
		}
		
		let disabledButtonsWithTitle = buttonsWithTitle().map { button -> NSButton in
			button.isEnabled = false
			return button
		}

		let buttonsWithImage: () -> [NSButton] = {
			return [
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .primaryFilled),
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .primaryOutline),
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .borderless),
			]
		}

		let disabledButtonsWithImage = buttonsWithImage().map { button -> NSButton in
			button.isEnabled = false
			return button
		}
		
		let leadingArrowImage = NSImage(named: TestButtonViewController.leadingArrow)!
		let trailingArrowImage = NSImage(named: TestButtonViewController.trailingArrow)!
		
		
		let buttonsWithTitleAndImage: () -> [NSButton] = {
			return [
				Button(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, style: .primaryFilled),
				Button(title: "Back", image: trailingArrowImage, imagePosition: .imageTrailing, style: .primaryOutline),
				Button(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, style: .borderless),
			]
		}
		
		let disabledButtonsWithTitleAndImage = buttonsWithTitleAndImage().map { button -> NSButton in
			button.isEnabled = false
			return button
		}

		let gridView = NSGridView(frame: .zero)
		gridView.rowSpacing = TestButtonViewController.gridViewRowSpacing
		gridView.columnSpacing = TestButtonViewController.gridViewColumnSpacing
		gridView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		
		gridView.addColumn(with: columnLabels)
		gridView.addColumn(with: buttonsWithTitle())
		gridView.addColumn(with: disabledButtonsWithTitle)
		gridView.addColumn(with: buttonsWithImage())
		gridView.addColumn(with: disabledButtonsWithImage)
		gridView.addColumn(with: buttonsWithTitleAndImage())
		gridView.addColumn(with: disabledButtonsWithTitleAndImage)

		let emptyCell = NSGridCell.emptyContentView
	
		// Insert the Row Titles as the last step
		let rowLabels: [NSView] = [
			emptyCell,
			NSTextField(labelWithString: "Title"),
			NSTextField(labelWithString: "Title (Disabled)"),
			NSTextField(labelWithString: "Image"),
			NSTextField(labelWithString: "Image (Disabled)"),
			NSTextField(labelWithString: "Title & Image"),
			NSTextField(labelWithString: "Title & Image (Disabled)")
		]
		gridView.insertRow(at: 0, with: rowLabels)
		gridView.addRow(with: [])	//Padding

		let containerView = NSStackView()
		containerView.orientation = .vertical
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.edgeInsets = NSEdgeInsets(
			top: TestButtonViewController.containerViewEdgeInsets,
			left: TestButtonViewController.containerViewEdgeInsets,
			bottom: TestButtonViewController.containerViewEdgeInsets,
			right: TestButtonViewController.containerViewEdgeInsets
		)

		containerView.addView(gridView, in: .top)

		view = containerView
	}
	
	private static let leadingArrow = "ic_fluent_chevron_left_16_filled"
	private static let trailingArrow = "ic_fluent_chevron_right_16_filled"
	
	private static let gridViewRowSpacing: CGFloat = 20
	private static let gridViewColumnSpacing: CGFloat = 20
	private static let containerViewEdgeInsets: CGFloat = 20

}

// MARK: - Constants

