//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@objc(MSFButton)
open class Button: NSButton {
	/// Initializes a Fluent UI Button with a title only
	/// - Parameters:
	///   - title: String displayed in the button
	///   - size: The ButtonSize, default .large
	///   - style: The ButtonStyle, default .primary
	///   - accentColor: The accent NSColor, defaulting to the app primary color
	@objc public convenience init(
		title: String,
		size: ButtonSize = .large,
		style: ButtonStyle = .primary,
		accentColor: NSColor = Colors.primary
	) {
		let format = ButtonFormat(size: size, style: style, accentColor: accentColor)
		self.init(title: title, format: format)
	}

	/// Initializes a Fluent UI Button with an image only
	/// - Parameters:
	///   - image: The NSImage to diplay in the button
	///   - size: The ButtonSize, default .large
	///   - style: The ButtonStyle, default .primary
	///   - accentColor: The accent NSColor, defaulting to the app primary color
	@objc public convenience init(
		image: NSImage,
		size: ButtonSize = .large,
		style: ButtonStyle = .primary,
		accentColor: NSColor = Colors.primary
	) {
		let format = ButtonFormat(size: size, style: style, accentColor: accentColor)
		self.init(image: image, format: format)
	}

	/// Initializes a Fluent UI Button with a title and image
	/// - Parameters:
	///   - title: String displayed in the button
	///   - image: The NSImage to diplay in the button
	///   - imagePosition: The position of the image relative to the title, default .imageLeading
	///   - size: The ButtonSize, default .large
	///   - style: The ButtonStyle, default .primary
	///   - accentColor: The accent NSColor, defaulting to the app primary color
	@objc public convenience init(
		title: String,
		image: NSImage,
		imagePosition: NSControl.ImagePosition = .imageLeading,
		size: ButtonSize = .large,
		style: ButtonStyle = .primary,
		accentColor: NSColor = Colors.primary
	) {
		let format = ButtonFormat(size: size, style: style, accentColor: accentColor)
		self.init(title: title, image: image, imagePosition: imagePosition, format: format)
	}

