//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

// MARK: ColorProviding

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The view associated with the passed in theme will display the set colors to allow apps to provide different experiences per each view
@objc(MSFColorProviding)
public protocol ColorProviding {
	/// If this protocol is not conformed to, communicationBlue variants will be used
	@objc var primary: NSColor { get }
	@objc var primaryShade10: NSColor { get }
	@objc var primaryShade20: NSColor { get }
	@objc var primaryShade30: NSColor { get }
	@objc var primaryTint10: NSColor { get }
	@objc var primaryTint20: NSColor { get }
	@objc var primaryTint30: NSColor { get }
	@objc var primaryTint40: NSColor { get }
}
