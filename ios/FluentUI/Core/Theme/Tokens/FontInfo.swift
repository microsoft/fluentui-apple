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
            UIFontMetrics(forTextStyle: .body).scaledValue(for: fontInfo.size) :
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
            UIFontMetrics(forTextStyle: .body).scaledValue(for: fontInfo.size) :
            fontInfo.size

        if let name = fontInfo.name,
           let font = UIFont(name: name, size: size) {
            return font
        } else {
            return .systemFont(ofSize: size, weight: uiWeight(fontInfo.weight))
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
            return .regular
        }
    }
}
