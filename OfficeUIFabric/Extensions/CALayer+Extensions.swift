//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension CALayer {
    var isAnimating: Bool { return animationKeys()?.isEmpty == false }
}
