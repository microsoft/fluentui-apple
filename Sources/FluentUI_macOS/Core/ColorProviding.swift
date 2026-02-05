//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit
import SwiftUI

// MARK: ColorProviding

/// Protocol through which consumers can provide colors to "theme" their experiences.
///
/// The view associated with the passed in theme will display the set colors to allow apps to provide different experiences per each view.
/// If this protocol is not conformed to, communicationBlue variants will be used.
@objc(MSFColorProviding)
public protocol ColorProviding {
	// MARK: - Brand Background Colors

	@objc var brandBackground1: NSColor { get }
	@objc var brandBackground1Pressed: NSColor { get }
	@objc var brandBackground1Selected: NSColor { get }

	// MARK: - Brand Foreground Colors

	@objc var brandForeground1: NSColor { get }

	// MARK: - Legacy Brand Colors (kept for backward compatibility)

	@objc var primary: NSColor { get }
	@objc var primaryShade10: NSColor { get }
	@objc var primaryShade20: NSColor { get }
	@objc var primaryShade30: NSColor { get }
	@objc var primaryTint10: NSColor { get }
	@objc var primaryTint20: NSColor { get }
	@objc var primaryTint30: NSColor { get }
	@objc var primaryTint40: NSColor { get }
}

// MARK: - Brand Color Overrides

func brandColorOverrides(provider: ColorProviding) -> [FluentTheme.ColorToken: Color] {
	var brandColors: [FluentTheme.ColorToken: Color] = [:]

	brandColors[.brandBackground1] = Color(provider.brandBackground1)
	brandColors[.brandBackground1Pressed] = Color(provider.brandBackground1Pressed)
	brandColors[.brandBackground1Selected] = Color(provider.brandBackground1Selected)
	brandColors[.brandBackground2] = Color(provider.brandBackground1Selected)

	return brandColors
}

// MARK: - FluentTheme Extension

@objc public extension FluentTheme {
	/// Updates color overrides in place without replacing the theme (preserves shadow/typography/gradient overrides).
	///
	/// - Parameter provider: The `ColorProviding` whose colors should be used. Passing `nil` removes brand color overrides.
	@objc static func setSharedThemeColorProvider(_ provider: ColorProviding?) {
		if let provider {
			let brandColors = brandColorOverrides(provider: provider)
			FluentTheme.shared.setColorOverrides(brandColors)
		} else {
			FluentTheme.shared.removeAllColorOverrides()
		}
	}
}
