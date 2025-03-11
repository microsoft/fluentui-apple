//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if !COCOAPODS
import FluentUI_common
#endif
import SwiftUI
import UIKit

public extension Font {
    static func fluent(_ fontInfo: FontInfo, shouldScale: Bool = true) -> Font {
        // SwiftUI Font is missing some of the ease of construction available in UIFont.
        // So just leverage the logic there to create the equivalent SwiftUI font.
        let uiFont = UIFont.fluent(fontInfo, shouldScale: shouldScale)
        return Font(uiFont)
    }
}

extension UIFont {
    @objc public static func fluent(_ fontInfo: FontInfo, shouldScale: Bool = true) -> UIFont {
        return fluent(fontInfo, shouldScale: shouldScale, contentSizeCategory: nil)
    }

    @objc public static func fluent(_ fontInfo: FontInfo, shouldScale: Bool = true, contentSizeCategory: UIContentSizeCategory?) -> UIFont {
        let traitCollection: UITraitCollection?
        if let contentSizeCategory = contentSizeCategory {
            traitCollection = .init(preferredContentSizeCategory: contentSizeCategory)
        } else {
            traitCollection = nil
        }

        let weight = uiWeight(fontInfo.weight)

        if let name = fontInfo.name,
           let font = UIFont(name: name, size: fontInfo.size) {
            // Named font
            let unscaledFont = font.withWeight(weight)
            if shouldScale {
                let fontMetrics = UIFontMetrics(forTextStyle: uiTextStyle(fontInfo.textStyle))
                return fontMetrics.scaledFont(for: unscaledFont, compatibleWith: traitCollection)
            } else {
                return unscaledFont
            }
        } else {
            // System font
            if !shouldScale {
                return .systemFont(ofSize: fontInfo.size, weight: weight)
            }

            let textStyle = uiTextStyle(fontInfo.textStyle)
            if fontInfo.matchesSystemSize {
                // System-recognized font size, let the OS scale it for us
                return UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection).withWeight(weight)
            }

            // Custom font size, we need to scale it ourselves
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: .systemFont(ofSize: fontInfo.size, weight: weight), compatibleWith: traitCollection)
        }
    }

    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

        traits[.weight] = weight

        // We need to remove `.name` since it may clash with the requested font weight, but
        // `.family` will ensure that e.g. Helvetica stays Helvetica.
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName

        let descriptor = UIFontDescriptor(fontAttributes: attributes)

        return UIFont(descriptor: descriptor, size: pointSize)
    }

    private static func uiTextStyle(_ textStyle: Font.TextStyle) -> UIFont.TextStyle {
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

    private static func uiWeight(_ weight: Font.Weight) -> UIFont.Weight {
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
