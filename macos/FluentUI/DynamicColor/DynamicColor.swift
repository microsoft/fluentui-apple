//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFColorSet)
public class ColorSet: NSObject {
	@objc public let background: DynamicColor
	@objc public let foreground: DynamicColor

	public init(background: DynamicColor, foreground: DynamicColor) {
		self.background = background
		self.foreground = foreground
	}
}

@objc(MSFDynamicColor)
public class DynamicColor: NSObject {

	@objc public let light: NSColor
	@objc public let dark: NSColor

	public init(light: NSColor, dark: NSColor) {
		self.light = light
		self.dark = dark
	}

	/// resolves color based on theme
	@objc func resolvedColor(_ appearance: NSAppearance? = nil) -> NSColor {
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
