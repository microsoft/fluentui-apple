//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
	
	static let borderWidth: CGFloat = 1
	
	static let cornerRadius: CGFloat = 3
	
	static let minimumWidth: CGFloat = 120
	
	static let verticalPadding: CGFloat = 2
	
	static let horizontalPadding:  CGFloat = 2
	
	private init() {}
}

@objc public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case borderless
}

// MARK: - Button

/// A fluent styled button, with hover effects and a corner radius.
@IBDesignable
@objc(MSFButton)
open class Button: NSButton {
	/// The primary color of the button, AKA, the fill color in the primaryFilled style, and the outline in the primaryOutline style
	@objc open var primaryColor: NSColor = NSColor.clear
	
	private var trackingArea: NSTrackingArea?
	
	private var mouseEntered: Bool = false
	private var mouseClicked: Bool = false
	
	override open var wantsUpdateLayer: Bool {
		return true
	}

	private let style: ButtonStyle
	
	@objc public init(title: String, style: ButtonStyle = .primaryFilled) {
		self.style = style
        super.init(frame: .zero)
		self.title = title
        initialize()
    }
	
    public override init(frame: CGRect) {
		preconditionFailure()
    }

    public required init?(coder aDecoder: NSCoder) {
		preconditionFailure()
    }
	
	open func initialize() {
		// Do common initialization work
		isBordered = false
		wantsLayer = true

		if #available(macOS 10.14, *) {
			primaryColor = NSColor.controlAccentColor
		} else {
			primaryColor = NSColor.systemBlue
		}
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
		mouseClicked = true
		needsDisplay = true
	}
	
	override public func mouseUp(with event: NSEvent) {
		mouseClicked = false
		needsDisplay = true
	}
	
	open override func updateLayer() {
		layer?.borderWidth = Constants.borderWidth
		layer?.masksToBounds = true
		layer?.cornerRadius = Constants.cornerRadius
				
		var fillColor : NSColor = NSColor.clear
		var outlineColor : NSColor = NSColor.clear
		var textColor : NSColor = NSColor.white
		
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
			if (mouseClicked) {
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
	
	open override var intrinsicContentSize: NSSize {
		var intrinsicContentSize = super.intrinsicContentSize;

		if (intrinsicContentSize.width > Constants.minimumWidth) {
			intrinsicContentSize.width += (Constants.horizontalPadding * 2);
		} else {
			intrinsicContentSize.width = Constants.minimumWidth;
		}

		intrinsicContentSize.height += (Constants.verticalPadding * 2);

		return intrinsicContentSize;
	}
}