	/// Initializes a Fluent UI Button with no title or image, and with default formatting
	@objc public convenience init() {
		self.init(title: "", image: nil, imagePosition: .imageLeading, format: ButtonFormat())
	}

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}

	/// Swift-only designated initializer accepting ButtonFormat struct.
	/// - Parameters:
	///   - title: String displayed in the button, default empty string
	///   - image: The NSImage to diplay in the button, default nil
	///   - imagePosition: The position of the image, relative to the title, default imageLeading
	///   - format: The ButtonFormat including size, style and accentColor, with all applicable defaults
	public init(
		title: String = "",
		image: NSImage? = nil,
		imagePosition: NSControl.ImagePosition = .imageLeading,
		format: ButtonFormat = ButtonFormat()
	) {
		super.init(frame: .zero)
		isBordered = false
		wantsLayer = true
		layer?.contentsScale = window?.backingScaleFactor ?? 1.0
		setButtonType(.momentaryChange)

		if let cell = cell as? ButtonCell {
			// The Button properties `contentTintColorDisabled`,
			// `backgroundColorDisabled`, and `borderColorDisabled` fully
			// specify the look of the disabled button, and may already include
			// a 'disabled' system effect.  Don't apply the effect again on top
			// of that.
			cell.imageDimsWhenDisabled = false
		}

		self.title = title
		self.image = image
		self.imagePosition = imagePosition
		self.format = format

		// Ensure we update backing properties even if high-level style and size
		// properties have their default values
		let defaultFormat = ButtonFormat()
		if style == defaultFormat.style {
			setColorValues(forStyle: style, accentColor: accentColor)
		}
		if size == defaultFormat.size {
			setSizeParameters(forSize: size)
		}
	}

	open override class var cellClass: AnyClass? {
		get {
			return ButtonCell.self
		}
		set {}
	}

	/// Image to display in the button.
	open override var image: NSImage? {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the image is rendered on the layer")
			}
		}
	}

	/// Title string to display in the button.
	public override var title: String {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the title is rendered on the layer")
			}
		}
	}

	/// While the current Button is pressed, its style is temporarily applied to the linkedPrimary button.
	/// This emulates an effect seen in the default style of Cocoa buttons, where pressing a secondary
	/// button takes the accent color highlighting from a nearby primary button. For best results, the
	/// current button should have the `.secondary` style, the linkedPrimary button should have the
	/// `.primary` style, and both buttons should have the same accentColor.
	@objc public var linkedPrimary: Button? {
		didSet {
			guard oldValue != linkedPrimary else {
				return
			}
			linkedPrimaryOriginalStyle = linkedPrimary?.style
		}
	}

	private var linkedPrimaryOriginalStyle: ButtonStyle?

	public var isPressed: Bool = false {
		didSet {
			guard isEnabled && oldValue != isPressed else {
				return
			}
			updateContentTintColor()
			if let linkedPrimary = linkedPrimary {
				if isPressed {
					linkedPrimaryOriginalStyle = linkedPrimary.style
					linkedPrimary.style = self.style
				} else {
					linkedPrimary.style = linkedPrimaryOriginalStyle ?? .primary
				}
			}
			needsDisplay = true
		}
	}

	open override func mouseDown(with event: NSEvent) {
		isPressed = true
		super.mouseDown(with: event)
		isPressed = false
	}

	open override var isEnabled: Bool {
		didSet {
			guard oldValue != isEnabled else {
				return
			}
			updateContentTintColor()
		}
	}

	open override func updateLayer() {
		guard let layer = layer else {
			return
		}
		layer.borderWidth = Button.borderWidth
		layer.cornerRadius = cornerRadius
		if !isEnabled {
			layer.backgroundColor = backgroundColorDisabled?.cgColor
			layer.borderColor = borderColorDisabled?.cgColor
		} else if isPressed {
			layer.backgroundColor = backgroundColorPressed?.cgColor
			layer.borderColor = borderColorPressed?.cgColor
		} else {
			layer.backgroundColor = backgroundColorRest?.cgColor
			layer.borderColor = borderColorRest?.cgColor
		}
	}

	public override var wantsUpdateLayer: Bool {
		return true
	}

	open override func viewDidChangeBackingProperties() {
		super.viewDidChangeBackingProperties()

		// Update the layer content scales to the current window backingScaleFactor
		guard let scale = window?.backingScaleFactor else {
			return
		}
		if let layer = layer {
			layer.contentsScale = scale
		}
	}

	public var format: ButtonFormat {
		get {
			return ButtonFormat(
				size: self.size,
				style: self.style,
				accentColor: self.accentColor
			)
		}
		set {
			self.accentColor = newValue.accentColor
			self.style = newValue.style
			self.size = newValue.size
		}
	}

	/// State-specific colors for foreground, background and border
	private var contentTintColorRest: NSColor?
	private var contentTintColorPressed: NSColor?
	private var contentTintColorDisabled: NSColor?
	private var backgroundColorRest: NSColor?
	private var backgroundColorPressed: NSColor?
	private var backgroundColorDisabled: NSColor?
	private var borderColorRest: NSColor?
	private var borderColorPressed: NSColor?
	private var borderColorDisabled: NSColor?

	private func updateContentTintColor() {
		if !isEnabled {
			contentTintColor = contentTintColorDisabled
		} else if isPressed {
			contentTintColor = contentTintColorPressed
		} else {
			contentTintColor = contentTintColorRest
		}
	}

	private func setColorValues(forStyle: ButtonStyle, accentColor: NSColor) {
		switch forStyle {
		case .primary:
			contentTintColorRest = ButtonColor.neutralInverted
			contentTintColorPressed = ButtonColor.neutralInverted?.withSystemEffect(.pressed)
			contentTintColorDisabled = ButtonColor.brandForegroundDisabled
			backgroundColorRest = accentColor
			backgroundColorPressed = accentColor.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.brandBackgroundDisabled
			borderColorRest = .clear
			borderColorPressed = .clear
			borderColorDisabled = .clear
		case .secondary:
			contentTintColorRest = .textColor
			contentTintColorPressed = ButtonColor.neutralInverted?.withSystemEffect(.pressed)
			contentTintColorDisabled = NSColor.textColor.withSystemEffect(.disabled)
			backgroundColorRest = ButtonColor.neutralBackground2
			backgroundColorPressed = accentColor.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.neutralBackground2?.withSystemEffect(.disabled)
			borderColorRest = ButtonColor.neutralStroke2
			borderColorPressed = .clear
			borderColorDisabled = ButtonColor.neutralStroke2?.withSystemEffect(.disabled)
		case .acrylic:
			contentTintColorRest = ButtonColor.neutralForeground3
			contentTintColorPressed = ButtonColor.neutralForeground3?.withSystemEffect(.pressed)
			contentTintColorDisabled = ButtonColor.neutralForeground3?.withSystemEffect(.disabled)
			backgroundColorRest = ButtonColor.neutralBackground3
			backgroundColorPressed = ButtonColor.neutralBackground3?.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.neutralBackground3?.withSystemEffect(.disabled)
			borderColorRest = .clear
			borderColorPressed = .clear
			borderColorDisabled = .clear
		case .borderless:
			contentTintColorRest = accentColor
			contentTintColorPressed = accentColor.withSystemEffect(.deepPressed)
			contentTintColorDisabled = ButtonColor.brandForegroundDisabled
			backgroundColorRest = .clear
			backgroundColorPressed = .clear
			backgroundColorDisabled = .clear
			borderColorRest = .clear
			borderColorPressed = .clear
			borderColorDisabled = .clear
		}
		updateContentTintColor()
	}

	/// This color is used for the background in the primary style, the pressed background in the secondary
	/// style, and the content tint (i.e. foreground text/image) color in the borderless style.  It is not used
	/// for the acrylic style.
	@objc public var accentColor: NSColor = Colors.primary {
		didSet {
			guard oldValue != accentColor else {
				return
			}
			// Recompute relevant state-specific colors appropriate to the style
			setColorValues(forStyle: style, accentColor: accentColor)
			needsDisplay = true
		}
	}

	/// Any of several pre-set button styles.  Setting it determines the content tint
	/// (i.e. foreground text/image), background and border color properties for all button states.
	@objc public var style: ButtonStyle = .primary {
		didSet {
			guard oldValue != style else {
				return
			}
			setColorValues(forStyle: style, accentColor: accentColor)
			needsDisplay = true
		}
	}

	private var cornerRadius: CGFloat = ButtonSizeParameters.large.cornerRadius

	private static let borderWidth: CGFloat = 1

	private func setSizeParameters(forSize: ButtonSize) {
		let parameters = ButtonSizeParameters.parameters(forSize: size)
		font = NSFont.systemFont(ofSize: parameters.fontSize)
		cornerRadius = parameters.cornerRadius
		guard let cell = cell as? ButtonCell else {
			return
		}
		cell.verticalPadding = parameters.verticalPadding
		cell.horizontalPadding = parameters.horizontalPadding
		cell.titleVerticalPositionAdjustment = parameters.titleVerticalPositionAdjustment
		cell.titleToImageSpacing = parameters.titleToImageSpacing
		cell.titleToImageVerticalSpacingAdjustment = parameters.titleToImageVerticalSpacingAdjustment
	}

	/// Any of several pre-set button sizes.  Determines several factors including font size, corner radius,
	/// and padding.
	@objc public var size: ButtonSize = .large {
		didSet {
			guard oldValue != size else {
				return
			}
			setSizeParameters(forSize: size)
			invalidateIntrinsicContentSize()
			needsDisplay = true
		}
	}
}

