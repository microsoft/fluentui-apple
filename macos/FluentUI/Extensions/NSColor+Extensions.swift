//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc public extension NSColor {
	private struct AssociatedKeys {
		static var light: String = "light"
		static var lightHighContrast: String = "lightHighContrast"
	}
	
	/// Returns self on iOS 13 and later. For older iOS versions returns self for Regular Contrast mode or a specific color for Increased Contrast mode if it's defined either for this color or for one of its ancestors.
	var current: NSColor {
		if #available(macOS 10.14, *) {
			return self
		}
		if !NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast {
			return self
		}
		return lightHighContrast ?? light?.current ?? self
	}
	
	private var light: NSColor? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.light) as? NSColor
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.light, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	private var lightHighContrast: NSColor? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.lightHighContrast) as? NSColor
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.lightHighContrast, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	convenience init(light: NSColor, lightHighContrast: NSColor? = nil, lightElevated: NSColor? = nil, lightElevatedHighContrast: NSColor? = nil, dark: NSColor? = nil, darkHighContrast: NSColor? = nil, darkElevated: NSColor? = nil, darkElevatedHighContrast: NSColor? = nil) {
		if #available(macOS 14, *) {
			self.init(name: "") { traits -> NSColor in
				let getColorForContrast = { (default: NSColor?, highContrast: NSColor?) -> NSColor? in
					if traits.name == .accessibilityHighContrastAqua, let color = highContrast {
						return color
					}
					return `default`
				}
				
				let getColor = { (default: NSColor?, highContrast: NSColor?, elevated: NSColor?, elevatedHighContrast: NSColor?) -> NSColor? in
					if traits.name == .accessibilityHighContrastAqua,
						let color = getColorForContrast(elevated, elevatedHighContrast) {
						return color
					}
					return getColorForContrast(`default`, highContrast)
				}
				
				if traits.name == .accessibilityHighContrastVibrantDark,
					let color = getColor(dark, darkHighContrast, darkElevated, darkElevatedHighContrast) {
					return color
				}
				return getColor(light, lightHighContrast, lightElevated, lightElevatedHighContrast)!
			}
			return
		}
		
		self.init(cgColor: light.cgColor)!
		self.light = light
		if let lightHighContrast = lightHighContrast {
			self.lightHighContrast = lightHighContrast
		}
	}
}
