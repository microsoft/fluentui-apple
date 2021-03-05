//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import QuartzCore
import UIKit

<<<<<<< HEAD:ios/FluentUI/Extensions/CALayer+Extensions.swift
extension CALayer {
    var isAnimating: Bool { return animationKeys()?.isEmpty == false }

=======
public extension CALayer {
>>>>>>> fafd715ae3d4cf999bfadea17285811bc949c04c:ios/FluentUI/Drawer/CALayer+Extensions.swift
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
