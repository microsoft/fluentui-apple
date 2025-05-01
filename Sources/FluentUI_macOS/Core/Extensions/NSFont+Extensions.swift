//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import AppKit
import SwiftUI

public extension Font {
	static func fluent(_ fontInfo: FluentUI_common.FontInfo, shouldScale: Bool = true) -> Font {
		// SwiftUI Font is missing some of the ease of construction available in NSFont.
		// So just leverage the logic there to create the equivalent SwiftUI font.
		let nsFont = NSFont.fluent(fontInfo, shouldScale: shouldScale)
		return Font(nsFont)
	}
}

extension NSFont {
	@objc public static func fluent(_ fontInfo: FluentUI_common.FontInfo, shouldScale: Bool = true) -> NSFont {
		let weight = nsWeight(fontInfo.weight)

		if let name = fontInfo.name,
		   let font = NSFont(name: name, size: fontInfo.size) {
			// Named font
			let unscaledFont = font.withWeight(weight)
			if shouldScale {
				return font.scale(nsTextStyle(fontInfo.textStyle))
			} else {
				return unscaledFont
			}
		} else {
			// System font
			if !shouldScale {
				return .systemFont(ofSize: fontInfo.size, weight: weight)
			}

			let textStyle = nsTextStyle(fontInfo.textStyle)
			if fontInfo.matchesSystemSize {
				// System-recognized font size, let the OS scale it for us
				return NSFont.preferredFont(forTextStyle: textStyle).withWeight(weight)
			}

			// Custom font size, we need to scale it ourselves
			return .systemFont(ofSize: fontInfo.size, weight: weight).scale(textStyle)
		}
	}

	func scale(_ textStyle: NSFont.TextStyle) -> NSFont {
		let fontDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: textStyle)
		let scaledFont = NSFont(descriptor: fontDescriptor, size: pointSize)!
		return scaledFont
	}

	private func withWeight(_ weight: NSFont.Weight) -> NSFont {
		var attributes = fontDescriptor.fontAttributes
		var traits = (attributes[.traits] as? [NSFontDescriptor.TraitKey: Any]) ?? [:]

		traits[.weight] = weight

		// We need to remove `.name` since it may clash with the requested font weight, but
		// `.family` will ensure that e.g. Helvetica stays Helvetica.
		attributes[.name] = nil
		attributes[.traits] = traits
		attributes[.family] = familyName

		let descriptor = NSFontDescriptor(fontAttributes: attributes)

		return NSFont(descriptor: descriptor, size: pointSize)!
	}

	private static func nsTextStyle(_ textStyle: Font.TextStyle) -> NSFont.TextStyle {
		switch textStyle {
		case .largeTitle:
			return .largeTitle
		case .title:
			return .title1
		case .title2:
			return .title2
		case .title3:
			return .title3
		case .headline:
			return .headline
		case .body:
			return .body
		case .callout:
			return .callout
		case .subheadline:
			return .subheadline
		case .footnote:
			return .footnote
		case .caption:
			return .caption1
		case .caption2:
			return .caption2
		default:
			// Font.TextStyle has `@unknown default` attribute, so we need a default.
			assertionFailure("Unknown Font.TextStyle found! Reverting to .body style.")
			return .body
		}
	}

	private static func nsWeight(_ weight: Font.Weight) -> NSFont.Weight {
		switch weight {
		case .ultraLight:
			return .ultraLight
		case .thin:
			return .thin
		case .light:
			return .light
		case .regular:
			return .regular
		case .medium:
			return .medium
		case .semibold:
			return .semibold
		case .bold:
			return .bold
		case .heavy:
			return .heavy
		case .black:
			return .black
		default:
			// Font.Weight has `@unknown default` attribute, so we need a default.
			assertionFailure("Unknown Font.Weight found! Reverting to .regular weight.")
			return .regular
		}
	}
}