// MARK: - ButtonCell

class ButtonCell: NSButtonCell {
	var verticalPadding: CGFloat = 0
	var horizontalPadding: CGFloat = 0
	var titleVerticalPositionAdjustment: CGFloat = 0
	var titleToImageSpacing: CGFloat = 0
	var titleToImageVerticalSpacingAdjustment: CGFloat = 0

	override func imageRect(forBounds rect: NSRect) -> NSRect {
		guard
			let image = image,
			let controlView = controlView,
			image.size != .zero,
			imagePosition != .noImage
		else {
			return .zero
		}

		let layoutDirectionSign = controlView.userInterfaceLayoutDirection == .rightToLeft ? -1 : 1
		let titleSize = title.size(withAttributes: [.font: font as Any])
		let imageSize = image.size

		// Image is either centered, or offset from center by the title
		var xOffsetSign = 0
		var yOffsetSign = 0

		if title.count == 0 {
			imagePosition = .imageOnly
		}

		switch imagePosition {
		case .noImage:
			preconditionFailure(".noImage case is covered by guard return")
		case .imageOnly, .imageOverlaps:
			break
		case .imageLeft:
			xOffsetSign = -1
		case .imageLeading:
			xOffsetSign = -layoutDirectionSign
		case .imageRight:
			xOffsetSign = 1
		case .imageTrailing:
			xOffsetSign = layoutDirectionSign
		case .imageBelow:
			yOffsetSign = 1
		case .imageAbove:
			yOffsetSign = -1
		@unknown default:
			break
		}

		var x = (rect.width - imageSize.width) / 2
		var y = (rect.height - imageSize.height) / 2

		if xOffsetSign != 0 {
			x += CGFloat(xOffsetSign) * (titleSize.width + titleToImageSpacing) / 2
		} else if yOffsetSign != 0 {
			y += CGFloat(yOffsetSign) * (titleSize.height + titleToImageSpacing - titleToImageVerticalSpacingAdjustment) / 2
		}

		return NSRect(x: x, y: y, width: imageSize.width, height: imageSize.height)
	}

