//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension CALayer {
    var isAnimating: Bool { return animationKeys()?.isEmpty == false }
}
