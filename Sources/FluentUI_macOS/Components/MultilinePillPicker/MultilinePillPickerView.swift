//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import SwiftUI

/// This is a work-in-progress control for hosting multiple rows of pill buttons. At present, this control
/// only supports a hard-coded two rows of elements.
@objc(MSFMultilinePillPickerView)
public final class MultilinePillPickerView: ControlHostingView {
	/// Creates a multiline pill picker.
	/// - Parameters:
	///   - labels: An array of labels to show in the picker.
	///   - action: An action to invoke when a pill is selected in the picker. Includes the index of the item being selected.
	@objc(initWithLabels:action:)
	@MainActor public init(labels: [String], action: (@MainActor (Int) -> Void)? = nil) {
		self.labels = labels
		self.action = action
		let picker = MultilinePillPicker(labels: labels, action: action)
		super.init(AnyView(picker))
	}

	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@MainActor required init(rootView: AnyView) {
		fatalError("init(rootView:) has not been implemented")
	}

	@MainActor public var isEnabled: Bool = true {
		didSet {
			updatePicker()
		}
	}
	@MainActor public var labels: [String] {
		didSet {
			updatePicker()
		}
	}
	@MainActor public var action: (@MainActor (Int) -> Void)? {
		didSet {
			updatePicker()
		}
	}

	private func updatePicker() {
		let picker = MultilinePillPicker(labels: labels, action: action)
			.disabled(!isEnabled)
		hostingView.rootView = AnyView(picker)
	}
}
