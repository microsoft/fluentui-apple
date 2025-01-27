//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

class TestMultilinePillPickerViewController: NSViewController {
	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical

		let pillPickerView = MultilinePillPickerView(labels: labels) { [weak self] index in
			self?.pillButtonPressed(index)
		}
		containerView.addView(pillPickerView, in: .center)
		self.pillPickerView = pillPickerView

		// TODO: Add controls to add and remove pills
		let checkbox = NSButton(checkboxWithTitle: "Enabled", target: self, action: #selector(toggleEnabled(_:)))
		checkbox.state = .on
		containerView.addView(checkbox, in: .center)

		view = containerView
	}

	@objc func toggleEnabled(_ sender: NSButton?) {
		pillPickerView?.isEnabled = sender?.state == .on
	}

	func pillButtonPressed(_ index: Int) {
		guard let window = NSApplication.shared.mainWindow else {
			print("No window -- selected index \(index)")
			return
		}
		let alert = NSAlert()
		alert.messageText = "Suggestion clicked"
		alert.informativeText = "\(labels[index])"
		alert.addButton(withTitle: "OK")
		alert.beginSheetModal(for: window)
	}

	private let labels: [String] = [
		"One",
		"Two",
		"Three",
		"Four",
		"Five",
		"Six",
		"Seven",
		"Eight",
		"Nine",
	]

	private var pillPickerView: MultilinePillPickerView?
}
