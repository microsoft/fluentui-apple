//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

public typealias MSBadgeView = BadgeView

@objc(MSFBadgeView)
open class BadgeView: NSView {
	@objc(MSFBadgeViewStyle)
	public enum Style: Int, CaseIterable {
		case `default`
		case primary
	}

	@objc(MSFBadgeViewSize)
	public enum Size: Int, CaseIterable {
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
				return 3
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
				return 8
			}
		}
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
			_backgroundColor = Colors.Badge.defaultBackground
			_textColor = Colors.Badge.defaultText
		case .primary:
			_backgroundColor = Colors.Badge.primaryBackground
			_textColor = Colors.Badge.primaryText
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

	private var _backgroundColor: NSColor
	@objc open var backgroundColor: NSColor {
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

	private var _textColor: NSColor
	@objc open var textColor: NSColor {
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
		layer?.backgroundColor = backgroundColor.cgColor
	}

	private func updateTextColors() {
		textField.textColor = textColor
	}
}

// MARK: - Colors

extension Colors {
	struct Badge {
		static let defaultBackground: NSColor = Palette.communicationBlueTint40.color
		static let defaultText: NSColor = Palette.communicationBlue.color
		static let primaryBackground: NSColor = primaryTint40
		static let primaryText: NSColor = primary
	}
}
