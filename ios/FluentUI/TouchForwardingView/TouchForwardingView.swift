//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
                    // Prevents the underlying (passthrough) view from getting touch events if there's custom code already handling it (onPassthroughViewTouches closure)
                    guard let onPassthroughViewTouches = onPassthroughViewTouches else {
                        return true
                    }
                    onPassthroughViewTouches(event)
                }
                return false
            }
        }
        return super.point(inside: point, with: event)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitTestView = super.hitTest(point, with: event)

        // Prevents the underlying (passthrough) view from getting touch events if there's custom code already handling it (onPassthroughViewTouches closure)
        guard onPassthroughViewTouches == nil else {
            return hitTestView
        }

        if let hitView = hitTestView, let passthroughView = passthroughView {
            let convertedPoint = hitView.convert(point, to: passthroughView)
            // checking which subview is eligible for the touch event
            hitTestView = passthroughView.hitTest(convertedPoint, with: event)
        }

        return hitTestView
    }

}
