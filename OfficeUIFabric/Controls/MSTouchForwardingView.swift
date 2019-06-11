//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

open class MSTouchForwardingView: UIView {
    var forwardsTouches: Bool = true
    var onTouches: ((_ event: UIEvent?) -> Void)?

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if event?.type == .touches {
            onTouches?(event)
        }
        return forwardsTouches ? false : super.point(inside: point, with: event)
    }
}
