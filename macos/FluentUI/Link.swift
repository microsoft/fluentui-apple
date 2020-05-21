//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A lightweight hyperlink control
@objc(MSFLink)
open class Link : NSButton {
	
	/// Initializes a hyperlink with a content string that is displayed, and an underlying URL that opens when clicked
	/// - Parameters:
	///   - title: The visible text of the link that the user sees.
	///   - url: The URL that is opened when the link is clicked
	@objc public init(title: String, url: NSURL) {
		self.url = url
		super.init(frame: .zero)
		self.title = title
		alignment = .natural
		isBordered = false
		target = self
		action = #selector(linkClicked)
		
		updateTitle()
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	/// The URL that is opened when the link is clicked
	@objc public var url: NSURL
	
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
		updateTitle()
	}

	open override func mouseExited(with event: NSEvent) {
		mouseEntered = false
		updateTitle()
	}

	private var mouseEntered = false
	
	private func updateTitle() {
		let titleAttributes = (showsUnderlineWhileMouseInside && mouseEntered) ? underlinedlinkAttributes : linkAttributes
		self.attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
	}
	
	@objc private func linkClicked() {
		NSWorkspace.shared.open(url as URL)
	}
}

fileprivate let linkAttributes: [NSAttributedString.Key : Any] = [
	.foregroundColor : NSColor.linkColor
]

fileprivate let underlinedlinkAttributes: [NSAttributedString.Key : Any] = [
	.foregroundColor : NSColor.linkColor,
	.underlineStyle : NSUnderlineStyle.single.rawValue
]
