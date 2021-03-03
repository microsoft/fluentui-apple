//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AppKit

private let kAppleInterfaceStyle = "AppleInterfaceStyle"

public extension NSAppearance {

	/// Pseudo algorithm picked up from https://developer.apple.com/forums/thread/118974
	var isDarkMode: Bool {
		if #available(OSX 10.15, *) {
			let appearanceDescription = NSApplication.shared.effectiveAppearance.debugDescription.lowercased()
			if appearanceDescription.contains("dark") {
				return true
			}
		} else if #available(OSX 10.14, *) {
			if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
				if appleInterfaceStyle.lowercased().contains("dark") {
					return true
				}
			}
		}
		return false
	}
}

@objc(MSFDynamicColor)
public class DynamicColor: NSObject {

	private let background: NSColor
	private let foreground: NSColor

	public init(background: NSColor, foreground: NSColor) {
		self.background = background
		self.foreground = foreground
	}

	/// resolves color based on theme
	func resolvedForegroundColor(_ appearance: NSAppearance = NSAppearance.current) -> NSColor {
		if appearance.isDarkMode {
			return self.background
		}
		return self.foreground
	}

	/// resolves color based on theme
	func resolvedBackgroundColor(_ appearance: NSAppearance = NSAppearance.current) -> NSColor {
		if appearance.isDarkMode {
			return self.foreground
		}
		return self.background
	}

	public override func isEqual(_ object: Any?) -> Bool {
		let color = object as? DynamicColor
		guard let dynamicColor = color else {
			return false
		}
		return dynamicColor.background.isEqual(self.background) && dynamicColor.foreground.isEqual(self.foreground)
	}
}
