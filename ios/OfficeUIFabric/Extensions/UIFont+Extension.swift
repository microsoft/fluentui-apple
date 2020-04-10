//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIFont {
    var deviceLineHeight: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight) }
    var deviceLineHeightWithLeading: CGFloat { return UIScreen.main.roundToDevicePixels(lineHeight + max(0, leading)) }
}
