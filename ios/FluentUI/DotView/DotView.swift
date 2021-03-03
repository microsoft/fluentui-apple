//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "DotView")
public typealias MSDotView = DotView

@objc(MSFDotView)
open class DotView: UIView {
    @objc open var color: UIColor? {
        didSet {
            if oldValue != color {
                setNeedsDisplay()
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        (color ?? .clear).set()
        context.addEllipse(in: bounds)
        context.fillPath()
    }
}
