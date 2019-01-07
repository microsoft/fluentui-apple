//
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
//

import UIKit

open class MSTouchForwardingView: UIView {
    var forwardTouches: Bool = true

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return forwardTouches ? false : super.point(inside: point, with: event)
    }
}
