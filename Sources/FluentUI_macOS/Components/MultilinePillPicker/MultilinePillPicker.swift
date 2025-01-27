//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// This is a work-in-progress control for hosting multiple rows of pill buttons. At present, this control
/// only supports a hard-coded two rows of elements.
public struct MultilinePillPicker: View {
	/// Creates a multiline pill picker.
	/// - Parameters:
	///   - labels: An array of labels to show in the picker.
	///   - action: An action to invoke when a pill is selected in the picker. Includes the index of the item being selected.
	public init(labels: [String], action: (@MainActor (Int) -> Void)? = nil) {
		self.labels = labels
		self.action = action
	}

	public var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			// Bias towards the first row
			let midIndex = Int(ceil(Double(labels.count) / 2.0))
			row(0..<midIndex)
			row(midIndex..<labels.count)
		}
		.frame(alignment: .center)
		.padding(lineWidth)
	}

	@ViewBuilder
	private func button(_ index: Int) -> some View {
		SwiftUI.Button(action: {
			action?(index)
		}, label: {
			Text(labels[index])
				.padding(.vertical, paddingVertical)
				.padding(.horizontal, paddingHorizontal)
				.overlay(
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.stroke(Color(nsColor: Colors.primaryTint10), lineWidth: lineWidth)
				)
		})
		.buttonStyle(.plain)
	}

	@ViewBuilder
	private func row(_ range: Range<Int>) -> some View {
		HStack(spacing: spacing) {
			ForEach(range, id: \.self) { index in
				button(index)
			}
		}
	}

	private let labels: [String]
	private let action: (@MainActor (Int) -> Void)?

	// Constants
	private let cornerRadius: CGFloat = 6.0
	private let lineWidth: CGFloat = 1.0
	private let paddingHorizontal: CGFloat = 8.0
	private let paddingVertical: CGFloat = 4.0
	private let spacing: CGFloat = 4.0
}
