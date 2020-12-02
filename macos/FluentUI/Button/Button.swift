//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

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
	/// No defined colors; user to specify.
	case none

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
	var size: ButtonSize
	var style: ButtonStyle
	var accentColor: NSColor?

	public init(
		size: ButtonSize = .large,
		style: ButtonStyle = .primary,
		accentColor: NSColor? = Colors.primary
	)
	{
		self.size = size
		self.style = style
		self.accentColor = accentColor
	}
}

// MARK: - Semantic Colors

@objc(MSFButonColor)
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

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@objc(MSFButton)
open class Button: NSButton {
	/// Initializes a Fluent UI Button with a title only
	/// - Parameters:
	///   - title: String displayed in the button
	///   - size: The ButtonSize, default .large
	///   - style: The ButtonStyle, default .primary
	///   - accentColor: The accent or highlight NSColor, defaulting to the app primary color
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
	///   - accentColor: The accent or highlight NSColor, defaulting to the app primary color
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
	///   - accentColor: The accent or highlight NSColor, defaulting to the app primary color
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
		self.init()
	}

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}

	/// Swift-only designated initializer accepting ButtonFormat struct.
	/// - Parameters:
	///   - title: String displayed in the button, default nil
	///   - image: The NSImage to diplay in the button, default nil
	///   - imagePosition: The position of the image, relative to the title, default imageLeading
	///   - format: The ButtonFormat including size, style and accentColor, with all applicable defaults
	public init(
		title: String? = nil,
		image: NSImage? = nil,
		imagePosition: NSControl.ImagePosition = .imageLeading,
		format: ButtonFormat = ButtonFormat()
	)
	{
		super.init(frame: .zero)
		isBordered = false
		wantsLayer = true
		layer?.contentsScale = window?.backingScaleFactor ?? 1.0

		if let cell = cell as? ButtonCell {
			// The Button properties `contentTintColorDisabled`,
			// `backgroundColorDisabled`, and `borderColorDisabled` fully
			// specify the look of the disabled button, and may already include
			// a 'disabled' system effect.  Don't apply the effect again on top
			// of that.
			cell.imageDimsWhenDisabled = false
		}

		if let title = title {
			self.title = title
			if let image = image {
				self.image = image
				self.imagePosition = imagePosition
			} else {
				self.imagePosition = .noImage
			}
		} else if let image = image {
			self.image = image
			self.imagePosition = .imageOnly
		}

		self.format = format
	}

	open class override var cellClass: AnyClass? {
		get {
			return ButtonCell.self
		}
		set {}
	}

	/// Image to display in the button.
	override public var image: NSImage? {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the image is rendered on the layer")
			}
		}
	}

	/// Title string to display in the button.
	override public var title: String {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the title is rendered on the layer")
			}
		}
	}

	private var mouseDown = false

	/// While the current Button is pressed, its style is temporarily applied to the linkedPrimary button.
	/// This emulates an effect seen in the default style of Cocoa buttons, where pressing a secondary
	/// button takes the accent color highlighting from a nearby primary button. For best results, the
	/// current button should have the `.secondary` style, the linkedPrimary button should have the
	/// `.primary` style, and both buttons should have the same accentColor.
	@objc public var linkedPrimary: Button?

	private var linkedPrimaryOriginalStyle: ButtonStyle?

	private func setMouse(down: Bool) {
		mouseDown = down
		needsDisplay = true
		if isEnabled {
			if let linkedPrimary = linkedPrimary
			{
				if down {
					linkedPrimaryOriginalStyle = linkedPrimary.style
					linkedPrimary.style = self.style
				} else {
					linkedPrimary.style = linkedPrimaryOriginalStyle ?? .primary
				}
				linkedPrimary.needsDisplay = true
			}
		}
	}

	open override func mouseDown(with event: NSEvent) {
		setMouse(down: true)
	}

	open override func mouseUp(with event: NSEvent) {
		setMouse(down: false)
	}

	open override func updateLayer() {
		if let layer = layer {
			layer.borderWidth = Button.borderWidth
			layer.cornerRadius = cornerRadius
			if let contentTintColor = contentTintColor {
				super.contentTintColor = contentTintColor
			}
			if let backgroundColor = backgroundColor { 
				layer.backgroundColor = backgroundColor.cgColor
			}
			if let borderColor = borderColor {
				layer.borderColor = borderColor.cgColor
			}
		}
	}

	override public var wantsUpdateLayer: Bool {
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

	private var format: ButtonFormat {
		get {
			return ButtonFormat(
				size: self.size,
				style: self.style,
				accentColor: self.accentColor
			)
		}
		set {
			self.accentColor = newValue.accentColor
			self.style = newValue.style  // depends on accentColor
			self.size = newValue.size
		}
	}

	/// Foreground text/image color when button is not pressed or disabled.
	@objc public var contentTintColorRest: NSColor?

	/// Foreground text/image color when button is pressed.
	@objc public var contentTintColorPressed: NSColor?

	/// Foreground text/image color when button is disabled.
	@objc public var contentTintColorDisabled: NSColor?

	/// Button foreground text/image color.  Setting this property determines the colors for the resting
	/// (normal), pressed and disabled states by applying system effects.  The value returned when getting
	/// this property will depend on which state currently applies to the button.  To set the state-specific
	/// colors separately, use the `contentTintColorRest`, `contentTintColorPressed`,
	/// and/or `contentTintColorDisabled` properties.
	open override var contentTintColor: NSColor? {
		get {
			if !isEnabled {
				return contentTintColorDisabled
			} else if mouseDown {
				return contentTintColorPressed
			} else {
				return contentTintColorRest
			}
		}
		set {
			contentTintColorRest = newValue
			contentTintColorPressed = newValue == .clear ? newValue : newValue?.withSystemEffect(.pressed)
			contentTintColorDisabled = newValue?.withSystemEffect(.disabled)
			super.contentTintColor = newValue
		}
	}

	/// Background fill color when button is not pressed or disabled.
	@objc public var backgroundColorRest: NSColor?

	/// Background fill color when button is pressed.
	@objc public var backgroundColorPressed: NSColor?

	/// Background fill color when button is disabled.
	@objc public var backgroundColorDisabled: NSColor?

	/// Button background fill color.  Setting this property determines the colors for the resting (normal),
	/// pressed and disabled states by applying system effects.  The value returned when getting this
	/// property will depend on which state currently applies to the button.  To set the state-specific
	/// colors separately, use the `backgroundColorRest`, `backgroundColorPressed`, and/or
	/// `backgroundColorDisabled` properties.
	@objc public var backgroundColor: NSColor? {
		get {
			if !isEnabled {
				return backgroundColorDisabled
			} else if mouseDown {
				return backgroundColorPressed
			} else {
				return backgroundColorRest
			}
		}
		set {
			backgroundColorRest = newValue
			backgroundColorPressed = newValue == .clear ? newValue : newValue?.withSystemEffect(.pressed)
			backgroundColorDisabled = newValue?.withSystemEffect(.disabled)
		}
	}

	/// Border stroke color when button is not pressed or disabled.
	@objc public var borderColorRest: NSColor?

	/// Border stroke color when button is pressed.
	@objc public var borderColorPressed: NSColor?

	/// Border stroke color when button is disabled.
	@objc public var borderColorDisabled: NSColor?

	/// Button border stroke color.  Setting this property determines the colors for the resting (normal),
	/// pressed and disabled states by applying system effects.  The value returned when getting this
	/// property will depend on which state currently applies to the button.  To set the state-specific
	/// colors separately, use the `borderColorRest`, `borderColorPressed`, and/or
	/// `borderColorDisabled` properties.
	@objc public var borderColor: NSColor? {
		get {
			if !isEnabled {
				return borderColorDisabled
			} else if mouseDown {
				return borderColorPressed
			} else {
				return borderColorRest
			}
		}
		set {
			borderColorRest = newValue
			borderColorPressed = newValue == .clear ? newValue : newValue?.withSystemEffect(.pressed)
			borderColorDisabled = newValue?.withSystemEffect(.disabled)
		}
	}

	/// This color is used for the background in the primary style, the pressed background in the secondary
	/// style, and the content tint (i.e. foreground text/image) color in the borderless style.  It is not used
	/// for the acrylic style.
	@objc public var accentColor: NSColor? = Colors.primary

	/// Any of several pre-set button styles.  Setting this property to `.none` does nothing.  Setting it to
	/// any other value determines the content tint (i.e. foreground text/image), background and border
	/// color properties for all button states, discarding any previous values.
	@objc open var style: ButtonStyle = .primary {
		willSet {
			switch newValue {
			case .primary:
				contentTintColor = ButtonColor.neutralInverted
				contentTintColorDisabled = ButtonColor.brandForegroundDisabled
				backgroundColor = accentColor
				backgroundColorDisabled = ButtonColor.brandBackgroundDisabled
				borderColor = .clear
			case .secondary:
				contentTintColor = .textColor
				contentTintColorPressed = ButtonColor.neutralInverted?.withSystemEffect(.pressed)
				backgroundColor = ButtonColor.neutralBackground2
				backgroundColorPressed = accentColor?.withSystemEffect(.pressed)
				borderColor = ButtonColor.neutralStroke2
				borderColorPressed = .clear
			case .acrylic:
				contentTintColor = ButtonColor.neutralForeground3
				backgroundColor = ButtonColor.neutralBackground3
				borderColor = .clear
			case .borderless:
				contentTintColor = accentColor
				contentTintColorDisabled = ButtonColor.brandForegroundDisabled
				backgroundColor = .clear
				borderColor = .clear
			case .none:
				break
			@unknown default:
				break
			}
		}
	}

	private var fontSize: CGFloat = 15 {
		willSet {
			font = NSFont.systemFont(ofSize:newValue)
		}
	}

	private var cornerRadius: CGFloat = 6

	private static let borderWidth: CGFloat = 1

	/// Any of several pre-set button sizes.  Determines several factors including font size, corner radius,
	/// and padding.
	@objc public var size: ButtonSize = .large {
		willSet {
			switch newValue {
			case .large:
				fontSize = 15  // line height: 19
				cornerRadius = 6
				if let cell = cell as? ButtonCell {
					cell.verticalPadding = 4.5  // overall height: 28
					cell.horizontalPadding = 36
					cell.titleVerticalPositionAdjustment = -0.25
					cell.titleToImageSpacing = 10
					cell.titleToImageVerticalSpacingAdjustment = 7
				}
			case .small:
				fontSize = 13  // line height: 17
				cornerRadius = 5
				if let cell = cell as? ButtonCell {
					cell.verticalPadding = 1.5  // overall height: 20
					cell.horizontalPadding = 14
					cell.titleVerticalPositionAdjustment = -0.75
					cell.titleToImageSpacing = 6
					cell.titleToImageVerticalSpacingAdjustment = 7
				}
			@unknown default:
				break
			}
		}
	}
}

