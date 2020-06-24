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
		
		let buttons: () -> [NSButton] = {
			return [
				Button(title: "FluentUI Button", style: .primaryFilled),
				Button(title: "FluentUI Button", style: .primaryOutline),
				Button(title: "FluentUI Button", style: .borderless),
			]
		}
		
		let buttonsWithTitle = buttons()
		let buttonsWithImage = buttons().map { button -> NSButton in
			button.imagePosition = .imageOnly
			button.image = NSImage(named: NSImage.addTemplateName)
			return button
		}

		let disabledButtons = buttons().map { button -> NSButton in
			button.isEnabled = false
			return button
		}
		
		let gridView = NSGridView(frame: .zero)
		gridView.rowSpacing = 20
		gridView.columnSpacing = 20
		gridView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		gridView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		gridView.addColumn(with: columnLabels)
		gridView.addColumn(with: buttonsWithTitle)
		gridView.addColumn(with: buttonsWithImage)
		gridView.addColumn(with: disabledButtons)
		gridView.addColumn(with: [])	//Padding

		let emptyCell = NSGridCell.emptyContentView
	
		// Insert the Row Titles as the last step
		let rowLabels: [NSView] = [
			emptyCell,
			NSTextField(labelWithString: "Title"),
			NSTextField(labelWithString: "Image"),
			NSTextField(labelWithString: "Disabled")
		]
		gridView.insertRow(at: 0, with: rowLabels)
		gridView.addRow(with: [])	//Padding

		let containerView = NSStackView()
		containerView.orientation = .vertical
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		
		containerView.addView(gridView, in: .top)
		
		view = containerView
	}
}

