//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
	/// Floating notification with brand colored text and background.
	case primaryToast

	/// Floating notification with neutral colored text and background.
	case neutralToast

	/// Bar notification with brand colored text and background.
	case primaryBar

	/// Bar notification with brand colored text and neutral colored background.
	case primaryOutlineBar

	/// Bar notification with neutral colored text and brackground.
	case neutralBar

	/// Floating notification with red text and background.
	case dangerToast

	///Floating notification with yellow text and background.
	case warningToast

	var isToast: Bool {
		switch self {
		case .primaryToast,
			 .neutralToast,
			 .dangerToast,
			 .warningToast:
			return true
		case .primaryBar,
			 .primaryOutlineBar,
			 .neutralBar:
			return false
		}
	}
}

/// Properties that can be used to customize the appearance of the `Notification`.
@objc public protocol MSFNotificationState: NSObjectProtocol {
	/// Style to draw the control.
	var style: MSFNotificationStyle { get set }

	/// Optional text for the main title area of the control. If there is a title, the message becomes subtext.
	var message: String? { get set }

	/// Optional text to draw above the message area.
	var title: String? { get set }

	/// Optional icon to draw at the leading edge of the control.
	var image: NSImage? { get set }

	/// Title to display in the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	var actionButtonTitle: String? { get set }

	/// Action to be dispatched by the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	var actionButtonAction: (() -> Void)? { get set }

	/// Bool to control if the Notification has a dismiss action by default.
	var showDefaultDismissActionButton: Bool { get set }

	/// Action to be dispatched by tapping on the toast/bar notification.
	var messageButtonAction: (() -> Void)? { get set }
}

/// View that represents the Notification.
public struct Notification: View {
	/// Creates the Notification
	/// - Parameters:
	///   - style: `MSFNotificationStyle` enum value that defines the style of the Notification being presented.
	///   - message: Optional text for the main title area of the control. If there is a title, the message becomes subtext.
	///   - title: Optional text to draw above the message area.
	///   - image: Optional icon to draw at the leading edge of the control.
	///   - actionButtonTitle:Title to display in the action button on the trailing edge of the control.
	///   - actionButtonAction: Action to be dispatched by the action button on the trailing edge of the control.
	///   - showDefaultDismissActionButton: Bool to control if the Notification has a dismiss action by default.
	///   - messageButtonAction: Action to be dispatched by tapping on the toast/bar notification.
	public init(style: MSFNotificationStyle,
				message: String? = nil,
				title: String? = nil,
				image: NSImage? = nil,
				actionButtonTitle: String? = nil,
				actionButtonAction: (() -> Void)? = nil,
				showDefaultDismissActionButton: Bool? = nil,
				messageButtonAction: (() -> Void)? = nil) {
		let state = MSFNotificationStateImpl(style: style,
											 message: message,
											 title: title,
											 image: image,
											 actionButtonTitle: actionButtonTitle,
											 actionButtonAction: actionButtonAction,
											 showDefaultDismissActionButton: showDefaultDismissActionButton,
											 messageButtonAction: messageButtonAction)
		self.state = state

		self.backgroundColor = {
			switch state.style {
			case .primaryToast, .primaryBar:
				return Constants.primaryBackgroundColor
			case .neutralToast, .neutralBar:
				return Constants.neutralBackgroundColor
			case .primaryOutlineBar:
				return Constants.primaryOutlineBarBackgroundColor
			case .dangerToast:
				return Constants.dangerToastBackgroundColor
			case .warningToast:
				return Constants.warningToastBackgroundColor
			}
		}()
		self.foregroundColor = {
			switch state.style {
			case .primaryToast, .primaryBar:
				return Constants.primaryForegroundColor
			case .neutralToast, .neutralBar:
				return Constants.neutralForegroundColor
			case .primaryOutlineBar:
				return Constants.primaryOutlineBarForegroundColor
			case .dangerToast:
				return Constants.dangerToastForegroundColor
			case .warningToast:
				return Constants.warningToastForegroundColor
			}
		}()
	}

