//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `CircleCutout`: Cutout shape for a circle
///
/// `xOrigin`: beginning location of cutout on the x axis
///
/// `yOrigin`: beginning location of cutout on the y axis
///
/// `cutoutSize`: diameter of the circle to cut out
struct ShapeCutout: Shape {
    func path(in rect: CGRect) -> Path {
        var cutoutFrame = Rectangle().path(in: rect)
        cutoutFrame.addPath(RoundedRectangle(cornerRadius: cornerRadius).path(in: CGRect(x: xOrigin,
                                                                                         y: yOrigin,
                                                                                         width: cutoutSize,
                                                                                         height: cutoutSize)))
        return cutoutFrame
    }

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(AnimatablePair(xOrigin, yOrigin), AnimatablePair(cornerRadius, cutoutSize))
        }
        set {
            xOrigin = newValue.first.first
            yOrigin = newValue.first.second
            cornerRadius = newValue.second.first
            cutoutSize = newValue.second.second
        }
    }

    var xOrigin: CGFloat
    var yOrigin: CGFloat
    var cornerRadius: CGFloat
    var cutoutSize: CGFloat
}
