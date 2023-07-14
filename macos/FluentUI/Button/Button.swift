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
			setupBorderShadowsIfNeeded()
			setColorValues(forStyle: style, accentColor: accentColor)
		}
		if size == defaultFormat.size {
			setSizeParameters(forSize: size)
		}

		NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.accessibilityDisplayOptionsDidChangeNotification,
														  object: nil,
														  queue: nil) {[weak self] _ in
			self?.increaseContrastEnabled = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast
		}
	}

	func setupBorderShadowsIfNeeded() {
		// At the moment border shadows only apply for the Primary and Secondary Button Styles.
		// Border shadows being meant for buttons and their corresponding States, that have ~some~
		// background color other than `clear` which is why they don't apply to the Borderless Style
		// buttons. Acrylic Style buttons do possess a background color, yet they maintain transparency.
		// This transparency allows any underlying border shadow layers to bleed through, consequently
		// impacting the overall button background color. Adding shadows in this context presents a
		// challenge. Therefore, unless it becomes necessary, these buttons will remain without shadows.
		// And perhaps shadowPath is the way to go, where you can have the CALayer have a Clear
		// background color and still show a shadow by setting a hollow shadowPath around the button.
		self.usesBorderShadows = style == .primary || style == .secondary
	}

	var firstOuterDropShadowLayer: CALayer?
	var secondOuterDropShadowLayer: CALayer?
	var innerShadowLayer: CALayer?

	open override func layout() {
		super.layout()
		if usesBorderShadows {
			// Set the frame of all the shadow layers to the same bounds as this Button View. This
			// couldn't have been done in the init where the shadow layers are setup because the Button
			// view doesn't yet have any bounds established, so we're forced to do it in the layout
			// override where we're guaranteed to have bounds and is also invoked every time the view's
			// size or position needs adjustments.
			firstOuterDropShadowLayer?.frame = self.bounds
			secondOuterDropShadowLayer?.frame = self.bounds
			innerShadowLayer?.frame = self.bounds
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

	/// When set to a non `nil` value ,this image will always be placed on the trailing edge of the button.
	/// It is designed to remain independent of  the `imagePosition` value of the NSButton which applies to the built-in `image` property.
	@objc public var trailingImage: NSImage? {
		didSet {
			guard oldValue != trailingImage else {
				return
			}

			guard let cell = cell as? ButtonCell else {
				preconditionFailure("The FluentUI `Button` should only be used with the `ButtonCell` cell class.")
			}

			if let trailingImage = trailingImage {
				if let trailingImageView = trailingImageView {
					trailingImageView.image = trailingImage
				} else {
					let imageView = NSImageView(image: trailingImage)
					imageView.translatesAutoresizingMaskIntoConstraints = false
					addSubview(imageView)
					NSLayoutConstraint.activate([
						imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -cell.horizontalPadding),
						imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
					])
					trailingImageView = imageView
				}
				updateTrailingImageContentTintColor()
			} else {
				// Handle replacement/removal of a previously set image
				trailingImageView?.removeFromSuperview()
				trailingImageView = nil
			}
		}
	}

	private var trailingImageView: NSImageView?

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

		if usesBorderShadows {
			// Although we're using an AssetCatalog color for the shadows, which has a dynamic dark/light
			// appearance specified, we have to manually update the shadowColor property of the layer
			// since it's a CGColor and not an NSColor, and CGColorRef objects don’t adapt to environment
			// changes
			updateShadowLayer(shadowLayer: firstOuterDropShadowLayer,
							  shadowColor: ButtonColor.firstOuterDropShadow?.cgColor)
			updateShadowLayer(shadowLayer: secondOuterDropShadowLayer,
							  shadowColor: ButtonColor.secondOuterDropShadow?.cgColor)
			updateShadowLayer(shadowLayer: innerShadowLayer,
							  shadowColor: ButtonColor.innerShadow?.cgColor)
		}
	}

	func updateShadowLayer(shadowLayer: CALayer?, shadowColor: CGColor?) {
		guard let layer = layer else {
			return
		}
		// Match the shadow background color with that of the Button layer so that the shadow layer
		// content itself isn't visible, and just the shadow is.
		shadowLayer?.backgroundColor = layer.backgroundColor
		shadowLayer?.cornerRadius = layer.cornerRadius
		shadowLayer?.shadowColor = shadowColor
	}

	public override var wantsUpdateLayer: Bool {
		return true
	}

	open override func drawFocusRingMask() {
		// Ensure we draw the focus ring around the entire button bounds
		// rather than just around the image or title.
		let path = NSBezierPath(roundedRect: bounds, xRadius: cornerRadius, yRadius: cornerRadius)
		path.fill()
	}

	public override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		isWindowInactive = !(window?.isMainWindow ?? false)

		// Remove any previous Notification Observers if we're moving away from a window (in which case `viewDidMoveToWindow` is called and `window == nil`)
		// Or, remove any Notification Observers from the old window if we're moving directly into a new window
		if let resignMainWindowObserver = resignMainWindowObserver {
			NotificationCenter.default.removeObserver(resignMainWindowObserver)
			self.resignMainWindowObserver = nil
		}

		if let becomeMainWindowObserver = becomeMainWindowObserver {
			NotificationCenter.default.removeObserver(becomeMainWindowObserver)
			self.becomeMainWindowObserver = nil
		}

		if window != nil {
			// Hook in Notification Handles to capture the Window's active and inactive states
			resignMainWindowObserver = NotificationCenter.default.addObserver(forName: NSWindow.didResignMainNotification,
												   object: window,
												   queue: nil) {[weak self] _ in
				self?.isWindowInactive = true
			}

			becomeMainWindowObserver = NotificationCenter.default.addObserver(forName: NSWindow.didBecomeMainNotification,
												   object: window,
												   queue: nil) {[weak self] _ in
				self?.isWindowInactive = false
			}
		}
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

	/// Stored Observers for NSWindow  Notifications, to be able to remove them from NotificationCenter when not needed
	private var resignMainWindowObserver: NSObjectProtocol?
	private var becomeMainWindowObserver: NSObjectProtocol?

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
		updateTrailingImageContentTintColor()
	}

	private func updateTrailingImageContentTintColor() {
		if let trailingImageView = trailingImageView {
			if !isEnabled {
				trailingImageView.contentTintColor = contentTintColorDisabled
			} else if isPressed {
				trailingImageView.contentTintColor = contentTintColorPressed
			} else {
				trailingImageView.contentTintColor = contentTintColorRest
			}
		}
	}

	private func setColorValues(forStyle: ButtonStyle, accentColor: NSColor) {

		// Use System Colors which respond correctly to accessibility settings like increase contrast
		// https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors
		let increaseContrastBorderColor: NSColor = .textColor

		switch forStyle {
		case .primary:
			contentTintColorRest = isWindowInactive ? .textColor : ButtonColor.neutralInverted
			contentTintColorPressed = ButtonColor.neutralInverted?.withSystemEffect(.pressed)
			contentTintColorDisabled = ButtonColor.brandForegroundDisabled
			backgroundColorRest = isWindowInactive ? ButtonColor.neutralBackground2 : accentColor
			backgroundColorPressed = accentColor.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.brandBackgroundDisabled
			if increaseContrastEnabled {
				borderColorRest = increaseContrastBorderColor
			} else {
				borderColorRest = isWindowInactive ? ButtonColor.neutralStroke2 : .clear
			}
			borderColorPressed = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorDisabled = increaseContrastEnabled ? increaseContrastBorderColor : .clear
		case .secondary:
			contentTintColorRest = .textColor
			contentTintColorPressed = ButtonColor.neutralInverted?.withSystemEffect(.pressed)
			contentTintColorDisabled = NSColor.textColor.withSystemEffect(.disabled)
			backgroundColorRest = ButtonColor.neutralBackground2
			backgroundColorPressed = accentColor.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.neutralBackground2?.withSystemEffect(.disabled)
			borderColorRest = increaseContrastEnabled ? increaseContrastBorderColor : ButtonColor.neutralStroke2
			borderColorPressed = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorDisabled = increaseContrastEnabled ? increaseContrastBorderColor : ButtonColor.neutralStroke2?.withSystemEffect(.disabled)
		case .acrylic:
			contentTintColorRest = ButtonColor.neutralForeground3
			contentTintColorPressed = ButtonColor.neutralForeground3?.withSystemEffect(.pressed)
			contentTintColorDisabled = ButtonColor.neutralForeground3?.withSystemEffect(.disabled)
			backgroundColorRest = ButtonColor.neutralBackground3
			backgroundColorPressed = ButtonColor.neutralBackground3?.withSystemEffect(.pressed)
			backgroundColorDisabled = ButtonColor.neutralBackground3?.withSystemEffect(.disabled)
			borderColorRest = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorPressed = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorDisabled = increaseContrastEnabled ? increaseContrastBorderColor : .clear
		case .borderless:
			contentTintColorRest = isWindowInactive ? .textColor : accentColor
			contentTintColorPressed = accentColor.withSystemEffect(.deepPressed)
			contentTintColorDisabled = ButtonColor.brandForegroundDisabled
			backgroundColorRest = .clear
			backgroundColorPressed = .clear
			backgroundColorDisabled = .clear
			borderColorRest = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorPressed = increaseContrastEnabled ? increaseContrastBorderColor : .clear
			borderColorDisabled = increaseContrastEnabled ? increaseContrastBorderColor : .clear
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
			setupBorderShadowsIfNeeded()
			setColorValues(forStyle: style, accentColor: accentColor)
			needsDisplay = true
		}
	}

	var usesBorderShadows: Bool = false {
		didSet {
			guard oldValue != usesBorderShadows else {
				return
			}

			if usesBorderShadows {
				firstOuterDropShadowLayer = CALayer()
				secondOuterDropShadowLayer = CALayer()
				innerShadowLayer = CALayer()

				// Ensure that the Shadow sublayers can in fact extend beyond the bounds of the Button View's
				// layer so that the shadows don't get clipped
				self.layer?.masksToBounds = false

				if let firstOuterDropShadowLayer = firstOuterDropShadowLayer {
					firstOuterDropShadowLayer.shadowOffset = CGSize(width: 0.0, height: 1)
					firstOuterDropShadowLayer.shadowRadius = 0.75
					firstOuterDropShadowLayer.shadowOpacity = 1
					firstOuterDropShadowLayer.needsDisplayOnBoundsChange = true
					self.layer?.addSublayer(firstOuterDropShadowLayer)
				}

				if let secondOuterDropShadowLayer = secondOuterDropShadowLayer {
					secondOuterDropShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
					secondOuterDropShadowLayer.shadowRadius = 0.5
					secondOuterDropShadowLayer.shadowOpacity = 1
					secondOuterDropShadowLayer.needsDisplayOnBoundsChange = true
					self.layer?.addSublayer(secondOuterDropShadowLayer)
				}

				if let innerShadowLayer = innerShadowLayer {
					innerShadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
					innerShadowLayer.shadowRadius = 0.5
					innerShadowLayer.shadowOpacity = 1
					innerShadowLayer.needsDisplayOnBoundsChange = true
					self.layer?.addSublayer(innerShadowLayer)
				}
			} else {
				firstOuterDropShadowLayer?.removeFromSuperlayer()
				secondOuterDropShadowLayer?.removeFromSuperlayer()
				innerShadowLayer?.removeFromSuperlayer()
				firstOuterDropShadowLayer = nil
				secondOuterDropShadowLayer = nil
				innerShadowLayer = nil
			}
			needsDisplay = true
		}
	}

	private var cornerRadius: CGFloat = ButtonSizeParameters.large.cornerRadius

	private static let borderWidth: CGFloat = 1

	private var minButtonHeight: CGFloat = ButtonSizeParameters.large.minButtonHeight

	private func setSizeParameters(forSize: ButtonSize) {
		let parameters = ButtonSizeParameters.parameters(forSize: size)
		font = NSFont.systemFont(ofSize: parameters.fontSize)
		cornerRadius = parameters.cornerRadius
		minButtonHeight = parameters.minButtonHeight
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

	open override var intrinsicContentSize: CGSize {
		let superSize = super.intrinsicContentSize
		let trailingImageAdjustment: CGFloat

		// Account for extra space needed by `trailingImage`
		if let trailingImage = trailingImage,
		   let cell = cell as? ButtonCell {
			trailingImageAdjustment = trailingImage.size.width + cell.titleToImageSpacing
		} else {
			trailingImageAdjustment = 0
		}
		return CGSize(width: superSize.width + trailingImageAdjustment,
					  height: superSize.height < minButtonHeight ? minButtonHeight : superSize.height)
	}

	/// Indicates if the Window that the button view has been added to, is inactive/backgrounded
	private var isWindowInactive: Bool = false {
		didSet {
			guard oldValue != isWindowInactive else {
				return
			}
			// Re-compute the Button's color values for the latest Window State, and re-render it
			setColorValues(forStyle: style, accentColor: accentColor)
			needsDisplay = true
		}
	}

	/// Indicates if the `Increase Contrast` Accessibility Setting is enabled
	private var increaseContrastEnabled: Bool = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast {
		didSet {
			guard oldValue != increaseContrastEnabled else {
				return
			}
			// Re-compute the Button's color values for the latest Contrast State, and re-render it
			setColorValues(forStyle: style, accentColor: accentColor)
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

		// Center the Primary Image
		var x = (rect.width - imageSize.width) / 2
		var y = (rect.height - imageSize.height) / 2

		if xOffsetSign != 0 {
			// Offset the Primary Image from the Title
			x += CGFloat(xOffsetSign) * (titleSize.width + titleToImageSpacing) / 2

			// Offset the Title from the Trailing Image
			if let controlView = controlView as? Button,
			   let trailingImage = controlView.trailingImage {
				x += CGFloat(-1 * layoutDirectionSign) * (trailingImage.size.width + titleToImageSpacing) / 2
			}
		} else if yOffsetSign != 0 {
			y += CGFloat(yOffsetSign) * (titleSize.height + titleToImageSpacing - titleToImageVerticalSpacingAdjustment) / 2
		}

		return NSRect(
			x: x.rounded(.towardZero),
			y: y.rounded(.towardZero),
			width: imageSize.width.rounded(.awayFromZero),
			height: imageSize.height.rounded(.awayFromZero)
		)
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

		// Center the Title
		var x = (rect.width - titleSize.width) / 2
		var y = (rect.height - titleSize.height) / 2 + titleVerticalPositionAdjustment

		if xOffsetSign != 0 {
			// Offset the Title from the Primary Image
			x += CGFloat(xOffsetSign) * (imageSize.width + titleToImageSpacing) / 2

			// Offset the Title from the Trailing Image
			if let controlView = controlView as? Button,
			   let trailingImage = controlView.trailingImage {
				x += CGFloat(-1 * layoutDirectionSign) * (trailingImage.size.width + titleToImageSpacing) / 2
			}
		} else if yOffsetSign != 0 {
			y += CGFloat(yOffsetSign) * (imageSize.height + titleToImageSpacing) / 2
		}

		return NSRect(
			x: x.rounded(.towardZero),
			y: y.rounded(.towardZero),
			width: titleSize.width.rounded(.awayFromZero),
			height: titleSize.height.rounded(.awayFromZero)
		)
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

		return NSRect(x: 0, y: 0, width: floor(width), height: floor(height))
	}
}

// MARK: - Button Formatting Parameters

/// Indicates the size of the button
@objc(MSFButtonSize)
public enum ButtonSize: Int, CaseIterable {

	/// Minimum Button Height - 28 pts
	case large

	/// Minimum Button Height - 24 pts
	case medium

	/// Minimum Button Height - 20 pts
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
	public static let firstOuterDropShadow = NSColor(named: "ButtonColors/firstOuterDropShadow", bundle: FluentUIResources.resourceBundle)
	public static let secondOuterDropShadow = NSColor(named: "ButtonColors/secondOuterDropShadow", bundle: FluentUIResources.resourceBundle)
	public static let innerShadow = NSColor(named: "ButtonColors/innerShadow", bundle: FluentUIResources.resourceBundle)
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
	fileprivate var minButtonHeight: CGFloat

	static let large = ButtonSizeParameters(
		fontSize: 15,  // line height: 19
		cornerRadius: 6,
		verticalPadding: 4.5,  // overall height: 28
		horizontalPadding: 36,
		titleVerticalPositionAdjustment: -0.25,
		titleToImageSpacing: 10,
		titleToImageVerticalSpacingAdjustment: 7,
		minButtonHeight: 28
	)

	static let medium = ButtonSizeParameters(
		fontSize: 13,  // line height: 17
		cornerRadius: 6,
		verticalPadding: 2.0, // overall height: 24
		horizontalPadding: 5,
		titleVerticalPositionAdjustment: 0,
		titleToImageSpacing: 3,
		titleToImageVerticalSpacingAdjustment: 7,
		minButtonHeight: 24
	)

	static let small = ButtonSizeParameters(
		fontSize: 13,  // line height: 17
		cornerRadius: 5,
		verticalPadding: 1.5,  // overall height: 20
		horizontalPadding: 14,
		titleVerticalPositionAdjustment: 0,
		titleToImageSpacing: 6,
		titleToImageVerticalSpacingAdjustment: 7,
		minButtonHeight: 20
	)

	static func parameters(forSize: ButtonSize) -> ButtonSizeParameters {
		switch forSize {
		case .large:
			return .large
		case .medium:
			return .medium
		case .small:
			return .small
		}
	}
}
