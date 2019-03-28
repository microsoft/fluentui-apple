//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension UIFontDescriptor {
    var traits: [UIFontDescriptor.TraitKey: Any]? {
        return object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
    }
    var weight: UIFont.Weight {
        if let weight = traits?[.weight] as? NSNumber {
            return UIFont.Weight(CGFloat(weight.floatValue))
        }
        return .regular
    }

    func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
        var attributes = fontAttributes
        var traits = self.traits ?? [:]
        traits[.weight] = NSNumber(value: Float(weight.rawValue))
        attributes[.traits] = traits
        return UIFontDescriptor(fontAttributes: attributes)
    }
}
