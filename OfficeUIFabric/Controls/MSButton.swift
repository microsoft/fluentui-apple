//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

@IBDesignable
open class MSButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    @IBInspectable open var showsBorder: Bool = true {
        didSet {
            if showsBorder != oldValue {
                initialize()
            }
        }
    }
    
    open func initialize() {
        layer.cornerRadius = 5
        layer.borderWidth = showsBorder ? 1 : 0
    }
}