	override func titleRect(forBounds rect: NSRect) -> NSRect {
		guard
			let font = font,
			let controlView = controlView,
			title.count > 0,
			imagePosition != .imageOnly
		else {
			return .zero
		}

		let layoutDirectionSign = controlView.userInterfaceLayoutDirection == .rightToLeft ? -1 : 1
		let titleSize = title.size(withAttributes: [.font: font])
		let imageSize = image?.size ?? .zero

		if imageSize == .zero {
			imagePosition = .noImage
		}

		// Title is either centered, or offset from center by the image
		var xOffsetSign = 0
		var yOffsetSign = 0

		switch imagePosition {
		case .imageOnly:
			preconditionFailure(".imageOnly case is covered by guard return")
		case .noImage, .imageOverlaps:
			break
		case .imageLeft:
			xOffsetSign = 1
		case .imageLeading:
			xOffsetSign = layoutDirectionSign
		case .imageRight:
			xOffsetSign = -1
		case .imageTrailing:
			xOffsetSign = -layoutDirectionSign
		case .imageBelow:
			yOffsetSign = -1
		case .imageAbove:
			yOffsetSign = 1
		@unknown default:
			break
		}

		var x = (rect.width - titleSize.width) / 2
		var y = (rect.height - titleSize.height) / 2 + titleVerticalPositionAdjustment

		if xOffsetSign != 0 {
			x += CGFloat(xOffsetSign) * (imageSize.width + titleToImageSpacing) / 2
		} else if yOffsetSign != 0 {
			y += CGFloat(yOffsetSign) * (imageSize.height + titleToImageSpacing) / 2
		}

		return NSRect(x: x, y: y, width: titleSize.width, height: titleSize.height)
	}

	override func drawingRect(forBounds rect: NSRect) -> NSRect {
		var width = rect.width - (horizontalPadding * 2)
		var height = rect.height - (verticalPadding * 2)

		switch imagePosition {
		case .imageLeft, .imageLeading, .imageRight, .imageTrailing:
			width -= titleToImageSpacing
		case .imageBelow, .imageAbove:
			height -= titleToImageSpacing
		case .noImage, .imageOnly, .imageOverlaps:
			break
		@unknown default:
			break
		}

		return NSRect(x: 0, y: 0, width: width, height: height)
	}
}

