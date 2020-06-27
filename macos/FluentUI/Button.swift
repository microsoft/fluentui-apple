//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Indicates what style our button is drawn as
@objc public enum ButtonStyle: Int, CaseIterable {
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

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	private func initialize(title: String?, image: NSImage?, style: ButtonStyle = .primaryFilled) {
		// Do common initialization work
		isBordered = false
		wantsLayer = true
		
		self.style = style
		
		if let title = title {
			self.title = title
		}
		
		if let image = image {
			self.image = image
		}
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
			layer.borderWidth = borderWidth
			layer.cornerRadius = cornerRadius
			layer.backgroundColor = layerBackgroundColor.cgColor
			layer.borderColor = outlineColor.cgColor
		}
	}
	
	open override var intrinsicContentSize: NSSize {
		var intrinsicContentSize = super.intrinsicContentSize;

		intrinsicContentSize.width = intrinsicContentSize.width + (horizontalPadding * 2)
		intrinsicContentSize.height += (verticalPadding * 2);

		return intrinsicContentSize;
	}
	
	override public var wantsUpdateLayer: Bool {
		return true
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
			return color.withAlphaComponent(disabledColorFallbackAlphaComponent)
		}
	}
	
	private var trackingArea: NSTrackingArea?
	
	private var mouseEntered = false
	private var mouseDown = false
	
	private var fillColor: NSColor {
		return style == ButtonStyle.primaryFilled ? primaryColor : .clear
	}
	
	private var outlineColor: NSColor {
		let baseOutlineColor = style == ButtonStyle.primaryOutline ? primaryColor.withAlphaComponent(outlineColorAlphaComponent) : .clear
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
			return fillColor.withAlphaComponent(hoverBackgroundColorFallbackAlphaComponent)
		}
	}

	private var pressedBackgroundColor: NSColor {
		if #available(macOS 10.14, *) {
			return fillColor.withSystemEffect(.pressed)
		} else {
			return fillColor.withAlphaComponent(pressedBackgroundColorFallbackAlphaComponent)
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
}

// MARK: - Constants

fileprivate let borderWidth: CGFloat = 1

fileprivate let cornerRadius: CGFloat = 3

fileprivate let verticalPadding: CGFloat = 4

fileprivate let horizontalPadding:  CGFloat = 12

fileprivate let outlineColorAlphaComponent:  CGFloat = 0.4

fileprivate let disabledColorFallbackAlphaComponent:  CGFloat = 0.25

fileprivate let hoverBackgroundColorFallbackAlphaComponent:  CGFloat = 0.5

fileprivate let pressedBackgroundColorFallbackAlphaComponent:  CGFloat = 0.25



