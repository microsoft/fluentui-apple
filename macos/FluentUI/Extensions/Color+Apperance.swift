//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

extension NSAppearance {
	var isDarkMode: Bool {
		return self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
	}
}

class ColorSet: NSObject {
	public let background: DynamicColor
	public let foreground: DynamicColor

	public init(background: DynamicColor, foreground: DynamicColor) {
		self.background = background
		self.foreground = foreground
	}
}

class DynamicColor: NSObject {

	private let light: NSColor
	private let dark: NSColor

	public init(light: NSColor, dark: NSColor) {
		self.light = light
		self.dark = dark
	}

	/// resolves color based on theme
	func resolvedColor(_ appearance: NSAppearance? = nil) -> NSColor {
		guard let appearance = appearance else {
			return self.light
		}
		return appearance.isDarkMode ? self.dark : self.light
	}

	public override func isEqual(_ object: Any?) -> Bool {
		guard let dynamicColor = object as? DynamicColor else {
			return false
		}
		return dynamicColor.light.isEqual(self.light) && dynamicColor.dark.isEqual(self.dark)
	}
}
