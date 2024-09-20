//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import QuartzCore
import UIKit

extension CALayer {
    var roundedCorners: UIRectCorner {
        var corners: UIRectCorner = []
        if maskedCorners.contains(.layerMinXMinYCorner) {
            corners.insert(.topLeft)
        }
        if maskedCorners.contains(.layerMaxXMinYCorner) {
            corners.insert(.topRight)
        }
        if maskedCorners.contains(.layerMinXMaxYCorner) {
            corners.insert(.bottomLeft)
        }
        if maskedCorners.contains(.layerMaxXMaxYCorner) {
            corners.insert(.bottomRight)
        }
        return corners
    }
}
