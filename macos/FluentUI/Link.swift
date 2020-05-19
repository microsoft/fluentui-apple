//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A lightweight hyperlink control
@objc(MSFLink)
open class Link : NSButton {
	
	/// Initialies a link with a content string that is displayed, and an underlying
	/// - Parameters:
	///   - content: The visible text of the link that the user sees.
	///   - url: The URL that is opened when the link is clicked
	@objc public init(content: String, url: NSURL) {
		self.content = content
		self.url = url
		super.init(frame: .zero)
		alignment = .natural
		isBordered = false
		target = self
		action = #selector(linkClicked(_:))
		
		let attributedTitleAttributes = [
			NSAttributedString.Key.foregroundColor : NSColor.linkColor,
			NSAttributedString.Key.font : NSFont.labelFont(ofSize: NSFont.labelFontSize)
		]
		let attributedTitle = NSAttributedString(string: content, attributes: attributedTitleAttributes)
		self.attributedTitle = attributedTitle
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	/// The visible text of the link that the user sees
	@objc public let content: String
	
	/// The URL that is opened when the link is clicked
	@objc public let url: NSURL

	
	@objc private func linkClicked(_ sender: NSButton) {
		NSWorkspace.shared.open(url as URL)
	}
}
