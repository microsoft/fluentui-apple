//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Indicates what style our button is drawn as
@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
	case primaryFilled	// Solid fill color
	case primaryOutline	// Clear fill color, solid outline
	case borderless		// Clear fill color, clear outline
}

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@objc(MSFButton)
open class Button: NSButton {
	/// Initializes a Fluent UI Button with a title, automatically colored to suit the style
	/// - Parameters:
	///   - title: String displayed in the button
	///   - style: The ButtonStyle, defaulting to primaryFilled
	@objc public init(title: String, style: ButtonStyle = .primaryFilled) {
		super.init(frame: .zero)
		initialize(title: title, image: nil, style: style)
	}

	/// Initializes a Fluent UI Button with an image, setting the imagePosition to imageOnly
	/// - Parameters:
	///   - image: The NSImage to diplay in the button
	///   - style: The ButtonStyle, defaulting to primaryFilled
	@objc public init(image: NSImage, style: ButtonStyle = .primaryFilled) {
		super.init(frame: .zero)
		imagePosition = .imageOnly
		initialize(title: nil, image: image, style: style)
	}
	
	
	/// Initializes a Fluent UI Button with a title,  image,  imagePosition, and style
	/// - Parameters:
	///   - title: String displayed in the button
	///   - image: The NSImage to display in the button
	///   - imagePosition: The position of the image, relative to the title
	///   - style: The ButtonStyle, defaulting to primaryFilled
	@objc public init(title: String, image: NSImage, imagePosition: NSControl.ImagePosition, style: ButtonStyle = .primaryFilled) {
		super.init(frame: .zero)
		self.imagePosition = imagePosition
		initialize(title: title, image: image, style: style)
	}

	/// Initializes a Fluent UI Button
	/// Set style to primaryFilled as default
	@objc public init() {
		super.init(frame: .zero)
		initialize(title: nil, image: nil, style: .primaryFilled)
	}

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	private func initialize(title: String?, image: NSImage?, style: ButtonStyle = .primaryFilled) {
		// Do common initialization work
		isBordered = false
		wantsLayer = true
		layer?.contentsScale = window?.backingScaleFactor ?? 1.0

		self.style = style

		if let title = title {
			self.title = title
		}

		if let image = image {
			self.image = image
		}
		
		if style == .primaryFilled {
			contentTintColor = .white
		} else {
			contentTintColor = primaryColor
		}
	}

	open class override var cellClass: AnyClass? {
		get {
			return FluentButtonCell.self
		}
		set {}
	}
	
