//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestFilledTemplateImageViewController: NSViewController, NSMenuDelegate {
	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		let tag = NSImage(named: tag)
		let tagFillMask = NSImage(named: tagMask)
		tagView = FilledTemplateImageView(image: tag!, fillMask: tagFillMask!, borderColor: .black, fillColor: .systemBlue)
		tagView.translatesAutoresizingMaskIntoConstraints = false
		let tagLock = NSImage(named: tagLock)
		let tagLockFillMask = NSImage(named: tagLockMask)
		tagLockView = FilledTemplateImageView(image: tagLock!, fillMask: tagLockFillMask!, borderColor: .black, fillColor: .systemBlue)
		tagLockView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tagView.heightAnchor.constraint(equalToConstant: imageSize),
			tagView.widthAnchor.constraint(equalToConstant: imageSize),
			tagLockView.heightAnchor.constraint(equalToConstant: imageSize),
			tagLockView.widthAnchor.constraint(equalToConstant: imageSize)
		])

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		preconditionFailure()
	}

	override func loadView() {

		// Load the popup menus
		borderColorsPopup.addItems(withTitles: borderColors.keys.sorted())
		borderColorsPopup.menu?.delegate = self
		borderColorsPopup.target = self
		borderColorsPopup.action = #selector(borderColorChanged)
		let borderColorTextField = NSTextField(labelWithString: "Border Color:")
		borderColorTextField.textColor = .white
		let borderPopupContainer = NSStackView(views: [borderColorTextField, borderColorsPopup])

		fillColorsPopup.addItems(withTitles: fillColors.keys.sorted())
		fillColorsPopup.menu?.delegate = self
		fillColorsPopup.target = self
		fillColorsPopup.action = #selector(fillColorChanged)

		let fillColorTextField = NSTextField(labelWithString: "Fill Color:")
		fillColorTextField.textColor = .white
		let fillPopupContainer = NSStackView(views: [fillColorTextField, fillColorsPopup])

		let containerView = NSStackView()
		containerView.orientation = .vertical
		containerView.distribution = .gravityAreas
		containerView.wantsLayer = true
		containerView.layer?.backgroundColor = NSColor.systemGray.cgColor
		containerView.addView(borderPopupContainer, in: .center)
		containerView.addView(fillPopupContainer, in: .center)
		containerView.addView(tagView, in: .center)
		containerView.addView(tagLockView, in: .center)

		view = containerView
	}
	@objc func fillColorChanged() {
		let color = fillColors[fillColorsPopup.titleOfSelectedItem!]!
		tagView.fillColor = color
		tagLockView.fillColor = color
	}
	@objc func borderColorChanged() {
		let color = borderColors[borderColorsPopup.titleOfSelectedItem!]!
		tagView.borderColor = color
		tagLockView.borderColor = color
	}

	let borderColorsPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let fillColorsPopup = NSPopUpButton(frame: .zero, pullsDown: false)
	let tagLockView: FilledTemplateImageView
	let tagView: FilledTemplateImageView

	fileprivate let tag: String = "FluentBadge"
	fileprivate let tagMask: String = "FluentBadge_Mask"
	fileprivate let tagLock: String = "FluentBadgeLocked"
	fileprivate let tagLockMask: String = "FluentBadgeLocked_Mask"
	fileprivate let imageSize: CGFloat = 48.0
	fileprivate let fillColors: [String: NSColor] = [
		"Blue": .systemBlue,
		"Clear": .clear,
		"Green": .systemGreen,
		"Orange": .systemOrange,
		"Pink": .systemPink,
		"Red": .systemRed
	]
	fileprivate let borderColors: [String: NSColor] = [
		"Black": .black,
		"White": .white
	]

}
