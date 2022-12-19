//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Represents the description of a font used by FluentUI components.
@objc(MSFFontInfo)
public class FontInfo: NSObject {

    /// Creates a `FontInfo` instance using the specified information.
    ///
    /// This struct simply stores information about a future font. Fluent will use this information to create the appropriate font object internally as needed.
    ///
    /// - Parameter name: An optional name for the font. If none is provided, defaults to the standard system font.
    /// - Parameter size: The point size to use for the font.
    /// - Parameter weight: The weight to use for the font. Defaults to `.regular`.
    ///
    /// - Returns: A struct containing the information needed to create a font object.
    public init(name: String? = nil,
                size: CGFloat,
                weight: Font.Weight = .regular) {
        self.name = name
        self.size = size
        self.weight = weight
    }

    /// An optional name for the font. If none is provided, defaults to the standard system font.
    public let name: String?

    /// The point size to use for the font.
    public let size: CGFloat

    /// The weight to use for the font.
    public let weight: Font.Weight

    var textStyle: Font.TextStyle {
        // Defaults to smallest supported text style for mapping, before checking if we're bigger.
        var textStyle = Font.TextStyle.caption2
        for tuple in Self.sizeTuples {
            if self.size >= tuple.size {
                textStyle = tuple.textStyle
                break
            }
        }
        return textStyle
    }

    private static var sizeTuples: [(size: CGFloat, textStyle: Font.TextStyle)] = [
        (34.0, .largeTitle),
        (28.0, .title),
        (22.0, .title2),
        (20.0, .title3),
        // Note: `17.0: .headline` is removed to avoid needing duplicate size key values.
        // But it's okay because Apple's scaling curve is identical between it and `.body`.
        (17.0, .body),
        (16.0, .callout),
        (15.0, .subheadline),
        (13.0, .footnote),
        (12.0, .caption),
        (11.0, .caption2)
    ]
}

// MARK: - ViewModifier

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
        let unscaledFont: UIFont

        if let name = fontInfo.name,
           let font = UIFont(name: name, size: fontInfo.size) {
            // Named font
            unscaledFont = font.withWeight(uiWeight(fontInfo.weight))
        } else {
            // System font
            unscaledFont = .systemFont(ofSize: fontInfo.size, weight: uiWeight(fontInfo.weight))
        }

        if shouldScale {
            let fontMetrics = UIFontMetrics(forTextStyle: uiTextStyle(fontInfo.textStyle))
            return fontMetrics.scaledFont(for: unscaledFont)
        } else {
            return unscaledFont
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
