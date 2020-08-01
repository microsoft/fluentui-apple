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
	///   - url: The URL that is opened when the link is clicked
	@objc public init(title: String, textStyle: TextStyle = .body, url: NSURL) {
		self.url = url
		self.textStyle = textStyle
		super.init(frame: .zero)
		self.title = title
		initialize()
	}
	
	/// Initializes a hyperlink with a title and no URL, useful if you plan to override the Target/Action
	/// - Parameters:
	///   - title: The visible text of the link that the user sees.
	@objc public init(title: String, textStyle: TextStyle = .body) {
		self.textStyle = textStyle
		super.init(frame: .zero)
		self.title = title
		initialize()
	}
	
	@objc public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.title = ""
		initialize()
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	private func initialize() {
		alignment = .natural
		isBordered = false
		target = self
		action = #selector(linkClicked)
		updateTitle()
	}
	
	@objc public var textStyle: TextStyle = .body {
		didSet {
			guard oldValue != textStyle else {
				return
			}
			updateTitle()
		}
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
	
	open override func mouseEntered(with event: NSEvent) {
		mouseEntered = true
		updateTitle()
	}

	open override func mouseExited(with event: NSEvent) {
		mouseEntered = false
		updateTitle()
	}

	private var mouseEntered = false
	
	open override func resetCursorRects() {
		addCursorRect(bounds, cursor: .pointingHand)
	}
	
	private func updateTitle() {
		
		let shouldUnderline = showsUnderlineWhileMouseInside && mouseEntered
		
		let titleAttributes = (shouldUnderline) ? underlinedlinkAttributes: linkAttributes
		self.attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
	}
	
	@objc private func linkClicked() {
		if let url = url {
			NSWorkspace.shared.open(url as URL)
		}
	}
	
	private var linkAttributes: [NSAttributedString.Key: Any] {
		return [
			.foregroundColor: NSColor.linkColor,
			.font: textStyle.font()
	  ]
	}

	private var underlinedlinkAttributes: [NSAttributedString.Key: Any] {
		return [
			.foregroundColor: NSColor.linkColor,
			.font: textStyle.font(),
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
	}
}


