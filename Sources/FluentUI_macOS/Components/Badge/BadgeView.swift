//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFBadgeView)
open class BadgeView: NSView {
	@objc(MSFBadgeViewStyle)
	public enum Style: Int, CaseIterable {
		case `default`
		case primary
	}

	/// Initializes a Fluent UI Badge View with the provided title, default style, and small size
	/// - Parameters:
	///   - title: String displayed in the badge
	@objc public convenience init(title: String) {
		self.init(title: title, style: .default)
	}

	/// Initializes a Fluent UI Badge View with the provided title and style
	/// - Parameters:
	///   - title: String displayed in the badge
	///   - style: The BadgeViewStyle
	@objc public init(title: String, style: Style) {
		textField = NSTextField(labelWithString: title)
		switch style {
		case .default:
			_backgroundColor = Constants.defaultBackgroundColor
			_textColor = Constants.defaultTextColor
		case .primary:
			_backgroundColor = Constants.primaryBackgroundColor
			_textColor = Constants.primaryTextColor
		}
		super.init(frame: .zero)

		wantsLayer = true
		layer?.cornerRadius = Size.small.cornerRadius

		textField.lineBreakMode = .byTruncatingMiddle
		textField.alignment = .center
		textField.backgroundColor = .clear
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = NSFont.systemFont(ofSize: Size.small.fontSize, weight: .light)
		addSubview(textField)

		setAccessibilityElement(true)
		setAccessibilityLabel(title)
		setAccessibilityRole(.staticText)

		var horizontalPadding: CGFloat
		var verticalPadding: CGFloat
		horizontalPadding = Size.small.horizontalPadding
		verticalPadding = Size.small.verticalPadding
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
			textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
			textField.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
			textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
		])
	}

	public required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	open override func updateLayer() {
		updateColors()
	}

	private var _backgroundColor: DynamicColor
	@objc open var backgroundColor: DynamicColor {
		get {
			return _backgroundColor
		}
		set {
			if backgroundColor != newValue {
				_backgroundColor = newValue
				updateColors()
			}
		}
	}

	private var _textColor: DynamicColor
	@objc open var textColor: DynamicColor {
		get {
			return _textColor
		}
		set {
			if textColor != newValue {
				_textColor = newValue
				updateColors()
			}
		}
	}

	private var textField: NSTextField

	private func updateColors() {
		updateBackgroundColors()
		updateTextColors()
	}

	private func updateBackgroundColors() {
		layer?.backgroundColor = backgroundColor.resolvedColor(window?.effectiveAppearance).cgColor
	}

	private func updateTextColors() {
		textField.textColor = textColor.resolvedColor(window?.effectiveAppearance)
	}

	private enum Size: Int, CaseIterable {
		case small

		var fontSize: CGFloat {
			switch self {
			case .small:
				return 11
			}
		}

		var cornerRadius: CGFloat {
			switch self {
			case .small:
				return 6
			}
		}

		var verticalPadding: CGFloat {
			switch self {
			case .small:
				return 3
			}
		}

		var horizontalPadding: CGFloat {
			switch self {
			case .small:
				return 4
			}
		}
	}

	private struct Constants {
		static let defaultBackgroundColor: DynamicColor = DynamicColor(light: Colors.Palette.communicationBlueTint40.color, dark: Colors.Palette.communicationBlueTint30.color)
		static let defaultTextColor: DynamicColor = DynamicColor(light: Colors.Palette.communicationBlue.color, dark: Colors.Palette.communicationBlueShade20.color)
		static let primaryBackgroundColor: DynamicColor = DynamicColor(light: Colors.primaryTint40, dark: Colors.primaryTint30)
		static let primaryTextColor: DynamicColor = DynamicColor(light: Colors.primary, dark: Colors.primaryShade20)
	}
}
