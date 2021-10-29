//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A lightweight hyperlink control
@objc(MSFLink)
open class Link: NSButton {

	/// The text displayed on the control, stylized to look like a hyperlink
	open override var title: String {
		didSet {
			guard oldValue != title else {
				return
			}
			updateTitle()
		}
	}

	open override func mouseEntered(with event: NSEvent) {
		mouseInside = true
		updateTitle()
	}

	open override func mouseExited(with event: NSEvent) {
		mouseInside = false
		updateTitle()
	}

	open override var isEnabled: Bool {
		get {
			return super.isEnabled
		}
		set {
			super.isEnabled = newValue
			self.window?.invalidateCursorRects(for: self)
			updateTitle()
		}
	}

	open override func resetCursorRects() {
		if isEnabled {
			addCursorRect(bounds, cursor: .pointingHand)
		}
	}

	open override func drawFocusRingMask() {
		// Ensure we draw the focus ring around the entire link bounds
		// rather than just around the image if the link contains one.
		let path = NSBezierPath(roundedRect: bounds, xRadius: cornerRadius, yRadius: cornerRadius)
		path.fill()
	}

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
	public init(frame: NSRect = .zero, title: String = "", url: NSURL? = nil) {
		super.init(frame: frame)
		self.title = title
		self.url = url

		alignment = .natural
		isBordered = false
		contentTintColor = .linkColor
		setButtonType(.momentaryChange)
		target = self
		action = #selector(linkClicked)
		setAccessibilityRole(.link)
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

	public override func updateTrackingAreas() {
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

	private var trackingArea: NSTrackingArea?

	private var mouseInside: Bool = false

	private let cornerRadius: CGFloat = 2

	private func updateTitle() {
		let titleAttributes = (isEnabled && showsUnderlineWhileMouseInside && mouseInside) ? underlinedLinkAttributes: linkAttributes
		attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
		setAccessibilityTitle(title)
	}

	@objc private func linkClicked() {
		if let url = url {
			NSWorkspace.shared.open(url as URL)
		}
	}
}

private let linkAttributes: [NSAttributedString.Key: Any] = [:]

private let underlinedLinkAttributes: [NSAttributedString.Key: Any] = [
	.underlineStyle: NSUnderlineStyle.single.rawValue
]
