//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import QuartzCore

public extension CALayer {
    var isAnimating: Bool { return animationKeys()?.isEmpty == false }
}
