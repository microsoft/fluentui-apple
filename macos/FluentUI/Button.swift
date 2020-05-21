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
		
		// Remove existing one
		if let trackingArea = trackingArea {
			removeTrackingArea(trackingArea)
			self.trackingArea = nil
		}
		
		// Create a new one
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
	
	override public var wantsUpdateLayer: Bool {
		return true
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
		layer?.borderWidth = borderWidth
		layer?.masksToBounds = true
		layer?.cornerRadius = cornerRadius

		var fillColor : NSColor = .clear
		var outlineColor : NSColor = .clear
		var textColor : NSColor = .white

		switch style {
		case .primaryFilled:
			fillColor = primaryColor
			break
		case .primaryOutline:
			outlineColor = primaryColor.withAlphaComponent(0.4)
			textColor = primaryColor
			break
		case .borderless:
			textColor = primaryColor
			break
		}
		
		if (isEnabled) {
			if (mouseDown) {
				if #available(macOS 10.14, *) {
					layer?.backgroundColor = fillColor.withSystemEffect(.pressed).cgColor
				} else {
					layer?.backgroundColor = fillColor.withAlphaComponent(0.25).cgColor
				}
				
			} else if (mouseEntered) {
				if #available(macOS 10.14, *) {
					layer?.backgroundColor = fillColor.withSystemEffect(.rollover).cgColor
				} else {
					layer?.backgroundColor = fillColor.withAlphaComponent(0.5).cgColor
				}
			} else {
				if #available(macOS 10.14, *) {
					layer?.backgroundColor = fillColor.withSystemEffect(.none).cgColor
				} else {
					layer?.backgroundColor = fillColor.cgColor
				}
			}
		} else {
			if #available(macOS 10.14, *) {
				layer?.backgroundColor = fillColor.withSystemEffect(.disabled).cgColor
			} else {
				layer?.backgroundColor = NSColor.systemGray.withAlphaComponent(0.25).cgColor
			}
		}
		
		layer?.borderColor = outlineColor.cgColor
		
		let titleAttributes: [NSAttributedString.Key : Any] = [
			.foregroundColor : textColor,
		]
		self.attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
	}
	
	private var trackingArea: NSTrackingArea?
	
	private var mouseEntered = false
	private var mouseDown = false
}

// MARK: - Constants

fileprivate let borderWidth: CGFloat = 1

fileprivate let cornerRadius: CGFloat = 3

fileprivate let verticalPadding: CGFloat = 2

fileprivate let horizontalPadding:  CGFloat = 10