	/// Image display in the button
	override public var image: NSImage? {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the image is rendered on the layer")
			}
		}
	}
	
	/// String display in the button
	override public var title: String {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the title is rendered on the layer")
			}
		}
	}
	
	override public func updateTrackingAreas() {
		super.updateTrackingAreas()
		
		// Remove existing trackingArea
		if let trackingArea = trackingArea {
			removeTrackingArea(trackingArea)
			self.trackingArea = nil
		}

		// Create a new trackingArea
		let opts: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
		let trackingArea = NSTrackingArea(
			rect: bounds,
			options: opts,
			owner: self,
			userInfo: nil
		)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}

	open override func mouseEntered(with event: NSEvent) {
		mouseEntered = true
		needsDisplay = true
	}

	open override func mouseExited(with event: NSEvent) {
		mouseEntered = false
		needsDisplay = true
	}

	open override func mouseDown(with event: NSEvent) {
		mouseDown = true
		needsDisplay = true
	}

	open override func mouseUp(with event: NSEvent) {
		mouseDown = false
		needsDisplay = true
	}

	open override func updateLayer() {
		if let layer = layer {
			layer.borderWidth = Button.borderWidth
			layer.cornerRadius = Button.cornerRadius
			layer.backgroundColor = layerBackgroundColor.cgColor
			layer.borderColor = outlineColor.cgColor
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
	
	/// Tint color of the button content.
	open override var contentTintColor: NSColor? {
		get {
			if style == .primaryFilled {
				return .white
			} else {
				return primaryColor
			}
		}
		set {
			super.contentTintColor = newValue
			needsDisplay = true
		}
	}

	/// The primary color of the button, AKA, the fill color in the primaryFilled style, and the outline in the primaryOutline style
	@objc public var primaryColor: NSColor = defaultPrimaryColor {
		didSet {
			if primaryColor != oldValue {
				needsDisplay = true
			}
		}
	}

	/// The primary style of the button
	@objc public var style: ButtonStyle = .primaryFilled {
		didSet {
			if style != oldValue {
				if style == .primaryFilled {
					contentTintColor = .white
				} else {
					contentTintColor = primaryColor
				}
				needsDisplay = true
			}
		}
	}

	/// Background color in rest state. Hover and pressed state colors will adjust accordingly using the systemEffect.
	@objc public var restBackgroundColor: NSColor? = nil
	
	private func disabledColor(for color: NSColor) -> NSColor {
		return color.withSystemEffect(.disabled)
	}

	private var trackingArea: NSTrackingArea?

	private var mouseEntered = false
	private var mouseDown = false

	private var fillColor: NSColor {
		return style == ButtonStyle.primaryFilled ? primaryColor : .clear
	}

	private var outlineColor: NSColor {
		let baseOutlineColor = style == ButtonStyle.primaryOutline ? primaryColor.withAlphaComponent(Button.outlineColorAlphaComponent) : .clear
		if isEnabled {
			return baseOutlineColor
		} else {
			return disabledColor(for: baseOutlineColor)
		}
	}
	
	private var hoverBackgroundColor: NSColor {
		return restBackgroundColor?.withSystemEffect(.rollover) ?? fillColor.withSystemEffect(.rollover)
	}

	private var pressedBackgroundColor: NSColor {
		return restBackgroundColor?.withSystemEffect(.pressed) ?? fillColor.withSystemEffect(.pressed)
	}

	private var layerBackgroundColor: NSColor {
		if isEnabled {
			if mouseDown {
				return pressedBackgroundColor
			} else if mouseEntered {
				return hoverBackgroundColor
			} else {
				return restBackgroundColor == nil ? fillColor : restBackgroundColor!
			}
		} else {
			return disabledColor(for: restBackgroundColor ?? fillColor)
		}
	}

	private static var defaultPrimaryColor: NSColor {
		return .controlAccentColor
	}
	
	
	class FluentButtonCell : NSButtonCell {
		override func imageRect(forBounds rect: NSRect) -> NSRect {
			let isRTL = NSApp.userInterfaceLayoutDirection == .rightToLeft
			let imageRect = super.imageRect(forBounds: rect)
			let titleSize = title.size(withAttributes: [.font: font as Any])
			let imageSize = image?.size ?? NSZeroSize
			
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
				break
			case .imageOnly:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = rect.width - (Button.horizontalEdgePadding * 2)
				height = rect.height - (Button.verticalEdgePadding * 2)
			case .imageLeft:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = imageSize.width
				height = imageSize.height
				break
			case .imageRight:
				x = titleSize.width + Button.titleAndImageRectInterspacing + Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = imageSize.width
				height = imageSize.height
				break
			case .imageBelow:
				x = (rect.width - imageSize.width) / 2
				y = Button.verticalEdgePadding + titleSize.height + Button.titleAndImageRectInterspacing
				width = imageSize.width
				height = imageSize.height
				break
			case .imageAbove:
				x = (rect.width - imageSize.width) / 2
				y = Button.verticalEdgePadding
				width = imageSize.width
				height = imageSize.height
				break
			case .imageOverlaps:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = rect.width - (Button.horizontalEdgePadding * 2)
				height = rect.height - (Button.verticalEdgePadding * 2)
				break;
			case .imageLeading:
				x = isRTL ? titleSize.width + Button.titleAndImageRectInterspacing + Button.horizontalEdgePadding : Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = imageSize.width
				height = imageSize.height
				break
			case .imageTrailing:
				x = isRTL ? Button.horizontalEdgePadding : titleSize.width + Button.titleAndImageRectInterspacing + Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = imageSize.width
				height = imageSize.height
				break
			@unknown default:
				break
			}

			return NSMakeRect(x, y, width, height)
		}

		override func titleRect(forBounds rect: NSRect) -> NSRect {
			let isRTL = NSApp.userInterfaceLayoutDirection == .rightToLeft
			let titleRect = super.titleRect(forBounds: rect);
			let titleSize = title.size(withAttributes: [.font: font as Any])
			
			var x = titleRect.origin.x
			var y = titleRect.origin.y
			var width = titleRect.size.width
			var height = titleRect.size.height
			
			let imageSize = image?.size ?? NSZeroSize
						
			switch imagePosition {
			case .noImage:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = rect.width - (Button.horizontalEdgePadding * 2)
				height = rect.height - (Button.verticalEdgePadding * 2)
				break
			case .imageOnly:
				x = 0
				y = 0
				width = 0
				height = 0
				break
			case .imageLeft:
				x = Button.horizontalEdgePadding + imageSize.width + Button.titleAndImageRectInterspacing
				y = Button.verticalEdgePadding
				width = titleSize.width
				height = titleSize.height
				break
			case .imageRight:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = titleSize.width
				height = titleSize.height
				break
			case .imageBelow:
				x = (rect.width - titleSize.width) / 2
				y = Button.verticalEdgePadding
				width =	titleSize.width
				height = titleSize.height
				break
			case .imageAbove:
				x = (rect.width - titleSize.width) / 2
				y = Button.verticalEdgePadding + imageSize.height + Button.titleAndImageRectInterspacing
				width =	titleSize.width
				height = titleSize.height
				break
			case .imageOverlaps:
				x = Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = rect.width - (Button.horizontalEdgePadding * 2)
				height = rect.height - (Button.verticalEdgePadding * 2)
				break;
			case .imageLeading:
				x = isRTL ? Button.horizontalEdgePadding : Button.horizontalEdgePadding + imageSize.width + Button.titleAndImageRectInterspacing
				y = Button.verticalEdgePadding
				width = titleSize.width
				height = titleSize.height
				break
			case .imageTrailing:
				x = isRTL ? Button.horizontalEdgePadding + imageSize.width + Button.titleAndImageRectInterspacing : Button.horizontalEdgePadding
				y = Button.verticalEdgePadding
				width = titleSize.width
				height = titleSize.height
				break
			@unknown default:
				break
			}

			return NSMakeRect(x, y, width, height)
		}

		override func drawingRect(forBounds rect: NSRect) -> NSRect {
			
			var horizontalInterCellSpacing: CGFloat = 0
			var verticalInterCellSpacing: CGFloat = 0
			switch imagePosition {
			
			case .noImage:
				break
			case .imageOnly:
				break
			case .imageLeft:
				horizontalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			case .imageRight:
				horizontalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			case .imageBelow:
				verticalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			case .imageAbove:
				verticalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			case .imageOverlaps:
				break
			case .imageLeading:
				horizontalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			case .imageTrailing:
				horizontalInterCellSpacing = Button.titleAndImageRectInterspacing
				break
			@unknown default:
				break
			}

			let drawingRectWithPadding = NSMakeRect(
				0,
				0,
				rect.width - (Button.horizontalEdgePadding * 2) - horizontalInterCellSpacing,
				rect.height - (Button.verticalEdgePadding * 2) - verticalInterCellSpacing
			)
			return drawingRectWithPadding
		}
	}

	private static let titleAndImageRectInterspacing: CGFloat = 8


	private static let borderWidth: CGFloat = 1
	
	private static let cornerRadius: CGFloat = 3

	private static let verticalEdgePadding: CGFloat = 4

	private static let horizontalEdgePadding:  CGFloat = 12

	private static let outlineColorAlphaComponent:  CGFloat = 0.4
}