// MARK: - ButtonCell

class ButtonCell: NSButtonCell {
	fileprivate var verticalPadding: CGFloat = 0
	fileprivate var horizontalPadding: CGFloat = 0
	fileprivate var titleVerticalPositionAdjustment: CGFloat = 0
	fileprivate var titleToImageSpacing: CGFloat = 0
	fileprivate var titleToImageVerticalSpacingAdjustment: CGFloat = 0

	override func imageRect(forBounds rect: NSRect) -> NSRect {
		guard let image = image else {
			return NSZeroRect
		}

		let isRTL = NSApp.userInterfaceLayoutDirection == .rightToLeft
		let imageRect = super.imageRect(forBounds: rect)
		let titleSize = title.size(withAttributes: [.font: font as Any])
		let imageSize = image.size

		var x = imageRect.origin.x
		var y = imageRect.origin.y
		var width = imageRect.size.width
		var height = imageRect.size.height

		switch imagePosition {
		case .noImage:
			x = 0
			y = 0
			width = 0
			height = 0
		case .imageOnly, .imageOverlaps:
			x = horizontalPadding
			y = verticalPadding
			width = rect.width - (horizontalPadding * 2)
			height = rect.height - (verticalPadding * 2)
		case .imageLeft:
			x = horizontalPadding
			y = (rect.height - imageSize.height) / 2
			width = imageSize.width
			height = imageSize.height
		case .imageLeading:
			x = isRTL ? titleSize.width + titleToImageSpacing + horizontalPadding : horizontalPadding
			y = (rect.height - imageSize.height) / 2
			width = imageSize.width
			height = imageSize.height
		case .imageRight:
			x = titleSize.width + titleToImageSpacing + horizontalPadding
			y = (rect.height - imageSize.height) / 2
			width = imageSize.width
			height = imageSize.height
		case .imageTrailing:
			x = isRTL ? horizontalPadding : titleSize.width + titleToImageSpacing + horizontalPadding
			y = (rect.height - imageSize.height) / 2
			width = imageSize.width
			height = imageSize.height
		case .imageBelow:
			x = (rect.width - imageSize.width) / 2
			y = (rect.height - imageSize.height + titleSize.height + titleToImageSpacing - titleToImageVerticalSpacingAdjustment) / 2
			width = imageSize.width
			height = imageSize.height
		case .imageAbove:
			x = (rect.width - imageSize.width) / 2
			y = (rect.height - imageSize.height - titleSize.height - titleToImageSpacing + titleToImageVerticalSpacingAdjustment) / 2
			width = imageSize.width
			height = imageSize.height
		@unknown default:
			break
		}

		return NSMakeRect(x, y, width, height)
	}

