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

	// MARK: ColorProviding
	var brandBackground1: NSColor = (NSColor(named: "Colors/DemoBrandBackground1Color"))!
	var brandBackground1Hover: NSColor = (NSColor(named: "Colors/DemoBrandBackground1HoverColor"))!
	var brandBackground1Pressed: NSColor = (NSColor(named: "Colors/DemoBrandBackground1PressedColor"))!
	var brandBackground1Selected: NSColor = (NSColor(named: "Colors/DemoBrandBackground1SelectedColor"))!
	var brandBackground2: NSColor = (NSColor(named: "Colors/DemoBrandBackground2Color"))!
	var brandBackground2Hover: NSColor = (NSColor(named: "Colors/DemoBrandBackground2HoverColor"))!
	var brandBackground2Pressed: NSColor = (NSColor(named: "Colors/DemoBrandBackground2PressedColor"))!

	var brandForeground1: NSColor = (NSColor(named: "Colors/DemoBrandForeground1Color"))!

	var primary: NSColor = (NSColor(named: "Colors/DemoPrimaryColor"))!
	var primaryShade10: NSColor = (NSColor(named: "Colors/DemoPrimaryShade10Color"))!
	var primaryShade20: NSColor = (NSColor(named: "Colors/DemoPrimaryShade20Color"))!
	var primaryShade30: NSColor = (NSColor(named: "Colors/DemoPrimaryShade30Color"))!
	var primaryTint10: NSColor = (NSColor(named: "Colors/DemoPrimaryTint10Color"))!
	var primaryTint20: NSColor = (NSColor(named: "Colors/DemoPrimaryTint20Color"))!
	var primaryTint30: NSColor = (NSColor(named: "Colors/DemoPrimaryTint30Color"))!
	var primaryTint40: NSColor = (NSColor(named: "Colors/DemoPrimaryTint40Color"))!
}
