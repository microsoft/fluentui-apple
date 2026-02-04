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
	var brandBackground1Pressed: NSColor = (NSColor(named: "Colors/DemoBrandBackground1PressedColor"))!
	var brandBackground1Selected: NSColor = (NSColor(named: "Colors/DemoBrandBackground1SelectedColor"))!

	var brandForeground1: NSColor = (NSColor(named: "Colors/DemoBrandForeground1Color"))!

	var primary: NSColor = (NSColor(named: "Colors/DemoPrimaryColor"))!
	var primaryShade10: NSColor = (NSColor(named: "Colors/DemoPrimaryShade10Color"))!
	var primaryShade20: NSColor = (NSColor(named: "Colors/DemoPrimaryShade20Color"))!
	var primaryShade30: NSColor = (NSColor(named: "Colors/DemoPrimaryShade30Color"))!
	var primaryTint10: NSColor = (NSColor(named: "Colors/DemoPrimaryTint10Color"))!
	var primaryTint20: NSColor = (NSColor(named: "Colors/DemoPrimaryTint20Color"))!
	var primaryTint30: NSColor = (NSColor(named: "Colors/DemoPrimaryTint30Color"))!
	var primaryTint40: NSColor = (NSColor(named: "Colors/DemoPrimaryTint40Color"))!

	// MARK: BrandColorProviding
	var brand10: NSColor = (NSColor(named: "Colors/DemoBrand10Color"))!
	var brand20: NSColor = (NSColor(named: "Colors/DemoBrand20Color"))!
	var brand30: NSColor = (NSColor(named: "Colors/DemoBrand30Color"))!
	var brand40: NSColor = (NSColor(named: "Colors/DemoBrand40Color"))!
	var brand50: NSColor = (NSColor(named: "Colors/DemoBrand50Color"))!
	var brand60: NSColor = (NSColor(named: "Colors/DemoBrand60Color"))!
	var brand70: NSColor = (NSColor(named: "Colors/DemoBrand70Color"))!
	var brand80: NSColor = (NSColor(named: "Colors/DemoBrand80Color"))!
	var brand90: NSColor = (NSColor(named: "Colors/DemoBrand90Color"))!
	var brand100: NSColor = (NSColor(named: "Colors/DemoBrand100Color"))!
	var brand110: NSColor = (NSColor(named: "Colors/DemoBrand110Color"))!
	var brand120: NSColor = (NSColor(named: "Colors/DemoBrand120Color"))!
	var brand130: NSColor = (NSColor(named: "Colors/DemoBrand130Color"))!
	var brand140: NSColor = (NSColor(named: "Colors/DemoBrand140Color"))!
	var brand150: NSColor = (NSColor(named: "Colors/DemoBrand150Color"))!
	var brand160: NSColor = (NSColor(named: "Colors/DemoBrand160Color"))!
}
