//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

private let kAppleInterfaceStyle = "AppleInterfaceStyle"

extension NSAppearance {

	/// Pseudo algorithm picked up from https://developer.apple.com/forums/thread/118974
	var isDarkMode: Bool {
		// Included for unit testing
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
			return self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
		}
		if #available(OSX 10.15, *) {
			let appearanceDescription = NSApplication.shared.effectiveAppearance.debugDescription.lowercased()
			return appearanceDescription.contains("dark")
		} else if #available(OSX 10.14, *) {
			if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
				return appleInterfaceStyle.lowercased().contains("dark")
			}
		}
		return false
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
	func resolvedColor(_ appearance: NSAppearance = NSAppearance.current) -> NSColor {
		return appearance.isDarkMode ? self.dark : self.light
	}

	public override func isEqual(_ object: Any?) -> Bool {
		guard let dynamicColor = object as? DynamicColor else {
			return false
		}
		return dynamicColor.light.isEqual(self.light) && dynamicColor.dark.isEqual(self.dark)
	}
}
