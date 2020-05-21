//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Indicates what style our button is drawn as
@objc public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled	// Solid fill color
    case primaryOutline	// Clear fill color, solid outline
    case borderless		// clear fill color, clear outline
}

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@IBDesignable
@objc(MSFButton)
open class Button: NSButton {

	@objc public init(title: String, style: ButtonStyle = .primaryFilled) {
		super.init(frame: .zero)
		self.title = title
		self.style = style
        initialize()
    }
	
	public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialize()
	}

	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	open func initialize() {
		// Do common initialization work
		isBordered = false
		wantsLayer = true

		if #available(macOS 10.14, *) {
			primaryColor = .controlAccentColor
		} else {
			primaryColor = .systemBlue
		}
		update()
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
	
	override public func mouseEntered(with event: NSEvent) {
		mouseEntered = true
		needsDisplay = true
	}

	override public func mouseExited(with event: NSEvent) {
		mouseEntered = false
		needsDisplay = true
	}
	
	override public func mouseDown(with event: NSEvent) {
		mouseDown = true
		needsDisplay = true
	}
	
	override public func mouseUp(with event: NSEvent) {
		mouseDown = false
		needsDisplay = true
	}
	
	open override func updateLayer() {
		update()
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
	@objc public var primaryColor: NSColor = .clear {
		didSet {
            if primaryColor != oldValue {
                update()
            }
		}
	}

	/// The primary style of the button
	@objc public var style: ButtonStyle = .primaryFilled {
		didSet {
            if style != oldValue {
                update()
            }
		}
	}
	
	private func update() {
		if let layer = layer {
			layer.borderWidth = borderWidth
			layer.masksToBounds = true
			layer.cornerRadius = cornerRadius
			layer.backgroundColor = layerBackgroundColor.cgColor
			layer.borderColor = outlineColor.cgColor
		}
		self.attributedTitle = NSAttributedString(string: title, attributes: [.foregroundColor : textColor])
	}
	
	private var trackingArea: NSTrackingArea?
	
	private var mouseEntered = false
	private var mouseDown = false
	
	private var fillColor: NSColor {
		return style == ButtonStyle.primaryFilled ? primaryColor : .clear
	}
	
	private var outlineColor: NSColor {
		return style == ButtonStyle.primaryOutline ? primaryColor.withAlphaComponent(0.4) : .clear
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
			return fillColor.withAlphaComponent(0.5)
		}
	}

	private var pressedBackgroundColor: NSColor {
		if #available(macOS 10.14, *) {
			return fillColor.withSystemEffect(.pressed)
		} else {
			return fillColor.withAlphaComponent(0.25)
		}
	}
	
	private var disabledBackgroundColor: NSColor {
		if #available(macOS 10.14, *) {
			return fillColor.withSystemEffect(.disabled)
		} else {
			return NSColor.systemGray.withAlphaComponent(0.25)
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
			return disabledBackgroundColor
		}
	}
}

// MARK: - Constants

fileprivate let borderWidth: CGFloat = 1

fileprivate let cornerRadius: CGFloat = 3

fileprivate let verticalPadding: CGFloat = 2

fileprivate let horizontalPadding:  CGFloat = 10
