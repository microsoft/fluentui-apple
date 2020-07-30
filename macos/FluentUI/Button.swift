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
	///   - image: The NSImage to diplay in the button
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
	}
	
	open class override var cellClass: AnyClass? {
		get {
			return FluentButtonCell.self
		}
		set {}
	}
	
	override public var image: NSImage? {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the image is rendered on the layer")
			}
		}
	}
	
	override public var title: String {
		willSet {
			guard wantsLayer == true else {
				preconditionFailure("wantsLayer must be set so that the title is rendered on the layer")
			}
		}
		didSet {
			self.attributedTitle = NSAttributedString(string: title, attributes: [.foregroundColor : textColor])
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
				needsDisplay = true
			}
		}
	}
	
	private func disabledColor(for color: NSColor) -> NSColor {
		if #available(macOS 10.14, *) {
			return color.withSystemEffect(.disabled)
		} else {
			return color.withAlphaComponent(Button.disabledColorFallbackAlphaComponent)
		}
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
	
	private var textColor: NSColor {
		return style == ButtonStyle.primaryFilled ? .white : primaryColor
	}
	
	private var restBackgroundColor: NSColor {
		return fillColor
	}

	private var hoverBackgroundColor: NSColor {
		if #available(macOS 10.14, *) {
			return fillColor.withSystemEffect(.rollover)
		} else {
			return fillColor.withAlphaComponent(Button.hoverBackgroundColorFallbackAlphaComponent)
		}
	}

	private var pressedBackgroundColor: NSColor {
		if #available(macOS 10.14, *) {
			return fillColor.withSystemEffect(.pressed)
		} else {
			return fillColor.withAlphaComponent(Button.pressedBackgroundColorFallbackAlphaComponent)
		}
	}
	
	private var layerBackgroundColor: NSColor {
		if isEnabled {
			if mouseDown {
				return pressedBackgroundColor
			} else if mouseEntered {
				return hoverBackgroundColor
			} else {
				return restBackgroundColor
			}
		} else {
			return disabledColor(for: fillColor)
		}
	}
	
	private static var defaultPrimaryColor: NSColor {
		if #available(macOS 10.14, *) {
			return .controlAccentColor
		} else {
			return .systemBlue
		}
	}
	
	
	class FluentButtonCell : NSButtonCell {
		override func imageRect(forBounds rect: NSRect) -> NSRect {
			let isRTL = NSApp.userInterfaceLayoutDirection == .rightToLeft
			let imageRect = super.imageRect(forBounds: rect)
			let titleSize = title.size(withAttributes: [.font: font as Any])
			
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
			case .imageLeading:
				x = isRTL ? titleSize.width + Button.titleAndImageRectInterspacing : 0
				y = Button.verticalEdgePadding
				width = rect.width - Button.titleAndImageRectInterspacing - titleSize.width
				height = rect.height - (Button.verticalEdgePadding * 2)
				break
			case .imageTrailing:
				x = isRTL ? 0 : titleSize.width + Button.titleAndImageRectInterspacing
				y = Button.verticalEdgePadding
				width = rect.width - Button.titleAndImageRectInterspacing - titleSize.width
				height = rect.height - (Button.verticalEdgePadding * 2)
				break
			default:
				// We explicitly do not support the other variants of imagePosition
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
				x = 0
				y = 0
				width = titleRect.width + (Button.horizontalEdgePadding * 2)
				height = titleRect.height + (Button.verticalEdgePadding * 2)
				break
			case .imageOnly:
				x = 0
				y = 0
				width = 0
				height = 0
				break
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
			default:
				// We explicitly do not support the other variants of imagePosition
				break
			}
			
			return NSMakeRect(x, y, width, height)
		}
		
		override func drawingRect(forBounds rect: NSRect) -> NSRect {
			let drawingRectWithPadding = NSMakeRect(
				0,
				0,
				rect.width - (Button.horizontalEdgePadding * 2),
				rect.height - (Button.verticalEdgePadding * 2)
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

	private static let disabledColorFallbackAlphaComponent:  CGFloat = 0.25

	private static let hoverBackgroundColorFallbackAlphaComponent:  CGFloat = 0.5

	private static let pressedBackgroundColorFallbackAlphaComponent:  CGFloat = 0.25
}
