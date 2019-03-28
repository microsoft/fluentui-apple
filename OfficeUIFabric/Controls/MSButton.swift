//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@IBDesignable
open class MSButton: UIButton {
    @IBInspectable open var showsBorder: Bool = true {
        didSet {
            if showsBorder != oldValue {
                initialize()
            }
        }
    }

    public convenience init() {
        self.init(type: .system)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        layer.cornerRadius = 8
        layer.borderWidth = showsBorder ? 1 : 0
    }
}
