//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "TouchForwardingView")
public typealias MSTouchForwardingView = TouchForwardingView

@objc(MSFTouchForwardingView)
open class TouchForwardingView: UIView {
    var forwardsTouches: Bool = true
    var passthroughView: UIView?

    var onPassthroughViewTouches: ((_ event: UIEvent?) -> Void)?
    var onTouches: ((_ event: UIEvent?) -> Void)?

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if event?.type == .touches {
            onTouches?(event)
        }
        if forwardsTouches {
            return false
        }
        if let view = passthroughView {
            let localPoint = convert(point, to: view)
            if view.point(inside: localPoint, with: event) {
                if event?.type == .touches {
                    onPassthroughViewTouches?(event)
                }
                return false
            }
        }
        return super.point(inside: point, with: event)
    }
}
