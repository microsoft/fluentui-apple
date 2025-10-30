//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@objc(MSFGlassButton)
open class GlassButton: Button {
	/// Swift-only designated initializer accepting ButtonFormat struct.
	/// - Parameters:
	///   - title: String displayed in the button, default empty string
	///   - image: The NSImage to diplay in the button, default nil
	///   - imagePosition: The position of the image, relative to the title, default imageLeading
	///   - format: The ButtonFormat including size, style and accentColor, with all applicable defaults
	override public init(
		title: String = "",
		image: NSImage? = nil,
		imagePosition: NSControl.ImagePosition = .imageLeading,
		format: ButtonFormat = ButtonFormat()
	) {
		super.init(title: title, image: image, imagePosition: imagePosition, format: format)

		// Update to use the established sizing for glass buttons
		self.setSizeParameters(GlassButton.standardSizeParameters)
	}

	override public var style: ButtonStyle {
		get {
			return super.style
		}
		set {
			// Only primary and secondary are supported on GlassButton
			super.style = newValue == .primary ? .primary : .secondary
		}
	}

	override func setColorValues(forStyle: ButtonStyle, accentColor: NSColor) {

		// Use System Colors which respond correctly to accessibility settings like increase contrast
		// https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors
		let increaseContrastBorderColor: NSColor = .textColor

		switch forStyle {
		case .primary:
			let contentTintRestColor = isWindowInactive ? fluentTheme.nsColor(.glassForeground1) : fluentTheme.nsColor(.foregroundLightStatic)
			contentTintColorSet = .init(
				rest: contentTintRestColor,
				pressed: contentTintRestColor.withSystemEffect(.pressed),
				hovered: contentTintRestColor.withSystemEffect(.rollover),
				disabled: ButtonColor.brandForegroundDisabled
			)
			let backgroundRestColor = isWindowInactive ? fluentTheme.nsColor(.background2).withAlphaComponent(0.05) : accentColor
			backgroundColorSet = .init(
				rest: backgroundRestColor,
				pressed: accentColor.withSystemEffect(.pressed),
				hovered: backgroundRestColor.withSystemEffect(.rollover),
				disabled: ButtonColor.brandBackgroundDisabled,
			)
			borderColorSet = .init(
				rest: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				pressed: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				hovered: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				disabled: increaseContrastEnabled ? increaseContrastBorderColor : .clear
			)
		case .secondary:
			let foreground = fluentTheme.nsColor(isWindowInactive ? .glassForeground1 : .foreground1)
			contentTintColorSet = .init(
				rest: foreground,
				pressed: foreground.withSystemEffect(.pressed),
				hovered: foreground.withSystemEffect(.rollover),
				disabled: foreground.withSystemEffect(.disabled)
			)
			let background = fluentTheme.nsColor(.background2).withAlphaComponent(0.05)
			backgroundColorSet = .init(
				rest: background,
				pressed: background.withSystemEffect(.pressed),
				hovered: background.withSystemEffect(.deepPressed),
				disabled: background.withSystemEffect(.disabled)
			)
			borderColorSet = .init(
				rest: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				pressed: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				hovered: increaseContrastEnabled ? increaseContrastBorderColor : .clear,
				disabled: increaseContrastEnabled ? increaseContrastBorderColor : .clear
			)
		default:
			preconditionFailure("Unsupported style for GlassButton: \(forStyle)")
		}
		updateContentTintColor()
	}

	override var cornerRadius: CGFloat {
		get {
			return (bounds.size.height / 2.0)
		}
		set {
			// No-op; we always calculate cornerRadius here
		}
	}

	static let standardSizeParameters = ButtonSizeParameters(
		fontSize: 13,  // line height: 17
		cornerRadius: 0.0, // unused
		verticalPadding: 4.0, // overall height: 28
		horizontalPadding: 6.0,
		titleVerticalPositionAdjustment: 0,
		titleToImageSpacing: 3,
		titleToImageVerticalSpacingAdjustment: 7,
		minButtonHeight: 24
	)
}
