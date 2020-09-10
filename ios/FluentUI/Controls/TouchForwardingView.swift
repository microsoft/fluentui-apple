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
                    // If onPassthroughViewTouches is nil then pass the touch events to passthroughView view
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

        // If onPassthroughViewTouches is non-nil then don't pass the touch events to passthroughView view
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
