//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A horizontal `MessageBar`.
public struct MessageBar: View, TokenizedControlView {
	public typealias TokenSetKeyType = MessageBarTokenSet.Tokens
	@ObservedObject public var tokenSet: MessageBarTokenSet = .init()

	/// The fixed height of a single message bar row.
	/// Used by `MSFMessageBarStack` to compute `targetContentHeight`.
	public static let fixedHeight: CGFloat = GlobalTokens.spacing(.size280)

	public init(_ configuration: MessageBarConfiguration) {
		self.configuration = configuration
	}

	public var body: some View {
		HStack(alignment: .center, spacing: GlobalTokens.spacing(.size80)) {
			leadingImage
			title
			message

			Spacer(minLength: 0.0)

			actionButtons
			closeButton
		}
		.foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
		.padding([.horizontal], GlobalTokens.spacing(.size120))
		.frame(height: GlobalTokens.spacing(.size280))
		.background(tokenSet[.backgroundColor].color)
		.overlay(alignment: .top) {
			Rectangle()
				.fill(tokenSet[.dividerColor].color)
				.frame(height: 1.0)
		}
	}

	@ViewBuilder
	private var leadingImage: some View {
		Image(systemName: "exclamationmark.triangle")
	}

	@ViewBuilder
	private var title: some View {
		Text(configuration.title)
			.font(tokenSet[.titleFont].font)
			.lineLimit(1)
	}

	@ViewBuilder
	private var message: some View {
		Text(configuration.message)
			.font(tokenSet[.messageFont].font)
			.lineLimit(1)
			.truncationMode(.tail)
			.layoutPriority(-1)
	}

	@ViewBuilder
	private var actionButtons: (some View)? {
		let actionButtonConfiguration = configuration.actionButtonConfiguration
		if let actionButtons = actionButtonConfiguration?.actionButtons {
			ForEach(actionButtons.indices, id: \.self) { buttonIndex in
				SwiftUI.Button(actionButtons[buttonIndex]) {
					actionButtonConfiguration?.callback?(UInt8(buttonIndex))
				}
				.controlSize(.small)
			}
		}
	}

	@ViewBuilder
	private var closeButton: some View {
		SwiftUI.Button("Close", systemImage: "xmark.circle.fill") {
			configuration.onCloseCallback()
		}
		.buttonStyle(.plain)
		.labelStyle(.iconOnly)
	}

	@Environment(\.fluentTheme) private var fluentTheme: FluentTheme
	private let configuration: MessageBarConfiguration
}

#Preview {
	let actionButtonConfiguration = MessageBarConfiguration.ActionButtonConfiguration(
		actionButton1Title: "Label1",
		actionButton2Title: "Label2",
		actionButton3Title: "Label3"
	) { buttonIndex in
		print("Pressed button \(buttonIndex)")
	}
	let messageBarConfiguration = MessageBarConfiguration(
		title: "Descriptive Title",
		message: "Message providing information to the user with actionable insights.",
		actionButtonConfiguration: actionButtonConfiguration,
		hasCloseButton: true,
		onCloseCallback: {
			print("Closing the message bar")
		}
	)

	MessageBar(messageBarConfiguration)
}
