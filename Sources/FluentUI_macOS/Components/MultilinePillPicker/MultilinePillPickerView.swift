//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import Combine
import SwiftUI

/// This is a work-in-progress control for hosting multiple rows of pill buttons. At present, this control
/// only supports a hard-coded two rows of elements.
@objc(MSFMultilinePillPickerView)
public final class MultilinePillPickerView: ControlHostingView, ObservableObject {
	/// Creates a multiline pill picker.
	/// - Parameters:
	///   - labels: An array of labels to show in the picker.
	///   - action: An action to invoke when a pill is selected in the picker. Includes the index of the item being selected.
	@objc(initWithLabels:action:)
	@MainActor public init(labels: [String], action: (@MainActor (Int) -> Void)? = nil) {
		self.labels = labels
		self.action = action
		super.init(AnyView(EmptyView()))

		let wrapper = MultilinePillPickerWrapper(viewModel: viewModel)
		self.hostingView.rootView = AnyView(wrapper)

		// Set up observation to keep the view model in sync.
		bindProperty(from: self.$isEnabled, to: \.isEnabled, on: viewModel)
		bindProperty(from: self.$labels, to: \.labels, on: viewModel)
		bindProperty(from: self.$action, to: \.action, on: viewModel)
	}

	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	@MainActor required init(rootView: AnyView) {
		preconditionFailure("init(rootView:) has not been implemented")
	}

	@MainActor @Published public var isEnabled: Bool = true
	@MainActor @Published public var labels: [String]
	@MainActor @Published public var action: (@MainActor (Int) -> Void)?

	@MainActor private var viewModel: MultilinePillPickerViewModel = .init()
}

/// Maps properties from `MultilinePillPickerView` to `MultilinePillPickerViewWrapper`.
fileprivate class MultilinePillPickerViewModel: ObservableObject {
	@Published var isEnabled: Bool = true
	@Published var labels: [String] = []
	@Published var action: (@MainActor (Int) -> Void)?
}

/// Private wrapper `View` to map from view model to `MultilinePillPicker`.
fileprivate struct MultilinePillPickerWrapper: View {
	@ObservedObject var viewModel: MultilinePillPickerViewModel

	var body: some View {
		MultilinePillPicker(
			labels: viewModel.labels,
			action: viewModel.action
		)
		.disabled(!viewModel.isEnabled)
	}
}
