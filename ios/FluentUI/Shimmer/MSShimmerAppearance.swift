//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 Object describing how a shimmer should look and function.
 */
public class MSShimmerAppearance: NSObject {
    @objc public let alpha: CGFloat
    @objc public let width: CGFloat

    /// Angle of the direction of the gradient, in radian. 0 means horizontal, Pi/2 means vertical.
    @objc public let angle: CGFloat

    /// Speed of the animation, in point/seconds.
    @objc public let speed: CGFloat

    /// Delay between the end of a shimmering animation and the beginning of the next one.
    @objc public let delay: TimeInterval

    @objc public init(alpha: CGFloat = 0.4,
                      width: CGFloat = 180,
                      angle: CGFloat = -(CGFloat.pi / 45.0),
                      speed: CGFloat = 350,
                      delay: TimeInterval = 0.4) {
        self.alpha = alpha
        self.width = width
        self.angle = angle
        self.speed = speed
        self.delay = delay
    }
}