	override func titleRect(forBounds rect: NSRect) -> NSRect {
		guard let font = font else {
			return NSZeroRect
		}

		let isRTL = NSApp.userInterfaceLayoutDirection == .rightToLeft
		let titleRect = super.titleRect(forBounds: rect);
		let titleSize = title.size(withAttributes: [.font: font])
		let imageSize = image?.size ?? NSZeroSize

		var x = titleRect.origin.x
		var y = titleRect.origin.y
		var width = titleRect.size.width
		var height = titleRect.size.height

		switch imagePosition {
		case .imageOnly:
			x = 0
			y = 0
			width = 0
			height = 0
		case .noImage, .imageOverlaps:
			x = horizontalPadding
			y = verticalPadding + titleVerticalPositionAdjustment
			width = rect.width - (horizontalPadding * 2)
			height = rect.height - (verticalPadding * 2)
		case .imageLeft:
			x = horizontalPadding + imageSize.width + titleToImageSpacing
			y = verticalPadding + titleVerticalPositionAdjustment
			width = titleSize.width
			height = rect.height - (verticalPadding * 2)
		case .imageLeading:
			x = isRTL ? horizontalPadding : horizontalPadding + imageSize.width + titleToImageSpacing
			y = verticalPadding + titleVerticalPositionAdjustment
			width = titleSize.width
			height = rect.height - (verticalPadding * 2)
		case .imageRight:
			x = horizontalPadding
			y = verticalPadding + titleVerticalPositionAdjustment
			width = titleSize.width
			height = rect.height - (verticalPadding * 2)
		case .imageTrailing:
			x = isRTL ? horizontalPadding + imageSize.width + titleToImageSpacing : horizontalPadding
			y = verticalPadding + titleVerticalPositionAdjustment
			width = titleSize.width
			height = rect.height - (verticalPadding * 2)
		case .imageBelow:
			x = (rect.width - titleSize.width) / 2
			y = (rect.height - titleSize.height - imageSize.height - titleToImageSpacing) / 2 + titleVerticalPositionAdjustment
			width = titleSize.width
			height = titleSize.height
		case .imageAbove:
			x = (rect.width - titleSize.width) / 2
			y = (rect.height - titleSize.height + imageSize.height + titleToImageSpacing) / 2 + titleVerticalPositionAdjustment
			width = titleSize.width
			height = titleSize.height
		@unknown default:
			break
		}

		return NSMakeRect(x, y, width, height)
	}

	override func drawingRect(forBounds rect: NSRect) -> NSRect {
		var horizontalInterCellSpacing: CGFloat = 0
		var verticalInterCellSpacing: CGFloat = 0

		switch imagePosition {
		case .imageLeft, .imageLeading, .imageRight, .imageTrailing:
			horizontalInterCellSpacing = titleToImageSpacing
		case .imageBelow, .imageAbove:
			verticalInterCellSpacing = titleToImageSpacing
		case .noImage, .imageOnly, .imageOverlaps:
			break
		@unknown default:
			break
		}

		let drawingRectWithPadding = NSMakeRect(
			0,
			0,
			rect.width - (horizontalPadding * 2) - horizontalInterCellSpacing,
			rect.height - (verticalPadding * 2) - verticalInterCellSpacing
		)
		return drawingRectWithPadding
	}
}
