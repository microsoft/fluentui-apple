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
			NSTextField(labelWithString: "Custom Button"),
		]
		
		let customButton = Button(title: "Custom Button")
		customButton.restBackgroundColor = Colors.Palette.green20.color
		customButton.contentTintColor = .white
		
		let buttonsWithTitle: () -> [NSButton] = {
			return [
				Button(title: "FluentUI Button", style: .primaryFilled),
				Button(title: "FluentUI Button", style: .primaryOutline),
				Button(title: "FluentUI Button", style: .borderless),
				customButton,
			]
		}

		let customButtonWithImage = Button()
		customButtonWithImage.restBackgroundColor = Colors.Palette.communicationBlue.color
		customButtonWithImage.image = NSImage(named: NSImage.stopProgressTemplateName)!
		customButtonWithImage.contentTintColor = .white
		
		let buttonsWithImage: () -> [NSButton] = {
			return [
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .primaryFilled),
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .primaryOutline),
				Button(image: NSImage(named: NSImage.stopProgressTemplateName)!, style: .borderless),
				customButtonWithImage,
			]
		}
		
		let leadingArrowImage = NSImage(named: TestButtonViewController.leadingArrow)!
		let trailingArrowImage = NSImage(named: TestButtonViewController.trailingArrow)!
		
		let customButtonWithTitleAndImage = Button()
		customButtonWithTitleAndImage.title = "BtnTitle+Img"
		customButtonWithTitleAndImage.contentTintColor = .white
		customButtonWithTitleAndImage.image = trailingArrowImage
		customButtonWithTitleAndImage.imagePosition = .imageTrailing
		customButtonWithTitleAndImage.restBackgroundColor = Colors.Palette.blueMagenta30.color
		
		let buttonsWithTitleAndImage: () -> [NSButton] = {
			return [
				Button(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, style: .primaryFilled),
				Button(title: "Skip", image: trailingArrowImage, imagePosition: .imageTrailing, style: .primaryOutline),
				Button(title: "Back", image: leadingArrowImage, imagePosition: .imageLeading, style: .borderless),
				customButtonWithTitleAndImage,
			]
		}
		
		let customDisabledButton = Button()
		customDisabledButton.title = "DisabledWithImg"
		customDisabledButton.contentTintColor = .white
		customDisabledButton.restBackgroundColor = Colors.Palette.blueMagenta30.color
		customDisabledButton.image = leadingArrowImage
		customDisabledButton.imagePosition = .imageLeading
		customDisabledButton.isEnabled = false
		
		let disabledPrimaryFilled = Button(title: "PrimaryFilled disbaled", style: .primaryFilled)
		let disabledPrimaryOutline = Button(title: "PrimaryOutline disabled", style: .primaryOutline)
		let disabledBorderless = Button(title: "Borderless disabled", style: .borderless)
		disabledPrimaryFilled.isEnabled = false
		disabledPrimaryOutline.isEnabled = false
		disabledBorderless.isEnabled = false
		
		let disabledButtons: () -> [NSButton] = {
			return [
				disabledPrimaryFilled,
				disabledPrimaryOutline,
				disabledBorderless,
				customDisabledButton,
			]
		}

		let gridView = NSGridView(frame: .zero)
		gridView.rowSpacing = TestButtonViewController.gridViewRowSpacing
		gridView.columnSpacing = TestButtonViewController.gridViewColumnSpacing
		gridView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		
		gridView.addColumn(with: columnLabels)
		gridView.addColumn(with: buttonsWithTitle())
		gridView.addColumn(with: buttonsWithImage())
		gridView.addColumn(with: buttonsWithTitleAndImage())
		gridView.addColumn(with: disabledButtons())
		
		let emptyCell = NSGridCell.emptyContentView
	
		// Insert the Row Titles as the last step
		let rowLabels: [NSView] = [
			emptyCell,
			NSTextField(labelWithString: "Title"),
			NSTextField(labelWithString: "Image"),
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