// MARK: - Button Formatting Parameters

/// Indicates the size of the button
@objc(MSFButtonSize)
public enum ButtonSize: Int, CaseIterable {
	case large
	case small
}

/// Indicates what style our button is drawn as
@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
	/// Accent color fill, white text/image.
	case primary

	/// Light mode: white fill, black text/image, light gray outline.
	/// Dark mode: dark gray fill, white text/image, subtle gray outline.
	/// Pressed: accent color fill, white text/image, no outline (same as primary style).
	case secondary

	/// Light mode: light gray fill, black text/image.
	/// Dark mode: dark gray fill, white text/image.
	case acrylic

	/// Accent color text/image, no fill or outline.
	case borderless
}

/// Combination of all formatting parameters.
public struct ButtonFormat {
	public var size: ButtonSize
	public var style: ButtonStyle
	public var accentColor: NSColor

	public init(
		size: ButtonSize = .large,
		style: ButtonStyle = .primary,
		accentColor: NSColor = Colors.primary
	) {
		self.size = size
		self.style = style
		self.accentColor = accentColor
	}
}

// MARK: - Semantic Color Constants

@objc(MSFButtonColor)
class ButtonColor: NSObject {
	public static let brandForegroundDisabled = NSColor(named: "ButtonColors/brandForegroundDisabled", bundle: FluentUIResources.resourceBundle)
	public static let brandBackgroundDisabled = NSColor(named: "ButtonColors/brandBackgroundDisabled", bundle: FluentUIResources.resourceBundle)
	public static let neutralInverted = NSColor(named: "ButtonColors/neutralInverted", bundle: FluentUIResources.resourceBundle)
	public static let neutralForeground2 = NSColor(named: "ButtonColors/neutralForeground2", bundle: FluentUIResources.resourceBundle)
	public static let neutralBackground2 = NSColor(named: "ButtonColors/neutralBackground2", bundle: FluentUIResources.resourceBundle)
	public static let neutralStroke2 = NSColor(named: "ButtonColors/neutralStroke2", bundle: FluentUIResources.resourceBundle)
	public static let neutralForeground3 = NSColor(named: "ButtonColors/neutralForeground3", bundle: FluentUIResources.resourceBundle)
	public static let neutralBackground3 = NSColor(named: "ButtonColors/neutralBackground3", bundle: FluentUIResources.resourceBundle)
}

// MARK: - Size Constants

private struct ButtonSizeParameters {
	fileprivate let fontSize: CGFloat
	fileprivate let cornerRadius: CGFloat
	fileprivate let verticalPadding: CGFloat
	fileprivate let horizontalPadding: CGFloat
	fileprivate let titleVerticalPositionAdjustment: CGFloat
	fileprivate let titleToImageSpacing: CGFloat
	fileprivate let titleToImageVerticalSpacingAdjustment: CGFloat

	static let large = ButtonSizeParameters(
		fontSize: 15,  // line height: 19
		cornerRadius: 6,
		verticalPadding: 4.5,  // overall height: 28
		horizontalPadding: 36,
		titleVerticalPositionAdjustment: -0.25,
		titleToImageSpacing: 10,
		titleToImageVerticalSpacingAdjustment: 7
	)

	static let small = ButtonSizeParameters(
		fontSize: 13,  // line height: 17
		cornerRadius: 5,
		verticalPadding: 1.5,  // overall height: 20
		horizontalPadding: 14,
		titleVerticalPositionAdjustment: -0.75,
		titleToImageSpacing: 6,
		titleToImageVerticalSpacingAdjustment: 7
	)

	static func parameters(forSize: ButtonSize) -> ButtonSizeParameters {
		switch forSize {
		case .large:
			return .large
		case .small:
			return .small
		}
	}
}
