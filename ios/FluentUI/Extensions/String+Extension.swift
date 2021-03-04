//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension String {
    internal var localized: String {
        return NSLocalizedString(self, bundle: FluentUIFramework.resourceBundle, comment: "")
    }

    func trimmed() -> String {
        var whitespace = CharacterSet(charactersIn: "\u{200B}") // Zero-width space
        whitespace.formUnion(CharacterSet.whitespacesAndNewlines)
        return trimmingCharacters(in: whitespace)
    }

    func preferredSize(for font: UIFont, width: CGFloat = .greatestFiniteMagnitude, numberOfLines: Int = 0) -> CGSize {
        if numberOfLines == 1 {
            return CGSize(
                width: UIScreen.main.roundToDevicePixels(min(self.size(withAttributes: [.font: font]).width, width)),
                height: font.deviceLineHeightWithLeading
            )
        }
        let maxHeight = numberOfLines > 1 ? font.deviceLineHeightWithLeading * CGFloat(numberOfLines) : .greatestFiniteMagnitude
        let rect = self.boundingRect(
            with: CGSize(width: width, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return CGSize(
            width: UIScreen.main.roundToDevicePixels(rect.width),
            height: UIScreen.main.roundToDevicePixels(rect.height)
        )
    }
}
