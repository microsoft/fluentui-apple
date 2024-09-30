//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFColorSet)
public class ColorSet: NSObject {
	@objc public let background: DynamicColor_DEPRECATED
	@objc public let foreground: DynamicColor_DEPRECATED

	public init(background: DynamicColor_DEPRECATED, foreground: DynamicColor_DEPRECATED) {
		self.background = background
		self.foreground = foreground
	}
}

@objc(MSFDynamicColor_DEPRECATED)
public class DynamicColor_DEPRECATED: NSObject {

	@objc public let light: NSColor
	@objc public let dark: NSColor

	@objc public init(light: NSColor, dark: NSColor) {
		self.light = light
		self.dark = dark
	}

	/// resolves color based on theme
	@objc public func resolvedColor(_ appearance: NSAppearance? = nil) -> NSColor {
		guard let appearance = appearance else {
			return self.light
		}
		return appearance.isDarkMode ? self.dark : self.light
	}

	public override func isEqual(_ object: Any?) -> Bool {
		guard let dynamicColor = object as? DynamicColor_DEPRECATED else {
			return false
		}
		return dynamicColor.light.isEqual(self.light) && dynamicColor.dark.isEqual(self.dark)
	}
}
