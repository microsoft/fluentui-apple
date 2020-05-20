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
	@objc public init(title: String, url: NSURL) {
		self.url = url
		super.init(frame: .zero)
		alignment = .natural
		isBordered = false
		target = self
		action = #selector(linkClicked(_:))
		
		let titleAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor : NSColor.linkColor
		]
		self.attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
	}
	
	@available(*, unavailable)
	required public init?(coder decoder: NSCoder) {
		preconditionFailure()
	}
	
	/// The URL that is opened when the link is clicked
	@objc public let url: NSURL
	
	@objc private func linkClicked(_ sender: NSButton) {
		NSWorkspace.shared.open(url as URL)
	}
}
