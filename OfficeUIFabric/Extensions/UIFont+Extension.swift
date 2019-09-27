//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension UIFont {
    var deviceLineHeight: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight) }
    var deviceLineHeightWithLeading: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight + max(0, leading)) }

    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        return UIFont(descriptor: fontDescriptor.withWeight(weight), size: pointSize)
    }
}
