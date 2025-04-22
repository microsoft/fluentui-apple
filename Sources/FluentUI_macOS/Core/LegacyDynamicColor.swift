//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// Note: this class will be removed once the core iOS color system has been migrated cross-platform.
@objc(MSFLegacyColorSet)
public class LegacyColorSet: NSObject {
	@objc public let background: LegacyDynamicColor
	@objc public let foreground: LegacyDynamicColor

	public init(background: LegacyDynamicColor, foreground: LegacyDynamicColor) {
		self.background = background
		self.foreground = foreground
	}
}

/// Note: this class will be removed once the core iOS color system has been migrated cross-platform.
@objc(MSFLegacyDynamicColor)
public class LegacyDynamicColor: NSObject {

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
		guard let dynamicColor = object as? LegacyDynamicColor else {
			return false
		}
		return dynamicColor.light.isEqual(self.light) && dynamicColor.dark.isEqual(self.dark)
	}
}
