//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct FontInfo {
    public init(name: String? = nil, size: CGFloat, weight: Font.Weight = .regular) {
        self.name = name
        self.size = size
        self.weight = weight
    }

    let name: String?
    let size: CGFloat
    let weight: Font.Weight
}

// MARK: - ViewModifier

extension Font {
    static func fluent(_ fontInfo: FontInfo, shouldScale: Bool = true) -> Font {
        let size = shouldScale ?
            UIFontMetrics.default.scaledValue(for: fontInfo.size) :
            fontInfo.size

        let font: Font
        if let name = fontInfo.name {
            // We use fixedSize because scaling is already managed above.
            font = .custom(name, fixedSize: size)
        } else {
            font = .system(size: size)
        }
        return font.weight(fontInfo.weight)
    }
}

extension UIFont {
    static func fluent(_ fontInfo: FontInfo, shouldScale: Bool = true) -> UIFont {
        let size = shouldScale ?
            UIFontMetrics.default.scaledValue(for: fontInfo.size) :
            fontInfo.size

        if let name = fontInfo.name,
           let font = UIFont(name: name, size: size) {
            return font.withWeight(uiWeight(fontInfo.weight))
        } else {
            return .systemFont(ofSize: size, weight: uiWeight(fontInfo.weight))
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
            return .regular
        }
    }
}
