//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AppKit

enum InterfaceStyle: String {
   case dark, light

	init() {
		var type: InterfaceStyle = .light
		let isDarkMode = NSApplication.shared.effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua
		if isDarkMode {
			type = .dark
		}
		self = type
	}
}

public extension NSColor {
	static func getColor(light: NSColor, dark: NSColor) -> NSColor {
		let currentStyle = InterfaceStyle()
		if currentStyle == .light {
			return light
		}
		return dark
	}
}
