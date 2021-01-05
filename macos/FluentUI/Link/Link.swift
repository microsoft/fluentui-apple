//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A lightweight hyperlink control
@objc(MSFLink)
open class Link: NSButton {
	
	/// Initializes a hyperlink with a title and an underlying URL that opens when clicked
	/// - Parameters:
	///   - title: The visible text of the link that the user sees.
	///   - url: The URL that is opened when the link is clicked.
	@objc public convenience init(title: String, url: NSURL) {
		self.init(frame: .zero, title: title, url: url)
	}
	
	/// Initializes a hyperlink with a title and no URL, useful if you plan to override the Target/Action
	/// - Parameters:
	///   - title: The visible text of the link that the user sees.
	@objc public convenience init(title: String) {
		self.init(frame: .zero, title: title, url: nil)
	}
	
	@objc public override convenience init(frame frameRect: NSRect) {
		self.init(frame: frameRect, title: "", url: nil)
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	/// Designated initializer.
	/// - Parameters:
	///   - frame: The position and size of this view in the superview's coordinate system.
	///   - title: The visible text of the link that the user sees.
	///   - url: The URL that is opened when the link is clicked.
	public init(frame: NSRect = .zero, title: String = "", url: NSURL? = nil)
	{
		super.init(frame: frame)
		self.title = title
		self.url = url

		alignment = .natural
		isBordered = false
		contentTintColor = .linkColor
		target = self
		action = #selector(linkClicked)
		updateTitle()
	}
	
	/// The URL that is opened when the link is clicked
	@objc public var url: NSURL?
	
	@objc public var showsUnderlineWhileMouseInside: Bool = false {
		didSet {
			guard oldValue != showsUnderlineWhileMouseInside else {
				return
			}
			updateTitle()
		}
	}
	
	/// The text displayed on the control, stylized to look like a hyperlink
	open override var title: String {
		didSet {
			guard oldValue != title else {
				return
			}
			updateTitle()
		}
	}
	
	private var trackingArea: NSTrackingArea?
	
	override public func updateTrackingAreas() {
		super.updateTrackingAreas()

		// Remove existing trackingArea
		if let trackingArea = trackingArea {
			removeTrackingArea(trackingArea)
			self.trackingArea = nil
		}

		// Create a new trackingArea
		let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
		let trackingArea = NSTrackingArea(
			rect: bounds,
			options: options,
			owner: self,
			userInfo: nil
		)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}
	
	open override func mouseDown(with event: NSEvent) {
		super.mouseDown(with: event)
		updateTitle()
	}

	open override func mouseEntered(with event: NSEvent) {
		mouseInside = true
		updateTitle()
	}

	open override func mouseExited(with event: NSEvent) {
		mouseInside = false
		updateTitle()
	}

	private var mouseInside = false
	
	open override func resetCursorRects() {
		addCursorRect(bounds, cursor: .pointingHand)
	}
	
	private func updateTitle() {
		let titleAttributes = (showsUnderlineWhileMouseInside && mouseInside) ? underlinedLinkAttributes: linkAttributes
		self.attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
	}
	
	@objc private func linkClicked() {
		if let url = url {
			NSWorkspace.shared.open(url as URL)
		}
	}
}

fileprivate let linkAttributes: [NSAttributedString.Key: Any] = [
	.underlineStyle: NSUnderlineStyle()
]

fileprivate let underlinedLinkAttributes: [NSAttributedString.Key: Any] = [
	.underlineStyle: NSUnderlineStyle.single.rawValue
]
