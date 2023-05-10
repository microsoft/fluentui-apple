//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: EasyTapButton

@objc(MSFEasyTapButton)
open class EasyTapButton: UIButton {
    static let minimumTouchSize = CGSize(width: 44, height: 44)

    var minTapTargetSize: CGSize = minimumTouchSize

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let growX = max(0, (minTapTargetSize.width - bounds.size.width) / 2)
        let growY = max(0, (minTapTargetSize.height - bounds.size.height) / 2)

        return bounds.insetBy(dx: -growX, dy: -growY).contains(point)
    }
}
