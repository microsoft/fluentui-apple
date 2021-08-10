//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

// MARK: - BadgeView

@available(*, deprecated, renamed: "BadgeView")
public typealias MSBadgeView = BadgeView

@objc(MSFBadgeView)
open class BadgeView: NSView {
	/// Initializes a Fluent UI Badge View with the provided title, default style, and small size
	/// - Parameters:
	///   - title: String displayed in the badge
	@objc public convenience init(title: String) {
		self.init(title: title, style: .default, size: .small)
	}

	public required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	/// Initializes a Fluent UI Badge View with the provided title, style, and size
	/// - Parameters:
	///   - title: String displayed in the badge
	///   - style: The BadgeViewStyle, currenly only default is supported
	///   - size: The BadgeViewSize, currently only small is supported
	public init(title: String, style: BadgeViewStyle = .default, size: BadgeViewSize = .small) {
		textField = NSTextField(labelWithString: title)
		self.style = style
		super.init(frame: .zero)

		wantsLayer = true

		textField.lineBreakMode = .byTruncatingMiddle
		textField.alignment = .center
		textField.backgroundColor = .clear
		textField.translatesAutoresizingMaskIntoConstraints = false
		addSubview(textField)

		setAccessibilityElement(true)
		setAccessibilityLabel(title)
		setAccessibilityRole(.staticText)

		switch style {
		case .default:
			layer?.backgroundColor = Colors.Badge.defaultBackground.cgColor
			textField.textColor = Colors.Badge.defaultText
		}

		var horizontalPadding: CGFloat
		var verticalPadding: CGFloat
		switch size {
		case .small:
			textField.font = NSFont.systemFont(ofSize: BadgeViewSizeParameters.small.fontSize, weight: .light)
			layer?.cornerRadius = BadgeViewSizeParameters.small.cornerRadius
			horizontalPadding = BadgeViewSizeParameters.small.horizontalPadding
			verticalPadding = BadgeViewSizeParameters.small.verticalPadding
		}

		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
			textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
			textField.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
			textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding)
		])
	}

	private var textField: NSTextField
	private var style: BadgeViewStyle

	open override func updateLayer() {
		switch self.style {
		case .default:
			layer?.backgroundColor = Colors.Badge.defaultBackground.cgColor
			textField.textColor = Colors.Badge.defaultText
		}
	}
}

// MARK: - Style

@objc(MSFBadgeViewStyle)
public enum BadgeViewStyle: Int, CaseIterable {
	case `default`
}

// MARK: - Colors

private extension Colors {
	struct Badge {
		fileprivate static let defaultBackground: NSColor = Palette.communicationBlueTint40.color
		fileprivate static let defaultText: NSColor = Palette.communicationBlue.color
	}
}

// MARK: - Size

@objc(MSFBadgeViewSize)
public enum BadgeViewSize: Int, CaseIterable {
	case small
}

private struct BadgeViewSizeParameters {
	fileprivate let fontSize: CGFloat
	fileprivate let cornerRadius: CGFloat
	fileprivate let verticalPadding: CGFloat
	fileprivate let horizontalPadding: CGFloat

	static let small = BadgeViewSizeParameters(
		fontSize: 11,
		cornerRadius: 3,
		verticalPadding: 3,
		horizontalPadding: 8
	)

	static func parameters(forSize: BadgeViewSize) -> BadgeViewSizeParameters {
		switch forSize {
		case .small:
			return .small
		}
	}
}
