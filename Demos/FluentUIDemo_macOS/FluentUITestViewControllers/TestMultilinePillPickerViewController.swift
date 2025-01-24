//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI
import SwiftUI

class TestMultilinePillPickerViewController: NSViewController {
	var labels: [String] = [
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

	override func loadView() {
		let containerView = NSStackView(frame: .zero)
		containerView.orientation = .vertical

		let pillPickerView = MultilinePillPickerView(labels: labels) { [weak self] index in
			self?.pillButtonPressed(index)
		}
		containerView.addView(pillPickerView, in: .center)

		// TODO: Add controls to add, remove, or disable pills.

		view = containerView
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
}
