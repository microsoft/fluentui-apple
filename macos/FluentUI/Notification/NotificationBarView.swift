//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
	/// Bar notification with brand colored text and background.
	case accent

	/// Bar notification with brand colored text and neutral colored background.
	case subtle

	/// Bar notification with neutral colored text and brackground.
	case neutral
}

/// Direction that the notification will appear from.
@objc public enum MSFNotificationDirection: Int, CaseIterable {
	case top
	case bottom
}

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState: NSObjectProtocol {
	/// Style to draw the control.
	var style: MSFNotificationStyle { get set }

	/// Optional text for the main title area of the control. If there is a title, the message becomes subtext.
	var message: String? { get set }

	/// Title to display in the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	var actionButtonTitle: String? { get set }

	/// Action to be dispatched by the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	var actionButtonAction: (() -> Void)? { get set }

	/// Action to be dispatched by tapping on the notification.
	var messageButtonAction: (() -> Void)? { get set }

	/// Direction that the notification will appear from. This is used to determine which side to draw the border for subtle notifications.
	var notificationDirection: MSFNotificationDirection { get set }
}

/// View that represents the Notification.
public struct NotificationBarView: View {
	/// Creates the Notification
	/// - Parameters:
	///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
	///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
	///   - actionButtonTitle: Title to display in the action button on the trailing edge of the control.
	///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
	///   - messageButtonAction: Action to be dispatched by tapping on the notification.
	///   - notificationDirection: Direction that the notification will appear from. This is used to determine which side to draw the border for subtle notifications.
    public init(style: MSFNotificationStyle,
                message: String? = nil,
                actionButtonTitle: String? = nil,
                actionButtonAction: (() -> Void)? = nil,
                messageButtonAction: (() -> Void)? = nil,
                notificationDirection: MSFNotificationDirection = .bottom) {
        let state = MSFNotificationStateImpl(style: style,
                                             message: message,
                                             actionButtonTitle: actionButtonTitle,
                                             actionButtonAction: actionButtonAction,
                                             messageButtonAction: messageButtonAction,
                                             notificationDirection: notificationDirection)
		self.state = state
		self.backgroundColor = {
			switch state.style {
			case .accent:
				return Constants.accentBackgroundColor
			case .subtle:
				return Constants.subtleBackgroundColor
			case .neutral:
				return Constants.neutralBackgroundColor
			}
		}()
		self.foregroundColor = {
			switch state.style {
			case .accent:
				return Constants.accentForegroundColor
			case .subtle:
				return Constants.subtleForegroundColor
			case .neutral:
				return Constants.neutralForegroundColor
			}
		}()
	}

	public var body: some View {
		@ViewBuilder
		var messageLabel: some View {
			if let message = state.message {
				Text(message)
					.font(.system(size: 15))
					.fontWeight(.regular)
					.foregroundColor(foregroundColor)
					.fixedSize(horizontal: false, vertical: true)
			}
		}

		@ViewBuilder
		var button: some View {
			if let buttonAction = state.actionButtonAction ?? nil {
				if let actionTitle = state.actionButtonTitle, !actionTitle.isEmpty {
					SwiftUI.Button(action: {
						buttonAction()
					}, label: {
						if #available(macOS 13.0, *) {
							Text(actionTitle)
								.lineLimit(1)
								.foregroundColor(foregroundColor)
								.font(.system(size: 15))
								.fontWeight(.semibold)
						} else {
							Text(actionTitle)
								.lineLimit(1)
								.foregroundColor(foregroundColor)
						}
					}).buttonStyle(PlainButtonStyle())
				} else {
					SwiftUI.Button(action: {
						buttonAction()
					}, label: {
						Image(nsImage: NSImage(named: NSImage.stopProgressTemplateName)!)
							.foregroundColor(foregroundColor)
					}).buttonStyle(PlainButtonStyle())
				}
			}
		}

		let messageButtonAction = state.messageButtonAction
		@ViewBuilder
		var innerContents: some View {
			if state.actionButtonAction == nil {
				HStack {
					Spacer()
					messageLabel
					Spacer()
				}
				.frame(minHeight: Constants.minimumHeight)
			} else {
				let horizontalSpacing = Constants.horizontalSpacing
				HStack(spacing: 0) {
					HStack(spacing: horizontalSpacing) {
						messageLabel
						Spacer(minLength: 0)
					}
					.accessibilityElement(children: .combine)
					button
						.layoutPriority(1)
				}
				.frame(minHeight: Constants.minimumHeight)
				.padding(.horizontal, Constants.horizontalPadding)
				.clipped()
			}
		}

		@ViewBuilder
		var notification: some View {
			innerContents
				.background(
					backgroundColor
				)
				.overlay(Rectangle().frame(width: nil, height: state.style == .subtle ? Constants.outlineWidth : 0, alignment: .top).foregroundColor(Constants.neutralBackgroundColor), alignment: state.notificationDirection == MSFNotificationDirection.bottom ? .top : .bottom)
				.onTapGesture {
					if let messageAction = messageButtonAction {
						messageAction()
					}
				}
		}

		return notification
	}

	var state: MSFNotificationStateImpl

	var backgroundColor: Color

	var foregroundColor: Color

	private struct Constants {
		static let accentBackgroundColor: Color = Color(Colors.primaryTint30)
		static let accentForegroundColor: Color = Color(Colors.primaryShade20)
		static let subtleBackgroundColor: Color = Color(.white)
		static let subtleForegroundColor: Color = Color(Colors.primary)
		static let neutralBackgroundColor: Color = Color(Colors.Palette.gray100.color)
		static let neutralForegroundColor: Color = Color(Colors.Palette.gray900.color)

		static let horizontalPadding: CGFloat = 16
		static let horizontalSpacing: CGFloat = 16
		static let minimumHeight: CGFloat = 45
		static let outlineWidth: CGFloat = 0.5
	}
}

class MSFNotificationStateImpl: NSObject, MSFNotificationState {
	@Published var message: String?

	/// Title to display in the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and `actionButtonAction`.
	@Published var actionButtonTitle: String?

	/// Action to be dispatched by the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and `actionButtonAction`.
	@Published var actionButtonAction: (() -> Void)?

	/// Action to be dispatched by tapping on the notification.
	@Published var messageButtonAction: (() -> Void)?

	/// Style to draw the control.
	@Published var style: MSFNotificationStyle

	/// Direction that the notification will appear from. This is used to determine which side to draw the border for subtle notifications.
	@Published var notificationDirection: MSFNotificationDirection

    @objc convenience init(style: MSFNotificationStyle) {
        self.init(style: style,
                  message: nil,
                  actionButtonTitle: nil,
                  actionButtonAction: nil,
                  messageButtonAction: nil,
                  notificationDirection: MSFNotificationDirection.bottom)
	}

    init(style: MSFNotificationStyle,
         message: String? = nil,
         actionButtonTitle: String? = nil,
         actionButtonAction: (() -> Void)? = nil,
         messageButtonAction: (() -> Void)? = nil,
         notificationDirection: MSFNotificationDirection = .bottom) {
		self.style = style
		self.message = message
		self.actionButtonTitle = actionButtonTitle
		self.actionButtonAction = actionButtonAction
		self.messageButtonAction = messageButtonAction
		self.notificationDirection = notificationDirection

		super.init()
	}
}