	public var body: some View {
		@ViewBuilder
		var image: some View {
			if state.style.isToast {
				if let image = state.image {
					let imageSize = image.size
					Image(nsImage: image)
						.frame(width: imageSize.width,
							   height: imageSize.height,
							   alignment: .center)
						.foregroundColor(foregroundColor)
				}
			}
		}

		@ViewBuilder
		var titleLabel: some View {
			if state.style.isToast && hasSecondTextRow {
				if let title = state.title {
					Text(title)
						.font(.system(size: 15))
						.fontWeight(.semibold)
						.foregroundColor(foregroundColor)
						.fixedSize(horizontal: false, vertical: true)
				}
			}
		}

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
		var textContainer: some View {
			VStack(alignment: .leading) {
				if hasSecondTextRow {
					titleLabel
				}
				messageLabel
			}
			.padding(.vertical, Constants.verticalPadding)
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
			if hasCenteredText {
				HStack {
					Spacer()
					textContainer
					Spacer()
				}
				.frame(minHeight: Constants.minimumHeight)
			} else {
				let horizontalSpacing = Constants.horizontalSpacing
				HStack(spacing: 0) {
					HStack(spacing: horizontalSpacing) {
						image
						textContainer
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
					.clipShape(RoundedRectangle(cornerRadius: state.style.isToast ? Constants.toastCornerRadius : Constants.barCornerRadius))
				)
				.overlay(Rectangle().frame(width: nil, height: state.style == .primaryOutlineBar ? Constants.outlineWidth : 0, alignment: .top).foregroundColor(Constants.neutralBackgroundColor), alignment: .top)
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

	private var hasImage: Bool {
		state.style.isToast && state.image != nil
	}

	private var hasSecondTextRow: Bool {
		guard state.title != nil else {
			return false
		}

		return state.style.isToast
	}

	private var hasCenteredText: Bool {
		!state.style.isToast && state.actionButtonAction == nil
	}

	private struct Constants {
		static let primaryBackgroundColor: Color = Color(FluentUI.Colors.primaryTint30)
		static let primaryForegroundColor: Color = Color(FluentUI.Colors.primaryShade20)
		static let neutralBackgroundColor: Color = Color(FluentUI.Colors.Palette.gray100.color)
		static let neutralForegroundColor: Color = Color(FluentUI.Colors.Palette.gray900.color)
		static let primaryOutlineBarBackgroundColor: Color = Color(.white)
		static let primaryOutlineBarForegroundColor: Color = Color(FluentUI.Colors.primary)
		static let dangerToastBackgroundColor: Color = Color(FluentUI.Colors.Palette.dangerTint30.color)
		static let dangerToastForegroundColor: Color = Color(FluentUI.Colors.Palette.dangerShade20.color)
		static let warningToastBackgroundColor: Color = Color(FluentUI.Colors.Palette.warningTint30.color)
		static let warningToastForegroundColor: Color = Color(FluentUI.Colors.Palette.warningShade30.color)

		static let toastCornerRadius: CGFloat = 12
		static let barCornerRadius: CGFloat = 0
		static let horizontalPadding: CGFloat = 16
		static let verticalPadding: CGFloat = 12
		static let horizontalSpacing: CGFloat = 16
		static let minimumHeight: CGFloat = 52
		static let outlineWidth: CGFloat = 0.5
	}
}

class MSFNotificationStateImpl: NSObject, MSFNotificationState {
	@Published var message: String?
	@Published var title: String?
	@Published var image: NSImage?
	@Published var showDefaultDismissActionButton: Bool

	/// Title to display in the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	@Published var actionButtonTitle: String?

	/// Action to be dispatched by the action button on the trailing edge of the control.
	///
	/// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
	@Published var actionButtonAction: (() -> Void)?

	/// Action to be dispatched by tapping on the toast/bar notification.
	@Published var messageButtonAction: (() -> Void)?

	/// Style to draw the control.
	@Published var style: MSFNotificationStyle

	@objc convenience init(style: MSFNotificationStyle) {
		self.init(style: style,
				  message: nil,
				  title: nil,
				  image: nil,
				  actionButtonTitle: nil,
				  actionButtonAction: nil,
				  showDefaultDismissActionButton: nil,
				  messageButtonAction: nil)
	}

	init(style: MSFNotificationStyle,
		 message: String? = nil,
		 title: String? = nil,
		 image: NSImage? = nil,
		 actionButtonTitle: String? = nil,
		 actionButtonAction: (() -> Void)? = nil,
		 showDefaultDismissActionButton: Bool? = nil,
		 messageButtonAction: (() -> Void)? = nil) {
		self.style = style
		self.message = message
		self.title = title
		self.image = image
		self.actionButtonTitle = actionButtonTitle
		self.actionButtonAction = actionButtonAction
		self.messageButtonAction = messageButtonAction
		self.showDefaultDismissActionButton = showDefaultDismissActionButton ?? style.isToast

		super.init()
	}
}
