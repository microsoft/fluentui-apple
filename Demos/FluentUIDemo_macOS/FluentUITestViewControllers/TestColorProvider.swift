//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

class TestColorProvider: ColorProviding {
	// This ensures this is a singleton where only one of these exists
	static let shared = TestColorProvider()

	private init() {
	  // Make the init private so no one can make separate instances
	}

	// MARK: ColorProvider
	var primary: NSColor = (NSColor(named: "Colors/DemoPrimaryColor"))!
	var primaryShade10: NSColor = (NSColor(named: "Colors/DemoPrimaryShade10Color"))!
	var primaryShade20: NSColor = (NSColor(named: "Colors/DemoPrimaryShade20Color"))!
	var primaryShade30: NSColor = (NSColor(named: "Colors/DemoPrimaryShade30Color"))!
	var primaryTint10: NSColor = (NSColor(named: "Colors/DemoPrimaryTint10Color"))!
	var primaryTint20: NSColor = (NSColor(named: "Colors/DemoPrimaryTint20Color"))!
	var primaryTint30: NSColor = (NSColor(named: "Colors/DemoPrimaryTint30Color"))!
	var primaryTint40: NSColor = (NSColor(named: "Colors/DemoPrimaryTint40Color"))!
}
